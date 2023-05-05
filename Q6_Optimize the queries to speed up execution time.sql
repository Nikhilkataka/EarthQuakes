/* To optimize the following query, I will create an index on the place column */


CREATE INDEX idx_place ON earthquakes_table(place);	
SELECT place, COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude
FROM (
  SELECT *
  FROM earthquakes_table
  WHERE place IS NOT NULL
) AS filtered
GROUP BY place
HAVING COUNT(*) >= 10
ORDER BY num_earthquakes DESC;


/*To optimize the following query, I will create an index on the latitude, longitude columns */

CREATE INDEX idx_earthquakes_table_lat_long ON earthquakes_table (latitude, longitude);
SELECT id,place,  SQRT(POWER(69.1 * (latitude - 40.7128), 2) + POWER(69.1 * (-74.0060 - longitude) * COS(latitude / 57.3), 2)) AS distance
FROM earthquakes_table
ORDER BY distance ASC
LIMIT 10;



/*To optimize the following query, I will create an index on the mag, type columns */

CREATE INDEX mag_type_index ON earthquakes_table (mag, type);
SELECT latitude, longitude, place
FROM earthquakes_table
WHERE mag >= 4.0 AND type = 'earthquake';




