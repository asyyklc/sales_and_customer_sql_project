CREATE DATABASE CustomerDB;
GO

USE CustomerDB;
GO

CREATE TABLE customer_data(
    customer_id NVARCHAR(50) PRIMARY KEY,  
    gender NVARCHAR(10),
    age INT,
    payment_method NVARCHAR(50)
);

CREATE TABLE sales_data (
    invoice_no NVARCHAR(50) PRIMARY KEY,
    customer_id NVARCHAR(50),
    category NVARCHAR(50),
    quantity INT,
    price DECIMAL(10,2),
    invoice_date DATE,
    shopping_mall NVARCHAR(50)
);


BULK INSERT customer_data
FROM 'C:\temp\customer_data.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


BULK INSERT sales_data
FROM 'C:\temp\sales_data_sql.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


SELECT TOP 100 * FROM customer_data


SELECT TOP 100 * FROM sales_data


SELECT invoice_no , 
COUNT(*) AS invoice_count
FROM sales_data
GROUP BY invoice_no
HAVING COUNT(*) > 1;


CREATE TABLE sales_customer_data (
    customer_id NVARCHAR(20),
    category NVARCHAR(50),
    quantity INT,
    price DECIMAL(10,2),
    total_price DECIMAL(12,2),
    invoice_date DATE,
    shopping_mall NVARCHAR(100),
    gender NVARCHAR(10),
    age INT,
    payment_method NVARCHAR(50)

);

INSERT INTO sales_customer_data (
    customer_id,
    category,
    quantity,
    price,
    total_price,
    invoice_date,
    shopping_mall,
    gender,
    age,
    payment_method
)
SELECT
    s.customer_id,
    s.category,
    s.quantity,
    s.price,
    s.quantity * s.price AS total_price,
    s.invoice_date,
    s.shopping_mall,
    c.gender,
    c.age,
    c.payment_method
FROM sales_data AS s
INNER JOIN customer_data AS c
    ON s.customer_id = c.customer_id;

SELECT *
FROM sales_customer_data
WHERE quantity IS NULL OR price IS NULL;


--Total Revenue by Year
SELECT YEAR(invoice_date) AS years , SUM(total_price) AS total_revenue
FROM sales_customer_data
GROUP BY YEAR(invoice_date)
ORDER BY total_revenue DESC;



--Customer Number by Year 
SELECT YEAR(invoice_date) AS years, COUNT(DISTINCT customer_id) AS customer_count
FROM sales_customer_data
GROUP BY YEAR(invoice_date)
ORDER BY customer_count DESC;



--Total Sales Quantity by Year
SELECT YEAR(invoice_date) AS years, SUM(quantity) AS total_quantity
FROM sales_customer_data
GROUP BY YEAR(invoice_date)
ORDER BY total_quantity DESC;



--Average Spending per Customer
SELECT YEAR(invoice_date) AS years, 
       SUM(total_price) / COUNT(DISTINCT customer_id) AS avg_spending_per_customer
FROM sales_customer_data
GROUP BY YEAR(invoice_date)
ORDER BY avg_spending_per_customer DESC;




--Total Revenue by Store
SELECT TOP 5 shopping_mall, SUM(total_price) AS total_revenue
FROM sales_customer_data
GROUP BY shopping_mall
ORDER BY total_revenue DESC;



--Total Revenue by Store and Gender
SELECT shopping_mall, gender, SUM(total_price) AS total_revenue
FROM sales_customer_data
GROUP BY shopping_mall, gender
ORDER BY total_revenue DESC;




--Most Popular Product Category
SELECT category, SUM(quantity) AS total_amount
FROM sales_customer_data
GROUP BY category
ORDER BY total_amount DESC;




--Total Sales by Store and Category
SELECT shopping_mall , category , SUM(total_price) AS total_revenue
FROM sales_customer_data 
GROUP BY shopping_mall , category
ORDER BY total_revenue DESC;



--Total Spending and Average Invoice by Payment Method
SELECT payment_method , SUM(total_price) AS total_revenue , AVG(total_price) AS average_price
FROM sales_customer_data
GROUP BY payment_method 
ORDER BY total_revenue , average_price DESC;



--Total Sales Quantity by Age Group and Product Category
SELECT
     CASE
         WHEN age BETWEEN 18 AND 29 THEN '18-29'
         WHEN age BETWEEN 30 AND 45 THEN '30-45'
         WHEN age BETWEEN 46 AND 59 THEN '46-59'
         ELSE '60+'
    END AS age_group,
    category,
    SUM(quantity) AS total_amount,
    SUM(total_price) AS total_revenue
FROM sales_customer_data
GROUP BY
     CASE
         WHEN age BETWEEN 18 AND 29 THEN '18-29'
         WHEN age BETWEEN 30 AND 45 THEN '30-45'
         WHEN age BETWEEN 46 AND 59 THEN '46-59'
         ELSE '60+'
    END,
    category
ORDER BY age_group, total_revenue DESC;



















