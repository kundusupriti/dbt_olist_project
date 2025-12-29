with payments as (
  select
    order_id,
    payment_type,
    payment_installments,
    payment_value
  from {{ ref('stg_payments') }}
),

agg as (
  select
    order_id,
    sum(payment_value) as payment_total_value,
    max(payment_installments) as max_payment_installments,
    count(*) as payment_row_count,
    min(payment_type) as payment_type_any
  from payments
  group by order_id
)

select *
from agg
