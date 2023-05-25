create database instd;

use instd;

create table users(
	id int primary key auto_increment,
    username varchar(30) not null unique,
    password varchar(30) not null,
    email varchar(50) not null,
    gender char(1) not null,
    age int not null,
    job_title varchar(40) not null,
    ip varchar(30) not null
);
create table  addresses(
	id int primary key auto_increment,
    address varchar(30) not null,
    town varchar(30) not null,
    country varchar(30) not null,
    user_id int not null,
    constraint fk_users_id
    foreign key (user_id)
    references users(id)
);

create table photos(
	id int primary key auto_increment,
    `description` text not null,
    `date` datetime not null,
    views int default 0 not null
);

create table comments(
	id int primary key auto_increment,
    comment varchar(255) not null,
    `date` datetime not null,
    photo_id int not null,
    constraint fk_photos_id
    foreign key(photo_id)
    references photos(id)
);

create table users_photos(
	user_id int not null,
    photo_id int not null,
    constraint fk_users_photos_id foreign key(user_id) references users(id),
	constraint fk_photo_photos_id foreign key(photo_id) references photos(id)
);

create table likes(
	id int primary key auto_increment,
    photo_id int,
    user_id int,
    constraint fk_photo_id_likes foreign key(photo_id) references photos(id),
    constraint fk_user_id_likes foreign key(user_id) references users(id)
);

insert into addresses(address, town, country, user_id)
select u.username as address, u.`password` as town, u.ip as country, u.age as user_id from users u
where u.gender like 'M';

update addresses as a
set a.country = case
	when left(country, 1) like 'B' then "Blocked"
   when left(country, 1) like 'T' then "Test"
   when left(country, 1) like 'P' then "In progress"
   end
   where country like 'B%' or country like 'T%' or country like 'P%';

delete from addresses
where id %3 =0;

select username, gender, age from users
order by age desc, username asc;

select p.id, p.`date`, p.`description`, count(c.id) from photos p
join comments as c on c.photo_id = p.id
group by p.id
order by count(c.id) desc, p.id asc
limit 5;

select concat_ws(' ', u.id, u.username) as id_username, u.email from users as u
join users_photos up on up.user_id = u.id
where up.user_id = up.photo_id
order by u.id;

select p.id, count(l.id) as likes_count, (select count(c.id) from photos as p1 left join comments as c on c.photo_id = p1.id where p.id = p1.id group by p1.id) as comments_count from photos as p
left join likes as l on l.photo_id = p.id
group by p.id
order by likes_count desc, comments_count desc, p.id asc;

select concat_ws('', left(p.`description`, 30),'...') as summary, `date` from photos p
where day(`date`) = 10
order by `date`desc;


DELIMITER $$
create function udf_users_photos_count(username VARCHAR(30))
returns int
deterministic 
begin
	return( select count(p.id) from users as u
    join users_photos as up on up.user_id = u.id
    join photos as p on p.id = up.photo_id
    where u.username like username);
end;

SELECT udf_users_photos_count('ssantryd') AS photosCount$$

create procedure udp_modify_user (address VARCHAR(30), town VARCHAR(30))
BEGIN
	update users as u
    join addresses as a on a.user_id = u.id
    set u.age = u.age+10
    where a.address like address and a.town like town;
END;

drop procedure udp_modify_user$$

CALL udp_modify_user ('97 Valley Edge Parkway', 'Divinópolis');
SELECT u.username, u.email,u.gender,u.age,u.job_title FROM users AS u
WHERE u.username = 'eblagden21'$$
