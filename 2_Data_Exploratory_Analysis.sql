WITH without_missing_data AS (
SELECT user_id, 
        user_session, 
        CAST(REPLACE(event_time, ' UTC', '') AS datetime) AS event_time, 
        event_type,
        product_id,
        category_id,
        COALESCE(NULLIF(brand,''), 'unknown') AS brand, 
        price
FROM merged_data_view
WHERE user_session != '' 
        AND user_session IS NOT NULL 
        AND price IS NOT NULL
        AND price > 0 
),  without_duplicates AS (
SELECT *, 
        ROW_NUMBER() OVER(PARTITION BY user_id, user_session, event_time, event_type, product_id, category_id, brand, price ORDER BY user_id ASC) AS rn
FROM without_missing_data 
)
SELECT user_id, 
        user_session, 
        event_time, 
        event_type,
        product_id, 
        category_id, 
        brand, 
        price
INTO Nykaa_cleaned_data
FROM without_duplicates
WHERE rn = 1




---------      Exploratory Analysis  ---------




-- 1. Understanding the Data Structure and Summary Statistics




SELECT TOP (10) * 
FROM Nykaa_cleaned_data

-- Total Columns 7 - user_id, user_session, event_time, event_type, product_id, category_id, brand, price



SELECT COUNT(*)
FROM Nykaa_cleaned_data

-- Total rows 19,493,208




SELECT 
	Count(Distinct user_id) AS total_unique_users, 
	Count(Distinct user_session) AS total_user_sessions,
	Count(Distinct event_type) AS unique_event_types,
	COUNT(Distinct product_id) AS total_unique_product_id, 
	COUNT(Distinct brand) AS total_unique_brands
FROM Nykaa_cleaned_data

-- Users - 1,637,770
-- User session (could also be said as visit) - 4,520,615
-- Event types - 4 view, cart, removed_from_cart,
-- Unique products - 53,903 
-- brands - 274



SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Nykaa_clean_data'


-- Data types of the columns 







-- 2. Data Distribution


-- user_id, 
-- user_session, 
-- event_time, 
-- event_type,
-- product_id, 
-- category_id, 
-- brand, 
-- price



SELECT event_type, count(event_type) AS even_count
FROM Nykaa_cleaned_data
GROUP BY event_type 
ORDER BY even_count DESC


-- event_type	even_count
-- view	9626268
-- cart	5612289
-- remove_from_cart	2968669
-- purchase	1285982



SELECT TOP(20) product_id, count(product_id) AS product_id_count
FROM Nykaa_cleaned_data
GROUP BY product_id
ORDER BY product_id_count DESC



-- Top 20 Products with most interactions

-- product_id	product_id_count
-- 5809910	138674
-- 5809912	53468
-- 5700037	46460
-- 5751383	41664
-- 5751422	41591
-- 5854897	41127
-- 5802432	40708
-- 5815662	38843
-- 5849033	36276
-- 5809911	34649
-- 5816170	30879
-- 5877454	29925
-- 5792800	29769
-- 5686925	25245
-- 5649236	24659
-- 5528035	23824
-- 5877456	23662
-- 5856186	23489
-- 5790563	23426
-- 5304	22360



SELECT TOP(10) category_id, count(category_id) AS category_id_count
FROM Nykaa_cleaned_data
GROUP BY category_id
ORDER BY category_id_count DESC


-- Top 10 Categories with most interactions

-- category_id	        category_id_count
-- 1487580007675986893	981268
-- 1487580005092295511	732718
-- 1487580005595612013	730291
-- 1487580005671109489	624573
-- 1602943681873052386	609797
-- 1487580006317032337	602673
-- 1487580005268456287	426339
-- 1487580013841613016	386283
-- 1487580005134238553	363027
-- 1487580008246412266	361604



SELECT TOP(11) brand, count(brand) AS brand_count
FROM Nykaa_cleaned_data
GROUP BY brand
ORDER BY brand_count DESC


-- Top 10 Brands with most interactions

-- brand	brand_count
-- unknown	8177241
-- runail	1433785
-- irisk	970331
-- grattol	811021
-- masura	801529
-- bpw.style	409838
-- ingarden	402726
-- estel	348312
-- kapous	314395
-- jessnail	245304
-- uno     	239727





SELECT DATEPART(HOUR, event_time) AS even_time_hour, COUNT(*) AS hour_count
FROM Nykaa_cleaned_data
GROUP BY DATEPART(HOUR, event_time)
ORDER BY hour_count DESC


