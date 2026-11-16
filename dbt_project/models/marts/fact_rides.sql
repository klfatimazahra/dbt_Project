{{
    config(
        materialized='incremental',
        unique_key='ride_id',
        incremental_strategy='merge'
    )
}}

select
    ride_id,
    driver_id,
    vehicle_id,
    pickup_zone_id,
    dropoff_zone_id,
    distance_km,
    fare_amount,
    requested_at,
    driver_name,
    driver_rating,
    driver_rating_bracket,
    vehicle_type,
    vehicle_make,
    vehicle_model
from {{ ref('int_rides_enriched') }}

{% if is_incremental() %}
where requested_at > (
    select coalesce(max(requested_at), '1900-01-01'::timestamp)
    from {{ this }}
)
{% endif %}