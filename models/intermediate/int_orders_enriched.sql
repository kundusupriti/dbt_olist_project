with orders as (
  select
    order_id,
    customer_id,
    order_status,
    order_purchase_ts,
    order_approved_ts,
    order_delivered_carrier_ts,
    order_delivered_customer_ts,
    order_estimated_delivery_date
  from {{ ref('stg_orders') }}
),

items_agg as (
  select
    order_id,
    order_item_row_count,
    distinct_product_count,
    items_total_value,
    freight_total_value
  from {{ ref('int_order_items_agg') }}
),

payments_agg as (
  select
    order_id,
    payment_total_value,
    max_payment_installments,
    payment_row_count,
    payment_type_any
  from {{ ref('int_payments_agg') }}
),

final as (
  select
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_ts,
    o.order_approved_ts,
    o.order_delivered_carrier_ts,
    o.order_delivered_customer_ts,
    o.order_estimated_delivery_date,

    coalesce(i.order_item_row_count, 0) as order_item_row_count,
    coalesce(i.distinct_product_count, 0) as distinct_product_count,
    coalesce(i.items_total_value, 0) as items_total_value,
    coalesce(i.freight_total_value, 0) as freight_total_value,

    coalesce(p.payment_total_value, 0) as payment_total_value,
    p.max_payment_installments,
    coalesce(p.payment_row_count, 0) as payment_row_count,
    p.payment_type_any
  from orders o
  left join items_agg i
    on o.order_id = i.order_id
  left join payments_agg p
    on o.order_id = p.order_id
)

select *
from final
