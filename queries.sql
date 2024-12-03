-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database
-- Insert sample students
INSERT INTO students (first_name, last_name, email, major, year_of_study) VALUES
('John', 'Doe', 'john.doe@mail.aub.edu', 'Computer Science', 'Sophomore'),
('Jane', 'Saab', 'jane.saab@mail.aub.edu', 'CCE', 'E2'),
('Alice', 'Khatib', 'alice.khatib@mail.aub.edu', 'Biology', 'Senior');

-- Insert sample instructors
INSERT INTO instructors (first_name, last_name, email) VALUES
('Professor', 'Bousaab', 'prof.saab@mail.aub.edu'),
('Professor', 'Bazzi', 'prof.bazzi@mail.aub.edu');

-- Insert sample courses
INSERT INTO courses (name, credits, description) VALUES
('CMPS201', 3, 'Introduction to Computer Science'),
('EECE210', 4, 'Electrical Engineering Fundamentals'),
('BIO301', 3, 'Advanced Biology Concepts');

-- Insert sample semester
INSERT INTO semester (name, year) VALUES
('Fall', 2024),
('Spring', 2025);

-- Insert sample prerequisites
INSERT INTO prerequisites (course_id, prerequisites_course_id) VALUES
(2, 1), -- EECE210 requires completion of CMPS201
(3, 2); -- BIO301 requires completion of EECE210

-- Insert sample course registration numbers
INSERT INTO course_registration_number (CRN, course_id, semester_id) VALUES
(1001, 1, 1), -- CMPS201 in Fall 2024
(1002, 2, 1), -- EECE210 in Fall 2024
(1003, 3, 2); -- BIO301 in Spring 2025

-- Insert sample course instructors
INSERT INTO course_instructors (CRN, instructor_id) VALUES
(1001, 1), -- CMPS201 taught by Professor Saab
(1002, 2); -- EECE210 taught by Professor Bazzi

-- Insert sample capacity
INSERT INTO capacity (CRN, capacity) VALUES
(1001, 30), -- CMPS201 has a capacity of 30 students
(1002, 25); -- EECE210 has a capacity of 25 students

-- Insert sample enrollment
INSERT INTO enrollment (CRN, student_id) VALUES
(1001, 1), -- John Doe enrolled in CMPS201
(1001, 2), -- Jane Saab enrolled in CMPS201
(1002, 3); -- Alice Khatib enrolled in EECE210

-- Drop enrollment
DELETE FROM enrollment
WHERE CRN = 1001 AND student_id = 1;

SELECT * FROM enrollment;
SELECT * FROM capacity;

SELECT * FROM students_in_class;
