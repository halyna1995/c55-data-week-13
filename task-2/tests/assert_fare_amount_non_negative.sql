select
    pickup_datetime,
    fare_amount
from {{ ref('stg_trips') }}
where fare_amount < 0
