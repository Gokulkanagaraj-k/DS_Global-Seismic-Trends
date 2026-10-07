

1-
 select mag from Earthquake group by mag order by mag desc limit 10; 
 
 2-
 select depth from Earthquake group by depth order by depth desc limit 10;
 
 3-
select * from Earthquake where id in ( select id from Earthquake where depth <50 and mag > 2.50);

 4-
select sources, avg(depth) from Earthquake group by sources; 

 5-
 select magtype, avg(mag) from Earthquake group by magtype; 
 
 6-
 select year(time) as year, count(year(time)) as no_of_earthquakes from Earthquake group by year(time) order by no_of_earthquakes desc limit 1 ; 
 
6a-
select year(time) as year, count(year(time)) as no_of_earthquakes from Earthquake group by year(time) order by no_of_earthquakes desc ; --   year(time) extract year from time 

 7-
 SELECT year, month, no_of_earthquakes FROM 
( SELECT YEAR(time) AS year, MONTH(time) AS month, COUNT(*) AS no_of_earthquakes FROM Earthquake GROUP BY YEAR(time), MONTH(time)) t 
WHERE (year, no_of_earthquakes) IN ( SELECT year, MAX(no_of_earthquakes) FROM ( SELECT YEAR(time) AS year, MONTH(time) AS month, COUNT(*) AS no_of_earthquakes
FROM Earthquake GROUP BY YEAR(time), MONTH(time)) x GROUP BY year) ORDER BY year;

8-		
 SELECT year, month, week, time, no_of_earthquakes FROM 
( SELECT YEAR(time) AS year, MONTH(time) AS month, week(time) AS week, time, COUNT(*) AS no_of_earthquakes FROM Earthquake GROUP BY YEAR(time), MONTH(time),week(time), time) t 
WHERE (year, no_of_earthquakes) IN ( SELECT year, MAX(no_of_earthquakes) FROM ( SELECT time, YEAR(time) AS year, MONTH(time) AS month, week(time), COUNT(*) AS no_of_earthquakes
FROM Earthquake GROUP BY YEAR(time), MONTH(time),week(time),time) x GROUP BY year) ORDER BY year;

9-
SELECT YEAR(time) AS year, MONTH(time) AS month, week(time) as week, date(time) as day, hour(time) as hour, COUNT(*) AS no_of_earthquakes
FROM Earthquake GROUP BY year, month,week,hour, hour, day order by year,month, week,day,hour;

10-
select max(net) from earthquake group by net limit 1;

11-
select place, sig from earthquake order by sig desc limit 5;

12- No detail

13- NO detail

14-
select status, count(*)  from earthquake group by status ;

15-
SELECT type, COUNT(*) AS count FROM Earthquake GROUP BY type;

16-
select type_1, types, count(*) as count from earthquake where type_1 = 'earthquake' group by types, type_1 order by count desc;

17-
select avg (rms), avg (gap), SUBSTRING_INDEX (place, ' ', -1) AS country FROM earthquake group by country;

18-
SELECT id,time, place, mag, nst
FROM earthquake
WHERE nst > 100   -- replace 100 with your threshold
  AND type_1 = 'earthquake'
ORDER BY nst DESC;


19-
select year(time) as year, sum(tsunami) as no_0f_tsunami from earthquake group by year(time) order by year asc ;

20-
select count(type_1) as earthquake ,  alert from earthquake where type_1 = 'earthquake' group by alert ;

21-
select avg(mag) magnitude , SUBSTRING_INDEX (place, ', ', -1) AS country  FROM earthquake group by country order by magnitude desc limit 5 ;

22-	
select distinct SUBSTRING_INDEX (place, ', ', -1) AS country, year(time) as year, month(time) as month from earthquake where type_1 = 'earthquake' group by year,month, country ;	

23-
select year(time) as year, type_1, count(*) as count from earthquake where type_1 = 'earthquake' group by year ;	

24-
select distinct REPLACE(SUBSTRING_INDEX(place, ', ', -1), ' region', '') AS country,
count(*) as earthquake,
avg(mag) magnitude,
(count(*) * avg(mag)) as frequency 
from earthquake where type_1 = 'earthquake' group by country order by frequency desc LIMIT 3;	

