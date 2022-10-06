{{ config(materialized='table')}}

with pivoted as (
    select distinct * from (
    {{
        dbt_utils.unpivot(
            relation=ref('stg_match_results'),
            cast_to='varchar',
            exclude=['match_date',
                        'match_type',
                        'score',
                        'league_level'],
            field_name='player_result',
            value_name='player_name'
        )
    }}
    )
    order by match_date, match_type, league_level, score, player_result   
)

-- logical CTEs
, match_defaults as (
    select 
        pivoted.* 
    from pivoted
    inner join (
        select 
            *
        from pivoted 
        where 1=1
        and score = '6-0, 6-0'
        and player_name is NULL
    ) using (match_date, match_type, score, league_level)
    
)

, non_defaults_only as (
    select * from pivoted
    minus
    select * from match_defaults
)

, final as (
    select distinct
        match_date,
        match_type,
        score,
        league_level,
        case
            when player_result like 'WIN%' then 'WON'
            when player_result like 'LOS%' then 'LOST'
        end as player_result,
        player_name
    from non_defaults_only
)

select * from final