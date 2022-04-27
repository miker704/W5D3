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

        def self.find_by_id(id)        
            user_id= QuestionsDatabase.instance.execute(<<-SQL,id)
            SELECT * FROM users WHERE id = ?;
            SQL
            Users.new(user_id)
        end

        def initialize(options)
            @id=options['id']
            @fname=options['fname']
            @lname=options['lname']
        end


    end


    class Questions

        def self.find_by_id(id)
            questions= QuestionsDatabase.instance.execute(<<-SQL,id)
            SELECT * FROM questions WHERE id = ?;
            SQL
            Questions.new(questions)
        end

        def initialize(options)
            @id=options['id']
            @title=options['title']
            @body=options['body']
        end
    end



    class QuestionFollows

        def self.find_by_id(id)
            question_follow=QuestionsDatabase.instance.execute(<<-SQL,id)
            SELECT * FROM question_follows WHERE id = ?;
            SQL
            QuestionFollows.new(question_follow)

        end

        def initialize(options)
            @id = options['id']
            @question_id=options['question_id']
            @user_id=options['user_id']

        end

    end

    class Replies

        def self.find_by_id(id)
            reply = QuestionsDatabase.intstance.execute(<<-SQL,id)
            SELECT * FROM replies WHERE id = ?;
            SQL
            Replies.new(reply)
        end

        def initialize(options)
            @id = options['id']
            @body=options['body']
            @reply_id=options['reply_id']
            @question_id=options['question_id']
            @user_id=options['user_id']
        end
    end


    class QLikes

        def self.find_by_id(id)
            ques_likes=QuestionsDatabase.instance.execute(<<-SQL,id)
            SELECT * FROM question_likes WHERE id = ?;
            SQL
            QLikes.new(ques_likes)
        end

        def initialize(options)
            @id=options['id']
            @question_id=options['question_id']
            @user_id=options['user_id']
        end
    end




    SQLite3::Database.new("questions.db") do |db|
        db.execute("SELECT * FROM users") do |row|
            p row
        end
    end


    