--A. Pizza Metrics

--How many pizzas were ordered?

SELECT COUNT(pizza_id) AS no_of_pizzas_ordered
FROM #temp_customer_orders;

--How many unique customer orders were made?

SELECT COUNT(DISTINCT order_id) AS unique_customer_orders
FROM #temp_customer_orders;

--How many successful orders were delivered by each runner?

SELECT 
	runner_id, 
	COUNT(pickup_time) AS orders_delivered
FROM #temp_runner_orders
GROUP BY runner_id;


--How many of each type of pizza was delivered?

SELECT 
	pn.pizza_name,
	COUNT(co.pizza_id) AS delivered_pizzas
FROM #temp_customer_orders co
	LEFT JOIN #temp_runner_orders ro ON ro.order_id = co.order_id
	JOIN pizza_runner.pizza_names pn ON pn.pizza_id = co.pizza_id
WHERE ro.pickup_time IS NOT NULL
GROUP BY pn.pizza_name;


--How many Vegetarian and Meatlovers were ordered by each customer?

WITH temp_cte AS(
SELECT 
	co.customer_id,
	pn.pizza_name,
	COUNT(co.pizza_id) AS orders
FROM #temp_customer_orders co
JOIN pizza_runner.pizza_names pn ON pn.pizza_id = co.pizza_id
GROUP BY co.customer_id, pn.pizza_name
)

SELECT 
	customer_id, 
	ISNULL([Meatlovers], 0) AS Meatlovers, 
	ISNULL([Vegetarian], 0) AS Vegetarian
FROM temp_cte
PIVOT (
	SUM(orders)
	FOR pizza_name IN ([Meatlovers], [Vegetarian]) 
) AS p;


--What was the maximum number of pizzas delivered in a single order?

SELECT TOP (1)
	co.order_id,
	COUNT(pizza_id) AS no_of_pizzas
FROM #temp_customer_orders co
	LEFT JOIN #temp_runner_orders ro ON ro.order_id = co.order_id
WHERE ro.pickup_time IS NOT NULL
GROUP BY co.order_id
ORDER BY no_of_pizzas DESC;


--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT
	customer_id,
	SUM(CASE
			WHEN (exclusions IS NULL AND extras IS NULL)
			THEN 1
			ELSE 0 END) AS  pizzas_without_changes,
	SUM(CASE
			WHEN (exclusions IS NOT NULL OR extras IS NOT NULL)
			THEN 1 
			ELSE 0 END) AS  pizzas_without_changes
FROM #temp_customer_orders co
	LEFT JOIN #temp_runner_orders ro ON ro.order_id = co.order_id
WHERE (ro.pickup_time IS NOT NULL)
GROUP BY customer_id;


--How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(pizza_id) AS no_of_pizzas
FROM #temp_customer_orders co
	LEFT JOIN #temp_runner_orders ro ON ro.order_id = co.order_id
WHERE (ro.pickup_time IS NOT NULL) 
	  AND (exclusions IS NOT NULL AND extras IS NOT NULL);


--What was the total volume of pizzas ordered for each hour of the day?

WITH temp_cte AS(

SELECT 
	DATEPART(HOUR, order_time) AS hour,
	pizza_id
FROM #temp_customer_orders
)

SELECT 
	hour, 
	COUNT(pizza_id) AS pizzas_ordered
FROM temp_cte
GROUP BY hour
ORDER BY date;


--What was the volume of orders for each day of the week?

WITH temp_cte AS(

SELECT
	DATEPART(WEEKDAY, order_time) as day_no,
	FORMAT(order_time, 'dddd') AS weekday,
	pizza_id
FROM #temp_customer_orders
)

SELECT 
	weekday,
	COUNT(pizza_id) AS pizzas_ordered
FROM temp_cte
GROUP BY 
	day_no, 
	weekday
ORDER BY day_no;
