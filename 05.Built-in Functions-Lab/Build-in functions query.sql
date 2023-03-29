USE `book_library`;

SELECT `title` FROM `books`
WHERE SUBSTRING(`title`,1, 3) ='The';

SELECT REPLACE (`title`,'The', '***')
AS `title`
FROM `books`
WHERE SUBSTRING(`title`,1, 3) ='The'
ORDER BY `id`;

SELECT FORMAT(SUM(`cost`),2) FROM `books`
AS `total_cost`;

SELECT concat_ws(' ', `first_name`, `last_name`) 
AS `Full Name`,
IF (`died` IS NULL,NULL,DATEDIFF(`died`, `born`)) AS 'Days Lived'
FROM `authors`;

SELECT title FROM books
WHERE title like '%Harry Potter%';




