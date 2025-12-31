{% macro clean_string(col, to_case='lower') -%}
  {%- if to_case == 'upper' -%}
    UPPER(TRIM({{ col }}))
  {%- elif to_case == 'lower' -%}
    LOWER(TRIM({{ col }}))
  {%- else -%}
    TRIM({{ col }})
  {%- endif -%}
{%- endmacro %}
