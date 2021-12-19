/* --------------------
   Case Study Questions:
   --------------------*/

-- Note: Used PostgreSQL v13 for the SQL queries

--B. Runner and Customer Experience

--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
--4. What was the average distance travelled for each customer?
--5. What was the difference between the longest and shortest delivery times for all orders?
--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
--7. What is the successful delivery percentage for each runner?

------------------------------------------------------------------------------------------------

--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT
  to_char(registration_date, 'WW') AS signups_week,
  COUNT(runner_id)
FROM pizza_runner.runners
GROUP BY signups_week
ORDER BY signups_week;


-- | signups_week | count |
-- | ------------ | ----- |
-- | 01           | 2     |
-- | 02           | 1     |
-- | 03           | 1     |


------------------------------------------------------------------------------------------------
--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

WITH runner_pickup_cte AS (
  SELECT
    tro.runner_id,
    (pickup_time - order_time) AS time_to_pickup
  FROM temp_runner_orders AS tro
  JOIN temp_customer_orders AS tco
    ON tro.order_id = tco.order_id
   WHERE tro.cancellation is null
  OR tro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
)
SELECT 
  runner_id,
  DATE_PART('minutes', AVG(time_to_pickup)) AS avg_minutes
FROM runner_pickup_cte
GROUP BY runner_id
ORDER BY runner_id;


-- | runner_id | avg_minutes |
-- | --------- | ----------- |
-- | 3         | 10          |
-- | 2         | 23          |
-- | 1         | 15          |


------------------------------------------------
--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

-- Solution1:
WITH prepare_cte AS (
  SELECT
    COUNT(tco.order_id) AS pizza_count,
    (pickup_time - order_time) AS time_to_pickup
  FROM temp_runner_orders AS tro
  JOIN temp_customer_orders AS tco
    ON tro.order_id = tco.order_id
   WHERE tro.cancellation is null
  OR tro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
  GROUP BY tco.order_id, time_to_pickup
)
SELECT 
  pizza_count,
  AVG(time_to_pickup) AS avg_minutes
FROM prepare_cte
GROUP BY pizza_count
ORDER BY pizza_count;


-- Solution2 :
WITH prep_time_cte AS
(
  SELECT
    ro.order_id,
    COUNT(co.pizza_id) AS pizza_count,
    (DATE_PART('hour', ro.pickup_time - co.order_time) * 60
    + DATE_PART('minute', ro.pickup_time - co.order_time)) AS prep_time
  FROM temp_runner_orders ro
  JOIN temp_customer_orders co 
    ON co.order_id = ro.order_id
  GROUP BY ro.order_id, prep_time
)
    
SELECT
  pizza_count,
  AVG(prep_time) AS avg_prep_time
FROM prep_time_cte
GROUP BY pizza_count
ORDER BY pizza_count;


-- | pizza_count | avg_prep_time |
-- | ----------- | ------------- |
-- | 1           | 12            |
-- | 2           | 18            |
-- | 3           | 29            |



------------------------------------------------
--4. What was the average distance travelled for each customer?

SELECT 
  tco.customer_id,
  AVG(tro.distance) AS avg_distance
FROM temp_customer_orders AS tco
JOIN temp_runner_orders AS tro
  ON tco.order_id = tro.order_id
WHERE tro.cancellation is null
  OR tro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY tco.customer_id
ORDER BY tco.customer_id;

-- Result:-

-- | customer_id | avg_distance       |
-- | ----------- | ------------------ |
-- | 101         | 20                 |
-- | 102         | 16.733333333333334 |
-- | 103         | 23.399999999999995 |
-- | 104         | 10                 |
-- | 105         | 25                 |


------------------------------------------------
--5. What was the difference between the longest and shortest delivery times for all orders?


SELECT
  MAX(duration) - MIN(duration) AS diff_delivery_time
FROM temp_runner_orders;

-- Result:-

-- | difference |
-- | ---------- |
-- | 30         |



-----------------------------------------------------------------------
--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT
  tro.runner_id,
  tco.order_id,
  COUNT(tco.order_id) AS pizza_count,
  tro.distance AS distance_km,
  tro.duration AS duration_minutes,
  distance/duration*60 AS speed_kmh
FROM temp_runner_orders AS tro
JOIN temp_customer_orders AS tco
 ON tro.order_id = tco.order_id
WHERE cancellation IS NULL
GROUP BY tro.runner_id, tco.order_id, tro.distance, tro.duration
ORDER BY tro.runner_id, tco.order_id;

-- Result:-


-- | runner_id | order_id | pizza_count | distance_km | duration_minutes | speed_kmh          |
-- | --------- | -------- | ----------- | ----------- | ---------------- | ------------------ |
-- | 1         | 1        | 1           | 20          | 32               | 37.5               |
-- | 1         | 2        | 1           | 20          | 27               | 44.44444444444444  |
-- | 1         | 3        | 2           | 13.4        | 20               | 40.2               |
-- | 1         | 10       | 2           | 10          | 10               | 60                 |
-- | 2         | 4        | 3           | 23.4        | 40               | 35.099999999999994 |
-- | 2         | 7        | 1           | 25          | 25               | 60                 |
-- | 2         | 8        | 1           | 23.4        | 15               | 93.6               |
-- | 3         | 5        | 1           | 10          | 15               | 40                 |


-----------------------------------------------------------------------
--7. What is the successful delivery percentage for each runner?

SELECT
  runner_id,
  count(order_id) AS Total_orders,
  COUNT(pickup_time) AS delivered_orders,
  (100 * COUNT(pickup_time) / count(order_id)) AS success_delivery_percent
FROM temp_runner_orders
GROUP BY runner_id
ORDER BY runner_id;

-- Result:-

-- | runner_id | total_orders | delivered_orders | success_delivery_percent |
-- | --------- | ------------ | ---------------- | ------------------------ |
-- | 1         | 4            | 4                | 100                      |
-- | 2         | 4            | 3                | 75                       |
-- | 3         | 2            | 1                | 50                       |


-----------------------------------------------------------------------