USE restaurant_db; # ensures to redirect you to the correct db even without clicking on it

-- 1. View the menu_items table.

SELECT * FROM menu_items; 

-- 2. Find the number of items on the menu.

SELECT COUNT(*) FROM menu_items; # a total of 32 items

-- 3. What are the least and most expensive item on the menu?

SELECT * FROM menu_items
ORDER BY price DESC;

# most expensive : Shrimp Sampi $19.95
# least expensive : Edamame $5.00

-- 4. How many Italian dishes are on the menu?

SELECT COUNT(*) FROM menu_items
WHERE category = 'Italian'
;

# 9 italian dishes 

-- 5. What are the least and most expensive Italian dishes on the menu?

# least expensive Italian dish
SELECT * FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC
;
# least expensive = Spaghetti and Fettuccine Alfredo ($14.50)


# most expensive Italian dish
SELECT * FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC
;
# most expensive = Shrimp Scampi ($19.95)

-- 6. How many dishes are in each category?

SELECT category, COUNT(menu_item_id) AS num_dishes
FROM menu_items
GROUP BY category
;

# American = 8
# Asian = 6
# Mexican = 9
# Italian = 9

-- 7. What is the average dish price within each category?

SELECT category, AVG(price) AS avg_dish_price
FROM menu_items
GROUP BY category
;

# American = $10.07
# Asian = $13.48
# Mexican = $11.80
# Italian = $16.75