{{ config(materialized='table') }}

with clients as (
    select * from {{ ref('stg_customers') }}
),

commandes as (
    select * from {{ ref('stg_orders') }}
)

select
    c.customer_id,
    c.prenom,
    c.nom,
    count(o.order_id)   as nb_commandes,
    sum(o.montant)      as total_depense
from clients c
left join commandes o
    on c.customer_id = o.customer_id
group by 1, 2, 3