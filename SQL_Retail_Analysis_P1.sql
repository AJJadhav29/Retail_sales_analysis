-- Creating a new database 
CREATE DATABASE SQL_Analysis_P1;
USE SQL_Analysis_P1;

-- Checking for table
SELECT * FROM [Retail_Sales_Analysis];

SELECT COUNT(*) FROM [Retail_Sales_Analysis];

-- Exploring data
-- Checking for null values
-- Data Cleaning

SELECT * 
FROM [Retail_Sales_Analysis]
WHERE transactions_id IS NULL;

SELECT * 
FROM [Retail_Sales_Analysis]
WHERE price_per_unit IS NULL;

SELECT * 
FROM [Retail_Sales_Analysis]
WHERE cogs IS NULL;

SELECT * 
FROM [Retail_Sales_Analysis]
WHERE quantiy IS NULL;

SELECT * 
FROM [Retail_Sales_Analysis]
WHERE category IS NULL;

SELECT * 
FROM [Retail_Sales_Analysis]
WHERE age IS NULL;

SELECT * 
FROM [Retail_Sales_Analysis]
WHERE gender IS NULL;

SELECT * 
FROM [Retail_Sales_Analysis]
WHERE customer_id IS NULL;

SELECT * 
FROM [Retail_Sales_Analysis]
WHERE sale_date IS NULL;

SELECT * 
FROM [Retail_Sales_Analysis]
WHERE sale_time IS NULL;

-- Getting null column all together

SELECT *
FROM [Retail_Sales_Analysis]
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL;
-- Deleted null value which are of no use
DELETE FROM Retail_Sales_Analysis
WHERE
	quantiy IS NULL
	AND
	price_per_unit IS NULL
	AND 
	cogs IS NULL
	AND 
	total_sale IS NULL;

-- Altering the float to decimal

ALTER TABLE Retail_Sales_Analysis
ALTER COLUMN price_per_unit DECIMAL(10,2);

ALTER TABLE Retail_Sales_Analysis
ALTER COLUMN cogs DECIMAL(10,2);

-- Altering time
ALTER TABLE Retail_Sales_Analysis
ALTER COLUMN sale_time TIME(0);

-- Data Exploration

-- How many sales we have?

SELECT COUNT(*) as total_sale FROM Retail_Sales_Analysis;

-- How many unique customers we have?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM Retail_Sales_Analysis;

-- How many unique category we have and what are they?

SELECT DISTINCT category
FROM Retail_Sales_Analysis;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * 
FROM Retail_Sales_Analysis
WHERE sale_date = '2022-11-05';

/*Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
and the quantity sold is more than 10 in the month of Nov-2022*/

SELECT *
FROM Retail_Sales_Analysis
WHERE category = 'Clothing' and quantiy >= 4 and (sale_date between '2022-11-01' and '2022-11-30');


-- Q.3 Write a SQL query to calculate the total sales (total_sale) and total_orders for each category.

SELECT 
	category, 
	SUM(total_sale) as Total_sales,
	COUNT(category) as Total_orders
FROM Retail_Sales_Analysis
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) as Average_age_of_Customers
FROM Retail_Sales_Analysis
WHERE category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
FROM Retail_Sales_Analysis
WHERE total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,gender ,COUNT(*) as total_no_transaction
FROM Retail_Sales_Analysis
GROUP BY category, gender
ORDER BY category;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH monthly_avg as (SELECT 
						YEAR(sale_date) as sal_year,
						MONTH(sale_date) as sal_month,
						AVG(total_sale) as avg_sale
					FROM Retail_Sales_Analysis
					GROUP BY YEAR(sale_date), MONTH(sale_date)),
	high_rank as (SELECT 
		sal_year,
		sal_month,
		avg_sale,
		RANK() OVER(PARTITION BY sal_year ORDER BY avg_sale DESC) AS sal_rank 
	FROM monthly_avg)
SELECT 
		sal_year,
		sal_month,
		avg_sale
FROM high_rank
WHERE sal_rank = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM Retail_Sales_Analysis
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC 
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM Retail_Sales_Analysis
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT 
	shift,
	COUNT(*) as total_orders
FROM (SELECT *,
	CASE 
		WHEN DATEPART(HOUR,sale_time)< 12 THEN 'Morning'
		WHEN DATEPART(HOUR,sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM Retail_Sales_Analysis)t
GROUP BY shift
