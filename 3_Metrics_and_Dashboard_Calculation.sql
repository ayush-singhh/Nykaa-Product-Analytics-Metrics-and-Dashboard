



-- 1. Active User


    --WAU

    WITH active_users AS (
    SELECT 
        CAST(event_time as date) as event_date, 
        user_id
    FROM Nykaa_cleaned_data
    WHERE event_type IN  ('purchase', 'cart', 'view')
    GROUP By CAST(event_time as date), user_id
    -- Criteria for actice user: user who has done purchase or added to cart or viewed product.
    ),
    wau_data AS (
    SELECT 
        a1.event_date as event_date,
        COUNT(DISTINCT a1.user_id) as wau
    FROM active_users a1 
    LEFT JOIN active_users a2 
        ON a1.event_date BETWEEN DATEADD(DAY, -6, a2.event_date) AND a2.event_date  
    GROUP BY a1.event_date
    ) 
    SELECT event_date, wau
    FROM wau_data
    -- ORDER By event_date ASC


    -- Execution time - Couldn't coomplete the exceution as it was taking too long to execute.




    WITH date_spine AS (
        -- Create a continuous date range to ensure no gaps in reporting
        SELECT DISTINCT event_date
        FROM Nykaa_cleaned_data
        WHERE event_date >= DATEADD(DAY, -6, (SELECT MIN(event_date) FROM Nykaa_cleaned_data))
    ),
    active_users AS (
        -- Identify active users with deduplication at source
        SELECT 
            event_date,
            user_id
        FROM Nykaa_cleaned_data
        WHERE event_type IN ('purchase', 'cart', 'view')
        GROUP BY event_date, user_id  -- Deduplication
    ),
    weekly_windows AS (
        -- Pre-calculate 7-day windows for each date
        SELECT 
            d.event_date,
            a.event_date as activity_date,
            a.user_id
        FROM date_spine d
        LEFT JOIN active_users a
            ON a.event_date BETWEEN DATEADD(DAY, -6, d.event_date) AND d.event_date
    )
    SELECT 
        event_date,
        COUNT(DISTINCT user_id) as wau
    FROM weekly_windows
    GROUP BY event_date
    ORDER BY event_date;


    -- Execution time - 9 min 






-- Extra Analysis to Aid in the Understadning of the main KPI Element

    --  Session per user per day

    with session_data AS (
    Select 
        event_date, 
        user_id,
        Count (Distinct user_session) as session_count
    From Nykaa_cleaned_data
    Group by event_date, user_id
    --Order by session_count DESC
    )
    SELECT 
        event_date,
        avg(session_count)
    FROM session_data
    GROUP BY event_date
    Order by event_date ASC



    -- Average session duration time series trend


    WITH session_data AS (
        SELECT 
            user_session,
            --CAST(event_time as date) as event_date,
            min(event_time) as session_start_time,
            max(event_time) as session_end_time
        FROM Nykaa_cleaned_data
        GROUP BY user_session--, CAST(event_time as date)
    )
    SELECT
        event_date,
        AVG(DATEDIFF(SECOND, session_start_time, session_end_time)) as avg_session_duration
    FROM session_data
    GROUP BY event_date
    GO



-- 2. Session time distribution (24-hour heat map)



    WITH cte AS (
    SELECT 
            user_session,
            DATEPART(Hour, MIN(event_time)) as time_of_the_day, 
            DATEPART(WEEKDAY, MIN(event_time)) as day_of_the_week  
    FROM Nykaa_cleaned_data
    GROUP BY user_session
    ) 
    SELECT * 
    FROM cte
    PIVOT(

        COUNT(user_session)
        FOR time_of_the_day
        IN (
                [0],[1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13],
                [14], [15], [16], [17], [18], [19], [20], [21], [22], [23]
            )
        ) as pivot_table
        Order BY day_of_the_week ASC




-- 3. Session Suration distribution 





-- User journey flow (simplified version)



SELECT *
FROM Nykaa_cleaned_data

o




