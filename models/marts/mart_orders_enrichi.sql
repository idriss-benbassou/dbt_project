-- La jointure avec les statuts est faite dans la couche intermédiaire.
-- Le mart expose le résultat aux outils de restitution et au Semantic Layer.
select
    order_id,
    customer_id,
    montant,
    statut,
    statut_libelle,
    est_paye,
    date_commande
from {{ ref('int_commandes_enrichies') }}