SELECT (DATEPART(HOUR, event_time) + 3 ) AS even_time_hour, COUNT(*) AS hour_count
FROM Nykaa_cleaned_data
GROUP BY DATEPART(HOUR, event_time)
ORDER BY hour_count DESC


-- Most active hours
-- 10 PM
-- 9 PM
-- 3 PM
-- 2 PM
-- 11 pm

-- even_time_hour	hour_count
-- 22	1283359
-- 21	1222149
-- 15	1176429
-- 14	1163387
-- 23	1155555
-- 13	1126607
-- 16	1114279
-- 20	1113454
-- 12	1064740
-- 17	1043765
-- 19	1036661
-- 11	1009587
-- 18	1002386
-- 10	914965
-- 24	794030
-- 9	767438
-- 8	567014
-- 25	475878
-- 7	372543
-- 26	275317
-- 6	260921
-- 3	190694
-- 5	189159
-- 4	172891








WITH cte1 AS (
SELECT 
	*, 
	MIN(event_time) OVER(Partition BY user_session) AS session_start_time, 
	MAX(event_time) OVER(Partition BY user_session) AS session_end_time
FROM Nykaa_cleaned_data
), cte2 AS (
SELECT 
	DISTINCT user_session,
	DATEDIFF(SECOND, session_start_time, session_end_time) AS session_duration
FROM cte1
-- ORDER BY session_duration -- DESC 
)
SELECT *
FROM cte2
WHERE session_duration > 0
ORDER BY session_duration ASC




-- where session duration is 0 - 2,897,451
-- where session duration is not 0 - 1,622,833


-- Users - 1,637,770
-- User session - 4,520,615




-- Distribution of session_duration where time is 0, 1 SECOND



WITH cte1 AS (
SELECT 
	user_session, 
	MIN(event_time) AS min_etime, 
	MAX(event_time) AS max_etime
FROM Nykaa_cleaned_data
GROUP BY user_id, user_session
)
SELECT 
	COUNT(*)
FROM cte1
 




-- user_session	                        min_etime	            max_etime	            session_duration
-- ae74cec4-ae31-4470-8484-84c3a75365d3	2019-10-01 05:48:54.000	2020-02-29 20:34:50.000	218326
-- beac319a-88e8-43db-98e9-d6cd6184f444	2019-10-01 05:59:35.000	2020-02-29 17:10:24.000	218111
-- 099fefe4-a74c-4dae-b9c2-fe15dea34ff1	2019-10-01 06:52:13.000	2020-02-29 17:31:51.000	218079
-- 5b9bcf07-5c80-4f98-84dd-cad0883e0477	2019-10-01 06:34:49.000	2020-02-29 16:15:36.000	218021
-- 285e8547-29b3-49d2-b503-5ca9a60413cc	2019-10-01 11:05:27.000	2020-02-29 16:53:06.000	217788
-- c5643d68-0641-4f40-9f1e-7019a49ec320	2019-10-01 08:23:20.000	2020-02-29 13:47:24.000	217764
-- 2d6fa5e7-e91c-4880-ba64-be3e3c8d3a55	2019-10-01 08:07:55.000	2020-02-29 11:18:37.000	217631
-- 52b30a79-923b-4612-b265-e2adc340a8e6	2019-10-01 09:07:13.000	2020-02-29 11:06:45.000	217559
-- 53e8dd6f-0a8a-408f-823b-cec4edfe89c7	2019-10-01 06:40:33.000	2020-02-29 08:23:50.000	217543
-- 91540b56-76ce-400f-8cf0-4b97ccff6729	2019-10-01 20:56:25.000	2020-02-29 22:07:52.000	217511


-- user session distribution








-- price distriubtion (Histogram)







SELECT price, 
	MAX(price) max_price,
	MIN(price) min_price, 
	AVG(price) avg_price
FROM Nykaa_cleaned_data
GROUP BY price



-- SELECT
-- 	CASE WHEN price < 10 THEN 'Under 10$'
-- 	CASE WHEN price between 10 and 20 THEN '10$ - 20$'
-- 	CASE WHEN price between 21 and 30 THEN '10$ - 20$'
-- 	CASE WHEN price between 30 and 40 THEN '10$ - 20$'
-- 	CASE WHEN price between 40 and 50 THEN '10$ - 20$'
-- 	CASE WHEN price between 10 and 20 THEN '10$ - 20$'
-- 	CASE WHEN price between 10 and 20 THEN '10$ - 20$'
-- 	CASE WHEN price between 10 and 20 THEN '10$ - 20$'
-- 	CASE WHEN price between 10 and 20 THEN '10$ - 20$'
-- FROM nykaa_clean_data


