WITH
    currency_rates AS (
        SELECT c.id, c.name, c.rate_to_usd
        FROM (
                SELECT id, MAX(updated) AS updated
                FROM currency
                GROUP BY
                    id
            ) AS last_updated
            JOIN currency c ON last_updated.id = c.id
            AND last_updated.updated = c.updated
    )
SELECT
    COALESCE(u.name, 'not defined') AS name,
    COALESCE(u.lastname, 'not defined') AS lastname,
    b.type,
    SUM(b.money) AS volume,
    COALESCE(cr.name, 'not defined') AS currency_name,
    COALESCE(cr.rate_to_usd, 1) AS last_rate_to_usd,
    SUM(b.money) * COALESCE(cr.rate_to_usd, 1) AS total_volume_in_usd
FROM
    balance b
    LEFT JOIN "user" u ON b.user_id = u.id
    LEFT JOIN currency_rates cr ON b.currency_id = cr.id
GROUP BY
    u.name,
    u.lastname,
    b.type,
    cr.name,
    cr.rate_to_usd
ORDER BY 
    COALESCE(u.name, 'not defined') DESC, 
    COALESCE(u.lastname, 'not defined') ASC, 
    b.type ASC;