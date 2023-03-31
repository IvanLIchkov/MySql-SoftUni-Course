USE `restaurant`;

SELECT `department_id`, COUNT(`id`) FROM `employees`
GROUP BY `department_id`;

SELECT `department_id`, ROUND(AVG(`salary`),2) AS `Average Salary` from `employees`
GROUP BY `department_id` ;

SELECT `department_id` , MIN(`salary`) AS `Min Salary` from `employees`
GROUP BY `department_id`
ORDER BY `Min Salary` DESC
LIMIT 1;

SELECT COUNT( `category_id`) AS `count` FROM `products`
WHERE category_id = 2 AND price>8
GROUP BY `category_id`;


SELECT `category_id`, round(AVG(`price`),2) AS `Average Price`, round(MIN(`price`),2) AS `Cheapest Product`, round(MAX(`price`),2) AS `Most Expensive Product` FROM `products`
GROUP BY `category_id`;
