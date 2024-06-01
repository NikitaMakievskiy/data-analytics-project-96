with last_visit as (
    select
        visitor_id,
        source,
        medium,
        campaign,
        max(visit_date) as visit_date
    from sessions
    where medium != 'organic'
    group by visitor_id, source, medium, campaign
)

select
    lv.visitor_id,
    lv.visit_date,
    lv.source as utm_source,
    lv.medium as utm_medium,
    lv.campaign as utm_campaign,
    l.lead_id,
    l.created_at,
    l.amount,
    l.closing_reason,
    l.status_id
from last_visit as lv
left join leads as l on lv.visitor_id = l.visitor_id
order by
    l.amount desc nulls last, lv.visit_date asc, utm_source asc, utm_medium asc, utm_campaign asc;
