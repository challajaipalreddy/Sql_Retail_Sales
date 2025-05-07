--Create DataBase
create database sql_project_p1

-- Create Table
create table sales_details
(
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(15),
	age  int,
	category varchar(20),
	quantiy int,
	price_per_unit float,
	cogs float,
	total_sale float

);


select * from sales_details
limit 10


select count(*) from sales_details



-- Checking Null values
select * from sales_details
where 
transactions_id is Null
or 
sale_date is Null
or 
sale_time is NULL
or 
customer_id is null
or 
gender is null

or 
category is null
or 
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null



-- delete Null rows or Data Cleaning
delete from sales_details
where 
transactions_id is Null
or 
sale_date is Null
or 
sale_time is NULL
or 
customer_id is null
or 
gender is null

or 
category is null
or 
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null


-- Data Exploration

-- How many Sales we have?
select category,count(*) as total_sales from sales_details 
group by 1
-- How many customers we have?\
select count(distinct(customer_id)) as total_customer from sales_details
--
select distinct(category) as Types_of_categories from sales_details
--

select distinct(gender) from sales_details
--

select count(gender) from sales_details
where gender = 'Male'
--
select count(gender) from sales_details
where gender = 'Female'
--
select count(age) from sales_details
where age > 60
--
select sum(total_sale) from sales_details

--
select avg(total_sale) from sales_details
where sale_date between '2022-10-20' and '2023-10-20'


--
SELECT 
    extract(Year from sale_date) AS YEAR,
    AVG(total_sale) AS avg_sales
FROM 
    sales_details
GROUP BY 
    extract(year from sale_date)
ORDER BY 
    YEAR;

--Data Analysis and Business key Problems and Answers

--Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT sale_date 
from sales_details
where sale_date = '2022-11-05'


--Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * 
from 
sales_details
where 
category = 'Clothing'
AND
to_char(sale_date,'YYYY-MM') = '2022-11'
and quantiy >= 4;


--Q3. Write a SQL query to calculate the total sales (total_sale) for each category.:

select 
category,sum(total_sale) as net_sales,
count(*) as total_orders
from sales_details
group by 1


--Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select category,round(avg(age),2) 
as avg_age 
from sales_details
where category = 'Beauty'
group by 1


--Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * from sales_details
where total_sale > 1000



--Q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category..


SELECT category,gender, count(*) as total_transactions from sales_details
group by category,gender
order by 1






--Q7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year..:
select 
month,
year,
avg_sales
from(
SELECT 
extract(YEAR from sale_date) as year,
extract(MONTH from sale_date) as month,
avg(total_sale) as avg_sales,
rank() over(partition by extract(YEAR from sale_date) order by avg(total_sale) desc ) as rank
from sales_details
group by 1,2
) as t1
where rank = 1
--order by 1,3 desc;




--Q8.Write a SQL query to find the top 5 customers based on the highest total sales ...?

SELECT customer_id,sum(total_sale) as highest_sales
from sales_details
group by 1
order by 2 desc
limit 5


--Q9.Write a SQL query to find the number of unique customers who purchased items from each category.:.?

select category,count(distinct(customer_id)) as unique_customers from sales_details
group by 1


--Q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >1...?



WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM sales_details
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift



--Q11.What is the average quantity sold per category per gender?
SELECT 
    category,
    gender,
    ROUND(AVG(quantiy), 2) AS avg_quantity
FROM 
    sales_details
GROUP BY 
    category, gender
ORDER BY 
    category, gender;

---Q12.What is the total revenue and total COGS (Cost of Goods Sold) by category?
SELECT 
    category,
    SUM(total_sale) AS total_revenue,
    SUM(cogs) AS total_cogs
FROM 
    sales_details
GROUP BY 
    category;

--Q13. Which day of the week has the highest number of sales?


SELECT 
    TO_CHAR(sale_date, 'Day') AS weekday,
    COUNT(*) AS total_sales
FROM 
    sales_details
GROUP BY 
    weekday
ORDER BY 
    total_sales DESC;


---Q14.  What is the peak hour for sales?
SELECT 
    EXTRACT(HOUR FROM sale_time) AS hour_of_day,
    COUNT(*) AS total_sales
FROM 
    sales_details
GROUP BY 
    hour_of_day
ORDER BY 
    total_sales DESC;



---Q15..Which age group generates the highest sales?

SELECT 
    CASE
        WHEN age < 20 THEN 'Teen (<20)'
        WHEN age BETWEEN 20 AND 30 THEN 'Young Adult (20-30)'
        WHEN age BETWEEN 31 AND 50 THEN 'Adult (31-50)'
        ELSE 'Senior (50+)'
    END AS age_group,
    SUM(total_sale) AS total_sales
FROM 
    sales_details
GROUP BY 
    age_group
ORDER BY 
    total_sales DESC;




---End of project---


