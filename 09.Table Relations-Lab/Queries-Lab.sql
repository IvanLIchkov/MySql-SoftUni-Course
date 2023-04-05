 USE `test`;
 
 
 create table `mountains` (
	`id`INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL
 );
 CREATE TABLE `peaks` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `mountain_id` INT NOT NULL,
    CONSTRAINT `fk_peaks_mountains` 
    FOREIGN KEY (`mountain_id`) #единия и по-добър начин да добавяме CONSTRAINT
	REFERENCES `mountains` (`id`)
    ON DELETE CASCADE
);
#ALTER TABLE `peaks`			#Втория не толкова добър начин за добавяне зависи кой ми е по удобен
#ADD CONSTRAINT `fk_peaks_mountains`
#FOREIGN KEY (`mountain_id`)
#REFERENCES `mountains`(`id`)



USE `camp`;

SELECT 
    v.driver_id,
    v.vehicle_type,
    CONCAT_WS(' ', c.first_name, c.last_name) AS `driver_name`
FROM
    `vehicles` AS v
        JOIN
    `campers` AS c ON v.driver_id = c.id;
    
select 
r.starting_point as `route_starting_point`,
r.end_point as `route_ending_point`,
 c.id,
 concat_ws(' ', c.first_name, c.last_name) as `leader_name`
 from
 `routes` as r
 join
 `campers` as c on r.leader_id = c.id;

