{{ config(severity='error', warn_if='>0', error_if='>10', store_failures=true) }}

with all_matches as (
    select * from {{ ref('int_match_results') }}
)

, match_counts as (
    select 
        match_date,
        match_type,
        score,
        league_level,
        player_result,
        count(1) as num_players
    from all_matches
    group by 1,2,3,4,5
)

select distinct
    all_matches.*, num_players
from match_counts
left join all_matches using (match_date, match_type, score, league_level)
where mod(num_players,2) > 0
order by match_date, match_type, score, league_level