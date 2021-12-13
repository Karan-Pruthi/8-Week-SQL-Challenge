
# Case Study #1 - Danny's Diner
![Danny Diner image](https://github.com/Karan-Pruthi/8-Week-SQL-Challenge/blob/main/images/Diner_logo.png?raw=true)

## 📚 Table of Contents
- Problem Statement
- Entity Relationship Diagram
- Data
- Case Study Questions
- Solution

## Problem Statement
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

## Entity Relationship Diagram
![Entity Relationship image](https://github.com/Karan-Pruthi/8-Week-SQL-Challenge/blob/main/images/ER1.png?raw=true)

## Data
Danny has shared 3 key datasets for this case study:

### **`sales`**

<details>
  <summary>
    View table
  </summary>

  The sales table captures all `customer_id` level purchases with an corresponding `order_date` and `product_id` information for when and what menu items were ordered.

  |customer_id|order_date|product_id|
  |-----------|----------|----------|
  |A          |2021-01-01|1         |
  |A          |2021-01-01|2         |
  |A          |2021-01-07|2         |
  |A          |2021-01-10|3         |
  |A          |2021-01-11|3         |
  |A          |2021-01-11|3         |
  |B          |2021-01-01|2         |
  |B          |2021-01-02|2         |
  |B          |2021-01-04|1         |
  |B          |2021-01-11|1         |
  |B          |2021-01-16|3         |
  |B          |2021-02-01|3         |
  |C          |2021-01-01|3         |
  |C          |2021-01-01|3         |
  |C          |2021-01-07|3         |

</details>

### **`menu`**

<details>
  <summary>
    View table
  </summary>

  The menu table maps the `product_id` to the actual `product_name` and price of each menu item.

  |product_id |product_name|price     |
  |-----------|------------|----------|
  |1          |sushi       |10        |
  |2          |curry       |15        |
  |3          |ramen       |12        |

</details>

### **`members`**

<details>
  <summary>
    View table
  </summary>
  
  The final members table captures the `join_date` when a `customer_id` joined the beta version of the Danny’s Diner loyalty program.

  |customer_id|join_date   |
  |-----------|----------  |
  |A          | 2021-01-07 |
  |B          | 2021-01-09 |

</details>

***
## Case Study Questions

<details>
  <summary>
    Click here to view the Case Study Questions!
  </summary>

  - What is the total amount each customer spent at the restaurant?
  - How many days has each customer visited the restaurant?
  - What was the first item from the menu purchased by each customer?
  - What is the most purchased item on the menu and how many times was it purchased by all customers?
  - Which item was the most popular for each customer?
  - Which item was purchased first by the customer after they became a member?
  - Which item was purchased just before the customer became a member?
  - What is the total items and amount spent for each member before they became a member?
  - If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
  - In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

</details>

***
## Solution

### 1. What is the total amount each customer spent at the restaurant?
```sql
SELECT 
  s.customer_id,
  SUM(m.price) AS amount_spent
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
	ON s.product_id = m.product_id
GROUP BY customer_id
```

- Use **JOIN** to merge `sales` and `menu` tables as `customer_id` and `price` are present in these tables.
- Find out `total_spent` using **SUM** and then use **GROUP BY** to segregate it by each customer.


#### Result:
| customer_id | total_spent |
| ----------- | ----------- |
| B           | 74          |
| C           | 36          |
| A           | 76          |

***

### 2. How many days has each customer visited the restaurant?
```sql
SELECT
  customer_id,
  COUNT (DISTINCT order_date) AS visited_days
FROM dannys_diner.sales
GROUP BY customer_id;
```
- First, take unique `order_date` with **DISTINCT** and then take **COUNT** to find out the `visited_days` for each customer.

#### Result:
| customer_id | visited_days |
| ----------- | ------------ |
| A           | 4            |
| B           | 6            |
| C           | 2            |

***

### 3. What was the first item from the menu purchased by each customer?

```sql
WITH order_cte AS
(
   SELECT customer_id, order_date, product_name,
      DENSE_RANK() OVER(PARTITION BY s.customer_id
      ORDER BY s.order_date) AS rank
   FROM dannys_diner.sales AS s
   JOIN dannys_diner.menu AS m
      ON s.product_id = m.product_id
)

SELECT customer_id, product_name
FROM order_cte
WHERE rank = 1
```

- First, Create a temp table `order_cte` and use **Windows function** with **DENSE_RANK** to create a new column `rank` based on `order_date`.
- Its better to use **DENSE_RANK** instead of **ROW_NUMBER** or **RANK** as we dont have time in `order_date` to distinguish multiple items bought on same day.
- Finally, **GROUP BY** all columns to show first item only using `rank = 1`.

#### Result:
| customer_id | product_name | 
| ----------- | -----------  |
| A           | curry        | 
| A           | sushi        | 
| B           | curry        | 
| C           | ramen        |

***

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
SELECT
  menu.product_name,
  COUNT(sales.product_id) AS most_purchased
FROM dannys_diner.sales
JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id
GROUP BY menu.product_name
ORDER BY most_purchased DESC
LIMIT 1;
```

- First, count number of `product_id` using **COUNT** and then sort it by `most_purchased` using **ORDER BY** by desc order. 
- Then, use **LIMIT 1** to filter first item which is the most purchased item.

#### Result:
| product_name | most_purchased |
| ------------ | ----------- |
| ramen        | 8 |

***
### 5. Which item was the most popular for each customer?

```sql
WITH most_popular_cte AS
(  
   SELECT s.customer_id, m.product_name, COUNT(m.product_id) AS order_count,
      DENSE_RANK() OVER(PARTITION BY s.customer_id
      ORDER BY COUNT(s.customer_id) DESC) AS rank
   FROM dannys_diner.menu AS m
   JOIN dannys_diner.sales AS s
      ON m.product_id = s.product_id
   GROUP BY s.customer_id, m.product_name
)   

SELECT customer_id, product_name, order_count
FROM most_popular_cte 
WHERE rank = 1;
```

- Create a temp table `most_popular_cte` and use **DENSE_RANK** to `rank` the `order_count` for each product by desc order for each customer using **GROUP BY**.
- Filter out the most popular product for each customer using `rank = 1` .

#### Result:
| customer_id | product_name | order_count |
| ----------- | ---------- |-------------  |
| A           | ramen        |  3   |
| B           | sushi        |  2   |
| B           | curry        |  2   |
| B           | ramen        |  2   |
| C           | ramen        |  3   |

***
### 6. Which item was purchased first by the customer after they became a member?

```sql
WITH member_cte AS 
(
   SELECT s.customer_id, m.join_date, s.order_date, s.product_id,
      DENSE_RANK() OVER(PARTITION BY s.customer_id
      ORDER BY s.order_date ASC) AS rank
   FROM dannys_diner.sales s
   JOIN dannys_diner.members m
      ON s.customer_id = m.customer_id
   WHERE s.order_date >= m.join_date
)

SELECT s.customer_id, s.order_date, m1.product_name 
FROM member_cte AS s
JOIN dannys_diner.menu AS m1
   ON s.product_id = m1.product_id
WHERE rank = 1
ORDER BY s.customer_id;
```


- Create a temp table `member_cte` by using **windows function** and partitioning `customer_id` by ascending `order_date`. Then, filter `order_date` to be on or after `join_date`.
- Then, use **JOIN** to combine temp table `member_cte` and `menu` table
- Finally filter to get 1st item purchased by each customer using `rank = 1`.

#### Result:
| customer_id | order_date  | product_name |
| ----------- | ---------- |----------  |
| A           | 2021-01-07T00:00:00.000Z | curry |
| B           | 2021-01-11T00:00:00.000Z | sushi |

***

### 7. Which item was purchased just before the customer became a member?

```sql
WITH member_before_cte AS 
(
   SELECT s.customer_id, m.join_date, s.order_date, s.product_id,
      DENSE_RANK() OVER(PARTITION BY s.customer_id
      ORDER BY s.order_date DESC) AS rank
   FROM dannys_diner.sales s
   JOIN dannys_diner.members m
      ON s.customer_id = m.customer_id
   WHERE s.order_date < m.join_date
)

SELECT s.customer_id, s.order_date, m1.product_name 
FROM member_before_cte AS s
JOIN dannys_diner.menu AS m1
   ON s.product_id = m1.product_id
WHERE rank = 1
ORDER BY s.customer_id;
```

- Create a temp table `member_before_cte` to create new column `rank` by using **DENSE_RANK()** and partitioning by `customer_id` and sort `order_date` in desc order to find out the last order before becoming a member.
- Then, use **JOIN** to combine temp table `member_cte` and `menu` table
- Finally filter to get 1st item purchased by each customer using `rank = 1`.

#### Result:
| customer_id | order_date  | product_name |
| ----------- | ---------- |----------  |
| A           | 2021-01-01T00:00:00.000Z |  sushi        |
| A           | 2021-01-01T00:00:00.000Z |  curry        |
| B           | 2021-01-04T00:00:00.000Z |  sushi        |

***

### 8. What is the total items and amount spent for each member before they became a member?

```sql
SELECT
 s.customer_id,
 COUNT(s.product_id ) AS total_items,
 SUM(m.price) AS amount_spent
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
 ON m.product_id = s.product_id
JOIN dannys_diner.Members Mem
 ON Mem.Customer_id = s.customer_id
WHERE s.order_date < Mem.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;
```

- Filter on basis of `order_date` only before `join_date` and perform a **COUNT** on `product_id` to get total items bought before membership 
- Then, use **SUM** to get the total `amount_spent` before membership.

#### Result:
| customer_id | total_items | amount_spent |
| ----------- | ---------- |----------  |
| A           | 2 |  25       |
| B           | 3 |  40       |

***

### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?

```sql
WITH points_cte AS
(
   SELECT *, 
      CASE
         WHEN product_name = 'sushi' THEN price * 20
         ELSE price * 10
      END AS points
   FROM dannys_diner.menu
)

SELECT s.customer_id, SUM(p.points) AS points
FROM points_cte p
JOIN dannys_diner.sales s
   ON p.product_id = s.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;
```

- Each $1 spent = 10 points, Special case 'sushi' gets 2x points, meaning each $1 spent = 20 points
- Hence, use conditional statements CASE WHEN
- If product_name = 'sushi', then every $1 price multiply by 20 points
- All other product_id that is not 1, multiply $1 by 10 points
- Finally, add the `points` using **SUM**.

#### Result:
| customer_id | points | 
| ----------- | ------ |
| A           | 860 |
| B           | 940 |
| C           | 360 |

***
##  Acknowledgements

- [8 Week SQL Challenge By Danny](https://8weeksqlchallenge.com/case-study-1/)