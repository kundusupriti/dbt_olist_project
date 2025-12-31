{% set numeric_cols = [
  ('product_name_lenght', 'product_name_length'),
  ('product_description_lenght', 'product_description_length'),
  ('product_photos_qty', 'product_photos_qty'),
  ('product_weight_g', 'product_weight_g'),
  ('product_length_cm', 'product_length_cm'),
  ('product_height_cm', 'product_height_cm'),
  ('product_width_cm', 'product_width_cm')
] %}

SELECT
  product_id,
  product_category_name,

  {%- for src, alias in numeric_cols %}
  CAST({{ src }} AS NUMBER) AS {{ alias }}{%- if not loop.last %},{% endif %}
  {%- endfor %}
FROM {{ source('olist', 'products') }}
