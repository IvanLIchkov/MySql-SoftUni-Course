CREATE DATABASE ruk_database;

use ruk_database;

CREATE TABLE branches(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE employees(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    started_on DATE NOT NULL,
    branch_id INT NOT NULL,
    COnstraint fk_branches
    foreign key (branch_id)
    REFERENCES branches(id)
);

CREATE TABLE clients(
	id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    age INT NOT NULL
);

CREATE TABLE employees_clients (
    employee_id INT,
    client_id INT,
    CONSTRAINT fk_employees FOREIGN KEY (employee_id)
        REFERENCES employees (id),
    CONSTRAINT fk_clients FOREIGN KEY (client_id)
        REFERENCES clients (id)
);

CREATE TABLE bank_accounts(
	id INT PRIMARY KEY AUTO_INCREMENT,
    account_number VARCHAR(10) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL,
    client_id INT NOT NULL UNIQUE,
    CONSTRAINT fk_bank_account_client FOREIGN KEY (client_id)
		REFERENCES clients(id)
);

CREATE TABLE cards(
	id INT PRIMARY KEY AUTO_INCREMENT,
    card_number VARCHAR(19) NOT NULL,
    card_status VARCHAR(7) NOT NULL,
    bank_account_id INT NOT NULL,
    CONSTRAINT fk_cards_bank_account FOREIGN KEY (bank_account_id)
		REFERENCES bank_accounts(id)
);

#2 part

INSERT INTO cards(card_number, card_status, bank_account_id)
SELECT REVERSE(full_name) as card_number,"Active" as card_status ,id as bank_account_id from clients
where id between 191 and 200;


UPDATE employees_clients AS ec
JOIN
	(SELECT ec1.employee_id, COUNT(ec1.client_id) as `count` from employees_clients AS ec1
    group by ec1.employee_id
    order by `count`, ec1.employee_id) as s
set ec.employee_id = s.employee_id
where ec.employee_id = ec.client_id;

UPDATE employees_clients as ec
JOIN
(SELECT ec1.employee_id, COUNT(ec1.client_id) AS 'count'
		FROM employees_clients as ec1 
		GROUP BY ec1.employee_id
		ORDER BY `count`, ec1.employee_id) AS s
SET ec.employee_id = s.employee_id
WHERE ec.employee_id = ec.client_id;

DELETE from employees
where id not IN(select employee_id from employees_clients);

# 3
SELECT id, full_name from clients
order by id;

select id, CONCAT_WS(" ", first_name, last_name) as full_name, CONCAT_WS("", "$",salary) as salary, started_on from employees
where salary>=100000 and DATE(started_on) >= "2018-01-01" 
order by salary desc , id desc;

SELECT carD.id, CONCAT_WS(" : ",carD.card_number, c.full_name) AS card_token from clients c
join bank_accounts ba on c.id = ba.client_id
join cards as carD on ba.id = carD.bank_account_id
order by carD.id desc;

SELECT CONCAT_WS(" ", e.first_name, e.last_name) as name , e.started_on ,COUNT(e.id) as count_of_clients from employees as e
JOIN employees_clients as ec on ec.employee_id = e.id
group by e.id
order by count_of_clients desc, e.id
limit 5;

SELECT b.name, count(carD.id) as count_of_cards from branches as b
left join employees as e on e.branch_id = b.id
left join employees_clients as ec on e.id = ec.employee_id
left join clients as c on c.id = ec.client_id
left join bank_accounts as ba on c.id = ba.client_id
left join cards as carD on carD.bank_account_id = ba.id
group by b.name
order by count_of_cards desc, b.name;

#4
select count(card.id) as cars from clients as c
    join bank_accounts as ba on ba.client_id = c.id
   join cards as card on card.bank_account_id = ba.id
   where c.full_name = "Baxy David";

DELIMITER $$
CREATE FUNCTION udf_client_cards_count(name VARCHAR(30)) 
returns int
deterministic
begin
	return(select count(card.id) as cars from clients as c
    join bank_accounts as ba on ba.client_id = c.id
   join cards as card on card.bank_account_id = ba.id
   where c.full_name = name);
end$$

CREATE PROCEDURE udp_clientinfo(full_name varchar(50))
begin
	select c.full_name, c.age, ba.account_number, concat_ws("","$", ba.balance) as balance from clients as c
    join bank_accounts ba on ba.client_id = c.id
    where c.full_name LIKE full_name;
end$$

call udp_clientinfo('Hunter Wesgate')$$
