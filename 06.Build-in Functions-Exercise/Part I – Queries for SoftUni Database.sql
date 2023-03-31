USE `soft_uni`;

SELECT `first_name`, `last_name` FROM `employees`
WHERE `first_name` LIKE 'Sa%'
ORDER BY `employee_id`;

SELECT `first_name`, `last_name` FROM `employees`
WHERE `last_name` LIKE '%ei%'
ORDER BY `employee_id`;

SELECT `first_name` FROM `employees`
WHERE `department_id` IN (3,10) 
AND YEAR(`hire_date`) BETWEEN 1995 and 2005
ORDER BY `employee_id`;

SELECT `first_name`, `last_name` FROM `employees`
WHERE `job_title` NOT LIKE '%engineer%'
ORDER BY `employee_id`;

SELECT `name` FROM `towns`
WHERE length(`name`) BETWEEN 5 AND 6
ORDER BY `name`;

SELECT `town_id`, `name` FROM `towns`
WHERE `name` REGEXP '^[MKBE]'
ORDER BY `name`;

SELECT `town_id`, `name` FROM `towns`
WHERE `name` REGEXP '^(?![RBD])'
ORDER BY `name`;

CREATE VIEW `v_employees_hired_after_2000` AS
	SELECT `first_name`, `last_name` FROM `employees`
    WHERE YEAR(`hire_date`) > 2000
    ORDER BY `employee_id`;
    
    SELECT * FROM v_employees_hired_after_2000;
    
SELECT `first_name`, `last_name` FROM `employees`
WHERE length(`last_name`) =5;
	
    



