
1. Orders Volume Analysis Queries

   Stakeholder (Operations Manager):

/*
 We want to analyze the order data to understand how the store is performing and how the business is growing.
We want to find out:

 A. What is the total number of unique orders placed so far?
 B. How has this order volume changed month-over-month?
 C. Can we identify peak and off-peak ordering days?
 D. What is the average number of orders per customer?
 E. Who are our top repeat customers driving the order volume?
 F. Can you also project the expected order growth trend based on historical data?"
*/


select * from orders

-- 1.A. What is the total number of unique orders placed so far?

 SELECT COUNT(DISTINCT ORDER_ID)
 FROM ORDERS ; 
 

-- 1. B. How has this order volume changed month-over-month?

SELECT * FROM orders


WITH monthly_orders AS (
	SELECT COUNT (order_id) AS order_count,
	DATE_TRUNC('month',order_date) AS month
	FROM orders
	GROUP BY DATE_TRUNC('month',order_date)
)
SELECT month, order_count, 
LAG(order_count) over(order by month) AS prev_month,
ROUND(100.0*(order_count - LAG(order_count) over (order by month)) / nullif (LAG(order_count) over(order by month),0),2) AS mom_grow_per
FROM monthly_orders
ORDER BY month;


-- 1.C. Can we identify peak and off-peak ordering days?

SELECT * FROM orders


SELECT TO_CHAR(order_date, 'Day') as day,
	count(distinct order_id) as total_orders
	FROM orders
	GROUP BY TO_CHAR(order_date, 'Day')
	ORDER BY total_orders desc
	

-- 1.D. What is the average number of orders per customer?

SELECT * FROM orders


select 
 	Round(count(distinct order_id)  * 1.0 /  
	count(distinct custid),2) AS avg_count_per_cust
from orders;


-- 1. E. Who are our top repeat customers driving the order volume?

SELECT * FROM orders
SELECT * FROM customers


select custid,
	count(distinct order_id) as cust_order_count
from orders
group by custid
order by cust_order_count desc
limit 5;


-- 1. F. Can you also project the expected order growth trend based on historical data?"

 SELECT * FROM orders
SELECT * FROM customers

-- month-over-month

WITH monthly_orders AS (
	SELECT COUNT (order_id) AS order_count,
	DATE_TRUNC('month',order_date) AS month
	FROM orders
	GROUP BY DATE_TRUNC('month',order_date)
)
SELECT month, order_count, 
LAG(order_count) over(order by month) AS prev_month,
ROUND(100.0*(order_count - LAG(order_count) over (order by month)) / nullif (LAG(order_count) over(order by month),0),2) AS mom_grow_per
FROM monthly_orders
ORDER BY month;


-- Cumlative Order Trend

 select order_date, count(order_id) as daily_orders,
 		SUM(count(order_id)) over(order by order_date ) AS cumlative_orders
 from orders
Group by order_date
order by order_date


2. Total Revenue from Pizza Sales 

  Stakeholder (Finance Team):

/*

"We need to report monthly revenue to management.
Can you calculate the total revenue generated from all pizza sales,
considering price × quantity from each order?"
*/
Analyst Task: Join order_details with pizzas and sum (price × quantity).

--Query


select * from order_details
select * from pizzas

select sum(od.quantity* p.price)  As total_revenue
from pizzas p
join order_details od
on p.pizza_id = od.pizza_id



3. Highest-Priced Pizza

   Stakeholder (Menu Manager):
/*
"Our premium pizzas must be correctly priced. Can you find out which pizza
has the highest price on our menu and confirm its category and size?"

*/
Analyst Task: Query the pizzas table for the maximum price, joining with pizza_types for details.

--Query


select * from pizzas
select * from pizza_types

select pt.name,p.size,'$' || p.price as price
from pizzas p
join pizza_types pt
on pt.pizza_type_id = p.pizza_type_id
order by p.price desc



 4. Most Common Pizza Size Ordered
 
    Stakeholder (Logistics Manager):

/*
"To optimize packaging and raw material supply, I need to know which
pizza size (S, M, L, XL, XXL) is ordered the most."
*/
Analyst Task: Count and group orders by pizza size from pizzas + order_details.

--Query


select p.size, count(*) as Total_orders
from order_details od
join pizzas p  on od.pizza_id = p.pizza_id 
join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
group by p.size
order by Total_orders desc
limit 1;


5. Top 5 Most Ordered Pizza Types

   Stakeholder (Product Head):

