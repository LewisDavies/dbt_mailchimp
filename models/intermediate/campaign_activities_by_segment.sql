{{ config(enabled=var('using_segments', True)) }}

with activities as (

    select *
    from {{ ref('mailchimp_campaign_recipients')}}

), pivoted as (

    select 
        segment_id,
        count(*) as sends,
        sum(opens) as opens,
        sum(clicks) as clicks,
        count(distinct case when was_opened = True then member_id end) as unique_opens,
        count(distinct case when was_clicked = True then member_id end) as unique_clicks,
        count(distinct case when was_unsubscribed = True then member_id end) as unsubscribes
    from activities
    where segment_id is not null
    group by 1
    
)

select *
from pivoted