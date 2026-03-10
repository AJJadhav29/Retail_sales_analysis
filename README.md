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
```sql

