CREATE DATABASE sql_project;

USE sql_project;

CREATE TABLE retail_sales(
	transactions_id	INT PRIMARY KEY,
    sale_date  DATE,
    sale_time	TIME,
    customer_id	INT,
    gender	VARCHAR(15),
    age	INT,
    category VARCHAR(20),
	quantiy  INT,	
    price_per_unit FLOAT,
    cogs FLOAT,	
    total_sale  FLOAT
);


SELECT COUNT(*) FROM retail_sales;

drop table retail_sales;

SELECT * FROM retail_sales LIMIT 10;

-- check the null value in the dataset 

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
    OR 
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR 
    gender IS NULL
    OR 
    category IS NULL 
    OR 
    quantiy IS NULL
    OR 
    cogs IS NULL
    OR 
    total_sale IS NULL;
    


DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
    OR 
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR 
    gender IS NULL
    OR 
    category IS NULL 
    OR 
    quantiy IS NULL
    OR 
    cogs IS NULL
    OR 
    total_sale IS NULL;


-- DATA EXPLORATION 


-- How many sales we have ? 

SELECT count(total_sale) FROM retail_sales;

-- How many unique customers we have ? 

SELECT COUNT(DISTINCT customer_id) AS Unique_Customers FROM retail_sales;

-- How many unique categories we have ?

SELECT COUNT(DISTINCT category) AS Unique_Category FROM retail_sales ;

SELECT DISTINCT category  FROM retail_sales;


--    Data Analysis & Business Key Problems & Answers



--  1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
 
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';


--  2. Write  a SQL query to retrieve all transactions where the category is 'Clothing' and the 
-- quantities is sold is more than 4 in the month of nov-2022?


SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing'
        AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
        AND quantiy >= 4;
    
    
    
--  3. Write a SQL Query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    COUNT(*) AS total_orders,
    SUM(total_sale) AS net_sale
FROM
    retail_sales
GROUP BY 1;


--  4. Write a SQL query to find the average age of customers who purchased items from the 
-- 	   'Beauty' category 

SELECT 
    category, ROUND(AVG(age)) AS Average_age
FROM
    retail_sales
WHERE
    category = 'Beauty';
 
 

-- 5. Write a SQl query to find all transactions where the total sales is grater than 1000.

SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000; 
    
    
--  6. Write a SQL Query to find the total number of transactions made by each gender in each category


SELECT 
    category, gender, COUNT(*) AS total_trans
FROM
    retail_sales
GROUP BY gender , category
ORDER BY 1;



--  7. Write a SQL Query to calculate the average sale for each month. Find out best selling
--     month in each year 

SELECT 
	year,
    month,
    avg_sale
FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
        RANK() OVER(
				PARTITION BY EXTRACT(YEAR FROM sale_date) 
                ORDER BY AVG(total_sale) DESC
		) AS rnk
	FROM retail_sales
	GROUP BY year , month ) as t1
WHERE rnk = 1;



-- 8. Write a SQL Query to find the top 5 customers based on the highest total sales


SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;



--  9. Write a SQL Query to find the number of unique customers who purchased items from each category


SELECT 
    category, COUNT(DISTINCT customer_id) AS unique_customer
FROM
    retail_sales
GROUP BY category;



-- 10.  Write a SQL Query to create each shift and number of oders (Example Morning <= 12 ,
--      Afternoon betweeen 12 & 17 , Evening > 17


WITH hourly_sale AS (
    SELECT 
        *,
        CASE 
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)

SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift
ORDER BY total_orders DESC;




