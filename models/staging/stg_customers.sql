with source as (
    select * from {{ source('raw', 'customers') }}
),

renamed as (
    select
        id          as customer_id,
        first_name  as prenom,
        last_name   as nom,
        lower(email) as email,
        created_at  as date_creation
    from source
)

select * from renamed