--  --------------------
--   Case Study Questions:
--  --------------------

-- Note: Used PostgreSQL v13 for the SQL queries

--A. Pizza Metrics

-- 1. How many pizzas were ordered?
-- 2. How many unique customer orders were made?
-- 3. How many successful orders were delivered by each runner?
-- 4. How many of each type of pizza was delivered?
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
-- 6. What was the maximum number of pizzas delivered in a single order?
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
-- 8. How many pizzas were delivered that had both exclusions and extras?
-- 9. What was the total volume of pizzas ordered for each hour of the day?
-- 10. What was the volume of orders for each day of the week?

-----------------------------------------------------------------------------------------

-- 1. How many pizzas were ordered?

SELECT COUNT(order_id) AS pizza_count
FROM temp_customer_orders;

-- Result:-
-- | ──────────── |
-- | pizza_count  |
-- | ──────────── |
-- | 14           | 
-- | ──────────── | 

------------------------------------------------
-- 2. How many unique customer orders were made?

SELECT COUNT (DISTINCT order_id) AS unique_order_count
FROM temp_customer_orders;

-- Result:-
-- | ────────────────── |
-- | unique_order_count |
-- | ────────────────── |
-- | 10                 | 
-- | ────────────────── | 

------------------------------------------------
-- 3. How many successful orders were delivered by each runner?

SELECT
  runner_id,
  COUNT(order_id) AS successful_orders
FROM temp_runner_orders
WHERE cancellation is null
  OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY runner_id
ORDER BY successful_orders DESC;

-- Result:-
--  ───────────  ───────────────────
-- | runner_id  | successful_orders |
--  ───────────  ───────────────────
-- | 1          |       4           |
-- | 2          |       3           |
-- | 3          |       1           |
--  ───────────  ─────────────────── 

------------------------------------------------
-- 4. How many of each type of pizza was delivered?

SELECT
  pn.pizza_name,
  COUNT(*) AS pizza_type_count
FROM temp_customer_orders AS tco
INNER JOIN pizza_runner.pizza_names AS pn
   ON tco.pizza_id = pn.pizza_id
INNER JOIN temp_runner_orders AS tro
   ON tco.order_id = tro.order_id
WHERE cancellation is null
  OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY pn.pizza_name
ORDER BY pn.pizza_name;

-- Result:-

--  ───────────  ──────────────────
-- | pizza_name | pizza_type_count |
-- |───────────  ──────────────────|
-- | Meatlovers | 9                |
-- | Vegetarian | 3                |
--  ───────────  ──────────────────

------------------------------------------------
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT
  customer_id,
  SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS meatlovers,
  SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS vegetarian
FROM temp_customer_orders
GROUP BY customer_id;

-- Result:-
-- ────────────── ─────────────── ───────────── 
-- | customer_id  | meatlovers   | vegetarian  |
-- ────────────── ─────────────── ─────────────
-- | 101          | 2            | 1           |
-- | 103          | 3            | 1           |
-- | 104          | 3            | 0           |
-- | 105          | 0            | 1           |
-- | 102          | 2            | 1           |
--  ────────────── ────────────── ─────────────

-----------------------------------------------------------------------
-- 6. What was the maximum number of pizzas delivered in a single order?

WITH single_order_cte AS
(
  SELECT
    tco.order_id,
    COUNT(tco.pizza_id) AS count_single_order
  FROM temp_customer_orders AS tco
  JOIN temp_runner_orders AS tro
    ON tco.order_id = tro.order_id
  WHERE tro.cancellation is null
    OR tro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
  GROUP BY tco.order_id
)

SELECT
  MAX(count_single_order) AS max_pizza_count
FROM single_order_cte

-- Result:-
-- | ────────────────── |
-- | max_pizza_count    |
-- | ────────────────── |
-- | 10                 | 
-- | ────────────────── | 

-----------------------------------------------------------------------
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT tco.customer_id,
  SUM(CASE 
    WHEN tco.exclusions <> '' OR tco.extras <> '' THEN 1
    ELSE 0
    END) AS with_changes,
  SUM(CASE 
    WHEN tco.exclusions = '' OR tco.extras = '' THEN 1 
	ELSE 0
	END) AS no_changes
FROM temp_customer_orders AS tco
JOIN temp_runner_orders AS tro
  ON tco.order_id = tro.order_id
WHERE tro.cancellation is null
  OR tro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY tco.customer_id
ORDER BY tco.customer_id;

-- Result:-
-- ────────────── ─────────────── ───────────── 
-- | customer_id  | with_changes | no_changes  |
-- ────────────── ─────────────── ─────────────
-- | 101          | 0            | 2           |
-- | 102          | 0            | 3           |
-- | 103          | 3            | 3           |
-- | 104          | 2            | 2           |
-- | 105          | 1            | 1           |
--  ────────────── ────────────── ─────────────

-----------------------------------------------------------------------
-- 8. How many pizzas were delivered that had both exclusions and extras?

SELECT
  SUM(CASE
		WHEN exclusions <> '' AND extras <> '' THEN 1
		ELSE 0
		END) AS Pizza_Count
FROM temp_customer_orders AS tco
JOIN temp_runner_orders AS tro
  ON tco.order_id = tro.order_id
WHERE tro.cancellation is null
  OR tro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')

-- Result:-
-- | ────────────────── |
-- |     pizza_count    |
-- | ────────────────── |
-- |  1                 | 
-- | ────────────────── | 

-----------------------------------------------------------------------
-- 9. What was the total volume of pizzas ordered for each hour of the day?

SELECT
  DATE_PART('hour', order_time) AS hour_of_day,
  COUNT(*) AS pizza_count
FROM temp_customer_orders
WHERE order_time IS NOT NULL
GROUP BY hour_of_day
ORDER BY hour_of_day;

--Result:-
-- | ───────────── ──────────────
-- | hour_of_day  | pizza_count  |
-- | ───────────── ──────────────
-- | 11           | 1            |
-- | 13           | 3            |
-- | 18           | 3            |
-- | 19           | 1            |
-- | 21           | 3            |
-- | 23           | 3            |
--  ────────────── ──────────────

-----------------------------------------------------------------------
-- 10. What was the volume of orders for each day of the week?

SELECT
  TO_CHAR(order_time, 'day') AS day_of_week,
  COUNT(*) AS pizza_count
FROM temp_customer_orders
WHERE order_time IS NOT NULL
GROUP BY day_of_week
ORDER BY day_of_week;

--Result:-
-- | ───────────── ──────────────
-- | day_of_week  | pizza_count  |
-- | ───────────── ──────────────
-- | friday       | 1            |
-- | saturday     | 5            |
-- | thursday     | 3            |
-- | wednesday    | 5            |
--  ────────────── ──────────────

------------------------------------------------

