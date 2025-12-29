select
  order_id,
  cast(payment_sequential as number) as payment_sequential,
  lower(trim(payment_type)) as payment_type,
  cast(payment_installments as number) as payment_installments,
  cast(payment_value as number(18,2)) as payment_value
from {{ source('olist', 'payments') }}
