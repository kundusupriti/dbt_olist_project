select
  order_id,
  cast(order_item_id as number) as order_item_id,
  product_id,
  seller_id,
  cast(shipping_limit_date as timestamp) as shipping_limit_ts,
  cast(price as number(18,2)) as item_price,
  cast(freight_value as number(18,2)) as freight_value
from {{ source('olist', 'order_items') }}
