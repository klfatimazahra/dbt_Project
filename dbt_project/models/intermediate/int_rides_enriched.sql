{{ config(materialized='ephemeral') }}

with rides as (
    select * from {{ ref('stg_ride_events') }}
),

current_drivers as (
    select *
    from {{ ref('snap_drivers') }}
    where dbt_valid_to is null
),

vehicles as (
    select * from {{ ref('stg_vehicles') }}
)

select
    r.ride_id,
    r.driver_id,
    r.pickup_zone_id,
    r.dropoff_zone_id,
    r.distance_km,
    r.fare_amount,
    r.requested_at,

    d.driver_name,
    d.rating as driver_rating,
    {{ classify_rating('d.rating') }} as driver_rating_bracket,
   
    v.vehicle_id,
    v.vehicle_type,
    v.make as vehicle_make,
    v.model as vehicle_model
from rides r
left join current_drivers d
    on r.driver_id = d.driver_id
left join vehicles v
    on r.driver_id = v.vehicle_id