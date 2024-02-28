WITH RECURSIVE travel (path, next_point, last_cost) AS (

	SELECT n.point1, n.point2, cost
	  FROM nodes AS n
	 WHERE point1 = 'a'

     UNION ALL

    SELECT t.path || ',' || n.point1, n.point2, t.last_cost + n.cost
	  FROM nodes AS n
	  JOIN travel AS t ON  n.point1 = t.next_point
	 WHERE POSITION (n.point1 IN t.path) = 0
)

SELECT last_cost AS total_cost, ('{' || path || ',' || next_point || '}') AS tour
  FROM travel
 WHERE length(path) = 7
       AND next_point = 'a'
	   AND last_cost = (SELECT MIN(last_cost)
						  FROM travel
						 WHERE length(path) = 7 AND next_point = 'a')
UNION
SELECT last_cost AS total_cost, ('{' || path || ',' || next_point || '}') AS tour
  FROM travel
 WHERE length(path) = 7
       AND next_point = 'a'
	   AND last_cost = (SELECT MAX(last_cost)
						  FROM travel
						 WHERE length(path) = 7 AND next_point = 'a')
 ORDER BY total_cost, tour


