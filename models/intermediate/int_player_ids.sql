with player_names as (
    select distinct 
        player_name
    from {{ ref('players') }}
)

, final as (
    select *,
        row_number() over(order by player_name) as player_id
    from player_names
)

select * from final