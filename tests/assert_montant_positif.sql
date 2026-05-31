select
    order_id,
    montant
from {{ ref('stg_orders') }}
where montant <= 0