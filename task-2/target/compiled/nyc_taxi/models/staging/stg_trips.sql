



with base as (
    select
        md5(cast(concat(coalesce(cast(vendor_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(pickup_datetime as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(dropoff_datetime as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(pickup_location_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(dropoff_location_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(fare_amount as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(trip_distance as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(total_amount as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(passenger_count as string), '_dbt_utils_surrogate_key_null_')) as string)) as trip_id,
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
            
            when 0 then 'Flex Fare / unknown'
            
            when 1 then 'Credit card'
            
            when 2 then 'Cash'
            
            when 3 then 'No charge'
            
            when 4 then 'Dispute'
            
            when 5 then 'Unknown'
            
            when 6 then 'Voided trip'
            
            else 'Other'
        end as payment_type_label,
        round(
            (unix_timestamp(dropoff_datetime) - unix_timestamp(pickup_datetime)) / 60.0,
            2
        ) as trip_duration_minutes
    from `hyf`.`nyc_yellow`.`raw_trips`
    where pickup_location_id is not null
      and fare_amount >= 0
)

select *
from base
qualify row_number() over (
    partition by trip_id
    order by pickup_datetime
) = 1