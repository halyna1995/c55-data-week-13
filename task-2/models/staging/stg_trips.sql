{{ config(materialized='view') }}

{% set payment_types = {
    0: 'Flex Fare / unknown',
    1: 'Credit card',
    2: 'Cash',
    3: 'No charge',
    4: 'Dispute',
    5: 'Unknown',
    6: 'Voided trip'
} %}

with base as (
    select
        {{ dbt_utils.generate_surrogate_key([
            'vendor_id',
            'pickup_datetime',
            'dropoff_datetime',
            'pickup_location_id',
            'dropoff_location_id',
            'fare_amount',
            'trip_distance',
            'total_amount',
            'passenger_count'
        ]) }} as trip_id,
        pickup_datetime,
        dropoff_datetime,
        pickup_location_id,
        dropoff_location_id,
        fare_amount,
        tip_amount,
        trip_distance,
        total_amount,
        payment_type,
        case
            when fare_amount > 0 then round(tip_amount / fare_amount, 4)
            else null
        end as tip_pct,
        case
            when trip_distance > 0 then round(fare_amount / trip_distance, 4)
            else null
        end as fare_per_mile,
        case payment_type
            {% for code, label in payment_types.items() %}
            when {{ code }} then '{{ label }}'
            {% endfor %}
            else 'Other'
        end as payment_type_label,
        round(
            (unix_timestamp(dropoff_datetime) - unix_timestamp(pickup_datetime)) / 60.0,
            2
        ) as trip_duration_minutes
    from {{ source('nyc_taxi', 'raw_trips') }}
    where pickup_location_id is not null
      and fare_amount >= 0
)

select *
from base
qualify row_number() over (
    partition by trip_id
    order by pickup_datetime
) = 1
