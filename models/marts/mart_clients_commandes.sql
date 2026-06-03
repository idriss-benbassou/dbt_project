{{ config(materialized='table') }}

with clients as (
    select * from {{ ref('stg_customers') }}
),

commandes as (
    select * from {{ ref('stg_orders') }}
    where statut = 'completed'
)

-- demo comment
select
    c.customer_id,
    c.prenom,
    c.nom,
    count(o.order_id)   as nb_commandes,
    sum(o.montant)      as total_depense,
    {{ safe_divide('total_depense', 'nb_commandes') }} as panier_moyen
from clients c
left join commandes o
    on c.customer_id = o.customer_id
group by 1, 2, 3