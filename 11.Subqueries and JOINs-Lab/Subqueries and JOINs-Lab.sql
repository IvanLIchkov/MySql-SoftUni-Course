USE `soft_uni`;


#1.	Managers
SELECT 
	e.`employee_id`,
    CONCAT_WS(' ',e.`first_name`, e.`last_name`) AS `full_name`,
    d.`department_id`,
    d.`name` as `department_name`
FROM
    `employees` e
JOIN
    `departments` d ON e.`employee_id` = d.`manager_id`
    ORDER BY e.`employee_id`
    LIMIT 5;
    
    
    
#2.	Towns Addresses
SELECT 
	t.`town_id`,
    t.`name`,
    a.`address_text`
FROM 
	`addresses` a
JOIN 
	`towns` t ON a.`town_id` = t.`town_id`
WHERE
	t.`name` = 'San Francisco' OR t.`name` = 'Sofia' OR t.`name` = 'Carnation'
ORDER BY 
	t.`town_id`, a.`address_id`;

#3.	Employees Without Managers
SELECT 
	`employee_id`,
    `first_name`,
    `last_name`,
    `department_id`,
    `salary`
FROM
	`employees`
WHERE
	`manager_id` IS NULL;


#4.	Higher Salary
SELECT 
	COUNT(`employee_id`) AS `count`
FROM 
	`employees` 
WHERE `salary`> (SELECT AVG(`salary`) AS `average_salary` FROM `employees`);




