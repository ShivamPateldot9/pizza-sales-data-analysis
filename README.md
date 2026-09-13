
#  Pizza Store Analysis SQL Project

## Project Overview

**Project Title**: Pizza Store Analysis

**Database**: `pizza_sales_db`

I worked on this project to practice SQL on a business-style problem. It's based on a pizza store's sales data — orders, customers, pizza menu, everything. The goal was to actually dig into the data like a real analyst would: clean it up first, then answer the kind of questions different teams (finance, ops, marketing) would realistically ask.

---

## Objectives

1. Set up the database and load the data (orders, pizzas, customers, etc).
2. Clean the data — check for nulls, duplicates, anything inconsistent.
3. Explore the data to get a feel for order patterns and menu performance.
4. Answer business questions that would actually be useful to stakeholders.

---

## Database Structure

- `orders`: order_id, custid, order_date, order_time
- `order_details`: order_details_id, order_id, pizza_id, quantity
- `pizzas`: pizza_id, pizza_type_id, size, price
- `pizza_types`: pizza_type_id, name, category
- `customers`: custid, first_name, last_name

---

## Data Cleaning & Exploration

Before jumping into analysis, I checked:
- how many records each table actually had
- whether any critical columns had nulls or missing values
- and cleaned up anything incomplete or broken

---

## Analysis & Queries

### 1. Orders Volume Analysis
Total orders, how it's trending month to month, busiest days, average orders per customer, and top repeat customers.

### 2. Total Revenue
Added up price × quantity across every order to get overall revenue.

### 3. Highest-Priced Pizza
Checked which pizza costs the most on the menu.

### 4. Most Common Pizza Size
Which size (S/M/L/XL) gets ordered the most.

### 5. Top 5 Pizzas by Quantity
The 5 best-selling pizzas by how many were sold.

### 6. Quantity Sold by Category
Total pizzas sold, broken down by category.

### 7. Orders by Hour
What time of day people order the most, useful for staffing.

### 8. Category-Wise % Share
What percentage of total sales each category makes up.

### 9. Average Pizzas per Day
How consistent daily demand actually is.

### 10. Top 3 Pizzas by Revenue
Not the same as top by quantity, worth noting.

### 11. Revenue Contribution per Pizza
How much each pizza contributes to total revenue, in %.

### 12. Cumulative Revenue Over Time
Running total of revenue since the data started.

### 13. Top 3 Pizzas per Category (by Revenue)
Same idea as #10 but split by category.

### 14. Top 10 Customers by Spend
Who's spending the most overall.

### 15. Average Order Size
On average, how many pizzas are in one order.

### 16. Seasonal Trends
Checked if certain months see more orders than others.

### 17. Customer Segmentation
Split customers into High Value vs Regular based on total spend.

### 18. Repeat Customer Rate
What % of customers ordered more than once.

---

## Key Findings

- Customer Behavior: high-value and repeat customers identified.
- Order Trends: peak hours and seasonal patterns show up clearly in the data.
- Menu Insights: the pizzas that sell the most (by quantity) aren't always the ones bringing in the most revenue.
- Revenue Analysis: monthly and cumulative revenue trends, plus category-wise contribution, all mapped out.
- Operational Insights: average order size and daily demand consistency give a good base for staffing decisions.

Next up — building a Power BI dashboard on top of this to visualize these findings.
