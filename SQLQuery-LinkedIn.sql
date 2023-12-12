SELECT *
FROM job_postings$


-------------------------------------------

-- Splitting location to City, State, Country

SELECT location
FROM job_postings$

SELECT location, PARSENAME(REPLACE(location,', ','.'),1),
	PARSENAME(REPLACE(location,', ','.'),2),
	PARSENAME(REPLACE(location,', ','.'),3)
FROM job_postings$

CREATE VIEW SplittedLocation AS
SELECT job_id, location,
	'United States' AS Country,
	CASE WHEN location LIKE '%,%,%' THEN PARSENAME(REPLACE(location, ', ', '.'), 2)
		WHEN location LIKE '%,%' AND  PARSENAME(REPLACE(location, ', ', '.'), 1) LIKE '%United States%' THEN PARSENAME(REPLACE(location, ', ', '.'), 2)
		WHEN location LIKE '%,%' THEN PARSENAME(REPLACE(location, ', ', '.'), 1)
		WHEN location NOT LIKE '%United States%' THEN location
		ELSE NULL
		END AS State,
	CASE WHEN location LIKE '%,%,%' THEN PARSENAME(REPLACE(location, ', ', '.'), 3)
		WHEN location LIKE '%,%' AND  PARSENAME(REPLACE(location, ', ', '.'), 1) LIKE '%United States%' THEN NULL
		WHEN location LIKE '%,%' THEN PARSENAME(REPLACE(location, ', ', '.'), 2)
		ELSE NULL
		END AS City
FROM job_postings$


SELECT State, COUNT(State)
FROM SplittedLocation
WHERE State LIKE '%area%'
GROUP BY State

SELECT * 
FROM SplittedLocation

SELECT * 
FROM SpecialLocations

SELECT * 
FROM StateInitials

SELECT SL.*, SI.*
FROM SplittedLocation AS SL
INNER JOIN StateInitials AS SI
ON SL.State = SI.State OR SL.State = SI.Initial

SELECT SL.location, SL.Country, SI.State, SI. Initial, SL.City
FROM SplittedLocation AS SL
INNER JOIN StateInitials AS SI
ON SL.State = SI.State OR SL.State = SI.Initial


SELECT * 
FROM SplittedLocation

SELECT * 
FROM SpecialLocations

SELECT Spl.*, Spe.*
FROM SplittedLocation AS Spl
LEFT JOIN SpecialLocations AS Spe
ON Spl.State = Spe.Header

CREATE VIEW SpecialLocationCorrected AS
SELECT Spl.job_id, Spl.Location, Spl.Country,
	CASE WHEN Spe.Header IS NULL THEN Spl.State
		ELSE Spe.State
		END AS State,
Spl.City
FROM SplittedLocation AS Spl
LEFT JOIN SpecialLocations AS Spe
ON Spl.State = Spe.Header

CREATE VIEW LocationComplete AS
SELECT LC.job_id, LC.location, LC.Country, SI.State, SI. Initial, LC.City
FROM SpecialLocationCorrected AS LC
INNER JOIN StateInitials AS SI
ON LC.State = SI.State OR LC.State = SI.Initial

SELECT *
FROM LocationComplete

SELECT JP.*, LC.State, LC.Initial, LC.City
FROM job_postings$ AS JP
LEFT JOIN LocationComplete AS LC
ON JP.job_id = LC.job_id

SELECT * FROM job_postings$