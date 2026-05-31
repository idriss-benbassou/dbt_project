with source as (
    select * from {{ source('raw', 'orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        amount      as montant,
        status      as statut,
        order_date  as date_commande
    from source
)

select * from renamed
