with matches as (
    select 
    *
    from {{ ref('int_match_results') }}
)

, final as (

    select
        
)

select * from final