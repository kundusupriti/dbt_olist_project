select
  order_id,
  customer_id,
  order_status,
  order_purchase_ts,
  order_approved_ts,
  order_delivered_carrier_ts,
  order_delivered_customer_ts,
  order_estimated_delivery_date,

  order_item_row_count,
  distinct_product_count,
  items_total_value,
  freight_total_value,

  payment_total_value,
  max_payment_installments,
  payment_row_count,
  payment_type_any
from {{ ref('int_orders_enriched') }}
