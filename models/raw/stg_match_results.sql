with final as (
    select distinct
        match_date,
        match_type,
        winner1,
        winner2,
        loser1,
        loser2,
        score,
        level as league_level
    from {{ source('usta', 'player_results') }}
)

select * from final