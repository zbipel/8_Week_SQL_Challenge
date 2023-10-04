
-- Creating temporary #temp_customer_orders table, to not interfere with source data

DROP TABLE IF EXISTS #temp_customer_orders

SELECT *
INTO #temp_customer_orders
FROM [8 Week SQL Challenge #2].[pizza_runner].[customer_orders];


-- Detecting and replacing empty / inconsistent values

SELECT *
FROM [8 Week SQL Challenge #2].[pizza_runner].[customer_orders]
WHERE exclusions = ' ' OR extras = ' ' OR exclusions = 'null' OR extras = 'null';

UPDATE #temp_customer_orders
SET exclusions = NULL
FROM #temp_customer_orders
WHERE exclusions IN (' ', 'null');

UPDATE #temp_customer_orders
SET extras = NULL
FROM #temp_customer_orders
WHERE extras IN (' ', 'null');


-- Validating changes

SELECT * 
FROM #temp_customer_orders;


\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


-- Creating temporary temp_runner_orders table
-- Detecting and replacing empty / inconsistent values
-- Converting data to proper data types


SELECT 
	order_id,
	runner_id,
	CASE
		WHEN pickup_time = 'null' THEN NULL
		ELSE pickup_time
	END AS pickup_time,
	CASE
		WHEN distance = 'null' THEN NULL
		ELSE CAST(TRIM(REPLACE(distance, 'km', '')) AS DECIMAL (3,1))
	END AS distance_km,
	CASE
		WHEN duration = 'null' THEN NULL
		ELSE CAST(TRIM(REPLACE(REPLACE(REPLACE(duration, 'minutes', ''), 'mins', ''), 'minute', '')) AS INT)
	END AS duration_min,
	CASE
		WHEN cancellation = 'null' THEN NULL
		WHEN cancellation = '' THEN NULL
		ELSE cancellation
	END AS cancellation
INTO #temp_runner_orders
FROM [8 Week SQL Challenge #2].[pizza_runner].[runner_orders];


--Validating changes

SELECT *
FROM #temp_runner_orders;
