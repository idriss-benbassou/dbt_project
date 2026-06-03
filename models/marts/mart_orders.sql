{{ config(
    materialized='incremental',
    unique_key='order_id'
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

  -- ce filtre ne s'applique QUE aux runs incrémentaux
  where _loaded_at > (select max(_loaded_at) from {{ this }})

{% endif %}