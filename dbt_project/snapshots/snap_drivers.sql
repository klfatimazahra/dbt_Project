{% snapshot snap_drivers %}

{{
    config(
        target_schema='snapshots',
        unique_key='driver_id',
        strategy='check',
        check_cols=['rating'],
        invalidate_hard_deletes=True
    )
}}

select
    driver_id,
    driver_name,
    city,
    phone,
    rating
from {{ ref('stg_drivers') }}

{% endsnapshot %}