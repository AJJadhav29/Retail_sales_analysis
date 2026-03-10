# Retail Sales Analysis

# Summary

Developed a Retail Sales Analysis project using SQL Server to analyze transactional sales data and generate business insights. The project involved data cleaning, transformation, and exploratory data analysis to understand customer behavior, product performance, and sales trends. Missing and inconsistent records were identified and removed, and data types were optimized by converting fields such as price and cost into appropriate decimal formats.
Using SQL queries, I analyzed sales performance across product categories, customer demographics, and time periods. Key analyses included identifying top customers based on total spending, monthly sales trends, category-wise revenue, gender-based purchasing behavior, and high-value transactions. I also used window functions and CTEs to determine the best-performing sales month each year and created time-based insights by categorizing orders into morning, afternoon, and evening shifts to evaluate customer activity patterns. 
The project demonstrates strong skills in SQL data manipulation, aggregation, joins, CTEs, window functions, and business-driven data analysis, helping translate raw retail data into actionable insights.

# Project Objective

1. Analyze retail transaction data to understand overall sales performance and customer purchasing patterns.

2. Clean and prepare the dataset by identifying and removing null or inconsistent records and ensuring correct data types for accurate analysis.

3. Evaluate category-wise sales performance to determine which product categories generate the highest revenue and number of orders.

4. Understand customer behavior by analyzing demographics such as age and gender and identifying high-value customers.

5. Identify sales trends over time by analyzing monthly sales performance and determining the best-performing months each year.

6. Discover high-value transactions and top customers to help businesses focus on their most profitable segments.

7. Analyze shopping patterns by time of day (morning, afternoon, evening) to understand peak transaction periods.

8. Generate business insights using SQL queries including aggregations, CTEs, and window functions to support data-driven decision making.

# Project Structure

#### 1. Setting up Database

- **Creating Database**: First I created a database named `p1_retail_db`.
- **Upload data**: Follow up to that instead of creating table directly uploaded the data in MSSQL.

#### 2. Dataset Description

Main Columns:

- **transactions_id** – Unique ID for each transaction
- **sale_date** – Date of the sale
- **sale_time** – Time when the transaction occurred
- **customer_id** – Unique customer identifier
- **gender** – Gender of the customer
- **age** – Age of the customer
- **category** – Product category purchased
- **quantity** – Number of units purchased
- **price_per_unit** – Price of a single unit
- **cogs** – Cost of goods sold
- **total_sale** – Total sales value for the transaction

#### 3. Data Cleaning and Data Exploration
Steps taken to prepare the data for analysis:

- Checked for NULL values in important columns.
- Removed incomplete records.
- Converted data types (e.g., float to decimal).
- Standardized time and date formats.

Initial analysis to understand the dataset:

- Total number of transactions
- Total unique customers
- Unique product categories
- Overview of customer demographics

```sql
SELECT * FROM [Retail_Sales_Analysis];

SELECT COUNT(*) FROM [Retail_Sales_Analysis];

SELECT * FROM [Retail_Sales_Analysis]
WHERE 
	transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL
	OR age IS NULL OR category IS NULL OR quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;

DELETE FROM Retail_Sales_Analysis
WHERE
	quantiy IS NULL AND price_per_unit IS NULL AND cogs IS NULL AND total_sale IS NULL;

ALTER TABLE Retail_Sales_Analysis
ALTER COLUMN price_per_unit DECIMAL(10,2);

ALTER TABLE Retail_Sales_Analysis
ALTER COLUMN cogs DECIMAL(10,2);

-- Altering time
ALTER TABLE Retail_Sales_Analysis
ALTER COLUMN sale_time TIME(0);

-- How many sales we have?

SELECT COUNT(*) as total_sale FROM Retail_Sales_Analysis;

-- How many unique customers we have?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM Retail_Sales_Analysis;

-- How many unique category we have and what are they?

SELECT DISTINCT category
FROM Retail_Sales_Analysis;
```
#### 4. Data Analysis & Solving Business Problems

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**

```sql
SELECT * 
FROM Retail_Sales_Analysis
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022**

```sql
SELECT *
FROM Retail_Sales_Analysis
WHERE category = 'Clothing' and quantiy >= 4 and (sale_date between '2022-11-01' and '2022-11-30');
```

3. **Write a SQL query to calculate the total sales (total_sale) and total_orders for each category.**

```sql
SELECT 
	category, 
	SUM(total_sale) as Total_sales,
	COUNT(category) as Total_orders
FROM Retail_Sales_Analysis
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**

```sql
SELECT ROUND(AVG(age),2) as Average_age_of_Customers
FROM Retail_Sales_Analysis
WHERE category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**

```sql
SELECT * 
FROM Retail_Sales_Analysis
WHERE total_sale>1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**

```sql
SELECT category,gender ,COUNT(*) as total_no_transaction
FROM Retail_Sales_Analysis
GROUP BY category, gender
ORDER BY category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**

```sql
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
```

8. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**

```sql
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM Retail_Sales_Analysis
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC 
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**

```sql
SELECT
	category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM Retail_Sales_Analysis
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)**

```sql
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
```

#### 5. Findings

- Top Performing Categories
Analysis showed that certain product categories generated the highest revenue and order volumes, indicating strong customer demand and making them the primary drivers of overall sales.

- High-Value Transactions
Multiple transactions recorded sales greater than $1000, showing that the business has a segment of high-spending customers who significantly contribute to revenue.

- Top Customers Contribution
A small group of customers accounted for a large share of total sales, highlighting the importance of retaining and targeting these high-value customers.

- Seasonal Sales Patterns
Monthly sales analysis revealed specific months with higher average sales, indicating seasonal buying trends that businesses can leverage for promotions and inventory planning.

- Customer Demographics Influence Purchases
Customer age and gender patterns showed variations in purchasing behavior across product categories, suggesting opportunities for targeted marketing strategies.

- Peak Shopping Time
Sales distribution across morning, afternoon, and evening shifts showed that certain times of the day experience higher transaction volumes.

#### 6. Reports

- Category-wise Sales Report
Generated a report showing total sales revenue and number of orders per product category to evaluate product performance.

- Customer Spending Report
Identified the top 5 customers based on total sales, helping highlight the most valuable customers for the business.

- Monthly Sales Trend Report
Created a report to analyze average monthly sales and identify the best-performing month each year.

- Gender and Category Transaction Report
Analyzed transaction counts by gender across different product categories to understand purchasing behavior.

- Customer Distribution Report
Calculated the number of unique customers purchasing from each category, identifying categories with wider customer reach.

- Daily Sales Activity Report
Analyzed orders by time of day (morning, afternoon, evening) to understand peak transaction periods.

#### 7. Conclusion

The Retail Sales Analysis project demonstrates how SQL can be used to transform raw transactional data into meaningful business insights. Through data cleaning, exploration, and analytical queries, the project identified key trends in customer behavior, product category performance, and sales patterns over time. These insights can help businesses improve marketing strategies, inventory planning, and customer retention, ultimately supporting more data-driven decision making.
