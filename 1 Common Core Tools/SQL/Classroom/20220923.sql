use farmers_market;
select database();

select p.product_id, p.product_name, pc.product_category_name
from product as p
join product_category as pc on p.product_category_id = pc.product_category_id;

# all the product categories and thier products
select pc.*, p.product_name
from product_category as pc
left join product as p on pc.product_category_id = p.product_category_id;

# Get a list of customers who made a purchase on 2019-04-06
select c.*, pc.market_date
from customer_purchases as pc
left join customer as c on pc.customer_id = c.customer_id
where pc.market_date = '2019-04-06';

# All the products and categories
select p.product_name, pc.product_category_name
from product as p
left join product_category as pc on p.product_category_id = pc.product_category_id

union

select p.product_name, pc.product_category_name
from product as p
right join product_category as pc on p.product_category_id = pc.product_category_id;

# Get all customers who have purchased nothing form the market yet
select c.*, pc.market_date
from customer as c
left join customer_purchases as pc on c.customer_id = pc.customer_id
where market_date is Null;

# We want details of all farmers booth and vendor booth assignment for all dates. Along with vendor details.
select b.*, v.*
from booth as b
left join vendor_booth_assignments as vba on b.booth_number=vba.booth_number
join vendor as v on vba.vendor_id = v.vendor_id;

# 
