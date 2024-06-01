WITH last_visit AS (
    SELECT
        visitor_id,
        MAX(visit_date) AS last_paid_visit
    FROM sessions
    WHERE medium != 'organic'
    GROUP BY visitor_id
)

SELECT
    s.visitor_id,
    s.visit_date,
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    l.lead_id,
    l.created_at,
    l.amount,
    l.closing_reason,
    l.status_id
FROM last_visit AS lv
INNER JOIN
    sessions AS s
    ON lv.visitor_id = s.visitor_id AND lv.last_paid_visit = s.visit_date
LEFT JOIN leads AS l ON s.visitor_id = l.visitor_id
WHERE s.medium != 'organic' AND created_at >= s.visit_date
ORDER BY
    l.amount DESC NULLS LAST, visit_date ASC, utm_source ASC, utm_medium ASC, utm_campaign ASC;

