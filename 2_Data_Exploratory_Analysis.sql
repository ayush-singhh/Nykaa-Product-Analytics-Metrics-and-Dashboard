

-- ###########################  -------      Exploratory Analysis  -------    ##########################


SELECT TOP(10 ) * 
  FROM [2019-Oct]


-- Total 450 MB size Dataset, Takes 2 min to execute
-- Top 1000 rows, Takes 2 sec to execute
-- Order By took 8 seconds


SELECT * 
FROM [2019-Oct]

SELECT Count(Distinct user_id)
FROM [2019-Oct]

SELECT  Count(Distinct user_session)
FROM [2019-Oct]



WITH cte1 AS (
SELECT user_session, COUNT(*) AS event_count_per_session	
FROM [2019-Oct]
GROUP BY user_session
)
SELECT event_count_per_session, COUNT(event_count_per_session) AS numeber_of_event_count
FROM cte1
GROUP BY event_count_per_session
ORDER BY event_count_per_session ASC



-- Total rows of Data 41,02,283
-- number of distinct users 3,99,664
-- number of distinct user_sessions 8,73,961
-- number of events per session, histogram 



WITH user_session_times AS (
	SELECT TOP(15) user_id, user_session, event_time, event_type, product_id,
		MIN(event_time) OVER (Partition by user_session) AS start_time, 
		MAX(event_time) OVER (Partition by user_session) AS end_time
	FROM [2019-Oct]  
)
SELECT * , DATEDIFF(MINUTE,start_time, end_time ) As timecal
FROM user_session_times



SELECT TOP(1000) *
FROM [2019-Oct]





-- Category Types and Total Category count

SELECT DISTINCT category_code
FROM [2019-Oct]

SELECT COUNT(DISTINCT category_code) 
FROM [2019-Oct]