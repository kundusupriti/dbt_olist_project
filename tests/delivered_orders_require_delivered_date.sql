SELECT
  order_id,
  order_status,
  order_delivered_customer_ts,
  order_purchase_ts
FROM {{ ref('fct_orders') }}
WHERE order_status = 'delivered'
  AND order_delivered_customer_ts IS NULL
