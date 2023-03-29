CREATE DATABASE `gamebar`;
USE `gamebar`;

CREATE TABLE `employees`(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL
);
CREATE TABLE `categories`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(100) NOT NULL
);

CREATE TABLE  `products`(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(100) NOT NULL,
    `category_id` INT NOT NULL
);
INSERT INTO `employees`(`first_name`, `last_name`) VALUES ("Pesho", "Peshov");
INSERT INTO `employees`(`first_name`, `last_name`) VALUES 
("Gosho", "Goshov"),
 ("Gergana", "Peshova");
 
 ALTER TABLE `employees`
 ADD COLUMN `middle_name` VARCHAR(100);
 
 ALTER TABLE `employees`
 MODIFY COLUMN `middle_name` VARCHAR(100);
 
alter table `products` add constraint fk_products_categories 
foreign key `products`(`category_id`) references `categories`(`id`);
 