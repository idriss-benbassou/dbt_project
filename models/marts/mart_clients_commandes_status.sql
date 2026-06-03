select
    customer_id,
    {{ count_by_status(['completed', 'pending']) }}
from {{ ref('stg_orders') }}
group by 1