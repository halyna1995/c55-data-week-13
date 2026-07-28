import os

os.environ.setdefault("PYARROW_IGNORE_TIMEZONE", "1")

import pytest
from pyspark.sql import SparkSession


@pytest.fixture(scope="session")
def spark() -> SparkSession:
    session = (
        SparkSession.builder
        .master("local[2]")
        .appName("week13-pyspark-tests")
        .config("spark.ui.enabled", "false")
        .getOrCreate()
    )

    yield session

    session.stop()