USE restaurant_db; #redirect you to the db you want to use without having to click the schema

-- Objective 1 : Explore and analyse Menu Items table

# view the menu_items table
SELECT * FROM menu_items;

# find the number of items on the menu
SELECT COUNT(*) AS total_menu_items FROM menu_items; ## a total of 32 items

# what are the least and most expensive items on the menu?
SELECT * FROM menu_items
ORDER BY price DESC; ## most expensive : Shrimp Sampi $19.95
					 ## least expensive : Edamame $5.00
                     
# how many italian dishes on the menu?
SELECT COUNT(*) AS total_italian_dish FROM menu_items
WHERE category = 'Italian'; ## 9 italian dishes

# what are the least and most expensive Italian dishes on the menu?
SELECT * FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC; ## least expensive = Spaghetti and Fettuccine Alfredo ($14.50)
					 ## most expensive = Shrimp Scampi ($19.95)
                     
# how many dishes in each category? 
SELECT category, COUNT(menu_item_id) AS num_dishes
FROM menu_items
GROUP BY category; ## American = 8
				   ## Asian = 6
				   ## Mexican = 9
				   ## Italian = 9

# what is the average dish price within each category? 
SELECT category, AVG(price) AS avg_dish_price
FROM menu_items
GROUP BY category; ## American = $10.07
				   ## Asian = $13.48
				   ## Mexican = $11.80
				   ## Italian = $11.80
                   
-- Objective 2. Explore and analyse Order Details table

# view the order_details table

SELECT * FROM order_details;

# what is the date range of the table?

SELECT * FROM order_details
ORDER BY order_date;

## another approach
SELECT MIN(order_date) AS min_date, MAX(order_date) AS max_date FROM order_details; ## date range: 2023-01-01 to 2023-03-01

# how many orders were made within this date range?

SELECT COUNT(DISTINCT order_id)
FROM order_details; ## 5370 orders 

# how many items were ordered within this date range?

SELECT COUNT(*) FROM order_details; ## 12 234 items 

# which orders had the most number of items?

SELECT order_id, COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
ORDER BY num_items DESC; ## Order ID with 14 dishes: 4305, 3473, 1957, 330, 440, 443, 2675

# how many orders had more than 12 items?

SELECT COUNT(*) FROM 

(SELECT order_id, COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
HAVING num_items > 12) AS num_orders; ## 20 orders

-- Objective 3. Understanding customer purchasing pattern and reactions to the new menu

SELECT * FROM menu_items;
SELECT * FROM order_details;

SELECT * 
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id;
    
# what menu items are customers purchasing most and least?

SELECT item_name, category, COUNT(order_details_id) AS num_purchases
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases DESC; ## most ordered: Hamburger (622 orders)
							 ## least ordered: Chicken Tacos (123 orders)

###### to check if this calculated right total within those peak hours                             
SELECT 
    mi.item_name,
    mi.category,
    COUNT(od.order_details_id) AS num_orders
FROM order_details od
JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
WHERE HOUR(od.order_time) IN (12, 13, 17, 18, 19)
GROUP BY mi.item_name, mi.category
ORDER BY num_orders DESC;
####

# which categories and items generate the most revenue?

SELECT 
	category,
    COUNT(order_details_id) AS total_orders,
    SUM(price) AS total_revenue,
    ROUND(AVG(price), 2) AS avg_price_item
FROM order_details od 
LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY category
ORDER BY total_revenue DESC;  ## Italian food leads in terms of total revenue and avg price per item despite Asian food having the most orders
							  ## American food ranks the lowest across total orders, total revenue and avg price per item
                              
SELECT item_name,
	category, 
    COUNT(order_details_id) AS num_orders,
    SUM(price) AS total_revenue
FROM order_details od 
LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY total_revenue DESC; 	## Korean Beef Bowl, Spaghetti and Tofu Pad Thai make top 3 highest revenue
								## Chicken tacos, Potstickers and Chips and Guacamole made the least revenue
			
