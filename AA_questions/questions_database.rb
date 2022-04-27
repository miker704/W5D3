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
end


# SQLite3::Database.new("questions.db") do |db|
#     db.execute("SELECT * FROM users") do |row|
#         p row
#     end
# end

testuser = QuestionsDatabase.instance.execute(<<-SQL, 1)
      SELECT * FROM users WHERE id = ?;
    SQL
Users.new(testuser.first)

testq = QuestionsDatabase.instance.execute(<<-SQL, 1)
      SELECT * FROM questions WHERE id = ?
    SQL
Questions.new(testq.first)


p question = Questions.find_by_author_id(1)
puts
p Replies.find_by_user_id(1)
puts
p Replies.find_by_question_id(1)
puts
p leo = Users.find_by_name('Leo', 'Chung')
puts
p leo.authored_questions
puts
p leo.authored_replies
puts
p question.author