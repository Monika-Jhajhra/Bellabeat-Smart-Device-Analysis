--Overview of the data
SELECT top 10 * FROM dbo.Daily_Activity
SELECT top 10 * FROM dbo.Hourly_Intensities
SELECT top 10 * FROM dbo.Hourly_Steps
SELECT top 10 * FROM dbo.Hourly_Calories
SELECT top 10 * FROM dbo.Minute_Sleep
SELECT top 10 * FROM dbo.Sleep_Day



--Overview the data types of columns
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Daily_Activity'
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Hourly_Intensities'
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Hourly_Steps'
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Hourly_Calories'
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Minute_Sleep'
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Sleep_Day'

--Change the data type of all the columns in table Daily_Activity except column Id to the appropriate data type
ALTER TABLE dbo.Daily_Activity ALTER COLUMN ActivityDate DATE
ALTER TABLE dbo.Daily_Activity ALTER COLUMN TotalSteps INT
ALTER TABLE dbo.Daily_Activity ALTER COLUMN TotalDistance FLOAT
ALTER TABLE dbo.Daily_Activity ALTER COLUMN TrackerDistance FLOAT
ALTER TABLE dbo.Daily_Activity ALTER COLUMN LoggedActivitiesDistance FLOAT
ALTER TABLE dbo.Daily_Activity ALTER COLUMN VeryActiveDistance FLOAT
ALTER TABLE dbo.Daily_Activity ALTER COLUMN ModeratelyActiveDistance FLOAT
ALTER TABLE dbo.Daily_Activity ALTER COLUMN LightActiveDistance FLOAT
ALTER TABLE dbo.Daily_Activity ALTER COLUMN SedentaryActiveDistance FLOAT
ALTER TABLE dbo.Daily_Activity ALTER COLUMN VeryActiveMinutes INT
ALTER TABLE dbo.Daily_Activity ALTER COLUMN FairlyActiveMinutes INT
ALTER TABLE dbo.Daily_Activity ALTER COLUMN LightlyActiveMinutes INT
ALTER TABLE dbo.Daily_Activity ALTER COLUMN SedentaryMinutes INT
ALTER TABLE dbo.Daily_Activity ALTER COLUMN Calories INT

--Are all the above alter statements successful?
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Daily_Activity'

--Change the data type of all the columns in table Hourly_Intensities except column Id to the appropriate data type
ALTER TABLE dbo.Hourly_Intensities ALTER COLUMN ActivityHour DATETIME
ALTER TABLE dbo.Hourly_Intensities ALTER COLUMN TotalIntensity INT
ALTER TABLE dbo.Hourly_Intensities ALTER COLUMN AverageIntensity FLOAT

--Are all the above alter statements successful?
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Hourly_Intensities'

--Change the data type of all the columns in table Hourly_Steps except column Id to the appropriate data type
ALTER TABLE dbo.Hourly_Steps ALTER COLUMN ActivityHour DATETIME
ALTER TABLE dbo.Hourly_Steps ALTER COLUMN StepTotal INT

--Are all the above alter statements successful?
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Hourly_Steps'

--Change the data type of all the columns in table Hourly_Calories except column Id to the appropriate data type
ALTER TABLE dbo.Hourly_Calories ALTER COLUMN ActivityHour DATETIME
ALTER TABLE dbo.Hourly_Calories ALTER COLUMN Calories INT

--Are all the above alter statements successful?
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Hourly_Calories'

--Change the data type of all the columns in table Minute_Sleep except column Id to the appropriate data type
ALTER TABLE dbo.Minute_Sleep ALTER COLUMN date DATETIME
ALTER TABLE dbo.Minute_Sleep ALTER COLUMN value INT

--Are all the above alter statements successful?
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Minute_Sleep'

--Change the data type of all the columns in table Sleep_Day except column Id to the appropriate data type
ALTER TABLE dbo.Sleep_Day ALTER COLUMN SleepDay DATETIME
ALTER TABLE dbo.Sleep_Day ALTER COLUMN TotalSleepRecords INT
ALTER TABLE dbo.Sleep_Day ALTER COLUMN TotalMinutesAsleep INT
ALTER TABLE dbo.Sleep_Day ALTER COLUMN TotalTimeInBed INT

