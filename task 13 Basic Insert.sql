CREATE DATABASE `soft_uni`;

USE `soft_uni`;

CREATE TABLE `towns`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE `addresses`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `address_text` TEXT NOT NULL
);
ALTER TABLE `addresses`
ADD COLUMN `town_id` INT NOT NULL,
ADD CONSTRAINT `town_id`
FOREIGN KEY (`town_id`)
REFERENCES `towns`(`id`);

CREATE TABLE `departments`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE `employees`(
id INT PRIMARY KEY AUTO_INCREMENT, 
first_name VARCHAR(255) NOT NULL, 
middle_name VARCHAR(255), 
last_name VARCHAR(255) NOT NULL, 
job_title VARCHAR(255), 
department_id INT NOT NULL, 
FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`),
hire_date DATE, 
salary DECIMAL, 
address_id INT,
FOREIGN KEY (`address_id`) REFERENCES `addresses`(`id`)
);

INSERT INTO `towns`(`name`) 
value 
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO `departments`(`name`)
VALUE
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO `employees`(first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUE
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);
