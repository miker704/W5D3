PRAGMA foreign_keys=ON;

    DROP TABLE IF EXISTS question_follows;
    DROP TABLE IF EXISTS replies;
    DROP TABLE IF EXISTS question_likes;
    DROP TABLE IF EXISTS users;
    DROP TABLE IF EXISTS questions;

    CREATE TABLE users (
      id INTEGER PRIMARY KEY,
      fname TEXT DEFAULT '',
      lname TEXT DEFAULT ''
    );

    CREATE TABLE questions (
        id INTEGER PRIMARY KEY,
        title TEXT DEFAULT '',
        body TEXT DEFAULT '',
        user_id INTEGER NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
    );

    CREATE TABLE question_follows (
        id INTEGER PRIMARY KEY,
        question_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY(question_id) REFERENCES questions(id),
        FOREIGN KEY(user_id) REFERENCES users(id)
        
    );

    CREATE TABLE replies (
        id INTEGER PRIMARY KEY,
        body TEXT DEFAULT '',
        reply_id INTEGER DEFAULT NULL,
        question_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY(question_id) REFERENCES questions(id),
        FOREIGN KEY(user_id) REFERENCES users(id)

    );


    CREATE TABLE question_likes (
        id INTEGER PRIMARY KEY,
        question_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY(question_id) REFERENCES questions(id),
        FOREIGN KEY(user_id) REFERENCES users(id)
    );

    INSERT INTO 
    users(fname,lname) 
    VALUES
    ('Leo','Chung'),
    ('Michael','Ramoutar');

    INSERT INTO 
      questions(title,body,user_id)
    VALUES
      ('Why am I alive?','Is it just to make money?', 1),
      ('Whats for lunch?','Is anyone feeling Halal food?', 2),
      ('What ELO are you in?', 'I do not play League', 1),
      ('Where am I?','I have dementia', 1);

    INSERT INTO
      replies(body, reply_id, question_id, user_id)
    VALUES
      ('Dank reply',NULL,1,2),
      ('This reply is so much danker than the last one',1,1,1),
      ('Bro, I am the dankest', 2, 1, 2),
      ('Bro you are pretty dank', 3, 1, 1);