# how much do customers typically spend? 

SELECT 
    MIN(order_total) AS min_order,
    MAX(order_total) AS max_order,
    ROUND(AVG(order_total), 2) AS avg_order
FROM (
    SELECT 
        order_id,
        SUM(price) AS order_total
    FROM order_details od
    LEFT JOIN menu_items mi
        ON od.item_id = mi.menu_item_id
    GROUP BY order_id ## calculates the total for each orderID
) AS order_summary;	  ## min or

SELECT 
	MIN(num_items) AS min_items,
    MAX(num_items) AS max_items,
    ROUND(AVG(num_items), 2) AS avg_items_per_order
FROM (
	SELECT
		order_id, 
		COUNT(item_id) AS num_items
	FROM order_details od
    LEFT JOIN menu_items mi
        ON od.item_id = mi.menu_item_id
	WHERE od.item_id IS NOT NULL
	GROUP BY order_id
) AS order_summary;			# min number of items is 1, max is 14
							# avg number of itesm per order is around 3 

# what do high-value orders look like?

SELECT order_id, SUM(price) AS total_spend
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC;  ## Order ID: 440, 2075, 1957, 330, 2675

SELECT category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category; ## a lot of Italian dishes on the highest-value order (440) eventhough Italian isnt the most popular dish 

SELECT order_id, SUM(price) AS total_spend
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5;  ## showcasess the top 5 orders and they're total spend

SELECT category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY category; ## shows that the top 5 highest spend orders, spends more on Italian food in total over other categories

SELECT order_id, category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category; ## the highest spend orders tend to like Italian dishes more (like 440, 1957, and 2075)

# what are the peak periods and which category is the most popular during these peak periods?

SELECT 
    HOUR(order_time) AS order_hour,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_details
GROUP BY HOUR(order_time)
ORDER BY total_orders DESC; ## Lunch and dinner hours are peak ordering hours (12PM, 5PM, 6PM, 1PM, 7PM)

SELECT 
	MIN(num_items) AS min_items,
    MAX(num_items) AS max_items,
    ROUND(AVG(num_items), 2) AS avg_items_per_order
FROM (
	SELECT
		order_id, 
		COUNT(item_id) AS num_items
	FROM order_details od
    LEFT JOIN menu_items mi
        ON od.item_id = mi.menu_item_id
	WHERE od.item_id IS NOT NULL
	GROUP BY order_id
) AS order_summary;	

SELECT 
    CASE 
        WHEN HOUR(order_time) BETWEEN 11 AND 14 THEN 'Lunch'
        WHEN HOUR(order_time) BETWEEN 15 AND 17 THEN 'Afternoon'
        WHEN HOUR(order_time) BETWEEN 18 AND 21 THEN 'Dinner'
        ELSE 'Other'
    END AS time_period,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_details
GROUP BY time_period
ORDER BY total_orders DESC; ## grouping the time periods together to make it easier to view 

SELECT 
    HOUR(order_time) AS order_hour,
    category,
    COUNT(order_details_id) AS num_items_ordered
FROM order_details od
JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
GROUP BY HOUR(order_time), category
ORDER BY order_hour, num_items_ordered DESC; ## Asian food dominates as most ordered every hour 


-- CONCLUSIONS --
# popularity != revenue
# there is potential high value customer preference for Italian > cross selling when customers order italian dishes , limit dont know if same/diff customers
# dont immediately remove the most popular dishes > review low performing items > promotional pricing, bundling, feedback, reposition on menu first
# american food is the biggest area for investigation > weakest overall performance but hamburger is the most popular item and may be time-dependent > brunch options
# peak periods gives operational opportunity > ensure sufficient staffing, maitain availability of high-demand items
# average order is around 3 items > can increase revenue by having people add one more item > bundles, add-ons
# Asian dishes drive volume, Italian dishes drive revenue, and American dishes underperform overall but show some morning demand
# customers typically purchase around three items per order and demand peaks around lunch and dinner


