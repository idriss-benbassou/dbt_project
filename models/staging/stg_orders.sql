with source as (
    select * from {{ source('raw', 'orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        amount      as montant,
        status      as statut,
        order_date  as date_commande,
        _loaded_at
    from source
)

select * from renamed