--Are all the above alter statements successful?
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Sleep_Day'

--Check for duplicate rows in all the tables depending on Id and date column
SELECT Id, ActivityDate, COUNT(*) as duplicates FROM dbo.Daily_Activity GROUP BY Id, ActivityDate HAVING COUNT(*) > 1

SELECT Id, ActivityHour, COUNT(*) as duplicates FROM dbo.Hourly_Intensities GROUP BY Id, ActivityHour HAVING COUNT(*) > 1

SELECT Id, ActivityHour, COUNT(*) as duplicates FROM dbo.Hourly_Steps GROUP BY Id, ActivityHour HAVING COUNT(*) > 1

SELECT Id, ActivityHour, COUNT(*) as duplicates FROM dbo.Hourly_Calories GROUP BY Id, ActivityHour HAVING COUNT(*) > 1

SELECT Id, date, COUNT(*) as duplicates FROM dbo.Minute_Sleep GROUP BY Id, date HAVING COUNT(*) > 1

--See all the duplicate rows in the table Minute_Sleep using row_number() function where rn >1
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY Id, date ORDER BY Id) AS rn
    FROM dbo.Minute_Sleep
) AS t
WHERE rn > 1

--Delete all the duplicate rows from the table Minute_Sleep using row_number() function
WITH cte AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY Id, date ORDER BY Id) AS rn
    FROM dbo.Minute_Sleep
)
DELETE FROM cte WHERE rn > 1


SELECT Id, SleepDay, COUNT(*) as duplicates FROM dbo.Sleep_Day GROUP BY Id, SleepDay HAVING COUNT(*) > 1
  

--Delete all the duplicate rows in the table Sleep_Day using row_number() function 
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY Id, SleepDay ORDER BY Id) AS rn
    FROM dbo.Sleep_Day
) AS t
WHERE rn > 1


--Delete all the duplicate rows from the table Sleep_Day using row_number() function
WITH cte AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY Id, SleepDay ORDER BY Id) AS rn
    FROM dbo.Sleep_Day
)
DELETE FROM cte WHERE rn > 1

-- Check for null values in primary key columns in all the tables
SELECT * FROM dbo.Daily_Activity WHERE Id IS NULL
SELECT * FROM dbo.Hourly_Intensities WHERE Id IS NULL
SELECT * FROM dbo.Hourly_Steps WHERE Id IS NULL
SELECT * FROM dbo.Hourly_Calories WHERE Id IS NULL
SELECT * FROM dbo.Minute_Sleep WHERE Id IS NULL
SELECT * FROM dbo.Sleep_Day WHERE Id IS NULL


-- Check for null values in foreign key columns in all the tables
SELECT * FROM dbo.Minute_Sleep WHERE logId IS NULL

-- Calculate the total number of days for which the activity was recorded in the table Daily_Activity
SELECT COUNT(DISTINCT ActivityDate) AS TotalDays FROM dbo.Daily_Activity

-- Join the hourly calories , hourly steps and hourly intensities table to get the Id, total calories burnt, total steps taken and total intensity for each activity hour
SELECT hc.Id, hc.ActivityHour, hc.Calories, hs.StepTotal, hi.TotalIntensity
FROM dbo.Hourly_Calories hc
JOIN dbo.Hourly_Steps hs ON hc.Id = hs.Id AND hc.ActivityHour = hs.ActivityHour
JOIN dbo.Hourly_Intensities hi ON hc.Id = hi.Id AND hc.ActivityHour = hi.ActivityHour

-- Make a new table for the above join query
SELECT hc.Id, hc.ActivityHour, hc.Calories, hs.StepTotal, hi.TotalIntensity
INTO dbo.Hourly_Activity
FROM dbo.Hourly_Calories hc
JOIN dbo.Hourly_Steps hs ON hc.Id = hs.Id AND hc.ActivityHour = hs.ActivityHour
JOIN dbo.Hourly_Intensities hi ON hc.Id = hi.Id AND hc.ActivityHour = hi.ActivityHour

