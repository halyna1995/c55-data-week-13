
  
  
  create or replace view `hyf`.`dev_halyna`.`stg_zones`
  
  as (
    select
    location_id,
    borough,
    zone,
    service_zone
from `hyf`.`nyc_yellow`.`raw_zones`
  )
