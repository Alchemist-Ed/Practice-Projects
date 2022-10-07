use `dnr-rework`;

with temp
as
(
select
  sales_org_id,
  product_id,
  discount_percentage,
  special_price,
  max_order_quantity,
  concat(current_date(),' 23:59:00') as start_time,
  concat(current_date() + interval 7 day, ' 23:58:00') as end_time,
  is_lighting_deal,
  price_priority,
  reason,
  storage_type,
  count(product_id)over() as total,
  row_number()over(order by product_id) as index1
from
  `bcq3promo`
),

tempnotlast as
(
select
  sales_org_id,
  product_id,
  discount_percentage,
  special_price,
  max_order_quantity,
  start_time,
  end_time,
  is_lighting_deal,
  price_priority,
  reason,
  storage_type
from
  temp
where
  index1 <= total*6/7
and
  index1 not between total*3/7 and total*4/7
),

tempday as
(
  select
  sales_org_id,
  product_id,
  discount_percentage,
  special_price,
  max_order_quantity,
  case
  when index1 < total/7 then concat(date(start_time) + interval 1 day, ' 12:00:00')
  when index1 between total*1/7 and total*2/7 then concat(date(start_time) + interval 2 day, ' 12:00:00')
  when index1 between total*2/7 and total*3/7 then concat(date(start_time) + interval 3 day, ' 12:00:00')
  when index1 between total*3/7 and total*4/7 then concat(date(start_time) + interval 4 day, ' 12:00:00')
  when index1 between total*4/7 and total*5/7 then concat(date(start_time) + interval 5 day, ' 12:00:00')
  when index1 between total*5/7 and total*6/7 then concat(date(start_time) + interval 6 day, ' 12:00:00')
  when index1 > total*6/7 then concat(date(start_time) + interval 7 day, ' 12:00:00')
  end as start_time,
  case
  when index1 < total/7 then concat(date(start_time) + interval 1 day, ' 12:59:00')
  when index1 between total*1/7 and total*2/7 then concat(date(start_time) + interval 2 day, ' 12:59:00')
  when index1 between total*2/7 and total*3/7 then concat(date(start_time) + interval 3 day, ' 12:59:00')
  when index1 between total*3/7 and total*4/7 then concat(date(start_time) + interval 4 day, ' 12:59:00')
  when index1 between total*4/7 and total*5/7 then concat(date(start_time) + interval 5 day, ' 12:59:00')
  when index1 between total*5/7 and total*6/7 then concat(date(start_time) + interval 6 day, ' 12:59:00')
  when index1 > total*6/7  then concat(date(start_time) + interval 7 day, ' 12:59:00')
  end as end_time, 
  "Y" as is_lighting_deal,
  price_priority,
  reason,
  storage_type
  from
    temp
  ),
  
  tempnight as
  (
  select
  sales_org_id,
  product_id,
  discount_percentage,
  special_price,
  max_order_quantity,
  case
  when index1 < total/7 then concat(date(start_time) + interval 4 day, ' 19:00:00')
  when index1 between total*1/7 and total*2/7 then concat(date(start_time) + interval 5 day, ' 19:00:00')
  when index1 between total*2/7 and total*3/7 then concat(date(start_time) + interval 6 day, ' 19:00:00')
  when index1 between total*3/7 and total*4/7 then concat(date(start_time) + interval 7 day, ' 19:00:00')
  when index1 between total*4/7 and total*5/7 then concat(date(start_time) + interval 1 day, ' 19:00:00')
  when index1 between total*5/7 and total*6/7 then concat(date(start_time) + interval 2 day, ' 19:00:00')
  when index1 > total*6/7 then concat(date(date(start_time)) + interval 3 day, ' 19:00:00')
  end as start_time,
  case
  when index1 < total/7 then concat(date(start_time) + interval 4 day, ' 23:59:00')
  when index1 between total*1/7 and total*2/7 then concat(date(start_time) + interval 5 day, ' 23:59:00')
  when index1 between total*2/7 and total*3/7 then concat(date(start_time) + interval 6 day, ' 23:59:00')
  when index1 between total*3/7 and total*4/7 then concat(date(start_time) + interval 7 day, ' 23:58:00')
  when index1 between total*4/7 and total*5/7 then concat(date(start_time) + interval 1 day, ' 23:59:00')
  when index1 between total*5/7 and total*6/7 then concat(date(start_time) + interval 2 day, ' 23:59:00')
  when index1 > total*6/7 then concat(date(start_time) + interval 3 day, ' 23:59:00')
  end as end_time, 
  "Y" as is_lighting_deal,
  price_priority,
  reason,
  storage_type
  from
    temp
  ),
  
  templastday as
  (
  select
  sales_org_id,
  product_id,
  discount_percentage,
  special_price,
  max_order_quantity,
  concat(date(start_time) + interval 7 day, ' 13:00:00') as start_time,
  concat(date(start_time) + interval 7 day, ' 23:58:00') as end_time, 
  "N" as is_lighting_deal,
  price_priority,
  reason,
  storage_type
  from
    temp
  where
    index1 > total*6/7 
  ),
  
  templastnight as
  (
  select
  sales_org_id,
  product_id,
  discount_percentage,
  special_price,
  max_order_quantity,
  concat(date(start_time),' 23:59:00') as start_time,
  case
  when index1 > total*6/7 then concat(date(start_time) + interval 7 day, ' 11:59:00')
  when index1 between total*3/7 and total*4/7 then concat(date(start_time) + interval 7 day, ' 18:59:00')
  end as end_time,
  is_lighting_deal,
  price_priority,
  reason,
  storage_type
  from
    temp
  where
    index1 > total*6/7
  or
    index1 between total*3/7 and total*4/7 
  )
  
select
    *
  from
    tempnotlast
union all
select
    *
  from
    templastnight
union all
select
    *
  from
    templastday
union
select
    *
  from
    tempday
union
select
    *
  from
    tempnight