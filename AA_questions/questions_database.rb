require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  def initialize
    super("questions.db")
    self.type_translation=true
    self.results_as_hash=true
  end
end

class Users 
  attr_accessor :id, :fname, :lname
  
  def self.find_by_id(id)        
    user_id = QuestionsDatabase.instance.execute(<<-SQL,id)
      SELECT * FROM users WHERE id = ?;
    SQL
    Users.new(user_id.first)
  end
  
  def self.find_by_name(fname,lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND
        lname = ?;
    SQL
    Users.new(user.first)
  end

  def authored_questions
    author = Questions.find_by_author_id(self.id)
    raise "You haven't asked anything yet!" if !author
    return author
  end

  def authored_replies
    author = Replies.find_by_user_id(self.id)
    raise "You haven't replied to anything!" if !author
    return author
  end
  
  def followed_questions
    QuestionFollows.followed_questions_for_user_id(self.id)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
end


class Questions
  attr_accessor :id, :title, :body

  def self.find_by_id(id)
    questions = QuestionsDatabase.instance.execute(<<-SQL,id)
      SELECT * FROM questions WHERE id = ?;
    SQL
    Questions.new(questions.first)
  end

  def self.find_by_question(title, body)
    question = QuestionsDatabase.instance.execute(<<-SQL, title, body)
      SELECT
        *
      FROM
        questions
      WHERE
        title = ? AND
        body = ?;
    SQL
    Questions.new(question.first)
  end

  def self.find_by_author_id(user_id)
    author = Users.find_by_id(user_id)
    raise "No user found" if !author
    
    questions = QuestionsDatabase.instance.execute(<<-SQL, author.id)
      SELECT * FROM questions WHERE user_id = ?
    SQL
    questions.map {|q| Questions.new(q)}
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def author
    question_id = self.id
    user_id = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT * FROM question_follows WHERE question_id = ?
    SQL
    user = Users.find_by_id(user_id.first["user_id"])
    return [user.fname, user.lname]
  end

  def replies
    reply = Replies.find_by_question_id(self.id)
    return reply
  end

  def followers
    QuestionFollows.followers_for_question_id(self.id)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
  end
end

class QuestionFollows
  attr_accessor :id, :question_id, :user_id
  
  def self.find_by_id(id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM question_follows WHERE id = ?;
    SQL
    QuestionFollows.new(question_follow.first)
  end

  def self.followers_for_question_id(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_follows
      JOIN questions ON questions.id = question_follows.question_id
      JOIN users ON users.id = question_follows.user_id
      WHERE
        question_id = ?
      GROUP BY
        users.id;
    SQL
    followers.map {|user| Users.find_by_id(user['id'])}
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_follows
      JOIN users ON users.id = question_follows.user_id
      WHERE
        user_id = ?
      SQL
    questions.map {|quest| Questions.find_by_id(quest["question_id"])}
  end

  def self.most_followed_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        question_follows
      JOIN questions ON questions.id = question_follows.question_id
      JOIN users ON users.id = question_follows.user_id
      GROUP BY
        questions.id
      LIMIT ?
    SQL
    questions
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end

class Replies
  attr_accessor :id, :body, :reply_id, :question_id, :user_id
  
  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE id = ?;
    SQL
    Replies.new(reply.first)
  end

  def self.find_by_body(body)
    reply = QuestionsDatabase.instance.execute(<<-SQL, body)
      SELECT * FROM replies WHERE body = ?;
    SQL
    Replies.new(reply.first)
  end

  def self.find_by_user_id(id)
    user = Users.find_by_id(id)

    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE user_id = ?
    SQL
    reply.map {|comment| Replies.new(comment)}
  end

  def self.find_by_question_id(id)
    question = Questions.find_by_id(id)

    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE question_id = ?
    SQL
    reply.map {|comment| Replies.new(comment)}
  end

  def author
    return Users.find_by_id(self.user_id)
  end

  def question
    return Questions.find_by_id(self.question_id)
  end

  def parent_reply
    raise "You have no parent reply" if self.reply_id.nil?
    Replies.find_by_id(self.reply_id)
  end

  def child_reply
    children = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT * FROM replies WHERE reply_id = ?
    SQL
    children.map {|rep| Replies.new(rep)}
  end

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @reply_id = options['reply_id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end


class Likes
  attr_accessor :id, :question_id, :user_id
  
  def self.find_by_id(id)
    ques_likes = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM question_likes WHERE id = ?;
    SQL
    Likes.new(ques_likes.first)
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end


  def self.likers_for_question_id(question_id)
        likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT *
            FROM question_likes
            WHERE 
            question_id = ?;
        
        SQL
        return likes.map{|user| Users.find_by_id(user['user_id'])}
  end

  def self.num_likes_for_question_id(question_id)
    likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT count(question_id)
        FROM question_likes
        WHERE 
        question_id = ?;

        SQL
        # return likes.map{|liked| Questions.find_by_id(liked['question_id'])}
        return likes

  end



end

# puts "---- TABLE DISPLAYS BELOW ----"
# puts "---- USERS ----"
# SQLite3::Database.new("questions.db") do |db|
#     db.execute("SELECT * FROM users") do |row|
#         p row
#     end
# end

# puts

# puts "---- QUESTIONS ----"
# SQLite3::Database.new("questions.db") do |db|
#     db.execute("SELECT * FROM questions") do |row|
#         p row
#     end
# end

# puts "---- QUESTIONS FOLLOWS ----"
# SQLite3::Database.new("questions.db") do |db|
#     db.execute("SELECT * FROM question_follows") do |row|
#         p row
#     end
# end

# puts "---- EASY ----""
# p question = Questions.find_by_author_id(1)
# puts
# p Replies.find_by_user_id(2)
# puts
# p Replies.find_by_question_id(1)
# puts
# p leo = Users.find_by_name('Leo', 'Chung')
# puts
# p leo.authored_questions
# puts
# p leo.authored_replies
# puts
# p question.first.author
# puts
# p question.first.replies
# puts

# reply = Replies.find_by_id(3)
# p reply.author
# puts
# p reply.question
# puts
# p reply.parent_reply
# puts
# p reply.child_reply
# puts

# puts "---- Medium ----"
# firstuser = Users.find_by_id(1)
# firstquestion = Questions.find_by_id(1)
# p QuestionFollows.followers_for_question_id(1)
# puts
# p QuestionFollows.followed_questions_for_user_id(1)
# puts
# p firstuser.followed_questions
# puts
# p firstquestion.followers

puts "---- HARD ----"
firstuser = Users.find_by_id(1)
firstquestion = Questions.find_by_id(1)
# p QuestionFollows.most_followed_questions(2)
# p firstquestion.most_followed(2)

p Questions.most_followed(2)

p Likes.likers_for_question_id(1)
p Likes.likers_for_question_id(3)

p Likes.num_likes_for_question_id(5)
p Likes.num_likes_for_question_id(3)