-- Check the new table
SELECT TOP 10 * FROM dbo.Hourly_Activity

SELECT TOP 10 * FROM dbo.Minute_Sleep
SELECT TOP 10 * FROM dbo.Sleep_Day


--Data Analysis

-----------------------------------------------------------
--Physical Activity Analysis--
-----------------------------------------------------------
--1. Calculate the average number of steps taken by the users each day and classify users as Sedenatry, Lightly Active and Highly Active based on the average steps taken by them each day
-- run the query using cte
WITH Average_Steps as (
    SELECT Id, AVG(TotalSteps) as AverageTotalSteps
    FROM dbo.Daily_Activity
    GROUP BY Id
)
SELECT Id, AverageTotalSteps,
CASE 
        WHEN AverageTotalSteps < 5000  THEN 'Sedentary'
        WHEN AverageTotalSteps >= 5000 AND AverageTotalSteps < 10000 THEN 'Lightly Active'
        ELSE 'Highly Active'
    END AS Activity_Level
FROM Average_Steps


 -- Count users by activity level
WITH Average_Steps AS
(
    SELECT Id, AVG(TotalSteps) as AverageTotalSteps
    FROM dbo.Daily_Activity
    GROUP BY Id
)
,Activity_Level AS
(
SELECT Id, AverageTotalSteps,
CASE 
        WHEN AverageTotalSteps < 5000  THEN 'Sedentary'
        WHEN AverageTotalSteps >= 5000 AND AverageTotalSteps < 10000 THEN 'Lightly Active'
        ELSE 'Highly Active'
    END AS ActivityLevel
FROM Average_Steps
)

SELECT ActivityLevel, COUNT(DISTINCT Id) AS User_Count
FROM Activity_Level
GROUP BY ActivityLevel



-- 2. Calculate the average time spent in different activity levels for each day and classify users as Lightly active, very active, fairly active and sedentary based on the average time spent in different activity levels 
-- make a new table for the above query with the columns ActivityDate, Activity level, minutes
SELECT ActivityDate, Activity_Level, AVG(Minutes) AS AverageMinutes
INTO dbo.Daily_Activity_ActivityLevel
FROM (
    SELECT ActivityDate, 'Sedentary' AS Activity_Level, AVG(SedentaryMinutes) AS Minutes
    FROM dbo.Daily_Activity
    GROUP BY ActivityDate
    UNION ALL
    SELECT ActivityDate, 'Lightly Active' AS Activity_Level, AVG(LightlyActiveMinutes) AS Minutes
    FROM dbo.Daily_Activity
    GROUP BY ActivityDate
    UNION ALL
    SELECT ActivityDate, 'Fairly Active' AS Activity_Level, AVG(FairlyActiveMinutes) AS Minutes
    FROM dbo.Daily_Activity
    GROUP BY ActivityDate
    UNION ALL
    SELECT ActivityDate, 'Very Active' AS Activity_Level, AVG(VeryActiveMinutes) AS Minutes
    FROM dbo.Daily_Activity
    GROUP BY ActivityDate
) AS t
GROUP BY ActivityDate, Activity_Level

-- Check the new table
SELECT * FROM dbo.Daily_Activity_ActivityLevel


--3. Identify the most active day of the week based on the average steps taken
-- Make a new column in the table Daily_Activity to classify the day of the week
ALTER TABLE dbo.Daily_Activity ADD Day_of_Week VARCHAR(20)

UPDATE dbo.Daily_Activity
SET Day_of_Week = 
    CASE 
        WHEN DATEPART(WEEKDAY, ActivityDate) = 1 THEN 'Sunday'
        WHEN DATEPART(WEEKDAY, ActivityDate) = 2 THEN 'Monday'
        WHEN DATEPART(WEEKDAY, ActivityDate) = 3 THEN 'Tuesday'
        WHEN DATEPART(WEEKDAY, ActivityDate) = 4 THEN 'Wednesday'
        WHEN DATEPART(WEEKDAY, ActivityDate) = 5 THEN 'Thursday'
        WHEN DATEPART(WEEKDAY, ActivityDate) = 6 THEN 'Friday'
        ELSE 'Saturday'
    END

