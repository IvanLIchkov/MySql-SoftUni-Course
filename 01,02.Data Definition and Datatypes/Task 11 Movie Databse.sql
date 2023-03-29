CREATE DATABASE `Movies`;

USE `Mocies`;

CREATE TABLE `directors`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`director_name` VARCHAR(255) NOT NULL,
    `notes` TEXT
);
CREATE TABLE `genres`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `genre_name` VARCHAR(255) NOT NULL,
    `notes` TEXT
);
CREATE TABLE `categories`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `category_name` VARCHAR(255) NOT NULL,
    `notes` TEXT
);
CREATE TABLE `movies`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL
);
ALTER TABLE `movies`
ADD COLUMN `director_id` INT NOT NULL,
ADD CONSTRAINT `director_id`
FOREIGN KEY (`director_id`)
REFERENCES `directors`(`id`);

ALTER TABLE `movies`
ADD COLUMN `copyright_year` YEAR,
ADD COLUMN `length` DOUBLE,
ADD COLUMN `genre_id` INT NOT NULL,
ADD CONSTRAINT `genre_id`
FOREIGN KEY (`genre_id`)
REFERENCES `genres`(`id`),
ADD COLUMN `category_id` INT NOT NULL,
ADD CONSTRAINT `category_id`
FOREIGN KEY(`category_id`)
REFERENCES `categories`(`id`),
ADD COLUMN `rating` DOUBLE,
ADD COLUMN `notes` TEXT;

INSERT INTO `directors`(`director_name`,`notes`)
value
('pesho','golqm director'),
('vanko', 'luksozen director'),
('tonev', 'piqnski director'),
('zdravko', 'orizov magnat'),
('yono', 'dobri planove');

INSERT INTO `genres`(`genre_name`,`notes`)
value
('Ekshan','hubav film e'),
('Kriminalen', 'qko show'),
('Dokumentalen', 'ima li hora'),
('Musicalen', 'biva'),
('Fantastika', 'sdadsa');

INSERT INTO `categories`(`category_name`)
value
('Zelene'),
('Cherven'),
('Sin'),
('Oranjev'),
('Bql');

INSERT INTO `movies`(`title`, `director_id`, `copyright_year`, `genre_id`, `category_id`)
value
('barzi i qrostni', 1, 20, 1, 2);

INSERT INTO `movies`(`title`, `director_id`, `copyright_year`, `genre_id`, `category_id`)
value
('opasni ulici', 3, 2003, 4, 1),
('star wars 2', 4, 1998, 5, 3),
('kokoshkata s plombiraniq zab', 2, 1957, 2, 1),
('Redjep Ivedik',2, 2021, 3, 3);