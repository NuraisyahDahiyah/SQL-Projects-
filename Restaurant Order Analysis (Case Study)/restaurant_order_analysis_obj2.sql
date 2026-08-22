USE restaurant_db;

-- 1. View the order_details table.

SELECT * FROM order_details;

-- 2. What is the date range of the table?

SELECT * FROM order_details
ORDER BY order_date;

SELECT MIN(order_date) AS min_date, MAX(order_date) AS max_date FROM order_details; #another approach

-- 3. How many orders were made within this date range?

SELECT COUNT(DISTINCT order_id)
FROM order_details;

# 5370 unique orders were made

-- 4. How many items were ordered within this date range?

SELECT COUNT(*) FROM order_details;

# 12 234 items in total 

-- 5. Which orders had the most number of items?

SELECT order_id, COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
ORDER BY num_items DESC
;

# Order ID with 14 dishes: 4305, 3473, 1957, 330, 440, 443, 2675

-- 6. How many orders had more than 12 items?

SELECT order_id, COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
HAVING num_items > 12
; # this query only showcases all the orders with more than 12 items but doesnt COUNT how many

SELECT COUNT(*) FROM 

(SELECT order_id, COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
HAVING num_items > 12) AS num_orders; #subquery

# 20 orders with more than 12 orders