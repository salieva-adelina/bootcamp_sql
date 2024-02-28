WITH last_rate(id, name, rate_to_usd) AS
	(SELECT id, name, rate_to_usd
	  FROM currency
     WHERE updated IN (SELECT MAX(updated) FROM currency)
	)

SELECT COALESCE(u.name, 'not defined') AS name,
       COALESCE(u.lastname, 'not defined') AS lastname,
	   b.type,
	   SUM(b.money) AS volume,
	   COALESCE(lr.name, 'not defined') AS currency_name,
	   COALESCE(lr.rate_to_usd, 1) AS last_rate_to_usd,
	   SUM(b.money) * COALESCE(lr.rate_to_usd, 1) AS total_volume_in_usd
  FROM "user" AS u
  FULL JOIN balance AS b ON u.id = b.user_id
  LEFT JOIN last_rate AS lr ON lr.id = b.currency_id
 GROUP BY b.type, u.id, u.name, u.lastname, currency_name, last_rate_to_usd
 ORDER BY name DESC, lastname, type;
 





