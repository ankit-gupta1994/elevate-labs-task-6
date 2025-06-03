CREATE DATABASE IF NOT EXISTS elevate_labs_task6;

USE elevate_labs_task6;


DROP TABLE IF EXISTS product;
CREATE TABLE product (
	product_id VARCHAR(50) PRIMARY KEY,
	product_name VARCHAR(50),
	category VARCHAR(50),
	sub_category VARCHAR(50)
);

DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
	customer_id VARCHAR(50) PRIMARY KEY,
	customer_name VARCHAR(50),
	segment VARCHAR(50)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	order_id VARCHAR(50) PRIMARY KEY,
	order_date DATE,
	customer_id VARCHAR(50) REFERENCES customer(customer_id),
	region VARCHAR(50), 
	product_id VARCHAR(50) REFERENCES product(product_id),
	sale FLOAT,
	profit FLOAT,
	discount FLOAT, 
	quantity INT, 
	category VARCHAR(50)
);

SELECT * FROM customer;

SELECT * FROM orders;

SELECT * FROM product;

-- Total Sales by Category
SELECT 
    category,
	ROUND(SUM(sale),2) AS TotalSales
FROM orders
GROUP BY category
ORDER BY TotalSales DESC;

-- Count the Number of Orders for Each Customer
SELECT
	customer_id,
    COUNT(order_id) AS NumberOfOrders
FROM orders
GROUP BY customer_id
ORDER BY NumberOfOrders DESC;

-- Sales by Region with Rank
SELECT
    Region,
	ROUND(SUM(sale),2) AS TotalSales,
    RANK() OVER(ORDER BY SUM(sale) DESC) AS SalesRank
FROM orders
GROUP BY region;

-- Analyze Customer Profitability by Segment
Select
	c.customer_id,
    c.customer_name AS Name,
    c.segment,
    ROUND(SUM(Profit),2) AS Profit
FROM customer c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.segment
ORDER BY Profit DESC;

-- Rank Products by Sales within Each Category
SELECT
    o.category,
    p.product_name,
    ROUND(SUM(sale),2) AS TotalSales,
    RANK() OVER(PARTITION BY category ORDER BY SUM(sale) DESC) AS SalesRank
FROM orders o
JOIN product p
ON o.product_id = p.product_id
GROUP BY category, product_name
ORDER BY category;

-- Total Sales per Customer by Product Category
SELECT
	c.customer_id,
    c.customer_name,
    o.category,
    ROUND(SUM(sale),2) AS TotalSales,
    DENSE_RANK() OVER(ORDER BY SUM(sale) DESC) AS `Rank`
FROM customer c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY
	c.customer_id, c.customer_name, o.category
ORDER BY `Rank`, TotalSales DESC;


-- Find total quantity sold each month by product category
SELECT
	MONTHNAME(o.order_date) AS Month,
    EXTRACT(MONTH FROM o.order_date) AS MonthNumber,
	p.category,
    SUM(o.quantity) AS TotalQuantitySold
FROM orders o
JOIN product p
ON o.product_id = p.product_id
GROUP BY Month, MonthNumber, p.category
ORDER BY MonthNumber, TotalQuantitySold DESC;
    
    
-- Total orders received per month
SELECT
	MONTHNAME(order_date) AS Month,
    COUNT(order_id) AS TotalOrderReceived
FROM orders
GROUP BY Month;

-- Total Revenue generated for Feb, Mar and April month
SELECT
	MONTHNAME(order_date) AS Month,
    ROUND(SUM(sale),2) AS TotalRevenue
FROM orders
WHERE order_date BETWEEN '2024-02-01' AND '2024-04-30'
GROUP BY Month;