+++
date = "2025-04-08T02:00:00+02:00"
title = "Cloud Native Weather Station from Sensors to Dashboard"
tags = [ "cloud-native", "weather-station", "raspberry-pi", "parquet", "sensor-applications", "duckdb", "evidence-dev" ]
summary = "Building resilient environmental monitoring systems using cloud native architecture. Learn how modern data formats and serverless processing enable scalable weather station networks with interactive dashboards, from physical sensors to visual analytics."
author = "Youssef Harby"
author_url = "https://youssefharby.com"
slug = "cloud-native-weather-station"
+++

## Introduction to Cloud Native for Sensors

What does "cloud native" mean in the context of sensor applications? It's about leveraging modern cloud computing paradigms, like object storage, serverless functions (implicitly via services like GitHub Actions), and scalable data formats, to build systems that are flexible, efficient, and easily managed. For DIY sensor stations, which often operate on resource-constrained devices like Raspberry Pis, cloud native practices are crucial. They allow us to offload heavy processing and storage, focus on reliable data collection at the edge, and easily integrate our weather station into larger networks or data platforms without needing complex local infrastructure.

## Setting up a DIY Cloud Native Weather Station

Our example uses a common DIY hardware setup for environmental sensor applications:

*   **Raspberry Pi Zero 2 W:** A low-cost, low-power computer.
*   **Pimoroni Enviro+:** An add-on board with sensors for temperature, humidity, pressure, light, proximity, and various gases (oxidised, reducing, NH3).
*   **PMS5003 Particulate Matter Sensor:** Measures PM1.0, PM2.5, and PM10 air quality indicators.

## The software architecture uses cloud-native principles:

