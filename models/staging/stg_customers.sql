SELECT
  customer_id,
  customer_unique_id,
  CAST(customer_zip_code_prefix AS NUMBER) AS customer_zip_code_prefix,
  {{ clean_string('customer_city') }} AS customer_city,
  {{ clean_string('customer_state', 'upper') }} AS customer_state
FROM {{ source('olist', 'customers') }}
