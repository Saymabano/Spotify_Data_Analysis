--  SQL Spotify Project


CREATE TABLE spotify
(  
   Artist VARCHAR(255),	
   Track  VARCHAR(255),	
   Album VARCHAR(255),		
   Album_type VARCHAR(50),
   Danceability FLOAT,
   Energy	FLOAT,
   Loudness	FLOAT,
   Speechiness	FLOAT,
   Acousticness	FLOAT,
   Instrumentalness	FLOAT,
   Liveness FLOAT,
   Valence	FLOAT,
   Tempo	FLOAT,
   Duration_min	FLOAT,
   Title  VARCHAR(255),
   Channel	VARCHAR(255),
   Views FLOAT	,
   Likes BIGINT	,
   Comments	BIGINT,
   Licensed	BOOLEAN,
   official_video	BOOLEAN,
   Stream	BIGINT,
   EnergyLiveness	FLOAT,
   most_playedon VARCHAR(50)

);

-- EDA

SELECT COUNT(*) FROM spotify;

-- Find distinct artist

SELECT COUNT(DISTINCT artist) FROM spotify;

-- find distinct album

SELECT COUNT(DISTINCT album) FROM spotify;

-- find distinct album_type

SELECT DISTINCT album_type FROM spotify;

-- find max duration 

SELECT ROUND(MAX(duration_min)) FROM spotify;

-- total views

SELECT COUNT(views) FROM spotify;

SELECT * FROM spotify;
 
SELECT * FROM spotify
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;

SELECT DISTINCT most_playedon FROM spotify

-----Data Analysis -Easy Category----

-- Retrive tracks that have 1 billion stream
SELECT * FROM spotify;

SELECT track FROM spotify
WHERE stream >=1000000000;

-- 
SELECT album, artist FROM spotify;

-- 
SELECT track, COUNT(comments) FROM spotify
WHERE licensed = 'true'
GROUP BY track;

-- 
SELECT track  FROM spotify
WHERE album_type = 'single';

-- 
SELECT artist, COUNT(track) FROM spotify
GROUP BY artist;

--- Medium Category---

SELECT * FROM spotify;

-- Calculate AVG danceability of track in each album
SELECT 
  album ,
  avg(danceability)
FROM spotify
GROUP BY album
;

-- top five track with highest energy values
SELECT * FROM spotify

SELECT 
  track , 
  max( energy) AS energy_values
FROM spotify
GROUP BY 1
ORDER BY 2 desc
LIMIT 5;

-- tarcks along with views and likes where official_video = true
SELECT 
  track,
  sum(views) as total_views  ,
  sum(likes) as total_likes
from spotify
WHERE official_video = 'true'
group by 1
order by 2 desc;

-- each album, calculate total views of all associated tracks


SELECT 
  album,
  track,
  sum(views) as total_views
FROM spotify
GROUP BY 1,2
ORDER BY 3 desc;

-- tracks names that have been streamedon spotify more than yt
SELECT * FROM
(SELECT 
  track,
  COALESCE(sum(CASE WHEN most_playedon = 'Youtube' THEN stream END),0) as streamedon_yt ,
  COALESCE(sum(CASE WHEN most_playedon = 'Spotify' THEN stream END),0) as streamedon_spotify 
FROM spotify
GROUP BY 1)AS t1
WHERE
  streamedon_spotify >streamedon_yt 
AND
  streamedon_yt<>0 ;

 -- Advanced Category--

 -- top three most viewed track for each artist
 EXPLAIN ANALYZE
WITH ranking_artist
AS
(SELECT 
   artist,
   track,
   sum(views)AS total_views ,
   dense_rank() over(partition by artist order by  sum(views)desc )as rank
 FROM spotify
 group by 1,2
 order by 1,3 desc
 )
SELECT * FROM ranking_artist
WHERE rank <=3;
 
-- tracks where livness score its above the avg
SELECT * FROM spotify 
where liveness > (SELECT 
   AVG(liveness)as liveness_avg  -- 0.19
FROM spotify);
 
-- c
WITH energy_diffrences
AS
(SELECT
  album,
  max(energy)as highest_energy,
  min(energy) as lowest_energy
FROM spotify
group by 1
)
SELECT 
  album,
 (highest_energy - lowest_energy) as energy_diffrence
FROM energy_diffrences;


-- Query Optimization
EXPLAIN ANALYZE --et 12.22ms pt 0.17ms
SELECT
  artist,
  track,
  views
FROM spotify
WHERE artist = 'Gorillaz'
  AND
  most_playedon = 'Youtube'
order by stream DESC LIMIT 25;

CREATE INDEX artist_index ON spotify(artist);









