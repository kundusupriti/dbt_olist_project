{% snapshot customers_snapshot %}

{{
  config(
    target_schema='ANALYTICS_DEV',
    unique_key='customer_id',
    strategy='check',
    check_cols=['customer_city', 'customer_state', 'customer_zip_code_prefix']
  )
}}

SELECT
  customer_id,
  customer_zip_code_prefix,
  customer_city,
  customer_state
FROM {{ ref('dim_customers') }}

{% endsnapshot %}
