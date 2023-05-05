SELECT id,place,  SQRT(POWER(69.1 * (latitude - 40.7128), 2) + POWER(69.1 * (-74.0060 - longitude) * COS(latitude / 57.3), 2)) AS distance
FROM earthquakes_table
ORDER BY distance ASC;