/*
"We want to promote our top-selling pizzas. Can you provide the top 5 pizza
types ordered by quantity, along with the exact number of units sold?"
*/

Analyst Task: Join order_details with pizza_types, group by pizza name, and rank top 5.

--Query

select p.pizza_id, pt.name, 
SUM(od.quantity) as Total_qty
from order_details od
join pizzas p on p.pizza_id = od.pizza_id
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id
group by  p.pizza_id, pt.name
order by Total_qty desc
limit 5

6. Total Quantity by Pizza Category

Stakeholder (Marketing Manager):

/*
"We run promotions based on categories (Classic, Veggie, Supreme, Chicken, etc.).
Can you calculate the total number of pizzas sold in each category
so we can plan targeted campaigns?"
*/

Analyst Task: Join pizzas with pizza_types and sum quantities by category.

--Query


select pt.category, 
sum(od.quantity) as Total_qty
from  order_details od
join pizzas p on p.pizza_id = od.pizza_id
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id
Group by pt.category
order by Total_qty desc





7. Orders by Hour of the Day

Stakeholder (Operations Head):

/*
"When are customers ordering the most? Do they prefer lunch (12-2 PM),
evenings (6-9 PM), or late-night? Please give me a distribution
of orders by hour of the day so we can adjust staffing."
*/

Analyst Task: Extract the hour from order_time in orders table and count frequency.

--Query

select 
To_char(order_time::time, 'HH24:00') as order_hour,
count(*) as order_count
from orders
group by order_hour
order by order_hour

8. Category-Wise Pizza Distribution

Stakeholder (Product Strategy Team):

/*
"Which categories (like Veggie, Chicken, Supreme) dominate
our menu sales? Can you prepare a breakdown of orders per category with percentage share?"
*/

Analyst Task: Join tables and calculate share of each category.

--Query

select pt.category,
    sum(od.quantity) as total_qty,
    round(100.0 * sum(od.quantity) / sum(sum(od.quantity)) over(), 2) as percentage_share
from order_details od
join pizzas p on p.pizza_id = od.pizza_id
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id
group by pt.category
order by total_qty desc;



9. Average Pizzas Ordered per Day

Stakeholder (CEO):

/*
"I want to see if our daily demand is consistent.
Can you group orders by date and tell me the average number of pizzas ordered per day?"
*/

Analyst Task: Aggregate by order_date, calculate total pizzas per day, then average.

--Query

SELECT
	ROUND(AVG(DAILY_TOTAL)) AS AVG_PIZZA_PER_DAY
FROM
	(
		SELECT
			O.ORDER_DATE,
			SUM(OD.QUANTITY) AS DAILY_TOTAL
		FROM
			ORDERS O
			JOIN ORDER_DETAILS OD ON O.ORDER_ID = OD.ORDER_ID
		GROUP BY
			ORDER_DATE
	) AS T

10. Top 3 Pizzas by Revenue

Stakeholder (Finance Team):

/*
"We need to know which pizzas are our biggest revenue drivers.
Please provide the top 3 pizzas by revenue generated."
*/

Analyst Task: Calculate revenue per pizza (price × quantity) and rank top 3.

--Query

 

SELECT
	PT.NAME,
	SUM(OD.QUANTITY * P.PRICE) AS REVENUE
FROM
	ORDER_DETAILS OD
	JOIN PIZZAS P ON OD.PIZZA_ID = P.PIZZA_ID
	JOIN PIZZA_TYPES PT ON P.PIZZA_TYPE_ID = PT.PIZZA_TYPE_ID
GROUP BY
	PT.NAME
ORDER BY
	REVENUE DESC
LIMIT
	3;



11. Revenue Contribution per Pizza

Stakeholder (CFO):

/*
"For our revenue mix analysis, I need to know what percentage of
total revenue each pizza contributes.
This will show which items carry the business."
*/

Analyst Task: Divide revenue of each pizza by total revenue, express in Percentage.

--Query

select pt.name,
	sum(od.quantity * price) as revenue,
	concat(round(100.0 * sum(od.quantity * price) / sum(sum(od.quantity * price)) over (),2), '%' )as pct_contribution
from order_details od
join pizzas p on od.pizza_id = p.pizza_id
join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by pct_contribution desc;


12. Cumulative Revenue Over Time

Stakeholder (Board of Directors):

/*
"We want to see how our cumulative revenue has grown month by month
since launch. Can you prepare a cumulative revenue trend line?"
*/

Analyst Task: Aggregate revenue by date/month and calculate running total.

--Query

