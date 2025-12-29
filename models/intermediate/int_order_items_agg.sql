with items as (
  select
    order_id,
    product_id,
    item_price,
    freight_value
  from {{ ref('stg_order_items') }}
),

agg as (
  select
    order_id,
    count(*) as order_item_row_count,
    count(distinct product_id) as distinct_product_count,
    sum(item_price) as items_total_value,
    sum(freight_value) as freight_total_value
  from items
  group by order_id
)

select *
from agg
