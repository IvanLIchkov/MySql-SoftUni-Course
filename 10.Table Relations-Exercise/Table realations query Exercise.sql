use `test`;
#1.	One-To-One Relationship
create table passports(
	`passport_id` int primary key auto_increment,
    `passport_number` varchar(50) not null unique
);

insert into passports(passport_id, passport_number)
values
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');

create table people (
	`person_id` int primary key auto_increment,
    `first_name` varchar(50) not null,
    `salary` decimal(9,2) not null,
    `passport_id` int unique,
    constraint fk_passport_id
    foreign key (passport_id)
    references passports(passport_id)
);

insert into people( first_name, salary, passport_id) 
values
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101);


#2.	One-To-Many Relationship
create database cars;

use cars;

create table manufacturers(
	manufacturer_id int primary key auto_increment,
    `name` varchar(55),
    established_on date
);

insert into manufacturers(`name`, established_on) values
('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');

create table models(
	model_id int primary key auto_increment,
    `name` varchar(50),
    manufacturer_id int,
    constraint fk_model_manufacurer_id
    foreign key (manufacturer_id)
    references manufacturers(manufacturer_id)
);

insert into models(model_id, `name`, manufacturer_id) values
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3);

#3.	Many-To-Many Relationship
create database students;
use students;

create table students(
	student_id int primary key auto_increment,
    `name` varchar(50)
);
insert into students(`name`) values
('Mila'),
('Toni'),
('Ron');

create table exams(
	exam_id int primary key auto_increment,
    `name` varchar(50)
);
insert into exams(`exam_id`, `name`) values
(101, 'Spring MVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g');

CREATE TABLE students_exams (
    student_id INT,
    exam_id INT,
    CONSTRAINT fk_student_id FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT fk_exam_id FOREIGN KEY (exam_id)
        REFERENCES exams (exam_id),
        primary key (student_id, exam_id)
);

insert into students_exams(student_id, exam_id) values 
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);

#4.	Self-Referencing

create table teachers(
	teacher_id int primary key auto_increment,
    `name` varchar(50) not null,
    manager_id int,
    constraint fk_manager_id_teacher_id
    foreign key (manager_id)
    references teachers(teacher_id)
);
insert into teachers(teacher_id, `name`, manager_id) values
(101, 'John', null),
(105, 'Mark', 101),
(106, 'Greta', 101),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(104, 'Ted', 105);

#5.	Online Store Database

