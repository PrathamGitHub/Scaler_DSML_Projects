select round(quantity*cost_to_customer_per_qty)
from farmers_market.customer_purchases as t1
where market_date in
(SELECT t2.market_date
FROM farmers_market.market_date_info as t2
where market_rain_flag = 1);

select *
from farmers_market.product
where product_id in
(select product_category_id
from farmers_market.product_category
where product_category_name like '%fresh%');


select product_category_id, product_category_name
from farmers_market.product_category
where product_category_name like '%fresh%';



select *
from farmers_market.vendor
where vendor_id =
(select distinct vendor_id
from farmers_market.vendor_inventory
where quantity =
(select max(quantity)
from farmers_market.vendor_inventory));

select distinct quantity
from farmers_market.vendor_inventory
order by quantity desc
limit 1,1;

select customer_id, round(quantity*cost_to_customer_per_qty) as Total_cost, 
	case
		when round(quantity*cost_to_customer_per_qty) < 5 
			then 'Under 5'
        when round(quantity*cost_to_customer_per_qty) >=5 and round(quantity*cost_to_customer_per_qty) < 10 
			then '5 to 10'
		when round(quantity*cost_to_customer_per_qty) >= 10 and round(quantity*cost_to_customer_per_qty) < 20
			then '10 to 20'
        else 'above 10'
    end as Spending_Category
from farmers_market.customer_purchases;

select * from customer_purchases limit 5;

select ascii('a');
select CHAR(65);








