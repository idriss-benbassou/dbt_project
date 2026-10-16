{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='order_key',
    on_schema_change='append_new_columns'
) }}

select
    {{ dbt_utils.generate_surrogate_key(['order_id', 'customer_id']) }} as order_key,
    order_id,
    customer_id,
    montant,
    statut,
    date_commande,
    _loaded_at
from {{ ref('stg_orders') }}

{% if is_incremental() %}

  -- ce filtre ne s'applique QUE aux runs incrémentaux.
  -- >= plutôt que > : une ligne arrivée au même horodatage que le dernier run
  -- n'est pas perdue, et le MERGE sur order_key évite les doublons.
  where _loaded_at >= (select max(_loaded_at) from {{ this }})

{% endif %}
