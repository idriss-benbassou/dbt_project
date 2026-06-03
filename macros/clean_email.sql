{% macro clean_email(column_name) %}
    trim(lower({{ column_name }}))
{% endmacro %}