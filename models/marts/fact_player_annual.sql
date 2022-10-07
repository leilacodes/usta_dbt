with matches as (
    select * from {{ ref('int_match_results') }}
)

, player_ids as (
    select * from {{ ref('int_player_ids')}}
)

, player_matches as (

    select
        player_ids.player_id,
        matches.*
    from matches
    inner join player_ids using (player_name)
)

, winloss as (
    select
        player_id,
        player_name,
        match_type,
        cast(year(match_date) as int) as match_year,
        sum(case when player_result = 'WON' then 1 else 0 end) as matches_won,
        sum(case when player_result = 'LOST' then 1 else 0 end) as matches_lost,
        matches_won + matches_lost as matches_played,
        matches_won / matches_played as win_pct,
        matches_lost / matches_played as lose_pct
    from player_matches
    group by 1,2,3,4
    order by player_id, match_year, match_type
)

select * from winloss