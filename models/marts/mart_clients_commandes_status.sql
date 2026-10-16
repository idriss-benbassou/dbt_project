-- La liste des statuts vient du seed : un nouveau statut ajouté au CSV
-- crée automatiquement sa colonne, sans toucher à ce modèle.
{% set statuts = dbt_utils.get_column_values(
    table=ref('statuts_commande'),
    column='statut',
    order_by='statut'
) %}

select
    customer_id,
    {{ count_by_status(statuts) }}
from {{ ref('stg_orders') }}
group by 1
