with daily_driver_totals as (
    select
        driver_id,
        coalesce(driver_name, 'Unknown') as driver_name,
        date_trunc('day', requested_at)::date as ride_date,
        count(ride_id) as total_rides,
        sum(fare_amount) as daily_earnings
    from {{ ref('fact_rides') }}
    group by 1, 2, 3
)

select
    driver_id,
    driver_name,
    ride_date,
    total_rides,
    daily_earnings,
    sum(daily_earnings) over (
        partition by driver_id
        order by ride_date
        rows between unbounded preceding and current row
    ) as cumulative_earnings,
    dense_rank() over (
        partition by ride_date
        order by daily_earnings desc
    ) as daily_earnings_rank
from daily_driver_totals