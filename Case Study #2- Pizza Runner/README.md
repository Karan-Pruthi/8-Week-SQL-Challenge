
# Case Study #2: Pizza Runner

![Pizza Runner image](https://user-images.githubusercontent.com/81607668/127271856-3c0d5b4a-baab-472c-9e24-3c1e3c3359b2.png)

## Table of Contents
- Problem Statement
- Entity Relationship Diagram
- Data
- Case Study Questions
- Solution
  - Data Cleaning
  - A. Pizza Metrics
  - B. Runner and Customer Experience
  
## Problem Statement
Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## Entity Relationship Diagram

![Entity Relationship image](https://user-images.githubusercontent.com/81607668/127271531-0b4da8c7-8b24-4a14-9093-0795c4fa037e.png)

## Data
Danny has shared 6 key datasets for this case study:

### **`runners`**
<details>
<summary>
View table
</summary>

The runners table shows the **`registration_date`** for each new runner.


|runner_id|registration_date|
|---------|-----------------|
|1        |1/1/2021         |
|2        |1/3/2021         |
|3        |1/8/2021         |
|4        |1/15/2021        |

</details>


### **`customer_orders`**

<details>
<summary>
View table
</summary>

Customer pizza orders are captured in the **`customer_orders`** table with 1 row for each individual pizza that is part of the order.

|order_id|customer_id|pizza_id|exclusions|extras|order_time        |
|--------|---------|--------|----------|------|------------------|
|1  |101      |1       |          |      | 2020-01-01 18:05:02 |
|2  |101      |1       |          |      |2020-01-01 19:00:52 |
|3  |102      |1       |          |      |2020-01-02 23:51:23 |
|3  |102      |2       |          |*null* |2020-01-02 23:51:23  |
|4  |103      |1       |4         |      |2020-01-04 13:23:46|
|4  |103      |1       |4         |      |2020-01-04 13:23:46|
|4  |103      |2       |4         |      |2020-01-04 13:23:46|
|5  |104      |1       |null      |1     |2020-01-08 21:00:29|
|6  |101      |2       |null      |null  |2020-01-08 21:03:13|
|7  |105      |2       |null      |1     |2020-01-08 21:20:29 |
|8  |102      |1       |null      |null  |2020-01-09 23:54:33|
|9  |103      |1       |4         |1, 5  |2020-01-10 11:22:59 |
|10 |104      |1       |null      |null  |2020-01-11 18:34:49 |
|10 |104      |1       |2, 6      |1, 4  |2020-01-11 18:34:49 |

</details>

### **`runner_orders`**

<details>
<summary>
View table
</summary>

After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

The **`pickup_time`** is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. 

The **`distance`** and **```duration`** fields are related to how far and long the runner had to travel to deliver the order to the respective customer.



|order_id|runner_id|pickup_time|distance  |duration|cancellation      |
|--------|---------|-----------|----------|--------|------------------|
|1       |1        |1/1/2021 18:15|20km      |32 minutes|                  |
|2       |1        |1/1/2021 19:10|20km      |27 minutes|                  |
|3       |1        |1/3/2021 0:12|13.4km    |20 mins |*null*             |
|4       |2        |1/4/2021 13:53|23.4      |40      |*null*             |
|5       |3        |1/8/2021 21:10|10        |15      |*null*             |
|6       |3        |null       |null      |null    |Restaurant Cancellation|
|7       |2        |1/8/2020 21:30|25km      |25mins  |null              |
|8       |2        |1/10/2020 0:15|23.4 km   |15 minute|null              |
|9       |2        |null       |null      |null    |Customer Cancellation|
|10      |1        |1/11/2020 18:50|10km      |10minutes|null              |

</details>

### **`pizza_names`**

<details>
<summary>
View table
</summary>

|pizza_id|pizza_name|
|--------|----------|
|1       |Meat Lovers|
|2       |Vegetarian|

</details>

### **`pizza_recipes`**

<details>
<summary>
View table
</summary>

Each **`pizza_id`** has a standard set of **`toppings`** which are used as part of the pizza recipe.


|pizza_id|toppings |
|--------|---------|
|1       |1, 2, 3, 4, 5, 6, 8, 10| 
|2       |4, 6, 7, 9, 11, 12| 

</details>

### **`pizza_toppings`**

<details>
<summary>
View table
</summary>

This table contains all of the **`topping_name`** values with their corresponding **`topping_id`** value.


|topping_id|topping_name|
|----------|------------|
|1         |Bacon       | 
|2         |BBQ Sauce   | 
|3         |Beef        |  
|4         |Cheese      |  
|5         |Chicken     |     
|6         |Mushrooms   |  
|7         |Onions      |     
|8         |Pepperoni   | 
|9         |Peppers     |   
|10        |Salami      | 
|11        |Tomatoes    | 
|12        |Tomato Sauce|

</details>


***

## Case Study Questions

<details>
  <summary>
    A. Pizza Metrics
  </summary>

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?
</details>

<details>

  <summary>
    B. Runner and Customer Experience
  </summary>

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

</details>

***
## Solution

<details>
  <summary>
    Click here to view the Data Cleaning
  </summary>

### Table: **`customer_orders`**

- 'exclusions' column - there are missing/ blank spaces ' ' and null values.
- 'extras' column - there are missing/ blank spaces ' ' and null values.

- Remove null values in exlusions and extras columns and replace with blank space ' '
- Saving the transformations in a temporary table `temp_customer_orders` since we dont want to permanently update the original table


```sql
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
```

Checking the results of temporary created table 
SELECT * FROM temp_customer_orders

<details>
<summary> 
temp_customer_orders
</summary>

| order_id | customer_id | pizza_id | exclusions | extras | order_time               |
| -------- | ----------- | -------- | ---------- | ------ | ------------------------ |
| 1        | 101         | 1        |            |        | 2020-01-01T18:05:02.000Z |
| 2        | 101         | 1        |            |        | 2020-01-01T19:00:52.000Z |
| 3        | 102         | 1        |            |        | 2020-01-02T23:51:23.000Z |
| 3        | 102         | 2        |            |        | 2020-01-02T23:51:23.000Z |
| 4        | 103         | 1        | 4          |        | 2020-01-04T13:23:46.000Z |
| 4        | 103         | 1        | 4          |        | 2020-01-04T13:23:46.000Z |
| 4        | 103         | 2        | 4          |        | 2020-01-04T13:23:46.000Z |
| 5        | 104         | 1        |            | 1      | 2020-01-08T21:00:29.000Z |
| 6        | 101         | 2        |            |        | 2020-01-08T21:03:13.000Z |
| 7        | 105         | 2        |            | 1      | 2020-01-08T21:20:29.000Z |
| 8        | 102         | 1        |            |        | 2020-01-09T23:54:33.000Z |
| 9        | 103         | 1        | 4          | 1, 5   | 2020-01-10T11:22:59.000Z |
| 10       | 104         | 1        |            |        | 2020-01-11T18:34:49.000Z |
| 10       | 104         | 1        | 2, 6       | 1, 4   | 2020-01-11T18:34:49.000Z |


</details>

### Table: **`runner_orders`**

- 'pickup_time' column - there are 'null' text values
- 'cancellation' column - there are missing/blank spaces ' ' and 'null' text values
- 'distance' column - there are 'null' values and unit values (km) which needs to be removed
- 'duration' column - there are 'null' values and unit values (minutes) which needs to be removed

- convert text 'null' to null values
- pickup time, distance, duration columns are of the wrong type
-- Saving the transformations in a temporary table since we dont want to permanently update the original table

```sql
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
```

Checking the results of temporary created table 
SELECT * FROM temp_runner_orders

<details>
<summary> 
temp_runner_orders
</summary>

| order_id | runner_id | pickup_time              | distance | duration | cancellation            |
| -------- | --------- | ------------------------ | -------- | -------- | ----------------------- |
| 1        | 1         | 2020-01-01T18:15:34.000Z | 20       | 32       |                         |
| 2        | 1         | 2020-01-01T19:10:54.000Z | 20       | 27       |                         |
| 3        | 1         | 2020-01-03T00:12:37.000Z | 13.4     | 20       |                         |
| 4        | 2         | 2020-01-04T13:53:03.000Z | 23.4     | 40       |                         |
| 5        | 3         | 2020-01-08T21:10:57.000Z | 10       | 15       |                         |
| 6        | 3         |                          |          |          | Restaurant Cancellation |
| 7        | 2         | 2020-01-08T21:30:45.000Z | 25       | 25       |                         |
| 8        | 2         | 2020-01-10T00:15:02.000Z | 23.4     | 15       |                         |
| 9        | 2         |                          |          |          | Customer Cancellation   |
| 10       | 1         | 2020-01-11T18:50:20.000Z | 10       | 10       |                         |

 </details>
</details>

View the full [Data Cleaning Solution](https://github.com/Karan-Pruthi/8-Week-SQL-Challenge/tree/main/Case%20Study%20%232%20-%20Pizza%20Runner/Data%20Cleaning.sql)


<details>
  <summary>
    A. Click here for Solution of Pizza Metrics
  </summary>

### 1. How many pizzas were ordered?
```sql
SELECT COUNT(order_id) AS pizza_count
FROM temp_customer_orders;
```

- Used **COUNT** to get the count of pizzas ordered.


#### Result:

|pizza_count|
|-----------|
|14         |

***

### 2. How many unique customer orders were made?
```sql
SELECT COUNT (DISTINCT order_id) AS unique_order_count
FROM temp_customer_orders;
```

- First we take unique `order_id` with **DISTINCT** and then take **COUNT** to find out the `unique_order_count` for each customer.


#### Result:
|unique_order_count|
|-----------|
|10         |

***

### 3. How many successful orders were delivered by each runner?

```sql
SELECT
  runner_id,
  COUNT(order_id) AS successful_orders
FROM temp_runner_orders
WHERE cancellation is null
  OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY runner_id
ORDER BY successful_orders DESC;
```

- Filter the orders based on the `cancellation` and get the count of non-cancelled orders.
- **GROUP BY** by each runner and sort them by the count of successful orders.

#### Result:
| runner_id | successful_orders |
|-----------|-------------------|
| 1         | 4                 |
| 2         | 3                 |
| 3         | 1                 |

***

### 4. How many of each type of pizza was delivered?

```sql
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
```

- First, **JOIN** the two tables as we need `pizza name` also and then Filter the orders based on the `cancellation` and then **GROUP BY** by `pizza name`. 
- Then, get the pizza name and **COUNT** the pizzas and then sort by `pizza name`.

#### Result:
| pizza_name | pizza_type_count |
|------------|------------------|
| Meatlovers | 9                |
| Vegetarian | 3                |

***
### 5. How many Vegetarian and Meatlovers were ordered by each customer?

```sql
SELECT
  customer_id,
  SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS meatlovers,
  SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS vegetarian
FROM temp_customer_orders
GROUP BY customer_id;

```

- In the table pizza_names `pizza_id`:1 is referred to meatlovers and `pizza_id`:2 is referred to vegetarian
- use **CASE** and **SUM** to get count of pizza based on `pizza_id`
 and to group the count of different pizzas for each customer using **GROUP BY**.

#### Result:
| customer_id | meatlovers  | vegetarian |
|-------------|-------------|------------|
| 101         | 2           | 1          |
| 103         | 3           | 1          |
| 104         | 3           | 0          |
| 105         | 0           | 1          |
| 102         | 2           | 1          |

***
### 6. What was the maximum number of pizzas delivered in a single order?

```sql
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
```


- Create a temp table `single_order_cte` by using **windows function** to get the **COUNT** of pizzas in single order. 
- Then, use **JOIN** to combine temp table `temp_customer_orders` and `temp_runner_orders` table, Then, filter on the basis of `cancellation`.
- Finally get the max count from `single_order_cte`.

#### Result:
| max_pizza_count |
|-----------|
| 3         |

***

### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

```sql
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
```

- Create a temp table `member_before_cte` to create new column `rank` by using **DENSE_RANK()** and partitioning by `customer_id` and sort `order_date` in desc order to find out the last order before becoming a member.
- Then, use **JOIN** to combine temp table `member_cte` and `menu` table
- Finally filter to get 1st item purchased by each customer using `rank = 1`.

#### Result:
| customer_id | changes | no_change |
|-------------|---------|-----------|
| 101         | 0       | 2         |
| 102         | 0       | 3         |
| 103         | 3       | 3         |
| 104         | 2       | 2         |
| 105         | 1       | 1         |

***

### 8. How many pizzas were delivered that had both exclusions and extras?

```sql
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
```

- Joining the two tables `temp_customer_orders`, `temp_runner_orders` and then Filter on basis of `cancellation`
- use **CASE** and **SUM** to get the`Pizza_Count` that had both exclusions and extras.

#### Result:
| Pizza_Count |
|-------------|
| 1           |

***

### 9. What was the total volume of pizzas ordered for each hour of the day?

```sql
SELECT
  DATE_PART('hour', order_time) AS hour_of_day,
  COUNT(*) AS pizza_count
FROM temp_customer_orders
WHERE order_time IS NOT NULL
GROUP BY hour_of_day
ORDER BY hour_of_day;
```

- Filter based on `order_time` or `cancellation` to get non-cancelled orders
- Extract hours from `order_time` using **DATE_PART**
- **GROUP BY** `hour_of_day` and sort them by same field 

#### Result:
| hour_of_day | pizza_count |
|-------------|-------------|
| 11          | 1           |
| 13          | 3           |
| 18          | 3           |
| 19          | 1           |
| 21          | 3           |
| 23          | 3           |

***

### 10. What was the volume of orders for each day of the week?

```sql
SELECT
  TO_CHAR(order_time, 'day') AS day_of_week,
  COUNT(*) AS pizza_count
FROM temp_customer_orders
WHERE order_time IS NOT NULL
GROUP BY day_of_week
ORDER BY day_of_week;
```

- Filter based on `order_time` or `cancellation` to get non-cancelled orders
- Extract day from `order_time` using **TO_CHAR**
- **GROUP BY** `day_of_week` and sort them by same field 

#### Result:
| day_of_week | pizza_count |
|-------------|-------------|
| friday      | 1           |
| saturday    | 5           |
| thursday    | 3           |
| wednesday   | 5           |

***

</details>

<details>
  <summary>
    B. Click here for Solution of Runner and Customer Experience
  </summary>

### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

```sql
SELECT
  to_char(registration_date, 'WW') AS signups_week,
  COUNT(runner_id)
FROM pizza_runner.runners
GROUP BY signups_week
ORDER BY signups_week;
```


#### Result:
| signups_week | count |
| ------------ | ----- |
| 01           | 2     |
| 02           | 1     |
| 03           | 1     |

***

### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
```sql
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
```

#### Result:
| runner_id | avg_minutes |
| --------- | ----------- |
| 3         | 10          |
| 2         | 23          |
| 1         | 15          |

***

### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

#### Solution 1:
```sql
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
```

#### Solution 2:

```sql
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
```

#### Result:
| pizza_count | avg_prep_time |
| ----------- | ------------- |
| 1           | 12            |
| 2           | 18            |
| 3           | 29            |

***

### 4. What was the average distance travelled for each customer?

```sql
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
```

#### Result:
| customer_id | avg_distance       |
| ----------- | ------------------ |
| 101         | 20                 |
| 102         | 16.733333333333334 |
| 103         | 23.399999999999995 |
| 104         | 10                 |
| 105         | 25                 |

***
### 5. What was the difference between the longest and shortest delivery times for all orders?

```sql
SELECT
  MAX(duration) - MIN(duration) AS diff_delivery_time
FROM temp_runner_orders;
```

#### Result:
| difference |
| ---------- |
| 30         |

***
### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

```sql
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
```

#### Result:
| runner_id | order_id | pizza_count | distance_km | duration_minutes | speed_kmh          |
| --------- | -------- | ----------- | ----------- | ---------------- | ------------------ |
| 1         | 1        | 1           | 20          | 32               | 37.5               |
| 1         | 2        | 1           | 20          | 27               | 44.44444444444444  |
| 1         | 3        | 2           | 13.4        | 20               | 40.2               |
| 1         | 10       | 2           | 10          | 10               | 60                 |
| 2         | 4        | 3           | 23.4        | 40               | 35.099999999999994 |
| 2         | 7        | 1           | 25          | 25               | 60                 |
| 2         | 8        | 1           | 23.4        | 15               | 93.6               |
| 3         | 5        | 1           | 10          | 15               | 40                 |

***

### 7. What is the successful delivery percentage for each runner?

```sql
SELECT
  runner_id,
  count(order_id) AS Total_orders,
  COUNT(pickup_time) AS delivered_orders,
  (100 * COUNT(pickup_time) / count(order_id)) AS success_delivery_percent
FROM temp_runner_orders
GROUP BY runner_id
ORDER BY runner_id;
```


#### Result:
| runner_id | total_orders | delivered_orders | success_delivery_percent |
| --------- | ------------ | ---------------- | ------------------------ |
| 1         | 4            | 4                | 100                      |
| 2         | 4            | 3                | 75                       |
| 3         | 2            | 1                | 50                       |


***

</details>

***

##  Acknowledgements

- [8 Week SQL Challenge By Danny](https://8weeksqlchallenge.com/case-study-2/)