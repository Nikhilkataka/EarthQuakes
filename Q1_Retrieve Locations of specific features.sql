SELECT latitude, longitude, place
FROM earthquakes_table
WHERE mag >= 4.0 AND type = 'earthquake';
