# Design Document: Online Course Registration Database

**Author**: Roni Bou Saab

**Date**: 2024-06-08

<!-- **Video Overview**: [Video Overview Link](https://youtu.be/7PUDlp7VfoE) -->

This document outlines the design of an online course registration database for a university. The database aims to streamline course registration processes by providing a central platform for students, instructors, and administrators.

## System Overview

The online course registration system facilitates efficient course enrollment and management. Students can browse available courses, register and drop courses, and access instructor details. Instructors have a view-only interface for their assigned courses. Administrators will possess broader access, including managing course details, instructor assignments, and semester configuration.

## System Functionality

### User Roles and Permissions (Theoretically)

**Students**:
- Search and view course offerings.
- View course descriptions, schedules, and instructor details.
- Register for courses (subject to prerequisite and capacity constraints TODO).
- Drop courses within designated deadlines (the coder using the database should be responsible in enforcing that).
- View their current enrollment status.

**Instructors**:
- View assigned courses for the semester (read-only access).

**Administrators**:
- Manage all aspects of the database, including:
  - Creating and editing courses.
  - Assigning instructors to courses.
  - Configuring semesters.
  - Defining course prerequisites.
  - Managing course capacities.
  - Generating reports on enrollments and waitlists (if implemented).

## Data Model

The system relies on a relational database model with the following core entities and their attributes:
![IMAGE TITLE](diagram.jpg)


### Entities

**Students**:
- `id` (unique identifier, primary key)
- `first_name`
- `last_name`
- `email` (unique identifier)
- `major`
- `year_of_study` (eg: sophomore, senior, ...)

**Instructors**:
- `id` (unique identifier, primary key)
- `first_name`
- `last_name`
- `email` (unique identifier)

**Courses**:
- `id` (unique identifier, primary key)
- `course_name`
- `credits`
- `description`

**Semesters**:
- `id` (unique identifier, primary key)
- `name` (e.g., Fall, Winter, Spring or Summer)
- `year` (e.g., 2024)

**Course Registration Numbers (CRNs)**:
- `crn` (unique identifier, primary key) - identifies a specific course offering in a semester
- `course_id` (foreign key referencing Courses)
- `semester_id` (foreign key referencing Semesters)

**Course Instructors**:
- `crn` (foreign key referencing Course Registration Numbers)
- `instructor_id` (foreign key referencing Instructors) - many-to-many relationship between Courses and Instructors

**Prerequisites**:
- `course_id` (foreign key referencing Courses) - identifies the course requiring a prerequisite
- `prerequisites_course_id` (foreign key referencing Courses) - identifies the prerequisite course

**Capacity**:
- `crn` (foreign key referencing Course Registration Numbers)
- `capacity` (maximum number of students allowed in the course)
- `enrollment_count` (number of students currently enrolled)

**Enrollment**:
- `student_id` (foreign key referencing Students)
- `crn` (foreign key referencing Course Registration Numbers) - many-to-many relationship between Students and Courses
- `enrollment_date`

### Relationships

- A student can enroll in many courses (many-to-many relationship implemented through the Enrollment table).
- A course is offered in a specific semester (identified by the CRN) and has one instructor assigned to it.
- A course can have multiple prerequisites (many-to-many relationship implemented through the Prerequisites table).
- The capacity table tracks the enrollment count for each course offered in a semester.

## Additional Considerations

- The ER Diagram for this system is also included as a separate document for visual representation.
- Indexes will be implemented on frequently queried columns (e.g., student email, instructor email) for faster search performance; however, index on emails where added.
- Views can be created to simplify complex queries, such as retrieving a list of enrolled students for a specific course or retrieving a student's complete course schedule. That why, two views that shows students enrolled in each course, and another showing professors giving which courses.

## System Limitations

- The current design does not explicitly handle course waitlists or priority enrollment functionalities. These features might require additional tables and logic.
- Representing complex prerequisite structures might require triggers or stored procedures within the database.
- Also, a schedule details can be added in the future.
