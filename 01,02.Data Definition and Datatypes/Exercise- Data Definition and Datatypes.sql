CREATE DATABASE `minions`;

USE `minions`;
CREATE TABLE `minions` (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    age INT 
);

CREATE TABLE `towns`(
	town_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL
);

ALTER TABLE towns
RENAME COLUMN town_id TO id;


alter table `minions`				/*Така се прави forign key*/
add column `town_id` int not null,
add constraint fk_minions_towns
foreign key (`town_id`)
references `towns` (`id`);


insert into `towns`(`id`, `name`) /*Така се прави запис в таблицата*/
values (1, 'Sofia'),(2, 'Plovdiv'), (3, 'Varna');

insert into `minions` (`id`, `name`, `age`, `town_id`)
values(1,"Kevin", 22, 1),(2,"Bob", 15, 3),(3, "Steward", null, 2);

truncate table `minions`;  /*Така трием информацията в таблицата*/

drop table `minions`;/*Така се трият направо целите таблици*/
drop table `towns`;

