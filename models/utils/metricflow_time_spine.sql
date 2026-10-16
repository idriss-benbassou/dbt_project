-- Le calendrier dont le Semantic Layer a besoin : une ligne par jour.
-- Il permet de regrouper les métriques par jour, semaine, mois ou année.
{{ config(materialized='table') }}

with jours as (
    {{ dbt.date_spine(
        datepart='day',
        start_date="'2025-01-01'::date",
        end_date="'2028-01-01'::date"
    ) }}
)

select cast(date_day as date) as date_day
from jours
