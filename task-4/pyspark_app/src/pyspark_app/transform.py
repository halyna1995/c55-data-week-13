from pyspark.sql import DataFrame
from pyspark.sql import functions as F


def pickup_borough_counts(
    trips: DataFrame,
    zones: DataFrame,
) -> DataFrame:
    """Count trips for every pickup borough."""

    zone_lookup = zones.select("location_id", "borough")

    return (
        trips.join(
            F.broadcast(zone_lookup),
            trips.pickup_location_id == zone_lookup.location_id,
            "left",
        )
        .groupBy("borough")
        .agg(F.count("*").alias("trip_count"))
        .orderBy(F.desc("trip_count"))
    )


def average_total_by_payment(
    trips: DataFrame,
) -> DataFrame:
    """Calculate average total amount per payment type."""

    return (
        trips.groupBy("payment_type")
        .agg(
            F.round(
                F.avg("total_amount"),
                2,
            ).alias("avg_total_amount")
        )
        .orderBy("payment_type")
    )
