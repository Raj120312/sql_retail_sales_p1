-- sql retail sales analysis
-- create table 

create table retail_sales(
		transactions_id int primary key,
		sale_date date,
		sale_time time,
		customer_id	int,
		gender varchar(10),
		age int ,
		category varchar(20),	
		quantity int ,
		price_per_unit	float,
		cogs float,
		total_sale float

)

select count(*) from retail_sales;

select * from retail_sales;

select * from retail_sales 
where 
	transactions_id is null 
	or
	sale_date is null
	or
	gender is null
	or 
	category is null
	or 
	quantity is null
	or 
	cogs is null
	or 
	total_sale is null
	;

-- now we will delete the null rows

delete from retail_sales 
where 
	transactions_id is null 
	or
	sale_date is null
	or
	gender is null
	or 
	category is null
	or 
	quantity is null
	or 
	cogs is null
	or 
	total_sale is null
	;


select count(*) from retail_sales


-- data exploration

-- how many sales we have 

select count(*) as total_sales from retail_sales;

-- how many customers we have 

select count(distinct customer_id) as unique_customers from retail_sales;

-- how many categories we have 

select count(distinct category) as category from retail_sales;

-- how many transactions based on gender wise and category wise 

select count(transactions_id) as transaction_count, gender , category from retail_sales 
group by gender , category;

-- total sales bifurcation based on gender and category
select sum(total_sale) , gender , category from retail_sales
group by gender , category;

-- customer with maximum total sale
SELECT *
FROM retail_sales
ORDER BY total_sale DESC
LIMIT 1;

-- Business key problems or answers 
--1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select * from retail_sales where sale_date = '2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_sales
where 
category='Clothing' and quantity >=4 and 
to_char(sale_date,'YYYY-MM') = '2022-11';

--3. Write a SQL query to calculate the total sales (total_sale) for each category.:
select sum(total_sale) , count(*) as total_orders, category from retail_sales
group by category;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select avg(age) from retail_sales
where
category = 'Beauty';

--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from retail_sales where total_sale>1000;

--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select count(transactions_id) as count_of_transactions,
gender , category from retail_sales
group by gender , category 
order by gender;




--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
With monthly_sales as (
select 
Extract(Year from sale_date) as sale_year,
extract(month from sale_date) as sale_month,
avg(total_sale) as average_month_sale
from retail_sales
Group by sale_year , sale_date
), 
ranked_sales as (
select * , Rank() over( partition by sale_year 
order by average_month_sale DESC) as rnk
from monthly_sales
)
select sale_year, sale_month, average_month_sale
from ranked_sales
where rnk=1;

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
)
WHERE rank = 1;


--8.**Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT customer_id, sum(total_sale) as total_sale_per_customer
FROM retail_sales 
group by customer_id
ORDER BY total_sale_per_customer DESC 
LIMIT 5;


-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
select count(distinct(customer_id)) as unique_customers_count , category 
from retail_sales
group by category;

--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hourly_sale 
as 
(
select *,
case 
when extract(hour from sale_time) < 12 then 'Morning'
when extract(hour from sale_time) Between 12 and 17 then 'Afternoon'
else 'Evening'
End as shift
from retail_sales 
)
select shift , count(*) as total_orders from hourly_sale
group by shift;