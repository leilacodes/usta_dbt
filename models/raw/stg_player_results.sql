with final as (
    select 
        id as match_id,
        match_date,
        match_type,
        case
            when won = 1 then 1
            when won = -1 then 0
            else NULL
        end as won,
        winner1,
        winner2,
        loser1,
        loser2,
        score,
        level
    from {{ source('usta', 'player_results') }}
)

select * from final