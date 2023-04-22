USE `soft_uni`;


DELIMITER $$
#1.	Employees with Salary Above 35000
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT `first_name`, `last_name` FROM `employees`
    WHERE `salary` > 35000
    ORDER BY `first_name`, `last_name`, `employee_id`;
END$$

CALL usp_get_employees_salary_above_35000()$$

#2.	Employees with Salary Above Number
create procedure usp_get_employees_salary_above(`above_salary` DECIMAL(19, 4))
BEGIN
	SELECT `first_name`, `last_name` FROM `employees`
    WHERE `salary` >= `above_salary`
     ORDER BY `first_name`, `last_name`, `employee_id`;
END$$
call usp_get_employees_salary_above(48100)$$

#3.	Town Names Starting With
CREATE PROCEDURE usp_get_towns_starting_with(`starting_string` VARCHAR(50))
BEGIN
	SELECT `name` AS `town_name` FROM `towns`
    WHERE `name` LIKE CONCAT(`starting_string`, '%')
    ORDER BY `name`;
END$$
drop procedure usp_get_towns_starting_with$$

CALL usp_get_towns_starting_with('b')$$

#4.	Employees from Town
CREATE PROCEDURE usp_get_employees_from_town(`town_name` VARCHAR(50))
BEGIN
	SELECT e.`first_name`, e.`last_name` FROM `employees` AS e
    JOIN `addresses` AS a ON a.`address_id` = e.`address_id`
    JOIN `towns` AS t ON t.`town_id` = a.`town_id`
    WHERE t.`name` LIKE `town_name`
    ORDER BY e.`first_name`, e.`last_name`, e.`employee_id`;
END$$

Drop procedure usp_get_employees_from_town$$
call usp_get_employees_from_town('Sofia')$$

#5.	Salary Level Function
CREATE FUNCTION ufn_get_salary_level(`salary` DECIMAL(19,2))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
		DECLARE `level` VARCHAR(10);
		
		IF (`salary` < 30000) THEN SET `level` = 'Low';
        ELSEIF (`salary`>=30000 && `salary`<=50000) THEN SET `level` = 'Average';
        ELSE SET `level` = 'High';
        END IF;
        RETURN `level`;
END$$
SELECT ufn_get_salary_level(125500.00)$$

#6.	Employees by Salary Level
CREATE PROCEDURE usp_get_employees_by_salary_level(`level` VARCHAR(10))
BEGIN
	SELECT `first_name`, `last_name` FROM `employees`
    WHERE (SELECT ufn_get_salary_level(`salary`)) LIKE `level`
    ORDER BY `first_name` DESC,`last_name`DESC;
END$$
drop procedure usp_get_employees_by_salary_level$$

call usp_get_employees_by_salary_level('high')$$

#7.	Define Function
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN word REGEXP (CONCAT('^[', set_of_letters, ']+$'));
END$$

#8.	Find Full Name
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT CONCAT_WS(" ", `first_name`, `last_name`) AS `full_name` FROM `account_holders`
    ORDER BY `full_name`, `id`;
END$$
drop procedure usp_get_holders_full_name$$
CALL usp_get_holders_full_name()$$

#9.	People with Balance Higher Than
CREATE FUNCTION ufn_get_holder_balance(`id` INT)
RETURNS DECIMAL(19,4)
DETERMINISTIC
BEGIN
	RETURN(SELECT SUM(`balance`) FROM `accounts` AS a
    WHERE a.`account_holder_id` = `id`
    GROUP BY a.`account_holder_id`);
END$$

CREATE PROCEDURE usp_get_holders_with_balance_higher_than(`over_number` DECIMAL(19,4))
BEGIN
	SELECT `first_name`, `last_name` FROM `account_holders`
    WHERE (SELECT ufn_get_holder_balance(`id`)) > `over_number`
    ORDER BY `id`;
END$$

CALL usp_get_holders_with_balance_higher_than(7000)$$

DROP FUNCTION ufn_get_holder_balance$$
SELECT ufn_get_holder_balance(3)$$


#10. Future Value Function
CREATE FUNCTION ufn_calculate_future_value (`sum` DECIMAL(19,4), `y_rate` DOUBLE, `years` INT)
RETURNS DECIMAL(19,4)
DETERMINISTIC
BEGIN
	RETURN `sum`*(POWER(1+`y_rate`, `years`));
END$$

select ufn_calculate_future_value(1000, 0.5, 5)$$

#11. Calculating Interest
CREATE PROCEDURE usp_calculate_future_value_for_account(`id` INT, `interest_rate` DECIMAL(19, 4))
BEGIN
	SELECT 
		a.`id`,
        ah.`first_name`,
        ah.`last_name`,
        a.`balance` AS `current_balance`,
        ufn_calculate_future_value(a.`balance`,`interest_rate`, 5) AS `balance_in_5_years`
	FROM
		`accounts` AS a
	JOIN
		`account_holders` AS ah ON a.`account_holder_id` = ah.`id`
	WHERE a.`id` = `id`;
END$$
drop procedure usp_calculate_future_value_for_account$$

call usp_calculate_future_value_for_account(1, 0.1)$$

#12. Deposit Money
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	UPDATE `accounts` AS a SET `balance`=(`money_amount`+`balance`)
    WHERE a.`id` = `account_id`  AND `money_amount`>0;
END$$
drop procedure usp_deposit_money$$
call usp_deposit_money(1, -200)$$
 
#13. Withdraw Money
 CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19, 4))
 BEGIN
	update `accounts` AS a SET `balance`=(`balance` - `money_amount`)
    WHERE a.id = account_id AND money_amount>0 AND  balance-money_amount >=0;
 END$$
 drop procedure usp_withdraw_money$$
 CALl usp_withdraw_money(1, 113)$$
 
 #14. Money Transfer
 CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19,4)) 
 BEGIN
	START TRANSACTION;
    IF
		from_account_id = to_account_id OR
        amount <=0 OR
        (SELECT balance FROM accounts WHERE id = from_account_id)<amount OR
        (SELECT COUNT(`id`) FROM accounts WHERE id = from_account_id)<>1 OR
        (SELECT COUNT(`id`) FROM accounts WHERE id = to_account_id)<>1
	THEN ROLLBACK;
    ELSE
		UPDATE `accounts` SET balance = balance - amount
        WHERE id = from_account_id;
        UPDATE accounts SET balance = balance + amount
        WHERE id = to_account_id;
	END IF;
 END$$