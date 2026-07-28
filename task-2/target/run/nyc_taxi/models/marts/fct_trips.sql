-- back compat for old kwarg name
  
  
  
  
  
  
      
          
          
      
  

    merge
    into
        `hyf`.`dev_halyna`.`fct_trips` as DBT_INTERNAL_DEST
    using
        `fct_trips__dbt_tmp` as DBT_INTERNAL_SOURCE
    on
        
              DBT_INTERNAL_SOURCE.trip_id <=> DBT_INTERNAL_DEST.trip_id
          
    when matched
        then update set
            *
    when not matched
        then insert
            *
