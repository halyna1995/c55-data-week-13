# Databricks notebook source
from pyspark.sql import functions as F

trips = spark.read.table("hyf.nyc_yellow.raw_trips")
zones = spark.read.table("hyf.nyc_yellow.raw_zones").select(
    "location_id",
    "borough",
)


# Question 1: Which pickup borough has the most trips?
pickup_counts = (
    trips
    .join(
        F.broadcast(zones),
        trips.pickup_location_id == zones.location_id,
        "left",
    )
    .groupBy("borough")
    .agg(F.count("*").alias("trip_count"))
)

top_pickup_borough = (
    pickup_counts
    .orderBy(F.desc("trip_count"))
    .limit(1)
    .select(
        F.lit("Pickup borough with most trips").alias("metric"),
        F.coalesce(F.col("borough"), F.lit("Unknown")).alias("category"),
        F.col("trip_count").cast("double").alias("value"),
    )
)

# Question 2: What is the average total_amount per payment_type?
average_total_by_payment = (
    trips
    .groupBy("payment_type")
    .agg(F.avg("total_amount").alias("avg_total_amount"))
    .select(
        F.lit("Average total_amount by payment_type").alias("metric"),
        F.col("payment_type").cast("string").alias("category"),
        F.round("avg_total_amount", 2).cast("double").alias("value"),
    )
)

# One final action for both answers.
results = top_pickup_borough.unionByName(average_total_by_payment)
results.orderBy("metric", "category").show(truncate=False)
