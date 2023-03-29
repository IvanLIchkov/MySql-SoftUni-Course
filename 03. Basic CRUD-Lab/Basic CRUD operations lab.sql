USE `hotel`;
			-- чрез concat (column1 + " " + column2) AS column1+column1 така се събират две колони
SELECT `id`, concat(`first_name`," ", `last_name`) AS `full_name`, `job_title`, `salary` FROM `employees`
WHERE `salary`>1000.00 -- условие при което да се вземат данните
ORDER BY `id`;

UPDATE `employees`
SET `salary` = `salary`+100
WHERE `job_title` ='Manager';

SELECT `salary` FROM `employees`;

SELECT `id`, `first_name`, `last_name`, `job_title`,`department_id`, `salary` FROM `employees`
WHERE `salary` = (SELECT MAX(`salary`) FROM `employees`);

SELECT `id`, `first_name`, `last_name`, `job_title`,`department_id`, `salary` FROM `employees`
WHERE `department_id` = 4 AND `salary`>=1000
ORDER BY `id`;

DELETE FROM `employees` WHERE `department_id`= 2 OR `department_id` = 1;
SELECT `id`, `first_name`, `last_name`, `job_title`,`department_id`, `salary` FROM `employees`
ORDER BY `id`;
