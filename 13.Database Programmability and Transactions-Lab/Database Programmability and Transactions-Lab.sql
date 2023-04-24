USE `soft_uni`;

SELECT COUNT(*) FROM `employees` AS `e`
JOIN `addresses` AS `a` ON `a`.`address_id` = `e`.`address_id`
JOIN `towns` AS `t` ON `t`.`town_id` = `a`.`town_id`
WHERE `t`.`name` = 'Sofia';

DELIMITER $$
CREATE FUNCTION `ufn_count_employees_by_town`()
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN (
		SELECT COUNT(*) FROM `employees` AS `e`
		JOIN `addresses` AS `a` ON `a`.`address_id` = `e`.`address_id`
		JOIN `towns` AS `t` ON `t`.`town_id` = `a`.`town_id`
		WHERE `t`.`name` = 'Sofia'
        );
END$$

SELECT ufn_count_employees_by_town();


CREATE FUNCTION `ufn_count_employees_by_town_fun`(town_name VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE e_count INT;
    SET e_count :=(SELECT COUNT(employee_id) FROM employees AS `e`
		JOIN addresses AS `a` ON `a`.`address_id` = `e`.`address_id`
        JOIN towns AS `t` ON `t`.`town_id` = `a`.`town_id`
	WHERE `t`.`name` = town_name);
	RETURN e_count;
END;

SELECT ufn_count_employees_by_town_fun('Sofia');

USE `soft_uni`;
 DELIMITER $$
CREATE PROCEDURE `usp_raise_salaries`(`department_name` VARCHAR(50))
BEGIN
	UPDATE `employees` SET `salary` = `salary` * 1.05
    WHERE `department_id` =(
		SELECT `department_id` FROM `departments`
        WHERE `name` = `department_name`
    );
END$$

CALL `usp_raise_salaries`('Finance')$$

SELECT `first_name`, `salary` FROM `employees`
WHERE `department_id` = 10
ORDER BY `first_name`, `salary`;

CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
DECLARE count_by_id INT;
	START TRANSACTION;
    SET count_by_id := (SELECT COUNT(*) FROM `employees` WHERE `employee_id` = id);
    
	UPDATE `employees` SET `salary` = `salary` * 1.05 WHERE `employee_id` = id;
    
    IF(count_by_id  < 1) THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
END$$


CREATE TABLE `deleted_employees`(
	`employee_id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50),
    `last_name` VARCHAR(50),
    `middle_name` VARCHAR(50),
    `job_title` VARCHAR (50),
    `department_id` INT,
    `salary` DOUBLE
)$$

CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
	INSERT INTO deleted_employees(`first_name`,`last_name`, `middle_name`, `job_title`, `department_id`, `salary`)
    VALUES (OLD.`first_name`,OLD.`last_name`, OLD.`middle_name`, OLD.`job_title`, OLD.`department_id`, OLD.`salary`);
END$$

SELECT * FROM `employees` AS `e`
WHERE (SELECT COUNT(*) FROM `employees_projects` AS `ep`
WHERE `ep`.`employee_id` = `e`.`employee_id`) = 0$$

DELETE FROM `employees` WHERE `employee_id` = 6$$





