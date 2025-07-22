-- Create tables
CREATE TABLE learners (
  id INTEGER PRIMARY KEY,
  name TEXT
);

CREATE TABLE courses (
  id TEXT PRIMARY KEY,
  title TEXT,
  description TEXT
);

CREATE TABLE enrollments (
  id INTEGER PRIMARY KEY,
  learner_id INTEGER,
  course_id TEXT,
  enrolled_on DATE
);

-- Insert learners
INSERT INTO learners (id, name) VALUES (1, 'Alice');
INSERT INTO learners (id, name) VALUES (2, 'Bob');
INSERT INTO learners (id, name) VALUES (3, 'Carol');

-- Insert courses
INSERT INTO courses (id, title, description) VALUES ('cs101', 'Intro to CS', 'Basics of computer science.');
INSERT INTO courses (id, title, description) VALUES ('math201', 'Calculus I', 'Differential calculus.');
INSERT INTO courses (id, title, description) VALUES ('ai301', 'AI for Beginners', 'Learn the basics of AI.');

-- Insert enrollments
INSERT INTO enrollments (id, learner_id, course_id, enrolled_on) VALUES (1, 1, 'cs101', '2023-01-10');
INSERT INTO enrollments (id, learner_id, course_id, enrolled_on) VALUES (2, 1, 'math201', '2023-02-15');
INSERT INTO enrollments (id, learner_id, course_id, enrolled_on) VALUES (3, 2, 'cs101', '2023-01-12');
INSERT INTO enrollments (id, learner_id, course_id, enrolled_on) VALUES (4, 2, 'ai301', '2023-03-01');
INSERT INTO enrollments (id, learner_id, course_id, enrolled_on) VALUES (5, 3, 'math201', '2023-02-20'); 