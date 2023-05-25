create database fsd;

use fsd;

CREATE TABLE countries(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL
);

CREATE TABLE towns(
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR (45) NOT NULL,
    country_id INT NOT NULL,
    constraint fk_countries_id
    foreign key(country_id)
    references countries(id)
);

CREATE TABLE stadiums(
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    capacity INT NOT NULL,
    town_id INT NOT NULL,
    constraint fk_towns_id
    foreign key (town_id)
    references towns(id)
);

create table teams(
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    established DATE NOT NULL,
    fan_base BIGINT NOT NULL DEFAULT 0,
    stadium_id INT NOT NULL,
    CONSTRAINT fk_stadiums_id
    FOREIGN KEY(stadium_id)
    REFERENCES stadiums(id)
);

create table skills_data(
	id INT PRIMARY KEY AUTO_INCREMENT,
    dribbling INT DEFAULT 0,
    pace INT DEFAULT 0,
    passing INT DEFAULT 0,
    shooting INT DEFAULT 0,
    speed INT DEFAULT 0,
    strength INT DEFAULT 0
);
create table coaches(
	id int PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10,2) DEFAULT 0,
    coach_level INT DEFAULT 0
);

create table players(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    age INT NOT NULL DEFAULT 0,
    position CHAR(1) NOT NULL,
    salary DECIMAL(10,2) NOT NULL DEFAULT 0,
    hire_date DATETIME,
    skills_data_id INT NOT NULL,
    team_id INT,
    constraint fk_skills_data_id
    foreign key(skills_data_id)
    references skills_data(id),
     constraint fk_team_id
    foreign key(team_id)
    references teams(id)
);
create table players_coaches(
	player_id INT,
    coach_id INT,
    constraint fk_player_id
    foreign key (player_id)
    references players(id),
    constraint fk_coach_id
    foreign key (coach_id)
    references coaches(id)
);

INSERT INTO coaches(first_name, last_name, salary, coach_level)
select p.first_name AS first_name, p.last_name AS last_name, p.salary*2 as salary, LENGTH(p.first_name) as coach_level from players as p
where age>=45;


UPDATE coaches as c
set coach_level = coach_level+1
where left(c.first_name,1) LIKE "A" and (select count(c.id) from players_coaches as pk where c.id = pk.coach_id)>=1;

DELETE FROM players as p
WHERE p.age>=45;

SELECT first_name, age, salary from players
order by salary desc;

SELECT p.id, CONCAT_WS(" ",p.first_name, p.last_name) full_name, p.age, p.`position`, p.hire_date from players as p
join skills_data AS sd on sd.id = p.skills_data_id
where p.age<23 and `position` like "A" and p.hire_date is null and sd.strength >50
order by salary, age;

Select t.`name` as team_name, t.established, t.fan_base, COUNT(p.id) AS players_count from teams as t
left join players as p on p.team_id = t.id
group by t.id
order by players_count desc, t.fan_base desc;


SELECT MAX(sk.speed) as max_speed, town.`name` from skills_data as sk
right join players as p on p.skills_data_id = sk.id
right join teams as t on p.team_id = t.id
right join stadiums as s on t.stadium_id = s.id
right join towns as town on s.town_id = town.id
where t.`name` not like "Devify"
group by town.`name`
order by MAX(sk.speed) desc, town.`name`;

SELECT c.`name`, COUNT(p.id), SUM(p.salary) from countries as c
left join towns as t on t.country_id = c.id
left join stadiums as s on s.town_id = t.id
left join teams as team on team.stadium_id = s.id
left join players as p on p.team_id = team.id
group by c.`name`
order by COUNT(p.id) desc, c.`name`;

DELIMITER $$
CREATE FUNCTION udf_stadium_players_count (stadium_name VARCHAR(30)) 
returns int
deterministic
begin 
RETURN(	SELECT COUNT(*) from stadiums as s
join teams as t on t.stadium_id = s.id
join players as p on p.team_id = t.id
where s.`name` like stadium_name);
end$$

SELECT udf_stadium_players_count ('Jaxworks') as `count`$$

CREATE PROCEDURE udp_find_playmaker(min_dribble_points int, team_name VARCHAR(45))
begin
	SELECT CONCAT_WS(" ",p.first_name, p.last_name) AS full_name, p.age, p.salary, sd.dribbling, sd.speed, t.`name` from players as p
    join skills_data as sd on sd.id = p.skills_data_id
    join teams as t on t.id = p.team_id
    where sd.dribbling > min_dribble_points and t.`name` like team_name
    order by sd.speed desc
    limit 1;
end$$
drop procedure udp_find_playmaker$$

CALL udp_find_playmaker (20, "Skyble")$$

SELECT CONCAT_WS(" ",p.first_name, p.last_name) AS full_name, p.age, p.salary, sd.dribbling, sd.speed, t.`name` from players as p
    join skills_data as sd on sd.id = p.skills_data_id
    join teams as t on t.id = p.team_id
    where sd.dribbling > 20 and t.`name` like "Skyble"
    order by sd.speed desc
    limit 1
