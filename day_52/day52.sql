
CREATE DATABASE database_01_hongha;

ALTER DATABASE database_01_hongha SET timezone TO 'Asia/Ho_Chi_Minh';
SET search_path = database_01_hongha;

CREATE TABLE courses (
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  price FLOAT,
  detail TEXT,
  teacher_id INT NOT NULL,
  active INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
--
CREATE FUNCTION updated_at_function()
RETURNS trigger AS
$$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
-- DROP TRIGGER IF EXISTS courses_moddatetime ON courses CASCADE;
CREATE TRIGGER courses_updated_at
    BEFORE UPDATE ON courses
    FOR EACH ROW
    EXECUTE PROCEDURE updated_at_function();

--
ALTER TABLE courses ADD description TEXT NULL;
--
ALTER TABLE courses RENAME COLUMN detail TO content;
--
CREATE TABLE teacher (
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  bio TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
--
ALTER TABLE courses
      ADD CONSTRAINT fk_course_teacher FOREIGN KEY (teacher_id) 
          REFERENCES teacher (id);
--
CREATE TRIGGER teacher_updated_at
    BEFORE UPDATE ON teacher
    FOR EACH ROW
    EXECUTE PROCEDURE updated_at_function();
--
INSERT INTO teacher (name, bio) VALUES
  ('Teacher 1', 'Bio 1'),
  ('Teacher 2', 'Bio 2'),
  ('Teacher 3', 'Bio 3');
--
INSERT INTO courses (name, price, teacher_id, active) VALUES
  ('Course 10', 100000, 1, 1),
  ('Course 2', 200000, 1, 1),
  ('Course 3', 300000, 1, 1),
  ('Course 4', 100000, 2, 1),
  ('Course 5', 200000, 2, 1),
  ('Course 6', 300000, 2, 1),
  ('Course 7', 100000, 3, 1),
  ('Course 8', 200000, 3, 1),
  ('Course 9', 300000, 3, 1);
--
UPDATE courses SET name = 'New Course 1', price = 200000 WHERE id = 1;
UPDATE courses SET name = 'New Course 2', price = 300000 WHERE id = 2;
UPDATE courses SET name = 'New Course 3', price = 400000 WHERE id = 3;
UPDATE courses SET name = 'New Course 4', price = 200000 WHERE id = 4;
UPDATE courses SET name = 'New Course 5', price = 300000 WHERE id = 5;
UPDATE courses SET name = 'New Course 6', price = 400000 WHERE id = 6;
UPDATE courses SET name = 'New Course 7', price = 200000 WHERE id = 7;
UPDATE courses SET name = 'New Course 8', price = 300000 WHERE id = 8;
UPDATE courses SET name = 'New Course 9', price = 400000 WHERE id = 9;
--
UPDATE teacher SET bio = 'New bio 1' WHERE id = 1;
UPDATE teacher SET bio = 'New bio 2' WHERE id = 2;
UPDATE teacher SET bio = 'New bio 3' WHERE id = 3;
--
SELECT * FROM teacher;

SELECT * FROM courses;
