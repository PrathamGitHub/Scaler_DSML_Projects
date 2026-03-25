use farmers_market;
select database();

select * from product_category;
# List pair of renters who can rent togeter based on their preffered district
select r1.name as renter1, r2.name as renter2
from rentors as r1
join rentors as r2 on r1.pref_dist = r2.pref_dist
where r1.id <> r2.id;

# Duplicates in House table: same address but different id
select h1.id as id1, h2.id as id2
from houses as h1
join houses as h2 on h1.address = h2.address and h1.add <> h2.add;

# Recommend houses to renters: 1. In their preffered district 2. within their price range 3. with the required number of bedrooms
select r.name, h.address
from renters as r
join houses as h
	on r.dist = r.dist and 
		h and h.rent between r.min_rent and r.max_rent
		and h.bedroom >= r.min_bedroom;

# Find all employees with a salary higher than their average deparmental salary
# its an example of correlated sub-query. where subquery is refering the outer query information
select name
from employee as e1
where e1.salary > (select avg(salary) as avg_salary
					from employee as e2
					where e1.dept = e2.dept);
                    
# Employees which have salary < 3rd highest salary. Example of multiple sub queries


# ------------------------------- Group by -----------------
# Q. Get a list of customers who made purchase on each market date
# Ans: add Distinct

# Q. Count the number of purchases each customer made per market date
select customer_id, market_date, concat(customer_id, '_', market_date) as new_group, count(*) as num_purchases
from customer_purchases
group by customer_id, market_date
order by customer_id, market_date;

# Q. Calculate the total quantity purchased by each customer per market date
select customer_id, market_date, concat(customer_id, '_', market_date) as new_group, sum(quantity) as total_quantity
from customer_purchases
group by customer_id, market_date
order by customer_id, market_date;

# Q. How many different kinds of products were purchases by each customer per market date
select 
	customer_id, market_date, 
    concat(customer_id, '_', market_date) as new_group, 
    count(product_id) as number_of_purchases, 
    count(Distinct product_id) as number_of_different_products
from customer_purchases
group by customer_id, market_date
order by customer_id, market_date;

# Q. Calculate the total_price paid by customer_id 3 per market_date
select customer_id, market_date, sum(quantity*cost_to_customer_per_qty) as total_price
from customer_purchases
where customer_id = 3
group by market_date;


# Q. We want to determine dow much each customer had spent at each vendor, regardless of date and get additional info of customer and vendor
select c.customer_id, c.customer_first_name, v.vendor_id, v.vendor_name, v.vendor_type, sum(cp.quantity*cp.cost_to_customer_per_qty) as total_spending
from customer_purchases as cp
join customer as c on cp.customer_id = c.customer_id
join vendor_inventory as vi on cp.market_date = vi.market_date
join vendor as v on vi.vendor_id = v.vendor_id
group by c.customer_id, v.vendor_id
order by c.customer_id, v.vendor_id;

# Q. Find
select product_category_name, min(original_price), max(original_price)
from vendor_inventory as vi
join product as p on vi.product_id = p.product_id
join product_category as pc on p.product_category_id = pc.product_category_id
group by pc.product_category_id
order by pc.product_category_id;

select product_category_name, p.product_id, min(original_price), max(original_price)
from vendor_inventory as vi
join product as p on vi.product_id = p.product_id
join product_category as pc on p.product_category_id = pc.product_category_id
group by pc.product_category_id
order by pc.product_category_id;

# filter out vendors who brought at least 10 itmes over the period 2-5-19 and 16-5-19

select vendor_id, count(distinct product_id) as differenct_prod_count, sum(quantity) as total_inv_count
from vendor_inventory 
where market_date between '2019-04-03' and '2019-05-16'
group by vendor_id
having differenct_prod_count > 2;
-- having count(distinct product_id) > 2;

select market_week, market_min_temp
from market_date_info
group by market_week
order by market_week;

 
