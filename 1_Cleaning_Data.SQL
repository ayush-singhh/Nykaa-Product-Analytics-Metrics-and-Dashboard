
SELECT TOP (20)*
FROM [2019-Oct]







-- Remove Irrelevent data                              (Knowing Business Objective will help you with this one)
-- Handling Missing Data[Null and Blanks]              (Removing Missing data, OR Replacing Data)
-- Remove Duplicate Data
-- Convert Types                                       (Str, Int, DATETIME, Timestamp)
-- Standerdize/Normalize Data                          (Unit Consistency, Scale Consistency)
-- Dealing with Outliers                               (Remove Outliers using Interquartile Rule, OR Understandin the reason)
-- Validate Data




-- # Removing Irrelevant data

-- As this Datset doesn't has many columns and most of the columns can be used in analysis, 
-- we are not removing any irrelevent column at this stage.


-- # Handling missing Data


-- 1. Identifying missing data



SELECT COUNT(*) As total_rows, 
        SUM(CASE WHEN user_id IS NULL or user_id = '' THEN 1 ELSE 0 END) AS missing_user_id,
        SUM(CASE WHEN user_session IS NULL or user_session = '' THEN 1 ELSE 0 END) AS missing_user_session,
        SUM(CASE WHEN event_time IS NULL or event_time = '' THEN 1 ELSE 0 END) AS missing_event_time,
        SUM(CASE WHEN event_type IS NULL or event_type = '' THEN 1 ELSE 0 END) AS missing_event_type,
        SUM(CASE WHEN user_id IS NULL or user_id = '' THEN 1 ELSE 0 END) AS missing_user_id,
        SUM(CASE WHEN product_id IS NULL or product_id = '' THEN 1 ELSE 0 END) AS missing_product_id,
        SUM(CASE WHEN category_id IS NULL or category_id = '' THEN 1 ELSE 0 END) AS missing_category_id,
        SUM(CASE WHEN category_code IS NULL or category_code = '' THEN 1 ELSE 0 END) AS missing_category_code, 
        SUM(CASE WHEN brand is NULL or brand = '' THEN 1 ELSE 0 END) AS missing_brand,
        SUM(CASE WHEN price IS NULL or price = '' THEN 1 ELSE 0 END) AS missing_price
FROM [2019-Oct]


-- Observation: There are missing values in user_seeion, category_code, and brand
-- Checking if there's any pattern to the missing data.  
-- There's no pattern to missing data and based on the context we can handle these dataset. 


-- 2. Handling Null and Missing Values

-- We removed category_code column as 90% of it is missing, and we replaced missing values of 'brand' column with Unknown.
-- We also turned datatype of price and event_time column as int and datetime bcz they were string.


SELECT user_id, 
        user_session, 
        CAST(REPLACE(event_time, ' UTC', '') AS datetime) AS event_time, 
        event_type,
        product_id,
        category_id,
        COALESCE(NULLIF(brand,''), 'Unknown') AS brand, 
        CAST(price AS float) AS price
FROM [2019-Oct]
WHERE user_session != ''






-- # Removing duplicates



WITH without_missing_data AS (
SELECT user_id, 
        user_session, 
        CAST(REPLACE(event_time, ' UTC', '') AS datetime) AS event_time, 
        event_type,
        product_id,
        category_id,
        COALESCE(NULLIF(brand,''), 'Unknown') AS brand, 
        CAST(price AS float) AS price
FROM [2019-Oct]
WHERE user_session != '' 
),  without_duplicates AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id, user_session, event_time, event_type, product_id, category_id, brand, price ORDER BY user_id ASC) AS rn
FROM without_missing_data
)
SELECT *
FROM without_duplicates
WHERE rn = 1

-- Removed over 2,00,000 duplicate records.





-- # Converting Types

-- In the previous step we have already converted the types.




-- # Standerdize/Normalize Data                          

-- There are no columns to be standardized 




-- # Dealing with outliers





-- There were 216984 rows of data where the product_id was not of 7 characters which is case for most of the rows.
-- but these rows have 4 or 5 character which could be okay based on context of the data. 


SELECT *
FROM (
    SELECT *, LEN(product_id) AS length_
FROM [2019-Oct]
) AS t1
WHERE length_ != 7 





WITH without_missing_data AS (
SELECT user_id, 
        user_session, 
        CAST(REPLACE(event_time, ' UTC', '') AS datetime) AS event_time, 
        event_type,
        product_id,
        category_id,
        COALESCE(NULLIF(brand,''), 'unknown') AS brand, 
        CAST(price AS float) AS price
FROM [2019-Oct]
WHERE user_session != '' 
),  without_duplicates AS (
SELECT *, 
        ROW_NUMBER() OVER(PARTITION BY user_id, user_session, event_time, event_type, product_id, category_id, brand, price ORDER BY user_id ASC) AS rn
FROM without_missing_data 
WHERE price > 0
)
SELECT user_id, 
        user_session, 
        event_time, 
        event_type,
        product_id, 
        category_id, 
        brand, 
        price 
FROM without_duplicates
WHERE rn = 1


































-----------Error Documentation --------



