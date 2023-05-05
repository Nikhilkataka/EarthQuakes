SELECT place, COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude
FROM earthquakes_table
GROUP BY place
HAVING COUNT(*) >= 10
ORDER BY num_earthquakes DESC;
