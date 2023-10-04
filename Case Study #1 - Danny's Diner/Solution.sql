
-- 1. What is the total amount each customer spent at the restaurant?


SELECT 
	customer_id, 
	SUM(price) AS 'Total amount spent'
FROM sales s
	LEFT JOIN menu m on s.product_id = m.product_id
GROUP BY customer_id;


-- 2. How many days has each customer visited the restaurant?


SELECT 
	customer_id, 
	COUNT(DISTINCT order_date) AS visit_days
FROM sales s
GROUP BY customer_id;

 
-- 3. What was the first item from the menu purchased by each customer?


WITH rank_cte AS (
SELECT 
	customer_id,
	product_name,
	RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS rank
FROM sales s
	JOIN  menu m ON m.product_id = S.product_id
)

SELECT 
	customer_id,
	product_name
FROM rank_cte 
WHERE rank = 1
GROUP BY 
	customer_id, 
	product_name;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?


SELECT TOP 1 
	product_name, 
	COUNT(order_date) AS orders_no
FROM sales s
	LEFT JOIN  menu m ON m.product_id = S.product_id
GROUP BY product_name
ORDER BY orders_no DESC;


-- 5. Which item was the most popular for each customer?


WITH rank_cte AS(

SELECT 
	customer_id,
	product_name,
	COUNT(s.product_id) AS orders,
	RANK() OVER( PARTITION BY customer_id ORDER BY COUNT(s.product_id) DESC) AS rank
FROM sales s
	LEFT JOIN  menu m ON m.product_id = S.product_id
GROUP BY 
	customer_id,
	product_name
)

SELECT 
	customer_id,
	product_name,
	orders
FROM rank_cte
WHERE rank = 1;


-- 6. Which item was purchased first by the customer after they became a member?


WITH rank_cte AS(
SELECT 
	s.customer_id,
	men.product_name,
	RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rank
FROM sales s
	JOIN members m  ON m.customer_id = s.customer_id
	JOIN menu men ON men.product_id = s.product_id
WHERE s.order_date >= m.join_date
)

SELECT 
	customer_id,
	product_name AS product
FROM rank_cte 
WHERE rank = 1;


-- 7. Which item was purchased just before the customer became a member?


WITH rank_cte AS(
SELECT 
	s.customer_id,
	order_date,
	product_id,
	RANK() OVER( PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS rank
FROM sales s
	JOIN members m ON m.customer_id = s.customer_id
WHERE order_date < join_date
)

SELECT 
	customer_id,
	order_date,
	product_id
FROM rank_cte
WHERE rank = 1;


-- 8. What is the total items and amount spent for each member before they became a member?


SELECT 
	s.customer_id,
	COUNT(s.product_id) AS total_items,
	SUM(m.price) AS amount_spent
FROM sales s
	JOIN menu m ON m.product_id = s.product_id
	JOIN members mem ON mem.customer_id = s.customer_id
WHERE order_date < join_date
GROUP BY s.customer_id;


-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?


SELECT
	customer_id,
	SUM(CASE
		WHEN product_name = 'sushi' THEN price * 20
		ELSE price * 10
	END) AS points
FROM sales s
	LEFT JOIN menu m ON m.product_id = s.product_id
GROUP BY customer_id;



-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


SELECT
	s.customer_id,
	SUM(
	CASE
		WHEN order_date >= join_date AND order_date < DATEADD(DAY, 7, join_date) THEN price * 20 
		ELSE price 
	END) AS points
FROM sales s
	JOIN members m ON s.customer_id = m.customer_id
	JOIN menu men ON men.product_id = s.product_id
WHERE MONTH(order_date) = 1
GROUP BY s.customer_id;