-- Check the updated table
SELECT TOP 10 * FROM dbo.Daily_Activity

-- Identify the most active day of the week based on the Average steps taken
SELECT ActivityDate,Day_of_Week, AVG(TotalSteps) AS AverageSteps
FROM dbo.Daily_Activity
GROUP BY ActivityDate, Day_of_Week
ORDER BY ActivityDate

--4. Identify peak activity hours 

-- Make a new column in the table Hourly_Activity to classify the hour as Morning, Afternoon, Evening and Night
ALTER TABLE dbo.Hourly_Activity ADD Times_of_Day VARCHAR(20)

UPDATE dbo.Hourly_Activity
SET Times_of_Day = 
    CASE 
        WHEN DATEPART(HOUR, ActivityHour) >= 5 AND DATEPART(HOUR, ActivityHour) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, ActivityHour) >= 12 AND DATEPART(HOUR, ActivityHour) < 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, ActivityHour) >= 17 AND DATEPART(HOUR, ActivityHour) < 21 THEN 'Evening'
        ELSE 'Night'
    END

-- Check the updated table
SELECT TOP 10 * FROM dbo.Hourly_Activity

-- Identify the peak activity hours based on the average intensity and group them by the times of the day
SELECT Times_of_Day, AVG(TotalIntensity) AS AverageIntensity,AVG(Calories) AS AverageCalories
FROM dbo.Hourly_Activity
GROUP BY Times_of_Day
ORDER BY AverageIntensity DESC


--5. Calculate the correlation between average intensity and calories burned for each user
SELECT Id, AVG(TotalIntensity) AS AverageIntensity, AVG(Calories) AS AverageCalories
FROM dbo.Hourly_Activity
GROUP BY Id

-----------------------------------------------------
--Sleep & Recovery Analysis--
-----------------------------------------------------
-- 1. Find Average Sleep Duration and convert into hours and minutes
-- Calculate the average sleep duration in minutes and hours
SELECT Id, AVG(TotalMinutesAsleep) AS AverageSleepDuration_Minutes,
       AVG(TotalMinutesAsleep) / 60 AS AverageSleepDuration_Hours,
       AVG(TotalMinutesAsleep) % 60 AS AverageSleepDuration_Minutes
FROM dbo.Sleep_Day
GROUP BY Id
ORDER BY Id

--2. Identify users with sleep deprivation (less than 6 hours of sleep)
SELECT Id, AVG(TotalMinutesAsleep) as AverageSleepDuration
FROM dbo.Sleep_Day
GROUP BY Id
HAVING AVG(TotalMinutesAsleep) < 360


--3. Identify users who are stressed based on the average time in bed and average time asleep
SELECT Id, AVG(TotalTimeInBed) AS AverageTimeInBed, AVG(TotalMinutesAsleep) AS AverageMinutesAsleep
FROM dbo.Sleep_Day
GROUP BY Id
HAVING AVG(TotalTimeInBed) - AVG(TotalMinutesAsleep) > 60


-- unique sleep value
SELECT DISTINCT value
FROM dbo.Minute_Sleep


--4. Give me the Average minutes per day in each sleep state for each user
WITH DailySleep AS (
    SELECT 
        Id,
        CAST(date AS DATE) AS sleep_date,  -- Extract date only
        value AS sleep_state,  -- Sleep state (1, 2, or 3)
        COUNT(*) AS total_minutes  -- Count occurrences (assuming each row = 1 min)
    FROM minute_sleep
    GROUP BY Id, CAST(date AS DATE), value
)
SELECT 
    Id, 
    CASE 
        WHEN sleep_state = 1 THEN 'Asleep'
        WHEN sleep_state = 2 THEN 'Restless'
        WHEN sleep_state = 3 THEN 'Awake'
        ELSE 'Unknown'
    END AS sleep_stage,
    AVG(total_minutes) AS avg_daily_minutes
FROM DailySleep
GROUP BY Id, sleep_state
ORDER BY Id;


































