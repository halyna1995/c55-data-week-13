

select
    t.trip_id,
    t.pickup_datetime,
    t.dropoff_datetime,
    t.fare_amount,
    t.tip_amount,
    t.trip_distance,
    t.total_amount,
    t.trip_duration_minutes,
    t.tip_pct,
    t.fare_per_mile,
    t.payment_type_label,
    pz.borough as pickup_borough,
    pz.zone as pickup_zone,
    dz.borough as dropoff_borough,
    dz.zone as dropoff_zone
from `hyf`.`dev_halyna`.`stg_trips` t
left join `hyf`.`dev_halyna`.`stg_zones` pz
    on t.pickup_location_id = pz.location_id
left join `hyf`.`dev_halyna`.`stg_zones` dz
    on t.dropoff_location_id = dz.location_id


    where t.pickup_datetime > (
        select max(pickup_datetime)
        from `hyf`.`dev_halyna`.`fct_trips`
    )
