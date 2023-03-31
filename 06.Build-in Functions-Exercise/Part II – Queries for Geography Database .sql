USE `geography`;


SELECT `country_name`, `iso_code` FROM `countries`
WHERE `country_name` LIKE '%a%a%a%'
ORDER BY `iso_code`;

SELECT `peak_name`, `river_name`, LOWER(CONCAT_WS ("",`peak_name`, SUBSTR(`river_name`,2))) AS `mix` FROM `peaks`, `rivers`
WHERE RIGHT(`peak_name`,1) = LEFT(`river_name`,1)
ORDER BY `mix`;
