create database `exercise`;

use `exercise`;
create table `people`(
	`id` int primary key auto_increment ,
    `name` varchar(200) not null, 
    `picture` blob,
    `height` double(10, 2),
    `weight` double(10, 2),
    `gender` enum('m', 'f') not null,
    `birthdate` date not null,
    `biography` text
);

insert into `people`(`name`,`gender`, `birthdate`)
values
('Boris', 'm', date(now())),
("Aleksandar", 'm', date(now())),
("Dancho", 'm', date(now())),
('Peter', 'm', date(now())),
('Desi', 'f', date(now()));

create table users(
	id int primary key auto_increment,
    zusername varchar(30) not null,
    password varchar(26) not null, 
    profile_picture blob,
    last_login_time time,
    is_deleted boolean
);

insert into users(username, password)
values
('pesho', 'pesho123'),
('scopi', 'scopi123'),
('martin', 'martin123'),
('gosho', 'gosho123'),
('stefan', 'stefan123');

#remove primary key
ALTER TABLE `users`
DROP PRIMARY KEY,
#add primary key to two colums
ADD PRIMARY KEY `pk_users`(`id`, `username`);

ALTER TABLE `users`
#ALTER COLUMN #set or remove def value on column
#CHANGE COLUMN -- rename, change type, move, resize
#MODIFY COLUMN -- like change but no rename
MODIFY COLUMN `last_login_time` DATETIME DEFAULT NOW();

ALTER TABLE `users`
DROP PRIMARY KEY,#premaham pk ot dvete kloni
ADD CONSTRAINT `pk_users`
PRIMARY KEY `users` (`id`),#dobavqme pk samo na id
MODIFY COLUMN `username` VARCHAR(30) UNIQUE;#tuk pravim nashata kolona username da e unikalna



