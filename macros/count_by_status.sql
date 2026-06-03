{% macro count_by_status(statuses) %}
    {% for s in statuses %}
    count(case when statut = '{{ s }}' then 1 end) as nb_{{ s }}{% if not loop.last %},{% endif %}
    {% endfor %}
{% endmacro %}