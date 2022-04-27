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
      questions(title, body, user_id)
    VALUES
      ('Why am I alive?','Is it just to make money?', 1),
      ('Whats for lunch?','Is anyone feeling Halal food?', 2),
      ('What ELO are you in?', 'I do not play League', 1),
      ('Where am I?','I have dementia', 1),
      ('1', 'What weird food combinations do you really enjoy?',1),
      ('2', 'What social stigma does society need to get over?',2),
      ('3', 'What food have you never eaten but would really like to try ?',1),
      ('4', 'What''s something you really resent paying for?',2),
      ('5', 'What would a world populated by clones of you be like?',2),
      ('6', 'Do you think that aliens exist?',1),
      ('7', 'What are you currently worried about?',2),
      ('8', 'Where are some unusual places you''ve been?',1),
      ('9', 'Where do you get your news?',2),
      ('10', 'What are some red flags to watch out for in daily life?',1),
      ('11', 'What movie can you watch over and over without ever getting tired of?',2),
      ('12', 'When you are old, what do you think children will ask you to tell stories about?',1),
      ('13', 'If you could switch two movie characters, what switch would lead to the most inappropriate movies?',2),
      ('14', 'What inanimate object would be the most annoying if it played loud upbeat music while being used?',1),
      ('15', 'When did something start out badly for you but in the end, it was great?',2),
      ('16', 'How would your country change if everyone, regardless of age, could vote?',1),
      ('17', 'What animal would be cutest if scaled down to the size of a cat?',2),
      ('18', 'If your job gave you a surprise three day paid break to rest and recuperate, what would you do with those three days?',1),
      ('19', 'What''s wrong but sounds right?',2),
      ('20', 'What''s the most epic way you''ve seen someone quit or be fired?',1),
      ('21', 'If you couldn''t be convicted of any one type of crime, what criminal charge would you like to be immune to?',2),
      ('22', 'What''s something that will always be in fashion, no matter how much time passes?',1),
      ('23', 'What actors or actresses play the same character in almost every movie or show they do?',2),
      ('24', 'In the past people were buried with the items they would need in the afterlife, what would you want buried with you so you could use it in the afterlife?',1),
      ('25', 'What''s the best / worst practical joke that you''ve played on someone or that was played on( you?',2),
      ('26', 'Who do you go out of your way to be nice to?',1),
      ('27', 'Where do you get most of the decorations for your home?',2),
      ('28', 'What food is delicious but a pain to eat?',1),
      ('29', 'Who was your craziest / most interesting teacher',2),
      ('30', 'What “old person” things do you do?',1);

    INSERT INTO
      replies(body, reply_id, question_id, user_id)
    VALUES
      ('Dank reply', NULL, 1, 2),
      ('This reply is so much danker than the last one',1 ,1 ,1),
      ('Bro, I am the dankest', 2, 1, 2),
      ('Bro you are pretty dank', 3, 1, 1);

    INSERT INTO
      question_follows(question_id, user_id)
    VALUES
      (1, 1),
      (1, 2),
      (3, 1),
      (4, 1),
      (5, 1),
      (6, 2),
      (7, 1),
      (8, 2),
      (9, 1),
      (3, 2);
      
      INSERT INTO 
      question_likes(question_id,user_id)
      VALUES
      (1, 1),
      (1, 2),
      (3, 1),
      (4, 1),
      (5, 1),
      (6, 2),
      (7, 1),
      (8, 2),
      (9, 1),
      (3, 2);