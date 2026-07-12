with commandes as (
    select * from {{ ref('stg_orders') }}
),

statuts as (
    select * from {{ ref('statuts_commande') }}
)

select
    c.order_id,
    c.customer_id,
    c.montant,
    c.statut,
    s.libelle   as statut_libelle,
    s.est_paye
from commandes c
left join statuts s
    on c.statut = s.statut
