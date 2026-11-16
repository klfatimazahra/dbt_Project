select
    vehicle_id::int             as vehicle_id,
    driver_id::int              as driver_id,
    make::varchar               as make,
    model::varchar              as model,
    plate_number::varchar              as plate_number,
    vehicle_type::varchar              as vehicle_type
from {{ source('raw', 'raw_vehicles') }}