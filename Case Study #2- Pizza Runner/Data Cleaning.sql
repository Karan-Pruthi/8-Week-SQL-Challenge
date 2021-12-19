
--   --------------------
--   Data Cleaning
--   --------------------

-- Note: Used PostgreSQL v13 for the SQL queries

-- Check Data Type in 'Customer_Orders' Table

SELECT
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'customer_orders';
	
-- Results:-

-- | ─────────── | ─────────────────────────── |
-- | column_name |         data_type           |
-- | ─────────── | ─────────────────────────── |
-- | order_id    | integer                     |
-- | customer_id | integer                     |
-- | pizza_id    | integer                     |
-- | order_time  | timestamp without time zone |
-- | exclusions  | character varying           |
-- | extras      | character varying           |
-- | ─────────── | ──────────────────────────── 


-- Check Data Type in 'runner_orders' Table

SELECT
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'runner_orders';

-- Results:-

-- | ──────────── | ────────────────────── |
-- | column_name  |         data_type      |
-- | ──────────── | ────────────────────── |
-- | order_id     | integer                |
-- | runner_id    | integer                |
-- | pickup_time  | character varying      |
-- | distance     | character varying      |
-- | duration     | character varying      |
-- | cancellation | character varying      |
-- | ──────────── | ────────────────────── |

--SQL functions: Create temp table, CASE WHEN, TRIM, ALTER TABLE, ALTER data type, filtering using '%'

-- Cleaning both tables starting with Customer_orders

--TABLE-: customer_orders

-- 'exclusions' column - there are missing/ blank spaces ' ' and null values.
-- 'extras' column - there are missing/ blank spaces ' ' and null values.

-- Remove null values in exlusions and extras columns and replace with blank space ' '
-- Saving the transformations in a temporary table since we dont want to permanently update the original table


CREATE TEMP TABLE temp_customer_orders AS
SELECT 
  order_id, 
  customer_id, 
  pizza_id, 
  CASE
	  WHEN exclusions LIKE 'null' THEN ''
	  ELSE exclusions
	  END AS exclusions,
  CASE
	  WHEN extras IS null OR extras LIKE 'null' THEN ''
	  ELSE extras
	  END AS extras,
	order_time
FROM pizza_runner.customer_orders;

-- Checking the results of temporary created table 
SELECT * FROM temp_customer_orders

-- Results:-

-- | ──────── | ─────────── | ──────── | ────────── | ────── | ──────────────────────── |
-- | order_id | customer_id | pizza_id | exclusions | extras | order_time               |
-- | ──────── | ─────────── | ──────── | ────────── | ────── | ──────────────────────── |
-- | 1        | 101         | 1        |            |        | 2020-01-01T18:05:02.000Z |
-- | 2        | 101         | 1        |            |        | 2020-01-01T19:00:52.000Z |
-- | 3        | 102         | 1        |            |        | 2020-01-02T23:51:23.000Z |
-- | 3        | 102         | 2        |            |        | 2020-01-02T23:51:23.000Z |
-- | 4        | 103         | 1        | 4          |        | 2020-01-04T13:23:46.000Z |
-- | 4        | 103         | 1        | 4          |        | 2020-01-04T13:23:46.000Z |
-- | 4        | 103         | 2        | 4          |        | 2020-01-04T13:23:46.000Z |
-- | 5        | 104         | 1        |            | 1      | 2020-01-08T21:00:29.000Z |
-- | 6        | 101         | 2        |            |        | 2020-01-08T21:03:13.000Z |
-- | 7        | 105         | 2        |            | 1      | 2020-01-08T21:20:29.000Z |
-- | 8        | 102         | 1        |            |        | 2020-01-09T23:54:33.000Z |
-- | 9        | 103         | 1        | 4          | 1, 5   | 2020-01-10T11:22:59.000Z |
-- | 10       | 104         | 1        |            |        | 2020-01-11T18:34:49.000Z |
-- | 10       | 104         | 1        | 2, 6       | 1, 4   | 2020-01-11T18:34:49.000Z |
-- | ──────── | ─────────── | ──────── | ────────── | ────── | ──────────────────────── |

--TABLE-: runner_orders

-- 'pickup_time' column - there are 'null' text values
-- 'cancellation' column - there are missing/blank spaces ' ' and 'null' text values
-- 'distance' column - there are 'null' values and unit values (km) which needs to be removed
-- 'duration' column - there are 'null' values and unit values (minutes) which needs to be removed
-- convert text 'null' to null values
-- pickup time, distance, duration columns are of the wrong type

-- Saving the transformations in a temporary table since we dont want to permanently update the original table

CREATE TEMP TABLE temp_runner_orders AS
SELECT 
  order_id, 
  runner_id,  
  CASE
	  WHEN pickup_time LIKE 'null' THEN null
	  ELSE pickup_time
	  END::timestamp AS pickup_time,
  CASE
	  WHEN distance LIKE 'null' THEN null
	  WHEN distance LIKE '%km' THEN TRIM('km' from distance)
	  ELSE distance 
    END::numeric AS distance,
  CASE
	  WHEN duration LIKE 'null' THEN null
	  WHEN duration LIKE '%mins' THEN TRIM('mins' from duration)
	  WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
	  WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
	  ELSE duration
	  END::numeric AS duration,
  CASE
	  WHEN cancellation IN ('null', '') THEN null
	  ELSE cancellation
	  END AS cancellation
FROM pizza_runner.runner_orders;

-- Checking the results of temporary created table 
SELECT * FROM temp_customer_orders

-- Results:-

-- | ──────── | ───────── | ─────────────────── | ──────── | ──────── | ─────────────────────── |
-- | order_id | runner_id | pickup_time         | distance | duration | cancellation            |
-- | ──────── | ───────── | ─────────────────── | ──────── | ──────── | ─────────────────────── |
-- | 1        | 1         | 2020-01-01 18:15:34 | 20       | 32       |                         |
-- | 2        | 1         | 2020-01-01 19:10:54 | 20       | 27       |                         |
-- | 3        | 1         | 2020-01-03 00:12:37 | 13.4     | 20       |                         |
-- | 4        | 2         | 2020-01-04 13:53:03 | 23.4     | 40       |                         |
-- | 5        | 3         | 2020-01-08 21:10:57 | 10       | 15       |                         |
-- | 6        | 3         |                     |          |          | Restaurant Cancellation |
-- | 7        | 2         | 2020-01-08 21:30:45 | 25       | 25       |                         |
-- | 8        | 2         | 2020-01-10 00:15:02 | 23.4     | 15       |                         |
-- | 9        | 2         |                     |          |          | Customer Cancellation   |
-- | 10       | 1         | 2020-01-11 18:50:20 | 10       | 10       |                         |
-- | ──────── | ───────── | ─────────────────── | ──────── | ──────── | ─────────────────────── |


***