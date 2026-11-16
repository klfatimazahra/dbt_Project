select
    vehicle_id,
    driver_id,
    vehicle_type,
    make,
    model,
    plate_number
from {{ ref('stg_vehicles') }}