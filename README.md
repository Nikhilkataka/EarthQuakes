# EarthQuakes

This entire project is done in postgresql  (PGAdmin4) with extracted data from https://www.usgs.gov/programs/earthquake-hazards.......
the CSV file used for this project is  [bigdataearquake.csv](https://github.com/Nikhilkataka/EarthQuakes/files/11409071/bigdataearquake.csv)

Created the table using query below.. inside the public schema after creating the database for this project....

-- Table: public.earthquakes_table

-- DROP TABLE IF EXISTS public.earthquakes_table;

CREATE TABLE IF NOT EXISTS public.earthquakes_table
(
    "time" timestamp without time zone,
    latitude double precision,
    longitude double precision,
    depth double precision,
    mag double precision,
    magtype character varying(10) COLLATE pg_catalog."default",
    nst integer,
    gap double precision,
    dmin double precision,
    rms double precision,
    net character varying(10) COLLATE pg_catalog."default",
    id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    updated timestamp without time zone,
    place character varying(255) COLLATE pg_catalog."default",
    type character varying(50) COLLATE pg_catalog."default",
    horizontal double precision,
    deptherror double precision,
    magerror double precision,
    magnst integer,
    status character varying(50) COLLATE pg_catalog."default",
    locationsource character varying(50) COLLATE pg_catalog."default",
    magsource character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT earthquakes_table_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.earthquakes_table
    OWNER to postgres;
-- Index: idx_earthquakes_table_lat_long

-- DROP INDEX IF EXISTS public.idx_earthquakes_table_lat_long;

CREATE INDEX IF NOT EXISTS idx_earthquakes_table_lat_long
    ON public.earthquakes_table USING btree
    (latitude ASC NULLS LAST, longitude ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: lon_lat_index

-- DROP INDEX IF EXISTS public.lon_lat_index;

CREATE INDEX IF NOT EXISTS lon_lat_index
    ON public.earthquakes_table USING btree
    (longitude ASC NULLS LAST, latitude ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: mag_index

-- DROP INDEX IF EXISTS public.mag_index;

CREATE INDEX IF NOT EXISTS mag_index
    ON public.earthquakes_table USING btree
    (mag ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: mag_type_index

-- DROP INDEX IF EXISTS public.mag_type_index;

CREATE INDEX IF NOT EXISTS mag_type_index
    ON public.earthquakes_table USING btree
    (mag ASC NULLS LAST, type COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;




*********************************************************************************************************************************************************************


**Retrieve Locations of specific features**

SELECT latitude, longitude, place
FROM earthquakes_table
WHERE mag >= 4.0 AND type = 'earthquake';

********************************************************************************************************************************************************************* 

**Calculate Distance between points:**

SELECT id,place,  SQRT(POWER(69.1 * (latitude - 40.7128), 2) + POWER(69.1 * (-74.0060 - longitude) * COS(latitude / 57.3), 2)) AS distance
FROM earthquakes_table
ORDER BY distance ASC;

******************************************************************************************************************************************************************** 
**Calculate Areas of Interest specific to each group**

SELECT mag, ST_Area(ST_Transform(ST_SetSRID(ST_MakePoint(longitude, latitude), 4326), 3857)) as area 
FROM earthquakes_table
WHERE mag > 4
GROUP BY mag, longitude , latitude
HAVING COUNT(*) < 2;

 

*************************************************************************************************************************************************************
**Analyze the above queries:**
Query 1
SELECT latitude, longitude, place
FROM earthquakes_table
WHERE mag >= 4.0 AND type = 'earthquake';

Explanation:
With a magnitude of at least 4.0 and a "earthquake" type, this query chooses the latitude, longitude, and location from the earthquakes_table. This search is probably used to retrieve data on earthquakes that are notable in terms of magnitude. The place can be used to provide extra information about the earthquake's location, such as the name of the closest city or landmark, while the latitude and longitude can be used to plot the earthquake's location on a map.
*******************************************************************************************************************************************************
Query 2

SELECT id,place,  SQRT(POWER(69.1 * (latitude - 40.7128), 2) + POWER(69.1 * (-74.0060 - longitude) * COS(latitude / 57.3), 2)) AS distance
FROM earthquakes_table
ORDER BY distance ASC;

Explanation:
This query selects the id, position, and distance of each earthquake in the earthquakes_table and arranges them according to how far they were from the New York City coordinates of (40.7128, -74.0060).
The distance is calculated using the Haversine formula, which determines the shortest path between two points on a sphere while accounting for the curvature of the Earth's surface. The radius of the Earth, which is 3960 miles, is used to determine the distance in miles.
To determine the separation between two locations on the surface of a sphere, like the Earth, mathematicians utilize the Haversine formula. It is more accurate than using the Pythagorean theorem alone to determine distance since it takes the curvature of the Earth's surface into consideration.
The central angle, or angle between two radii of a sphere that intersect in the center of the sphere, is the basis for the formula. Two sites' latitude and longitude can be used to get the center angle.
The great-circle distance, which is the shortest distance between two points on the surface of a sphere, is determined using the Haversine formula using the central angle. The formula accounts for the radius of the Earth, which is important for precise computations.
Geographic information systems (GIS) and location-based applications frequently employ the Haversine formula to determine the separation between two points that are identified by their latitude and longitude.
This search is helpful for locating earthquakes that occur close to New York City overall.
**********************************************************************************************************************************************************

Query 3

SELECT place, COUNT(*) as num_earthquakes, AVG(mag) as avg_magnitude
FROM earthquakes_table
GROUP BY place
HAVING COUNT(*) >= 10
ORDER BY num_earthquakes DESC;

Explanation:
For locations where there have been at least 10 earthquakes, this query provides data on the number of earthquakes that have happened there as well as their average magnitude.

The SELECT statement, which is used to specify the columns to be returned, is followed by the words "place," "COUNT(*) as num_earthquakes," and "AVG(mag) as avg_magnitude."

The name of the place where the earthquake happened is place.
The number of earthquakes that happened in each location is returned by COUNT(*).
The average magnitude of earthquakes that occurred in each location is returned by AVG(mag).
Next, the earthquakes_table table's name is specified in the FROM statement, where it will be used to obtain the data.
The GROUP BY clause organizes the rows geographically. This indicates that the COUNT(*) and AVG(mag) functions are computed for each unique value of place.

Only groups with a row count higher than or equal to 10 are included in the results after the HAVING statement filters the data.

The ORDER BY clause then arranges the outcomes according to the num_earthquakes column in descending order.

*************************************************************************************************************************************************************
**Sorting and Limit Executions :**

SELECT *
FROM earthquakes_table
WHERE mag >= 4.0 AND type = 'earthquake'
ORDER BY time DESC
LIMIT 10;


SELECT *                     -- Select all columns from the earthquakes_table
FROM earthquakes_table       -- Specify the table to retrieve data from
WHERE mag >= 4.0             -- Filter the results to only include earthquakes with magnitude >= 4.0
  AND type = 'earthquake'    -- Filter the results to only include earthquakes of type 'earthquake'
ORDER BY time DESC           -- Sort the results in descending order by the time column
LIMIT 10;                    -- Limit the number of results to 10

This search will pull all columns from the earthquakes_table whose types are "earthquake" and whose magnitudes are greater than or equal to 4.0. The results are then being limited to 10 and sorted by the time column in descending order. The results of this search will show the ten most recent earthquakes with a magnitude of at least 4.0.

 **************************************************************************************************************************************************************
**Optimization of queries for faster execution**

Query 3

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

The first line creates an index on the place column in the earthquakes_table table, which can speed up queries that involve searching or grouping by this column.

The second query is a modification of the original query that filters out rows where the place column is null before grouping the results. By doing this filtering step first, the query can potentially reduce the amount of data that needs to be processed and improve performance.

The use of a subquery also allows for better optimization by giving the database engine more control over the query plan. The subquery creates a temporary table of filtered results that can be optimized separately from the outer query.

Overall, the combination of creating an index, filtering out null values, and using a subquery can help to optimize the performance of this query.
************************************************************************************************************************************************************
Query 2

SELECT id,place, SQRT(POWER(69.1 * (latitude - 40.7128), 2) + POWER(69.1 * (-74.0060 - longitude) * COS(latitude / 57.3), 2)) AS distance FROM earthquakes_table ORDER BY distance ASC;
To optimize this query is to create an index on the longitude and latitude columns to speed up the sorting process.
This index will improve the performance of the query by allowing the database to quickly locate and sort the relevant rows based on latitude and longitude.
Additionally, you could limit the number of rows returned by the query by using the LIMIT clause if you only need a certain number of results. For example:
CREATE INDEX idx_earthquakes_table_lat_long ON earthquakes_table (latitude, longitude);
SELECT id,place,  SQRT(POWER(69.1 * (latitude - 40.7128), 2) + POWER(69.1 * (-74.0060 - longitude) * COS(latitude / 57.3), 2)) AS distance
FROM earthquakes_table
ORDER BY distance ASC
LIMIT 10;

 

Result comparisons after query optimization: 
upon comparinng  the execution results of optmized query is 115 millisecond where original query had 143 millisecond as execution time, so optimized and faster than earlier.

*******************************************************************************************************************************************************
Query 1

SELECT latitude, longitude, place
FROM earthquakes_table
WHERE mag >= 4.0 AND type = 'earthquake';


since this query does not involve any aggregations or complex spatial operations, there is not much scope for optimization. However, we can still try to optimize it by creating an index on the mag and type columns, which will speed up the filtering process.
CREATE INDEX mag_type_index ON earthquakes_table (mag, type);
SELECT latitude, longitude, place
FROM earthquakes_table
WHERE mag >= 4.0 AND type = 'earthquake';



upon comparinng  the execution results of optmized query is 052 millisecond where original query had 148 millisecond as execution time, so optimized and faster than earlier.


*****************************************************************************************************************************************************************
**N optimization of the queries:**

Beyond simple query optimization, N-optimization requires the use of more sophisticated optimization techniques. The following are some methods that can be applied:

Indexing: Building indexes on the columns that are utilized in the WHERE, JOIN, and GROUP BY clauses can greatly enhance query performance. It decreases the requirement for full table scans by enabling the database engine to locate and obtain the necessary data rapidly.
Partitioning: By lowering the quantity of data that needs to be scanned, splitting a big table into smaller, more manageable segments can boost performance
Materialized views: By decreasing the amount of processing necessary at query time, precomputed views of frequently accessible data can increase performance.
Query caching: Keeping the answers to frequently used queries in memory might cut down on the amount of time it takes to respond to a query.
Denormalization: By removing the requirement for complex joins, precomputing join tables or redundantly embedding data can increase performance.
Rewriting complex queries into smaller ones that accomplish the same task can increase performance by cutting down on the amount of processing necessary.
Query parallelization: Using many CPU cores, splitting a large query into smaller ones that may be processed simultaneously can enhance performance.
These methods call for a higher level of database administration expertise and might not be appropriate in all circumstances, but when used properly, they can result in significant performance improvements.







