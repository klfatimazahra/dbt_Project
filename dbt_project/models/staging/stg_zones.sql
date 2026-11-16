select
    zone_id::int        as zone_id,
    zone_name::varchar  as zone_name,
    city::varchar       as city
from {{ source('raw', 'raw_zones') }}