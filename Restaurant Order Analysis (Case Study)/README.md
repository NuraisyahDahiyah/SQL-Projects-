# Taste of the World Cafe - Restaurant Order Analysis

This project uses SQL to analyse restaurant menu and order data to understand menu performance, customer purchasing behaviour, revenue drivers and ordering patterns.

The first two objectives follow the guide case study led by [Alice Zhao](https://www.youtube.com/watch?v=JaUKDbCXMX4&t=4s).

**Database:** `SQL`

## Business Problem

The Taste of the World Cafe debuted a new menu at the start of the year and wants to understand how customers are reacting to the new menu.

The analysis aims to identify which menu items and categories are performing well or poorly, what contributes to higher-value orders, and when customers are most likely to order.

**Project Objectives**
1. Explore the `menu_items` table to understand the new menu.
2. Explore the `order_details` table to understand the available order data.
3. Use both tables to understand how customers are reacting to the new menu.

## Data 

The analysis uses two tables:

### `menu_items`

Contains information about the dishes available on the new menu.

| Column | Description |
|---|---|
| `menu_item_id` | Unique identifier for each menu item |
| `item_name` | Name of the menu item |
| `category` | category of the item (cuisine) |
| `price` | Price of the menu item |

### `order_details`

Contains information about items purchased in each order.

| Column | Description |
|---|---|
| `order_details_id` | Unique identifier for each order detail |
| `order_id` | Unique identifier for each order |
| `order_date` | Date of the order |
| `order_time` | Time of the order |
| `item_id` | Identifier linking the order to a menu item |

**Analysis Period:** 1 January 2023 – 1 March 2023

## Analysis
### Analysis Overview

| Analysis | Objective |
|---|---|
| Menu Exploration | Understand menu size, categories and pricing |
| Order Exploration | Understand order volume, dates and order size |
| Item Performance | Identify popular and underperforming menu items |
| Category Performance | Compare order volume, pricing and revenue by category |
| Order Value | Analyse typical and high-value orders |
| Purchasing Behaviour | Identify category preferences within high-value orders |
| Time Analysis | Identify peak ordering periods and popular items |

---

### 1. Menu Exploration

The menu was analysed to understand the size and composition of the new menu, including the number of items, category distribution, and pricing.

Key analyses include:
- Total number of menu items
- Number of dishes by category
- Average price by category
- Most and least expensive dishes
- Most and least expensive Italian dishes

Output: 

<img width="200" alt="image" src="https://github.com/user-attachments/assets/80111e6b-ac10-43fc-9b0f-3c1cdd1e3daa" />

Query:

```sql
SELECT 
    category, 
    COUNT(menu_item_id) AS num_dishes
FROM menu_items
GROUP BY category;
```
**Key Findings:** Italian and Mexican have the largest menu selections with 9 dishes each, while Asian has the smallest selection with 6 dishes. Italian also has the highest average menu price at $16.75.

---

### 2. Order Exploration

The `order_details` table was analysed to understand the volume and structure of orders collected during the analysis period.

Key analyses include:

- Order date range
- Total number of unique orders
- Total number of items ordered
- Largest orders by number of items
- Number of orders containing more than 12 items

Query:

```sql
SELECT 
    MIN(order_date) AS min_date,
    MAX(order_date) AS max_date
FROM order_details;
```

**Key Finding:** The dataset contains 5,370 orders and 12,234 individual items ordered between 1 January and 1 March 2023. The largest orders contained 14 items, with 20 orders containing more than 12 items.

--- 

### 3. Menu Item Performance

The `menu_items` and `order_details` tables were joined to analyse which dishes customers purchased most and least frequently.

```sql
SELECT 
    item_name,
    category,
    COUNT(order_details_id) AS num_purchases
FROM order_details od
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases DESC;
```

**Key Finding:** Hamburger was the most ordered menu item with 622 purchases, while Chicken Tacos was the least ordered with 123 purchases.

Output: 

<img width="200" alt="image" src="https://github.com/user-attachments/assets/fa62b4c1-1328-4adb-88ef-0b2345023752" />

---

### 4. Category Performance and Revenue

Performance for each cuisine category was analysed using order volume, total revenue and average item price.

```sql
SELECT 
    category,
    COUNT(order_details_id) AS total_orders,
    SUM(price) AS total_revenue,
    ROUND(AVG(price), 2) AS avg_price_item
FROM order_details od 
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
GROUP BY category
ORDER BY total_revenue DESC;
```
Output: 

<img width="250" alt="image" src="https://github.com/user-attachments/assets/8b45739c-2bce-447c-b92d-26b9b7c4ae7e" />

**Key Finding:** Asian cuisine drives the highest order volume, while Italian cuisine generates the highest revenue. Italian's higher average menu price of $16.75 contributes to its stronger revenue performance.

---

### 5. Order Value

Further analysis was done on the orders to understand typical customer spending and order size.

Key metrics include:

- Minimum order value
- Maximum order value
- Average order value
- Minimum and maximum items per order
- Average items per order

```sql
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
    GROUP BY order_id
) AS order_summary;
```

Output: 

<img width="250" alt="image" src="https://github.com/user-attachments/assets/23a94061-8e21-43a9-a474-80c2dc96b7ab" />

**Key Finding:** Customers spend approximately $29.80 per order on average and purchase around 3 items per order. The highest-value order was $192.15

```
Note: The dataset does not contain a customer identifier, so high-value orders cannot be attributed to individual customers.
```
---

### 6. High-Value Orders

The highest-spending orders were identified and their category composition was analysed to understand what types of dishes are associated with larger orders.

```sql
SELECT category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY category;
```

The category composition of the top five orders was then examined as shown in the output below:

<img width="268" alt="image" src="https://github.com/user-attachments/assets/eacfd1d7-0fd3-4c96-b4bf-d530aadc0564" />

**Key Finding:** Italian dishes appear frequently within the highest-value orders, supporting the finding that Italian cuisine contributes strongly to higher-value sales.

`Note: The dataset does not contain a customer identifier, so high-value orders cannot be attributed to individual customers.`

---

### 7. Peak Ordering Periods

Order times were analysed to identify when customer demand is highest.

```sql
SELECT 
    HOUR(order_time) AS order_hour,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_details
GROUP BY HOUR(order_time)
ORDER BY total_orders DESC;
```

Output: 

<img width="220" alt="image" src="https://github.com/user-attachments/assets/2e947093-885f-4ee6-b016-aed117aff124" />

The analysis shows that the busiest ordering hours are: `12 PM → 1 PM → 5 PM → 6 PM → 7 PM`
These periods represent the café's key lunch and dinner demand windows.

---

### 8. Cuisine Category Popularity by Hour 

Category ordering behaviour was analysed across different hours to identify customer changes in preferences throughout the day.

```sql
SELECT 
    HOUR(order_time) AS order_hour,
    category,
    COUNT(order_details_id) AS num_items_ordered
FROM order_details od
JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
GROUP BY HOUR(order_time), category
ORDER BY order_hour, num_items_ordered DESC;
```

**Key Finding:** Asian cuisine consistently records strong ordering volume across the analysed hours, reinforcing its position as the café's primary volume driver.

---

### 9. Popular Items during Peak Hours 

The most frequently ordered dishes during the identified peak periods were analysed.

```sql
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
```

Top peak-period items:

|Rank|Item|Orders|
|---|---|---|
| 1 | Edamame | 356 |
| 2 | Hamburger | 353 |
| 3 | Cheeseburger | 341 |
| 4 | Tofu Pad Thai | 323 |
| 5 | Korean Beef Bowl | 310 |

These items should be prioritised for inventory availability and preparation during peak periods.

---

## Key Insights and Recommendation 

<details>
  <summary>
    <strong>01 — Asian cuisine drives customer demand</strong>
  </summary>

Asian cuisine has the highest order volume despite having the smallest menu selection, making it the café's strongest volume driver.

**Recommendation:** Maintain sufficient inventory and preparation capacity for popular Asian dishes, particularly during peak periods.

</details>

<details>
  <summary>
    <strong>02 — Italian cuisine drives revenue</strong>
  </summary>

Italian cuisine generates the highest total revenue despite not having the highest order volume. Its higher average menu price of $16.75 and strong presence in high-value orders contribute to its revenue performance.

**Recommendation:** Maintain strong-performing Italian dishes and explore bundles or complementary add-ons to maximise their revenue potential.

</details>

<details>
  <summary>
    <strong>03 — American and Mexican cuisines require different strategies</strong>
  </summary>

American cuisine has weak overall category performance but contains strong individual bestsellers such as Hamburger and Cheeseburger. Mexican cuisine shows weaker demand despite having one of the largest menu selections.

**Recommendation:** Retain successful American bestsellers while reviewing weaker items individually. Investigate Mexican dishes through pricing, menu positioning and customer feedback before making major menu changes.

</details>

<details>
  <summary>
    <strong>04 — Customers typically purchase around three items per order</strong>
  </summary>

The average order contains approximately 3 items and has an average value of $29.80, suggesting an opportunity to increase basket size.

**Recommendation:** Test bundles, add-ons and complementary item recommendations to encourage customers to purchase additional items.

</details>

<details>
  <summary>
    <strong>05 —Demand is high around lunch and dinner</strong>
  </summary>

Ordering activity peaks at 12–1 PM and 5–7 PM, with dishes such as Edamame, Hamburger, Cheeseburger, Tofu Pad Thai and Korean Beef Bowl among the most popular during these periods.

**Recommendation:** Align staffing, inventory and food preparation with these peak periods to maintain availability and service efficiency.

</details>

---

**SQL Techniques Used**

`JOIN` · `LEFT JOIN` · `GROUP BY` · `HAVING` · `CASE WHEN` · `HOUR()` · Subqueries · Aggregate Functions





