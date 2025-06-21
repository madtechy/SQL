use ravet3pm;
-- Importing large data more than lakhs of rows

-- 1. Create the table athletes
create table athletes(
	Id int,
    Name varchar(200),
    Sex char(1),
    Age int,
    Height float,
    Weight float,
    Team varchar(200),
    NOC char(3),
    Games varchar(200),
    Year int,
    Season varchar(200),
    City varchar(200),
    Sport varchar(200),
    Event varchar(200),
    Medal Varchar(50));

-- View the blank Athletes table
select * from athletes;

-- Location to add the csv
SHOW VARIABLES LIKE "secure_file_priv";

-- Load the data from csv file after saving to above location
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Athletes_Cleaned.csv'
into table athletes
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- View the table
select * from athletes;

-- Check number of rows in the table
select count(*) from athletes;

-- 1. Showing medals count for entire data
SELECT 
    COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS Gold_Medals,
    COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS Silver_Medals,
    COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS Bronze_Medals,
    COUNT(Medal) AS Total_Medals
FROM athletes;

-- 2. count of unique Sports presents in olympics
SELECT COUNT(DISTINCT Sport) AS Unique_Sports_Count
FROM athletes;

-- 3. different medals won by Team India
SELECT 
    COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS Gold_Medals,
    COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS Silver_Medals,
    COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS Bronze_Medals,
    COUNT(Medal) AS Total_Medals
FROM athletes
WHERE Team = 'India';

-- 4. event wise medals won by india show from highest to lowest medals won in order
SELECT 
    Event,
    COUNT(Medal) AS Medal_Count
FROM athletes
WHERE Team = 'India'
GROUP BY Event
ORDER BY Medal_Count DESC;

-- 5. event and yearwise medals won by india in order of year
SELECT 
    Year,
    Event,
    COUNT(Medal) AS Medal_Count
FROM athletes
WHERE Team = 'India'
GROUP BY Year, Event
ORDER BY Year, Medal_Count DESC;

-- 6. the country with maximum medals won gold, silver, bronze
SELECT 
    Team,
    COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS Gold_Medals,
    COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS Silver_Medals,
    COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS Bronze_Medals,
    COUNT(Medal) AS Total_Medals
FROM athletes
GROUP BY Team
ORDER BY Total_Medals DESC
LIMIT 1;

-- 7. the top 10 countries with respect to gold medal
SELECT
      Team, COUNT(*) as Gold_Medals
FROM athletes
WHERE Medal = 'Gold'
GROUP BY Team
ORDER BY Gold_Medals DESC
LIMIT 10;

-- 8. year which United States won most of the medals
SELECT 
     Year, COUNT(*) as Total_Medals
FROM athletes
WHERE Team = 'United States'
GROUP BY Year
ORDER BY Total_Medals DESC
LIMIT 1;

-- 9. United States medals in different sports
SELECT
     Sport, COUNT(*) as Total_Medals
FROM athletes
WHERE Team = 'United States'
GROUP BY Sport
ORDER BY Total_Medals DESC
LIMIT 1;

-- 10. top 3 players who have won most medals along with their sports and country
SELECT 
    Name,
    Sport,
    Team,
    COUNT(Medal) AS total_medals
FROM 
    athletes
WHERE 
    Medal IS NOT NULL
GROUP BY 
    Name, Sport, Team
ORDER BY 
    total_medals DESC
LIMIT 3;

-- 11. player with most gold medals in cycling along with his country
SELECT 
    Name,
    Team,
    COUNT(Medal) AS gold_medals
FROM 
    athletes
WHERE 
    Sport = 'Cycling' 
    AND Medal = 'Gold'
GROUP BY 
    Name, Team
ORDER BY 
    gold_medals DESC
LIMIT 1;

-- 12. player with most medals (Gold + Silver + Bronze) in Basketball along with country
SELECT 
    Name,
    Team,
    COUNT(Medal) AS total_medals
FROM 
    athletes
WHERE 
    Sport = 'Basketball'
    AND Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY 
    Name, Team
ORDER BY 
    total_medals DESC
LIMIT 1;

-- 13. the count of different medals of the top basketball player
WITH TopPlayer AS (
    SELECT Name, Team
    FROM athletes
    WHERE Sport = 'Basketball' AND Medal IS NOT NULL
    GROUP BY Name, Team
    ORDER BY COUNT(Medal) DESC
    LIMIT 1
)
SELECT 
    Medal,
    COUNT(*) AS medal_count
FROM 
    athletes
JOIN 
    TopPlayer ON athletes.Name = TopPlayer.Name AND athletes.Team = TopPlayer.Team
WHERE 
    Sport = 'Basketball' AND Medal IS NOT NULL
GROUP BY 
    Medal;
    
-- 14. medals won by male, female each year.
SELECT 
    Year,
    Sex,
    COUNT(Medal) AS medal_count
FROM 
    athletes
WHERE 
    Medal IS NOT NULL
GROUP BY 
    Year, Sex
ORDER BY 
    Year, Sex;



