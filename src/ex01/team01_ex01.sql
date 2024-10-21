insert into currency values ( 100, 'EUR', 0.85, '2022-01-01 13:29' );

insert into currency values ( 100, 'EUR', 0.79, '2022-01-08 13:29' );

SELECT
    COALESCE(u.name, 'not defined') AS name,
    COALESCE(u.lastname, 'not defined') AS lastname,
    c.name AS currency_name,
    c.money * COALESCE(min, max) AS currency_in_usd
FROM (
        SELECT b.user_id, cur.id, cur.name, b.money, (
                SELECT cur.rate_to_usd
                FROM currency cur
                WHERE
                    cur.id = b.currency_id
                    AND cur.updated < b.updated
                ORDER BY rate_to_usd
                LIMIT 1
            ) AS min, (
                SELECT cur.rate_to_usd
                FROM currency cur
                WHERE
                    cur.id = b.currency_id
                    AND cur.updated > b.updated
                ORDER BY rate_to_usd
                LIMIT 1
            ) AS max
        FROM currency cur
            JOIN balance b ON cur.id = b.currency_id
        GROUP BY
            b.money, cur.name, cur.id, b.updated, b.currency_id, b.user_id
        ORDER BY min DESC, max, b.updated
    ) AS c
    LEFT JOIN "user" u ON c.user_id = u.id
ORDER BY name DESC, lastname, currency_name;