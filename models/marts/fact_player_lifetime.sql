with player_annual as (
    select * from {{ ref('fact_player_annual')}}
)

, final as (
    select
        player_id, 
        player_name,
        match_type,
        min(match_year) as start_year,
        max(match_year) as end_year,
        sum(matches_played) as total_matches,
        sum(matches_won) as total_matches_won,
        sum(matches_lost) as total_matches_lost,
        total_matches_won/total_matches as pct_total_matchs_won,
        total_matches_lost/total_matches as pct_total_matches_lost
    from player_annual
    group by player_id, player_name, match_type
)

select * from final