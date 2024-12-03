-- Create first the DB
CREATE DATABASE online_course_registration;
USE online_course_registration;

-- Represent students taking the course
CREATE TABLE `students` (
    `id` INT AUTO_INCREMENT,
    `first_name` varchar(32) NOT NULL,
    `last_name` varchar(32) NOT NULL,
    `email` varchar(100) NOT NULL UNIQUE,
    `major` varchar(64) NOT NULL,
    `year_of_study` ENUM('Freshman', 'Sophomore', 'Junior', 'Senior', 'E1', 'E2', 'E3', 'E4', 'masters', 'graduate') NOT NULL,
    PRIMARY KEY(`id`)
);

-- Represent instructors in the course
CREATE TABLE `instructors` (
    `id` INT AUTO_INCREMENT,
    `first_name` varchar(32) NOT NULL,
    `last_name` varchar(32) NOT NULL,
    `email` varchar(100) NOT NULL UNIQUE,
    PRIMARY KEY(`id`)
);

-- Represent Courses (eg EECE 230)
CREATE TABLE `courses` (
    `id` INT AUTO_INCREMENT,
    `name` varchar(64) NOT NULL UNIQUE,
    `credits` TINYINT UNSIGNED NOT NULL CHECK (credits >= 0 AND credits <= 4),
    `description` TEXT(1024) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `semester` (
    `id` INT AUTO_INCREMENT,
    `name` ENUM('Fall', 'Winter', 'Spring', 'Summer') NOT NULL,
    `year` YEAR NOT NULL,
    PRIMARY KEY(`id`)
);


-- Prerequisites table
CREATE TABLE `prerequisites` (
    `course_id` INT,
    `prerequisites_course_id` INT,
    PRIMARY KEY(`course_id`, `prerequisites_course_id`),
    FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
    FOREIGN KEY (`prerequisites_course_id`) REFERENCES `courses` (`id`)
);

-- CRN refer to a specific course taugh by a specific instructor
CREATE TABLE `course_registration_number` (
    `CRN` INT AUTO_INCREMENT,
    `course_id` INT,
    `semester_id` INT,
    PRIMARY KEY (`CRN`),
    FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
    FOREIGN KEY (`semester_id`) REFERENCES `semester` (`id`)
);

-- This table link which course will the intructor teach
CREATE TABLE `course_instructors` (
    `CRN` INT,
    `instructor_id` INT,
    PRIMARY KEY(`CRN`, `instructor_id`),
    FOREIGN KEY (`CRN`) REFERENCES `course_registration_number`(`CRN`),
    FOREIGN KEY (`instructor_id`) REFERENCES `instructors` (`id`)
);

-- Course that the instructor will teach a specific semester, CRN refer to a specific course taugh by a specific instructor
CREATE TABLE `capacity` (
    `CRN` INT UNIQUE,
    `capacity` INT NOT NULL DEFAULT 15,
    `enrollment_count` INT NOT NULL DEFAULT 0,
    FOREIGN KEY (`CRN`) REFERENCES `course_registration_number` (`CRN`)
);

-- Create the enrollment table
CREATE TABLE `enrollment` (
    `CRN` INT,
    `student_id` INT,
    `enrollment_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`CRN`, `student_id`),
    FOREIGN KEY (`CRN`) REFERENCES `course_registration_number` (`CRN`),
    FOREIGN KEY (`student_id`) REFERENCES `students` (`id`)
);

DELIMITER //
CREATE TRIGGER enrollment_insert_trigger
BEFORE INSERT ON `enrollment`
FOR EACH ROW
BEGIN
    DECLARE current_enrollment INT;
    DECLARE course_capacity INT;

    -- Get the current enrollment count for the course
    SELECT `enrollment_count` INTO current_enrollment
    FROM `capacity`
    WHERE `CRN` = NEW.`CRN`;

    -- Get the capacity for the course
    SELECT `capacity` INTO course_capacity
    FROM `capacity`
    WHERE `CRN` = NEW.`CRN`;
    -- Check if enrollment_count exceeds capacity and rollback the insert if necessary
    IF current_enrollment >= course_capacity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Enrollment capacity reached';
    ELSE
        -- Increment the enrollment_count for the course
        UPDATE `capacity`
        SET `enrollment_count` = `enrollment_count` + 1
        WHERE `CRN` = NEW.`CRN`;
    END IF;
END;
//
DELIMITER ;


-- When someone drop a course, the enrollenment count is updated
DELIMITER //

CREATE TRIGGER enrollment_delete_trigger
BEFORE DELETE ON `enrollment`
FOR EACH ROW
BEGIN
    DECLARE current_enrollment INT;

    -- Get the current enrollment count for the course
    SELECT `enrollment_count` INTO current_enrollment
    FROM `capacity`
    WHERE `CRN` = OLD.`CRN`;

    -- Decrement the enrollment_count for the course
    UPDATE `capacity`
    SET `enrollment_count` = `enrollment_count` - 1
    WHERE `CRN` = OLD.`CRN`;

END;
//

DELIMITER ;


CREATE INDEX idx_std_email ON students(email);
CREATE INDEX idx_instructors_email ON instructors(email);

CREATE VIEW course_instructor_view AS
SELECT ci.CRN, c.name AS course_name, CONCAT(i.first_name, ' ', i.last_name) AS instructor_name
FROM course_instructors ci
JOIN course_registration_number crn ON ci.CRN = crn.CRN
JOIN courses c ON crn.course_id = c.id
JOIN instructors i ON ci.instructor_id = i.id;

CREATE VIEW students_in_class AS
SELECT e.CRN, c.name, s.id AS student_id, s.first_name, s.last_name
FROM enrollment e
JOIN students s ON e.student_id = s.id
JOIN course_registration_number crn ON crn.CRN = e.CRN
JOIN courses c ON c.id = crn.course_id;