*   **Data Collection:** A Python script runs periodically (e.g., via cron) on the Raspberry Pi, reading sensor values.
*   **Data Formatting:** Libraries like `Pandas` and `fastparquet` are used to structure the data and save it in the efficient Parquet format. *Initially chosen due to limitations in building libraries like PyArrow or DuckDB directly on the older ARMv6 architecture of the Pi Zero W, though alternatives might be possible on newer hardware.*
*   **Data Storage:** Parquet files are directly uploaded to cloud object storage (like AWS S3), I am using [Source Cooperative](https://source.coop/). Files are often partitioned by date and time for efficient querying, something like :
```sql
station={ID}/year={YYYY}/month={MM}/day={DD}/data_{HHMM}.parquet
```
*   **Data Aggregation:** Automated workflows (e.g., GitHub Actions) periodically consolidate small, frequent files (e.g., 5-minute intervals) into larger summaries (e.g., daily files with minute-level averages) to optimize storage costs and query performance.
*   **Visualization & Analysis:** Tools like [Evidence.dev](https://evidence.dev/) coupled with [DuckDB-wasm](https://duckdb.org/docs/stable/clients/wasm/overview.html) can query Parquet files directly from cloud storage within the browser, enabling interactive dashboards without a dedicated backend server.

{{< img src="images/20250408-cloud-native-weather-station1.png" >}}

## Leveraging Cloud Native Data Formats: Parquet for Weather Station Sensor Applications

Why Parquet? This columnar storage format is ideal for weather station sensor applications and analytics.

*   **Efficiency:** Stores data by column, leading to better compression and faster read performance for analytical queries that often only need a subset of columns.
*   **Compatibility:** Widely supported by data processing tools like DuckDB, Spark/Sedona, Pandas/Geopandas, and cloud data warehouses.
*   **Schema Evolution:** Supports adding or changing columns over time without breaking existing data. In my project, this feature proved valuable when I added the PM1.0, PM2.5, and PM10 ..etc measurements later, allowing the system to continue working seamlessly with both old and new data formats. When querying these files with DuckDB, using the `union_by_name=true` parameter is essential to handle the different schemas correctly.

Here's a simplified version of the actual data collection script:

```python
# File: main.py (simplified)
import time
import pandas as pd
from datetime import datetime
from fastparquet import write
import os

# Enviro+ sensor imports
from enviroplus import gas
from bme280 import BME280
from ltr559 import LTR559

# Initialize sensors
bme280 = BME280()
ltr559 = LTR559()
# PMS5003 initialization would be here

# Create Hive-partitioned directory structure
station_id = "01"
now = datetime.utcnow()
year, month, day = now.strftime("%Y"), now.strftime("%m"), now.strftime("%d")
time_str = now.strftime("%H%M")
output_dir = f"./parquet_output/station={station_id}/year={year}/month={month}/day={day}/"
os.makedirs(output_dir, exist_ok=True)

# Collect data for 5 minutes at 1-second intervals
readings = []
for _ in range(300):  # 5 minutes
    timestamp = datetime.utcnow().isoformat()
    
    # Read all sensors
    temperature = bme280.get_temperature()
    pressure = bme280.get_pressure()
    humidity = bme280.get_humidity()
    
    gas_data = gas.read_all()
    light_data = ltr559.get_lux()
    
    # Store reading
    readings.append({
        "timestamp": timestamp,
        "temperature": temperature,
        "pressure": pressure,
        "humidity": humidity,
        "oxidised": gas_data.oxidising,
        "reducing": gas_data.reducing,
        "nh3": gas_data.nh3,
        "lux": light_data,
        # PM data would be added here
    })
    
    time.sleep(1)  # 1-second sampling interval

# Save as Parquet
df = pd.DataFrame(readings)
file_path = os.path.join(output_dir, f"data_{time_str}.parquet")
write(file_path, df, compression='GZIP')
```

The full code for this implementation is available in the [parquet-edge GitHub repository](https://github.com/Youssef-Harby/parquet-edge), which includes complete setup instructions and additional utilities.

To sync files to cloud storage, a simple script runs via cron:

```bash
#!/bin/bash
# sync_to_s3.sh
SOURCE_DIR="./parquet_output/"
BUCKET="s3://your-bucket/weather-data/"

# Sync to S3
aws s3 sync $SOURCE_DIR $BUCKET
```

The `sync` command offers major benefits over direct uploads, especially in places with unreliable internet connections. It uploads only missing or changed files, automatically continues after connection problems, and can store files locally until internet is available again. This makes it very useful in locations like Egypt, where I sometimes face internet problems or power outages. The Raspberry Pi can continue collecting data on battery backup (UPS or power bank), with the sync process catching up once the internet connection returns.

## Real-Time and Historical Analytics

This cloud native setup enables powerful analytics directly from the stored Parquet files. Dashboards built with Evidence.dev can provide:

*   **Near Real-Time Views:** Displaying the latest readings (e.g., from the last 5-minute file).
*   **Trend Analysis:** Visualizing hourly, daily, or monthly patterns using aggregated data.

{{< img src="images/20250408-cloud-native-weather-station2.gif" >}}

The dashboard SQL queries are surprisingly straightforward. Here's an example from the real-time metrics page:

```sql
-- Near Real-Time Analytics Query
SELECT 
  -- Key metrics with min/max/avg
  AVG(temperature) as avg_temp,
  MIN(temperature) as min_temp,
  MAX(temperature) as max_temp,
  AVG(humidity) as avg_humidity,
  AVG(pressure) as avg_pressure,
  
  -- Air quality metrics
  AVG(oxidised) as avg_oxidised,
  AVG(reducing) as avg_reducing,
  AVG(nh3) as avg_nh3,
FROM read_parquet('s3://us-west-2.opendata.source.coop/youssef-harby/weather-station-realtime-parquet/parquet/station=01/year=2025/month=04/day=08/data_0140.parquet') -- we can get the date time from the client dynamically
```

## Community Building and Data Sharing

This DIY cloud native model inherently supports community efforts. By adopting standard formats (Parquet) and open storage (Source Cooperative), stations can easily contribute data to a larger network.

*   **Data Sharing:** Parquet files on public cloud storage are readily accessible for others to analyze or integrate.
*   **Network Growth:** New stations following the same architecture can be easily added. A central registry (perhaps a simple Parquet file itself, like `stations_db.parquet`) can list participating stations, their locations, and data URLs.
*   **Collaborative Insights:** Shared data enables broader environmental analysis across multiple locations.

## Cost, Performance, and Scalability Considerations

*   **Cost:**
    *   **Hardware:** Around $60-$100 for Raspberry Pi Zero W and Enviro+ HAT, with optional $25-$30 for the PM sensor.
    *   **Storage:** Using Source Cooperative minimizes storage costs. For S3, costs are minimal for typical data volumes. As discussed on Slack, PUT requests for the 5-minute files are negligible (~$0.005/month), with each file being only 16-25KB. A full day produces about 5MB of data.
    *   **Compute:** Primarily on the Pi for collection and free GitHub Actions tiers for aggregation.
*   **Performance:**
    *   Direct Parquet queries with DuckDB-wasm are surprisingly fast, even in the browser.
    *   The main bottleneck is the Pi Zero W's limited processing power for *building* complex libraries, not for the core task of collecting and writing data.
*   **Optimization:**
    *   A GitHub Action runs for about 2~3 minutes at the end of each day to aggregate the many small 5-minute files into a single daily file with minute-level averages. This reduces the 288 small files per day (roughly 5MB total) into a single compact file that's easier to query for historical analysis.
    
    ```sql
    -- Core DuckDB query from the daily aggregation GitHub Action
    SELECT
      date_trunc('minute', timestamp) AS timestamp,
      AVG(temperature) AS temperature,
      AVG(pressure) AS pressure,
      AVG(humidity) AS humidity,
      AVG(oxidised) AS oxidised,
      AVG(reducing) AS reducing,
      AVG(nh3) AS nh3,
      AVG(lux) AS lux,
      AVG(pm1) AS pm1,
      AVG(pm2_5) AS pm2_5,
      AVG(pm10) AS pm10
      -- Additional particle size fields omitted for brevity
    FROM 
      read_parquet('s3://path/to/daily/files/*.parquet', 
                  hive_partitioning=1, 
                  union_by_name=true)
    GROUP BY 
      date_trunc('minute', timestamp)
    ORDER BY 
      timestamp
    ```

## Conclusion and Call to Action

Adopting cloud native principles offers major benefits for sensor applications, transforming them from isolated gadgets into valuable nodes in a potential data network. By leveraging Parquet on cloud storage and client-side analysis tools, we create weather station systems that are scalable, cost-effective, and naturally open. This complete journey from physical sensors to interactive dashboards demonstrates the power of modern cloud native architecture for environmental monitoring.

Ready to build your own cloud native weather station?

1.  Check out the hardware list and setup guide: [Join the Network Instructions](https://weather.youssefharby.com/join-network/)
2.  Set up your station and configure your data upload (e.g., to Source Cooperative).
3.  Share your station's endpoint to be added to the community dashboard!
4.  Explore the live data from the Station: [Live Dashboard](https://weather.youssefharby.com/)