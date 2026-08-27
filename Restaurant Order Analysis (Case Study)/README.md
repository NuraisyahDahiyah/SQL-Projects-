# Taste of the World Cafe - Restaurant Order Analysis

This project uses SQL to analyse restaurant menu and order data to understand menu performance, customer purchasing behaviour, revenue drivers and ordering patterns.

The first two objectives follow the guide case study led by [Alice Zhao](https://www.youtube.com/watch?v=JaUKDbCXMX4&t=4s)

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
````