SELECT
	ORDER_DATE,
	DAILY_REVENUE,
	SUM(DAILY_REVENUE) OVER (
		ORDER BY
			ORDER_DATE
	) AS CUMULATIVE_REVENUE
FROM
	(
		SELECT
			O.ORDER_DATE,
			SUM(OD.QUANTITY * P.PRICE) AS DAILY_REVENUE
		FROM
			ORDERS O
			JOIN ORDER_DETAILS OD ON O.ORDER_ID = OD.ORDER_ID
			JOIN PIZZAS P ON P.PIZZA_ID = OD.PIZZA_ID
		GROUP BY
			O.ORDER_DATE
	) T

13. Top 3 Pizzas by Category (Revenue-Based)

Stakeholder (Product Head):

/*
"Within each pizza category, which 3 pizzas bring the most revenue?
This will help us decide which pizzas to promote or expand."
*/

Analyst Task: Partition by category, calculate revenue per pizza, rank top 3.

-- Query


with cat_rank as (
select pt.name,pt.category,
	sum(od.quantity * p.price) as revenue,
	rank() over(partition by pt.category order by sum(od.quantity * p.price) desc) as rnk
from order_details od
	join pizzas p on od.pizza_id = p.pizza_id
    join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
group by pt.name,pt.category
 )
select  name,category , revenue 
from cat_rank
where rnk <= 3


14. Top 10 Customers by Spending

Stakeholder (Customer Retention Manager):

/*
"Who are our top 10 customers based on total spend?
We want to reward them with loyalty offers."
*/

--Query

SELECT
	C.CUSTID,
	C.FIRST_NAME || ' ' || C.LAST_NAME AS NAME,
	SUM(OD.QUANTITY * P.PRICE) AS TOTAL_SPENT
FROM
	CUSTOMERS C
	JOIN ORDERS O ON C.CUSTID = O.CUSTID
	JOIN ORDER_DETAILS OD ON O.ORDER_ID = OD.ORDER_ID
	JOIN PIZZAS P ON P.PIZZA_ID = OD.PIZZA_ID
GROUP BY
	C.CUSTID,
	NAME
ORDER BY
	TOTAL_SPENT DESC
LIMIT
	10;


15. Average Order Size

Stakeholder (Supply Chain Manager):

/*
"What's the average number of pizzas per order?
This helps us in planning inventory and staffing."
*/

--Querty


select round(Avg(order_size),0) as Avg_ord_size
from 
(select order_id,
sum (quantity) as order_size
from order_details
group by order_id
)
t 


16. Seasonal Trends

Stakeholder (Operations Manager):

/*
"Do we see peak sales in certain months or holidays?
This will help us manage seasonal demand."
*/

--Query

select extract (month from order_date) as month,
	count(*) as total_orders
from orders
group by extract (month from order_date)
order by month;



17. Customer Segmentation

Stakeholder (Customer Insights Team):

/*
"Do our high-value customers prefer premium pizzas or
regular pizzas? We want to personalize marketing."
*/

--Query


WITH
	CUST_SPEND AS (
		SELECT
			C.CUSTID,
			SUM(OD.QUANTITY * P.PRICE) AS TOTAL_SPENT
		FROM
			CUSTOMERS C
			JOIN ORDERS O ON C.CUSTID = O.CUSTID
			JOIN ORDER_DETAILS OD ON O.ORDER_ID = OD.ORDER_ID
			JOIN PIZZAS P ON OD.PIZZA_ID = P.PIZZA_ID
		GROUP BY
			C.CUSTID
	)
SELECT
	CASE
		WHEN TOTAL_SPENT > 105000 THEN 'High Value'
		ELSE 'Regular'
	END AS SEGMENT,
	COUNT(*) AS CUSTOMER_COUNT
FROM
	CUST_SPEND
GROUP BY
	SEGMENT;



18. Repeat Customer Rate

Stakeholder (CRM Head - Customer Relationship Manager):

/*
"We want to measure customer loyalty. Can you calculate the percentage
of repeat customers (customers who placed more than one order)
versus one-time buyers? This will help us design retention campaigns."
*/

Analyst Task:
	From the orders table, count distinct customers.
	Count how many customers have more than one order.
	Calculate repeat rate = (repeat customers ÷ total customers) × 100.


--Query


WITH cust_orders AS (
	SELECT custId, COUNT(DISTINCT order_id) AS order_count
	FROM orders
	GROUP BY custId
)
SELECT ROUND(100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_rate
FROM cust_orders;















