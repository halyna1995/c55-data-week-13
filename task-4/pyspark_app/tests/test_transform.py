from pyspark.testing import assertDataFrameEqual

from pyspark_app.transform import (
    average_total_by_payment,
    pickup_borough_counts,
)


def test_pickup_borough_counts(spark):
    """Count trips for every pickup borough."""
    trips = spark.createDataFrame(
        [
            (1,),
            (1,),
            (2,),
            (3,),
        ],
        "pickup_location_id integer",
    )

    zones = spark.createDataFrame(
        [
            (1, "Manhattan"),
            (2, "Queens"),
            (3, "Manhattan"),
        ],
        "location_id integer, borough string",
    )

    actual = pickup_borough_counts(trips, zones)

    expected = spark.createDataFrame(
        [
            ("Manhattan", 3),
            ("Queens", 1),
        ],
        "borough string, trip_count long",
    )

    assertDataFrameEqual(
        actual,
        expected,
        checkRowOrder=True,
    )


def test_average_total_by_payment(spark):
    """Calculate average total amount per payment type."""
    trips = spark.createDataFrame(
        [
            (1, 10.0),
            (1, 20.0),
            (2, 30.0),
        ],
        "payment_type integer, total_amount double",
    )

    actual = average_total_by_payment(trips)

    expected = spark.createDataFrame(
        [
            (1, 15.0),
            (2, 30.0),
        ],
        "payment_type integer, avg_total_amount double",
    )

    assertDataFrameEqual(
        actual,
        expected,
        checkRowOrder=True,
    )
