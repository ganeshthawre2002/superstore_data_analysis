-- Superstore Data Analysis Project ---


CREATE TABLE superstore (
    row_id INT,
    order_id VARCHAR(14),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(14),
    customer_id VARCHAR(8),
    customer_name VARCHAR(22),
    segment VARCHAR(11),
    country VARCHAR(13),
    city VARCHAR(17),
    state VARCHAR(20),
    postal_code INT,
    region VARCHAR(7),
    product_id VARCHAR(15),
    category VARCHAR(15),
    sub_category VARCHAR(11),
    product_name VARCHAR(127),
    sales NUMERIC(10, 2),
    quantity INT,
    discount NUMERIC(4, 2),
    profit NUMERIC(10, 2)
);


-- 15 Data Analysis Questions to Solve

-- Q1. Which region generates the most profit?

SELECT * FROM superstore;


SELECT 
region, 
SUM(profit) as total_profit
FROM superstore
GROUP BY region
ORDER BY total_profit DESC
LIMIT 1;  --  west region is the most profitable region...



-- Q2. What are the top 10 products by total sales?

SELECT * FROM superstore



SELECT 
product_name, 
SUM(Sales) AS total_sales
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;






-- Q3. Which customer has placed the highest number of orders?

SELECT * FROM superstore;


SELECT 
customer_name, 
COUNT(DISTINCT order_id) as total_orders
FROM superstore
GROUP BY customer_name
ORDER BY total_orders DESC
LIMIT 1;




-- Q4. Which segment (Consumer, Corporate, Home Office) is the most profitable?


SELECT * FROM superstore;

SELECT segment,
SUM(profit) as total_profit 
FROM superstore 
GROUP BY segment
ORDER BY total_profit DESC
LIMIT 1 ;  --- consumer is the highest profitable segment with 134119.33 






-- Q5. What are the top 5 cities by number of orders?

SELECT * FROM superstore;

SELECT 
city,
COUNT(DISTINCT order_id) as top_5_city_by_order
FROM superstore 
GROUP BY city
ORDER BY top_5_city_by_order DESC
LIMIT 5 ;




-- Q6. Which sub-categories contribute negatively to profit?

SELECT * FROM superstore;

SELECT sub_category, SUM(profit) AS total_profit
FROM superstore
GROUP BY sub_category
HAVING SUM(profit) < 0;   -- there is 3 sub_category which contributing negatively to profit table, bookcases, supplies.




-- Q7. How does the average discount impact profitability across categories?


SELECT * FROM superstore;

SELECT category,
ROUND(AVG(discount), 2) as avg_discount,
ROUND(AVG(profit), 2) as avg_profit
FROM superstore 
GROUP BY category
ORDER BY avg_discount DESC;



-- Q8. What is the month-wise trend of total sales?


SELECT * FROM superstore;

SELECT 
TO_CHAR(order_date, 'YYYY-MM') as month,
SUM(sales) as total_sales
FROM superstore 
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;



-- Q9. Which shipping mode is most used by customers?

SELECT * FROM superstore;

SELECT 
ship_mode,
COUNT(*) as total_orders
FROM superstore 
GROUP BY ship_mode
ORDER BY total_orders DESC 
LIMIT 1 ;




-- Q10. What’s the average delivery time (Ship Date - Order Date)?

SELECT * FROM superstore;


SELECT 
ROUND(AVG(ship_date - order_date),2)as avg_delivery_time
FROM superstore;   ---- avg_delivery_time is the 3.96 




-- Q11. Which states have the highest sales volume?
-- TOP 10 
SELECT * FROM superstore;

SELECT 
state,
SUM(sales) as total_sales_per_state
FROM superstore 
GROUP BY state
ORDER BY total_sales_per_state DESC
LIMIT 10;



-- Q12. Identify any customers with repeat purchases.

SELECT * FROM superstore;

SELECT 
customer_name,
COUNT(DISTINCT order_id) as customer_repeated_purchases
FROM superstore
GROUP BY customer_name 
HAVING COUNT(DISTINCT order_id)> 1 
ORDER BY customer_repeated_purchases DESC;



-- Q13. What are the most profitable product categories by region?

SELECT * FROM superstore;

SELECT region, category, total_profit
FROM(SELECT 
     region, 
	 category,
  SUM(profit) as total_profit,
  RANK() OVER(PARTITION BY region ORDER BY SUM(profit)DESC) as rank
  FROM superstore
  GROUP BY region, category) as ranked WHERE rank = 1 ;

-- Q14. what is the profit by region according to all categories.

SELECT * FROM superstore;

SELECT region, category,
     SUM(profit) as total_profit
	 FROM superstore 
	 GROUP BY region, category
	 ORDER BY region, total_profit DESC;




-- Q15. Which orders have the highest discounts applied?

SELECT * FROM superstore;

SELECT 
order_id, customer_id, product_name, 
discount, sales, 
profit
FROM superstore 
ORDER BY discount DESC 
LIMIT 10 ;





-- Q16. How do quantity and discount together influence profit?

SELECT * FROM superstore;

SELECT 
quantity,
discount,
ROUND(AVG(profit), 2) as avg_profit,
COUNT(*) as order_count
FROM superstore 
GROUP BY quantity, discount
ORDER BY avg_profit ASC;


-- Q17. Which products have a negative average profit per unit sold

SELECT 
product_name,
ROUND(SUM(profit) / NULLIF(SUM(quantity), 0),2) as avg_profit_per_unit
FROM superstore
GROUP BY product_name
HAVING SUM(profit) / NULLIF(SUM(quantity), 0) < 0
ORDER BY avg_profit_per_unit;


















