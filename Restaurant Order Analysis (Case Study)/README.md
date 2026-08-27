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

<img width="200" alt="image" src="https://github.com/user-attachments/assets/80111e6b-ac10-43fc-9b0f-3c1cdd1e3daa" />

Example query:

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

Example query:

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

<img width="250" alt="image" src="https://github.com/user-attachments/assets/8b45739c-2bce-447c-b92d-26b9b7c4ae7e" />

**Key Finding:** Asian cuisine drives the highest order volume, while Italian cuisine generates the highest revenue. Italian's higher average menu price of $16.75 contributes to its stronger revenue performance.

---

### 5. Order Value and Purchasing Behaviour

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

<img width="250" alt="image" src="https://github.com/user-attachments/assets/23a94061-8e21-43a9-a474-80c2dc96b7ab" />

---

### 6.

---

### 7. 

---

### 8.

---

### 9. 

---

## Key Insights and Recommendation 

<details> 
    <summary> 
        <strong> 01 — Asian cuisine drives order volume </strong>
    </summary>

Asian cuisine generates the highest order volume despite having the smallest menu selection with only 6 items.

**Recommendation:** Prioritise inventory availability and preparation of popular Asian dishes during peak periods.

</details>

<details> 
    <summary> 
        <strong> 02 — Italian cuisine drives revenue </strong> 
    </summary>

Italian generates the highest total revenue despite not having the highest order volume. Its higher average menu price of $16.75 contributes to its revenue performance.

**Recommendation:** Maintain strong-performing Italian dishes and explore complementary add-ons or bundles to maximise their revenue potential.

</details>

<details> 
    <summary> 
        <strong> 03 — Popularity does not equal revenue </strong> 
    </summary>

Asian dishes drive the highest order volume, while Italian dishes generate the highest revenue, showing that purchase volume and pricing both influence category performance.

**Recommendation:** Evaluate menu performance using both sales volume and revenue rather than relying on popularity alone.

</details>

<details> 
    <summary> 
        <strong> 04 — American demand is concentrated around a few bestsellers </strong> 
    </summary>

American cuisine has the weakest category-level performance, but Hamburger, Cheeseburger and French Fries are among the café's most popular individual items.

**Recommendation:** Retain strong American bestsellers while reviewing weaker items individually before making menu changes.

</details>

<details> 
    <summary> 
        <strong> 05 — Mexican cuisine requires further investigation </strong> 
    </summary>

Mexican cuisine has 9 menu items but relatively weak overall demand, with Chicken Tacos among the lowest-performing dishes.

**Recommendation:** Review pricing, menu positioning, promotions and customer feedback before considering removal of weaker dishes.

</details>

<details> 
    <summary> 
        <strong> 06 — Customers typically purchase around three items </strong> 
    </summary>

The average order contains approximately 3 items and has an average value of $29.80.

**Recommendation:** Test bundles, add-ons and complementary product recommendations to encourage customers to increase their basket size.

</details>

<details>
    <summary> 
        <strong> 07 — High-value orders show strong Italian demand </strong> 
    </summary>

Italian dishes appear frequently within the highest-spending orders, suggesting they contribute strongly to higher-value sales.

**Recommendation:** Explore cross-selling opportunities around popular Italian dishes while maintaining their current pricing.

</details>

<details> 
    <summary> 
        <strong> 08 — Demand peaks during lunch and dinner </strong> 
    </summary>

The busiest ordering hours are 12 PM, 1 PM, 5 PM, 6 PM and 7 PM.

**Recommendation:** Optimise staffing, preparation and inventory around these peak periods.

</details>

<details> 
    <summary> 
        <strong> 09 — Peak-period demand is concentrated around key dishes </strong> 
    </summary>

Edamame, Hamburger, Cheeseburger, Tofu Pad Thai and Korean Beef Bowl are among the most ordered items during peak hours.

**Recommendation:** Ensure sufficient ingredients and kitchen capacity for these high-demand dishes during peak periods.

</details>

<details> 
    <summary> 
        <strong> 10 — Menu optimisation should focus on individual items </strong> 
    </summary>

Category-level performance can hide strong and weak individual dishes, as demonstrated by the strong performance of several American items despite weak overall category results.

**Recommendation:** Evaluate individual menu items before removing or restructuring an entire category.

</details>

<details> 
    <summary> 
        <strong> 11 — Menu performance reflects both demand and pricing </strong> 
    </summary>

The analysis shows that customer demand and menu pricing work together to influence revenue. Asian drives volume, while higher-priced Italian dishes drive revenue.

**Recommendation:** Use both order volume and revenue when evaluating menu performance and making future menu decisions.

</details>

---

**SQL Techniques Used**
`JOIN` · `LEFT JOIN` · `GROUP BY` · `HAVING` · `CASE WHEN` · `HOUR()` · Subqueries · Aggregate Functions





