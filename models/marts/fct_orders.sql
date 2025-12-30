{{
  config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='order_id',
    on_schema_change='sync_all_columns'
  )
}}

WITH orders_enriched AS (
    SELECT
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
    FROM {{ ref('int_orders_enriched') }}

    {% if is_incremental() %}
    WHERE order_purchase_ts >= (
        SELECT
            DATEADD(day, -3, MAX(order_purchase_ts))
        FROM {{ this }}
    )
    {% endif %}
)

SELECT
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
FROM orders_enriched
