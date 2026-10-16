-- Couche intermédiaire : la logique métier partagée par plusieurs marts.
-- La jointure avec le référentiel des statuts est écrite une seule fois ici.
-- mart_orders_enrichi et mart_clients_commandes la réutilisent.
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
    s.est_paye,
    c.date_commande
from commandes c
left join statuts s
    on c.statut = s.statut
