-- 1. Combine the menu_items and order_details tables into a single table

SELECT * FROM menu_items;
SELECT * FROM order_details;
# menu_item_id and item_id are both about a specific item so need to JOIN

SELECT * 
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id;

-- 2. What were the least and most ordered items? What categories were they in?

SELECT item_name, COUNT(order_details_id) AS num_purchases
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name
ORDER BY num_purchases DESC;
# hamburger is the most ordered and the chicken tacos are the least ordered

SELECT item_name, category, COUNT(order_details_id) AS num_purchases
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases DESC;
# American (hamburger) and Mexican (chicken tacos)

-- 3. What were the top 5 orders that spent the most money?

SELECT order_id, SUM(price) AS total_spend
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC;

# Order ID: 440, 2075, 1957, 330, 2675

-- 4. View the details of the highest spend order. What insights can you gather from the results?

SELECT category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category;
# A lot of Italian dishes eventhough Italian isnt the most popular dish 

-- 5. View the details of the top 5 highest spend order. What insights can you gather from the results?

SELECT order_id, SUM(price) AS total_spend
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5; #showcases the top 5 orders and they're total spend

SELECT category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY category;
# Shows that the top 5 highest spend orders and spending more on Italian food in total over other categories

SELECT order_id, category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category;
# the highest spend orders tend to like Italian dishes more
# Insights: should keep Italian dishes seems customers seem to like it a lot esp the highest spent customers

