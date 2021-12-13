--   --------------------
--   Case Study Questions
--   --------------------

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

---------------------------------------------------------------------

-- 1. What is the total amount each customer spent at the restaurant?
SELECT 
	s.customer_id,
  SUM(m.price) AS amount_spent
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
	ON s.product_id = m.product_id
GROUP BY customer_id

-- Result:-
--  ────────────── ──────────────
-- | customer_id  | total_spent  |
--  ────────────── ──────────────
-- | B            | 74           |
-- | C            | 36           |
-- | A            | 76           |
--  ────────────── ────────────── 

---------------------------------------------------------
-- 2. How many days has each customer visited the restaurant?

SELECT
  customer_id,
  COUNT (DISTINCT order_date) AS visited_days
FROM dannys_diner.sales
GROUP BY customer_id;

-- Result:-
--  ────────────── ───────────────
-- | customer_id  | visited_days  |
--  ────────────── ───────────────-
-- | A            | 4             |
-- | B            | 6             |
-- | C            | 2             |
--  ────────────── ───────────────

--------------------------------------------------------------------
-- 3. What was the first item from the menu purchased by each customer?

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

-- Result:-
--  ────────────── ───────────────
-- | customer_id  | product_name  |
--  ────────────── ───────────────-
-- | A            | curry         |
-- | A            | sushi         |
-- | B            | curry         |
-- | C            | ramen         |
--  ────────────── ───────────────


-----------------------------------------------------------------------------------------------------
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT
  menu.product_name,
  COUNT(sales.product_id) AS most_purchased
FROM dannys_diner.sales
JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id
GROUP BY menu.product_name
ORDER BY most_purchased DESC
LIMIT 1;

-- Result:-
--  ─────────────── ──────────────
-- | product_name  |most_purchased|
-- |─────────────── ──────────────|
-- | ramen         | 8            |
--  ─────────────── ──────────────

--------------------------------------------------------
-- 5. Which item was the most popular for each customer?

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

-- Result:-
--  ────────────── ─────────────── ───────────────
-- | customer_id  | product_name  | order_count  |
--  ────────────── ─────────────── ───────────────
-- | A            | ramen         |     3        |
-- | B            | sushi         |     2        |
-- | B            | curry         |     2        |
-- | B            | ramen         |     2        |
-- | C            | ramen         |     3        |
--  ────────────── ─────────────── ───────────────


-- -----------------------------------------------------------------------------
-- 6. Which item was purchased first by the customer after they became a member?

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

-- Result:-
--  ────────────── ────────────────────────────── ───────────────
-- | customer_id  | order_date                   | product_name  |
--  ────────────── ────────────────────────────── ───────────────
-- | A            |   2021-01-07T00:00:00.000Z   |     curry     |
-- | B            |   2021-01-11T00:00:00.000Z   |     sushi     |
--  ────────────── ────────────────────────────── ──────-────────


-- ---------------------------------------------------------------------
-- 7. Which item was purchased just before the customer became a member?

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

-- Result:-
--  ────────────── ────────────────────────────── ───────────────
-- | customer_id  | order_date                   | product_name  |
--  ────────────── ────────────────────────────── ───────────────
-- | A            |   2021-01-01T00:00:00.000Z   |     sushi     |
-- | A            |   2021-01-01T00:00:00.000Z   |     curry     |
-- | B            |   2021-01-04T00:00:00.000Z   |     sushi     |
--  ────────────── ────────────────────────────── ──────-────────


-- ----------------------------------------------------------------------------------------
-- 8. What is the total items and amount spent for each member before they became a member?

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

-- Result:-
--  ────────────── ────────────── ───────────────
-- | customer_id  | total_items  | amount_spent  |
--  ────────────── ────────────── ───────────────
-- | A            | 2            |     25        |
-- | B            | 3            |     40        |
--  ────────────── ────────────── ───────────────


-- -------------------------------------------------------------------------------------------------------------------------
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

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

-- Result:-
--  ────────────── ─────────
-- | customer_id  | points  |
--  ────────────── ─────────
-- | A            | 860     |
-- | B            | 940     |
-- | C            | 360     |
--  ────────────── ─────────
