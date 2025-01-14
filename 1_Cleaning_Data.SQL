----------- Error Documentation --------



-- 1. Merging Datasets
-- Combined data from multiple months into a single view (merged_data_view) for easier analysis.
-- 2. Removing Unnecessary Data
-- Column Removed: category_code
-- Reason: This column had too many missing values to be useful for analysis.
-- 3. Data Type Conversion
-- Converted event_time from string to DATETIME format for accurate time-based analysis.


-- 4. Handling Missing Data
-- Identified Missing Data: Found missing values in user_session, brand, and price.
-- Action Taken:
-- Filled missing brand values with 'unknown'.
-- Removed rows where user_session was missing.
-- Removed rows with missing or non-positive (<= 0) price values.
-- 5. Removing Duplicates
-- Found and removed over 200,000 duplicate rows using a row numbering technique, keeping only the first occurrence.
-- 6. Checking for Structural Errors
-- No issues like typos or extra spaces in brand and event_type.
-- 7. Standardization/Normalization
-- No further standardization needed based on data requirements.
-- 8. Handling Outliers
-- product_id: Rows with shorter product_id values (less than 7 characters) were retained, assuming these could still be valid.
-- price: Removed rows with negative prices as they don't make sense for analysis.
-- Final Cleaned Data View
-- Created a final cleaned data view (cleaned_data_view) with all adjustments applied, ready for further analysis.



-- Merging Data from multiple sources


CREATE VIEW merged_data_view AS
WITH cte1 AS (
        SELECT * FROM [2019-Oct]
        UNION ALL
        SELECT * FROM [2019-Nov]
        UNION ALL
        SELECT * FROM [2019-Dec]
        UNION ALL
        SELECT * FROM [2020-Jan]
        UNION ALL
        SELECT * FROM [2020-Feb]
)
SELECT * FROM cte1;
GO



-- # Removing Irrelevant data

-- This Datset doesn't has many columns and most of the columns can be used in analysis.
-- However, category_code has most of the rows empty which will not come usefull in the analysis so we are removing this column.


-- # Converting Types

-- Turned the datatype of event_time column from string to DATETIME.


(
SELECT user_id, 
        user_session, 
        CAST(REPLACE(event_time, ' UTC', '') AS datetime) AS event_time, 
        event_type,
        product_id,
        category_id,
        brand, 
        price
FROM merged_data_view
)



-- # Handling missing Data


-- 1. Identifying missing data

WITH cte2 AS (
SELECT 
        user_id, 
        user_session, 
        CAST(REPLACE(event_time, ' UTC', '') AS datetime) AS event_time, 
        event_type,
        product_id,
        category_id,
        brand, 
        price
FROM merged_data_view
)
SELECT 
        COUNT(*) As total_rows, 
        SUM(CASE WHEN user_id IS NULL or user_id = '' THEN 1 ELSE 0 END) AS missing_user_id,
        SUM(CASE WHEN user_session IS NULL or user_session = '' THEN 1 ELSE 0 END) AS missing_user_session,
        SUM(CASE WHEN event_time IS NULL THEN 1 ELSE 0 END) AS missing_event_time,
        SUM(CASE WHEN event_type IS NULL or event_type = '' THEN 1 ELSE 0 END) AS missing_event_type,
        SUM(CASE WHEN product_id IS NULL or product_id = '' THEN 1 ELSE 0 END) AS missing_product_id,
        SUM(CASE WHEN category_id IS NULL or category_id = '' THEN 1 ELSE 0 END) AS missing_category_id, 
        SUM(CASE WHEN brand is NULL or brand = '' THEN 1 ELSE 0 END) AS missing_brand,
        SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS missing_price
FROM cte2



-- missing user_session rows - 4598
-- missing price rows - 94
-- missing brand rows - 8,757,117

-- Observation: There are missing values in user_session, price, and brand
-- Checking if there's any pattern to the missing data to find the root cause behind it.  
-- There's no pattern to missing data and based on the context we can move to next stage of handling these dataset. 


-- 2. Handling Null and Missing Values

-- We replaced missing values of 'brand' column with Unknown, 
-- removed rows with missing user_session, 
-- removed the rows where price is missing or is 0 or less.



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



-- # Removing duplicates


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
SELECT *
FROM without_duplicates
WHERE rn = 1




-- Removed over 2,00,000 duplicate records.




-- # Fixing structural errors

-- There are not typos and extra spaces in the brand or event_type column


-- # Standerdize/Normalize Data                          

-- There are no columns to be standardized 




-- # Dealing with outliers

-- There were 216984 rows of data where the product_id was not of 7 characters which is case for most of the rows.
-- but these rows have 4 or 5 character which could be okay based on context of the data. 

-- For the price column there are not outliers in the upper boundry but there are few products with price below 0.
-- We removed these rows of data.


SELECT *
FROM (
    SELECT *, LEN(product_id) AS length_
FROM merged_data_view
) AS t1
WHERE length_ != 7




-- Final code with clean data


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




-- creating index 

CREATE INDEX idx_user_id ON Nykaa_cleaned_data (user_id)
CREATE INDEX idx_user_session ON Nykaa_cleaned_data (user_session)
CREATE INDEX idx_event_time ON Nykaa_cleaned_data (event_time)



-- clean data table space - 2.8 gb 
-- space of 3 indexes - 2.5 gb
-- clean data table space with 3 indexes - 5.4 gb


-- clean data view runtime - 6.52 min
-- clean data table runtime - 4.22 min
-- clean data with 3 index runtime - 3.08 min


-- total rows after data cleaning - 19,493,208
-- total rows before data cleaning - 20,692,840


ALTER TABLE Nykaa_cleaned_data
ADD event_date DATE;

UPDATE Nykaa_cleaned_data
SET event_date = CAST(event_time as DATE);






Updating the UTS time to Moscow STANDARD TIME

Price FLOAT to decimal 100, 2




