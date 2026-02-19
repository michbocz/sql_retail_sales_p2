-- SQL Retail Sales Analysis - P2
-- Create TABLE
create database sql_project_p2;
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age	INT,
	category VARCHAR (15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
	);

SELECT 
	count (*)
	FROM retail_sales

SELECT * FROM retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or 
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sale is null;

-- DATA CLEANING --

 delete from retail_sales
 where 
	transactions_id is null
	or
	sale_date is null
	or 
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sale is null;

-- DATA EXPLORATION --

-- How many sales we have?
select count (*) as total_sale from retail_sales

-- How many customer we have?
select count(distinct customer_id) as total_sale from retail_sales

select distinct category from retail_sales

-- All columns for sales made on '2022-11-05'
select *
from retail_sales
where sale_date = '2022-11-05';

-- All transactions from cathegory 'clothing' AND the quantity sold is more than 4 in the month 11-2022

select 
* 
from retail_sales
where 
	category = 'Clothing'
	and
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	and 
	quantiy >= 4

-- Calculate the total sales for each category
SELECT 
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by 1

-- Average age of customers  who purchased items from the 'Beauty' category.
select 
	round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty'

-- All transactions where the total_sale is greater than 1000

select * from retail_sales
where total_sale > 1000

-- Total number of transactions made by each gender in each category

select
	category,
	gender,
	count(*) as total_trans
from retail_sales
group by
	category,
	gender
order by 1

-- Average sale for each month and best selling month in each year

select 
	year,
	month,
	avg_sale
from
(
select
	extract (year from sale_date) as year,
	extract (month from sale_date) as month,
	avg(total_sale) as avg_sale, 
	rank() over(partition by extract(year from sale_date)order by avg(total_sale)desc) as rank
from retail_sales
group by 1, 2
) as t1
where rank = 1

-- Top 5 customers based on the highest total sales

select 
customer_id,
sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5

-- Number of unique customers who purchased items from each category

select 
	category,
	count(distinct customer_id) as unique_customers
from retail_sales
group by category

-- Creating each shift and number of orders (example Morning <= 12, afternoon between 12 & 17 , evening >17)

with hourly_sale
as
(
select *, 
	case
		when extract ( hour from sale_time ) < 12 then 'Morning'
		when extract ( hour from sale_time ) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift 
from retail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_sale
group by shift

--END OF PROJECT

	
	
