DROP TABLE IF EXISTS nodes;

CREATE TABLE nodes (
	point1 varchar,
	point2 varchar,
	cost int
);

INSERT INTO nodes (point1, point2, cost)
VALUES 
('a', 'b', 10),
('b', 'a', 10),
('a', 'd', 20),
('d', 'a', 20),
('a', 'c', 15),
('c', 'a', 15),
('b', 'd', 25),
('d', 'b', 25),
('b', 'c', 35),
('c', 'b', 35),
('c', 'd', 30),
('d', 'c', 30);

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
 ORDER BY total_cost, tour
