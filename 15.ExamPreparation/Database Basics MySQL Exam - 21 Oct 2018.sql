CREATE DATABASE colonial_journey_management_system_db;

USE colonial_journey_management_system_db;

CREATE TABLE planets(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE spaceports(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    planet_id INT(11) DEFAULT NULL,
    KEY `fk_spaceports_planets_idx` (`planet_id`),
    CONSTRAINT fk_planet_id
    FOREIGN KEY (planet_id)
    REFERENCES planets(id)
);

CREATE TABLE spaceships(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(30) NOT NULL,
    light_speed_rate INT(11) DEFAULT 0
);

CREATE TABLE colonists(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    ucn CHAR(10) NOT NULL UNIQUE,
    birth_date DATE NOT NULL
);
CREATE TABLE journeys(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    journey_start DATETIME NOT NULL,
    journey_end DATETIME NOT NULL,
    purpose ENUM("Medical", "Technical", "Educational", "Military") NOT NULL,
    destination_spaceport_id INT(11) DEFAULT NULL,
    spaceship_id INT(11) DEFAULT NULL,
    CONSTRAINT fk_destination_spacesport_spacesports
    FOREIGN KEY (destination_spaceport_id)
    REFERENCES spaceports(id),
    CONSTRAINT fk_spaship_id_spaceships_id
    foreign key(spaceship_id)
    REFERENCES spaceships(id)
);

CREATE TABLE travel_cards(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    card_number CHAR(10) NOT NULL UNIQUE,
    job_during_journey ENUM("Pilot", "Engineer", "Trooper", "Cleaner", "Cook") NOT NULL,
    colonist_id	INT(11) DEFAULT NULL,
    journey_id INT(11) DEFAULT NULL,
    CONSTRAINT	fk_colonist_id_colonists
    FOREIGN KEY(colonist_id)
    REFERENCES colonists(id),
    CONSTRAINT fk_journey_id_journeys
    FOREIGN KEY(journey_id)
    REFERENCES journeys(id)
);

INSERT INTO travel_cards(card_number, job_during_journey, colonist_id, journey_id)
SELECT(CASE WHEN birth_date > "1980-01-01"
 THEN  CONCAT_WS('',YEAR(birth_date), DAY(birth_date), LEFT(ucn,4))
ELSE 
   CONCAT_WS('', YEAR(birth_date),MONTH(birth_date), RIGHT(ucn,4))
END)AS card_number,
(CASE
		WHEN id %2 = 0 THEN "Pilot"
        WHEN id %3 = 0 THEN "Cook"
        ELSE "Engineer"
	END
)AS job_during_journey,
id AS colonist_id,
LEFT(ucn,1) AS journey_id
FROM colonists
WHERE id between 96 and 100;

UPDATE journeys
SET purpose = CASE 
	WHEN id %2 = 0 THEN "Medical"
	when id % 3 = 0 THEN "Technical"
    when id % 5 = 0 THEN "Educational"
    when id % 7 = 0 then "Military"
    END
WHERE id %2 =0 OR id % 3 = 0 OR id % 5 = 0 OR id % 7 = 0;

DELETE FROM colonists
WHERE id not In (select colonist_id FROM travel_cards);

SELECT card_number, job_during_journey FROM travel_cards
ORDER BY card_number ASC;

SELECT id, CONCAT_WS(" ", first_name, last_name) AS full_name, ucn FROM colonists
ORDER BY first_name, last_name, id;

SELECT id, journey_start, journey_end FROM journeys
WHERE purpose LIKE "Military"
ORDER BY journey_start;

SELECT c.id, CONCAT_WS(" ",c.first_name, c.last_name)AS full_name FROM colonists AS c
JOIN travel_cards AS tc ON tc.colonist_id = c.id
WHERE tc.job_during_journey LIKE  "Pilot"
ORDER BY c.id;

SELECT COUNT(c.id) AS count FROM colonists AS c
JOIN travel_cards AS tc ON c.id = tc.colonist_id
JOIN journeys AS j ON j.id = tc.journey_id
WHERE j.purpose LIKE "Technical";

SELECT sh.`name` AS spaceship_name, sp.`name` AS spaceport_name FROM spaceships AS sh
JOIN journeys AS j ON j.spaceship_id = sh.id
JOIN spaceports AS sp ON j.destination_spaceport_id = sp.id
ORDER BY sh.light_speed_rate DESC
LIMIT 1;

SELECT sh.`name` , sh.manufacturer FROM spaceships AS sh
JOIN journeys AS j ON j.spaceship_id = sh.id
JOIN travel_cards AS tc ON tc.journey_id = j.id
JOIN colonists AS c ON c.id = tc.colonist_id
WHERE tc.job_during_journey LIKE 'Pilot' AND c.birth_date >  "1989-01-01"
ORDER BY sh.`name`;

SELECT p.`name` AS planet_name, sp.`name` AS spaceport_name FROM journeys AS j
JOIN spaceports AS sp ON sp.id = j.destination_spaceport_id
JOIN planets AS p ON p.id = sp.planet_id
WHERE j.purpose LIKE 'Educational'
ORDER BY sp.`name` DESC;

SELECT p.`name` AS planet_name, COUNT(p.`name`) AS journeys_count FROM journeys AS j
JOIN spaceports AS sp ON sp.id = j.destination_spaceport_id
JOIN planets AS p ON p.id = sp.planet_id
GROUP BY p.`name`
ORDER BY journeys_count DESC , planet_name ASC;

SELECT j.id , p.`name` AS planet_name, sp.`name` AS spaceport_name, j.purpose AS journey_purpose FROM journeys AS j
JOIN spaceports AS sp ON sp.id = j.destination_spaceport_id
JOIN planets AS p ON p.id = sp.planet_id
ORDER BY j.journey_end - j.journey_start
LIMIT 1;

SELECT j.id FROM journeys AS j
JOIN spaceports AS sp ON sp.id = j.destination_spaceport_id
JOIN planets AS p ON p.id = sp.planet_id
ORDER BY j.journey_end - j.journey_start DESC
limit 1;

SELECT  job_during_journey AS job_name FROM travel_cards
WHERE journey_id = (SELECT j.id FROM journeys AS j
JOIN spaceports AS sp ON sp.id = j.destination_spaceport_id
JOIN planets AS p ON p.id = sp.planet_id
ORDER BY j.journey_end - j.journey_start DESC
limit 1)
GROUP BY job_during_journey
ORDER BY COUNT(job_during_journey)
limit 1;


DELIMITER $$
CREATE FUNCTION udf_count_colonists_by_destination_planet (planet_name VARCHAR (30))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN(
		SELECT COUNT(*) FROM colonists AS c
JOIN
	travel_cards AS tc ON tc.colonist_id = c.id
JOIN
	journeys AS j ON j.id = tc.journey_id
JOIN 
	spaceports AS sp ON sp.id = j.destination_spaceport_id
JOIN 
	planets AS p ON p.id = sp.planet_id
WHERE p.name LIKE planet_name
    );
END$$

SELECT p.name, udf_count_colonists_by_destination_planet("Otroyphus") AS count
FROM planets AS p
WHERE p.name = "Otroyphus"$$

CREATE PROCEDURE udp_modify_spaceship_light_speed_rate(spaceship_name VARCHAR(50), light_speed_rate_increse INT(11)) 
BEGIN 
	IF
		(SELECT COUNT(*) FROM spaceships WHERE `name` LIKE spaceship_name)=0 THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Spaceship you are trying to modify does not exists.';
		ROLLBACK;
	ELSE
		UPDATE spaceships
        SET light_speed_rate = light_speed_rate+light_speed_rate_increse
		WHERE `name` = spaceship_name;
	END IF;
END$$

CALL udp_modify_spaceship_light_speed_rate ("Na Pesho koraba", 1914)$$
SELECT name, light_speed_rate FROM spacheships WHERE name = "Na Pesho koraba"$$

SELECT COUNT(*) FROM spaceships WHERE `name` LIKE "Na Pesho koraba"$$