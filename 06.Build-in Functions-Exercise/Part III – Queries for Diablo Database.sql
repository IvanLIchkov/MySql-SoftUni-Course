USE `diablo`;

SELECT `name`, date_format(`start`, '%Y-%m-%d') AS `start` FROM `games`
WHERE YEAR(`start`) IN (2011,2012)
ORDER BY `start`, `name`
LIMIT 50;

SELECT `user_name`, SUBSTR(email, INSTR(email, '@') + 1) AS `email provider` FROM `users`
ORDER BY `email provider`, `user_name`;

SELECT `user_name`, `ip_address` FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;

SELECT `name`AS `game`,
CASE
WHEN HOUR(`start`) >= 0 AND HOUR(`start`)<12 THEN 'Morning'
WHEN HOUR(`start`) >=12 AND HOUR(`start`)<18 THEN 'Afternoon'
ELSE 'Evening' END AS `Part of the Day`,
CASE
WHEN `duration`<=3 THEN 'Extra Short'
WHEN `duration`>3 AND `duration` <=6 THEN 'Short'
WHEN `duration` >6 AND `duration` <=10 THEN 'Long'
ELSE 'Extra Long' END AS `Duration`
FROM `games`;