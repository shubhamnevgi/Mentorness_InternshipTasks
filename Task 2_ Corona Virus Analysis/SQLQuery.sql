USE [CoronaDB]

SELECT *
FROM CoronaReport

--  Q1. Write a code to check NULL values
SELECT *
FROM CoronaReport
WHERE 
    Province IS NULL OR
    Country_Region IS NULL OR
    Latitude IS NULL OR
    Longitude IS NULL OR
    Date IS NULL OR
    Confirmed IS NULL OR
    Deaths IS NULL OR
    Recovered IS NULL;


-- Q2. If NULL values are present, update them with zeros for all columns. 
UPDATE CoronaReport
SET 
    Province = ISNULL(Province, 'Unknown'),
    Country_Region = ISNULL(Country_Region, 'Unknown'),
    Latitude = ISNULL(Latitude, 0),
    Longitude = ISNULL(Longitude, 0),
    Date = ISNULL(Date, '0000-00-00'),
    Confirmed = ISNULL(Confirmed, 0),
    Deaths = ISNULL(Deaths, 0),
    Recovered = ISNULL(Recovered, 0)
WHERE 
    Province IS NULL OR
    Country_Region IS NULL OR
    Latitude IS NULL OR
    Longitude IS NULL OR
    Date IS NULL OR
    Confirmed IS NULL OR
    Deaths IS NULL OR
    Recovered IS NULL;


-- Q3. check total number of rows
SELECT COUNT(*) AS Total_Rows
FROM CoronaReport;

-- Q4. Check what is start_date and end_date
SELECT 
    MIN(Date) AS Start_Date,
    MAX(Date) AS End_Date
FROM CoronaReport;


-- Q5. Number of month present in dataset
SELECT COUNT(DISTINCT FORMAT(Date, 'yyyy-MM')) AS Number_of_Months
FROM CoronaReport;


-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    FORMAT(Date, 'yyyy-MM') AS Month,
    AVG(CAST(Confirmed AS FLOAT)) AS Avg_Confirmed,
    AVG(CAST(Deaths AS FLOAT)) AS Avg_Deaths,
    AVG(CAST(Recovered AS FLOAT)) AS Avg_Recovered
FROM CoronaReport
GROUP BY FORMAT(Date, 'yyyy-MM');


-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
WITH RankedData AS (
    SELECT 
        FORMAT(Date, 'yyyy-MM') AS Month,
        Confirmed,
        Deaths,
        Recovered,
        ROW_NUMBER() OVER (PARTITION BY FORMAT(Date, 'yyyy-MM') ORDER BY COUNT(*) DESC) AS Rank
    FROM CoronaReport
    GROUP BY FORMAT(Date, 'yyyy-MM'), Confirmed, Deaths, Recovered
)
SELECT Month, Confirmed, Deaths, Recovered
FROM RankedData
WHERE Rank = 1;



-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
FORMAT(Date, 'yyyy') AS year,
        MIN(Confirmed) AS Minimum_Confirmed,
        MIN(Deaths) AS Minimum_Deaths,
        MIN(Recovered) AS Minimum_Recovered 
FROM CoronaReport
GROUP BY FORMAT(Date, 'yyyy');


-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
FORMAT(Date, 'yyyy') AS year,
        MAX(Confirmed) AS Maximum_Confirmed,
        MAX(Deaths) AS Maximum_Deaths,
        MAX(Recovered) AS Maximum_Recovered 
FROM CoronaReport
GROUP BY FORMAT(Date, 'yyyy');


-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
FORMAT(Date, 'yyyy-MM') AS Month,
        SUM(Confirmed) AS Total_Confirmed,
        SUM(Deaths) AS Total_Deaths,
        SUM(Recovered) AS Total_Recovered 
FROM CoronaReport
GROUP BY FORMAT(Date, 'yyyy-MM');


-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(Confirmed) AS Total_Confirmed,
    AVG(CAST(Confirmed AS FLOAT)) AS Avg_Confirmed,
    VAR(Confirmed) AS Var_Confirmed,
    STDEV(Confirmed) AS Stdev_Confirmed
FROM CoronaReport;


-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    FORMAT(Date, 'yyyy-MM') AS Month,
    SUM(Deaths) AS Total_Deaths,
    AVG(CAST(Confirmed AS FLOAT)) AS Avg_Deaths,
    VAR(Deaths) AS Var_Deaths,
    STDEV(Deaths) AS Stdev_Deaths
FROM CoronaReport
GROUP BY FORMAT(Date, 'yyyy-MM');

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    FORMAT(Date, 'yyyy-MM') AS Month,
    SUM(Recovered) AS Total_Recovered,
    AVG(CAST(Recovered AS FLOAT)) AS Avg_Recovered,
    VAR(Recovered) AS Var_Recovered,
    STDEV(Recovered) AS Stdev_Recovered
FROM CoronaReport
GROUP BY FORMAT(Date, 'yyyy-MM');

-- Q14. Find Country having highest number of the Confirmed case
SELECT TOP 1
    Country_Region,
    SUM(Confirmed) AS Total_Confirmed
FROM CoronaReport
GROUP BY Country_Region
ORDER BY Total_Confirmed DESC;


-- Q15. Find Country having lowest number of the death case
SELECT TOP 4
    Country_Region,
    SUM(Deaths) AS Lowest_Deaths
FROM CoronaReport
GROUP BY Country_Region
ORDER BY Lowest_Deaths;

-- Q16. Find top 5 countries having highest recovered case
SELECT TOP 5
    Country_Region,
    SUM(Recovered) AS Highest_Recovered
FROM CoronaReport
GROUP BY Country_Region
ORDER BY Highest_Recovered DESC;




