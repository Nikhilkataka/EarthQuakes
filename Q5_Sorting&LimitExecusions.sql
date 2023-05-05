SELECT *
FROM earthquakes_table
WHERE mag >= 4.0 AND type = 'earthquake'
ORDER BY time DESC
LIMIT 10;

