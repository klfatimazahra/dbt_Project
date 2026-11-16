# InDrive Analytics — End-to-End dbt Pipeline

An end-to-end analytics engineering project built with **dbt (`dbt-postgres`)** and **PostgreSQL** for InDrive ride data. The pipeline ingests raw CSV seeds, applies staging transformations, tracks driver rating history with SCD Type 2 snapshots, models a star schema with an incremental fact table, enforces data quality gates, and computes driver earnings metrics using SQL window functions.

## Project Architecture

~~~text
indrive_dbt/
├── README.md
└── dbt_project/
    ├── dbt_project.yml
    ├── seeds/
    │   ├── raw_drivers.csv
    │   ├── raw_vehicles.csv
    │   ├── raw_zones.csv
    │   └── raw_ride_events.csv
    ├── macros/
    │   └── classify_rating.sql
    ├── snapshots/
    │   └── snap_drivers.sql
    └── models/
        ├── staging/
        │   ├── _staging__sources.yml
        │   ├── stg_drivers.sql
        │   ├── stg_vehicles.sql
        │   ├── stg_zones.sql
        │   └── stg_ride_events.sql
        ├── intermediate/
        │   └── int_rides_enriched.sql
        └── marts/
            ├── _marts__models.yml
            ├── dim_vehicle.sql
            ├── dim_zone.sql
            ├── fact_rides.sql
            └── mart_driver_daily_earnings.sql
~~~

### Data Layers & Materializations

* **Seeds (`raw` schema):** 4 raw CSV tables (`raw_drivers`, `raw_vehicles`, `raw_zones`, `raw_ride_events`) with source freshness configured on `raw_ride_events`.
* **Staging (`view`):** Cleans, renames, and casts types (`stg_drivers`, `stg_vehicles`, `stg_zones`, `stg_ride_events`), filtering ride events from `var('start_date')`.
* **Snapshots (`snapshots` schema):** `snap_drivers` tracks historical changes to driver ratings using `strategy='check'` on `rating` (SCD Type 2).
* **Intermediate (`ephemeral`):** `int_rides_enriched` enriches ride events via `LEFT JOIN` to active driver snapshot versions (`dbt_valid_to is null`) and vehicles, classifying ratings with the `classify_rating` macro.
* **Marts (`table` & `incremental`):**
  * `dim_vehicle` & `dim_zone` — SCD Type 1 dimension tables.
  * `fact_rides` — Incremental fact table (`unique_key='ride_id'`, `merge` strategy on `requested_at`).
  * `mart_driver_daily_earnings` — Analytical mart using window functions for cumulative driver earnings (`SUM() OVER`) and daily driver earnings rank (`DENSE_RANK() OVER`).

## Quickstart & Execution Commands

~~~bash
# 1. Start PostgreSQL and Adminer
docker compose up -d

# 2. Verify dbt connection and load raw CSV seeds
cd dbt_project
dbt debug
dbt seed

# 3. Run snapshots, models, and data quality tests
dbt snapshot
dbt run
dbt test

# 4. Generate and view lineage documentation
dbt docs generate
dbt docs serve
~~~