25-
select distinct REPLACE(SUBSTRING_INDEX(place, ', ', -1), ' region', '') AS country,
avg(Depth)
from earthquake where type_1 = 'earthquake' and Latitude between -5 and 5 group by country;

26-
SELECT 
    country,
    SUM(CASE WHEN depth < 70 THEN 1 ELSE 0 END) AS shallow_count,
    SUM(CASE WHEN depth >= 300 THEN 1 ELSE 0 END) AS deep_count,
    CASE 
        WHEN SUM(CASE WHEN depth >= 300 THEN 1 ELSE 0 END) = 0 THEN NULL
        ELSE 
            SUM(CASE WHEN depth < 70 THEN 1 ELSE 0 END) * 1.0 /
            SUM(CASE WHEN depth >= 300 THEN 1 ELSE 0 END)
    END AS ratio
FROM (
    SELECT 
        REPLACE(SUBSTRING_INDEX(place, ', ', -1), ' region', '') AS country,
        depth
    FROM earthquake
    WHERE type_1 = 'earthquake'
) t
GROUP BY country
HAVING deep_count > 0
ORDER BY ratio DESC
LIMIT 10;

27-
SELECT 
    AVG(CASE WHEN tsunami = 1 THEN mag END) AS avg_with_tsunami,
    AVG(CASE WHEN tsunami = 0 THEN mag END) AS avg_without_tsunami,
    AVG(CASE WHEN tsunami = 1 THEN mag END) 
    - AVG(CASE WHEN tsunami = 0 THEN mag END) AS mag_difference
FROM earthquake
WHERE type_1 = 'earthquake';

28-
SELECT id,place, mag, gap, rms,
    (COALESCE(gap, 0) + COALESCE(rms, 0)) / 2 AS avg_error_margin
FROM earthquake
WHERE type_1 = 'earthquake'
ORDER BY avg_error_margin DESC
LIMIT 10;

29-

SELECT *
FROM (
    SELECT 
        id,
        LEAD(id) OVER (ORDER BY time) AS next_id,
        time,
        LEAD(time) OVER (ORDER BY time) AS next_time,
        mag,
        LEAD(mag) OVER (ORDER BY time) AS next_mag,

        TIMESTAMPDIFF(MINUTE, time, LEAD(time) OVER (ORDER BY time)) AS time_diff_min,

        6371 * 2 * ASIN(SQRT(
            POWER(SIN(RADIANS(LEAD(latitude) OVER (ORDER BY time) - latitude) / 2), 2) +
            COS(RADIANS(latitude)) * COS(RADIANS(LEAD(latitude) OVER (ORDER BY time))) *
            POWER(SIN(RADIANS(LEAD(longitude) OVER (ORDER BY time) - longitude) / 2), 2)
        )) AS distance_km

    FROM earthquake
    WHERE type_1 = 'earthquake'
) t
WHERE time_diff_min <= 60
  AND distance_km <= 50
ORDER BY time;

30-

SELECT 
    REPLACE(SUBSTRING_INDEX(place, ', ', -1), ' region', '') AS region,
    COUNT(*) AS deep_quake_count
FROM earthquake
WHERE depth > 300
  AND type_1 = 'earthquake'
GROUP BY region
ORDER BY deep_quake_count DESC;


-----------------------------------------


create table projects_1.Earthquake (
type VARCHAR (20),
id VARCHAR (20),
mag Float,
place VARCHAR (250),
time DATETIME,
updated DATETIME,
tz VARCHAR (20),
url VARCHAR (100),
detail VARCHAR (100),
felt Float,
cdi Float,
mmi Float,
alert VARCHAR (20),
status VARCHAR (50),
tsunami Integer ,
sig Integer ,
net VARCHAR (50),
code VARCHAR (20),
ids TEXT,
sources TEXT,
types VARCHAR (200),
nst Float,
dmin Float,
rms Float,
gap Float,
magType VARCHAR (20),
type_1 VARCHAR (100),
title VARCHAR (100),
type_2 VARCHAR (120),
coordinates VARCHAR(100), 
Longitude FLOAT,
Latitude FLOAT,
Depth FLOAT );

-----------------------

LOAD DATA LOCAL INFILE 'C:/Users/gokul/OneDrive/Documents/VS python/Project 1/SQL/csv/earthquake_full_data.txt'
INTO TABLE projects_1.earthquake
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-----------------------