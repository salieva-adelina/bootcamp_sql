--insert into currency values (100, 'EUR', 0.85, '2022-01-01 13:29');
--insert into currency values (100, 'EUR', 0.79, '2022-01-08 13:29');

WITH table_t AS
	(SELECT b.user_id, c.id, c.name, b.money,
	        (SELECT c.rate_to_usd
			   FROM currency AS C
			  WHERE c.id = b.currency_id AND c.updated < b.updated
			  ORDER BY c.rate_to_usd LIMIT 1) AS t1,
	        (SELECT c.rate_to_usd
			   FROM currency AS C
			  WHERE c.id = b.currency_id AND c.updated > b.updated
			  ORDER BY c.rate_to_usd LIMIT 1)AS t2
	   FROM currency AS c
	   JOIN balance AS b ON c.id = b.currency_id
	  GROUP BY b.money, c.name, c.id, b.updated, b.currency_id, b.user_id
	 ORDER By t1 DESC, t2
	)

SELECT COALESCE(u.name, 'not defined') AS name,
       COALESCE(u.lastname, 'not defined') AS lastname,
	   t.name AS currency_name,
	   t.money * COALESCE(t.t1, t.t2) AS currency_in_usd
  FROM "user" AS u
  RIGHT JOIN table_t AS t ON t.user_id = u.id
 ORDER BY name DESC, lastname, currency_name 
 





