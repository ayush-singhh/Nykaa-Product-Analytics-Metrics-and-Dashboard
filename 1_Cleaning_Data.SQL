
SELECT TOP (20)*
FROM [2019-Oct]








-- Handling Null and Missing Values








-- Counting NUll value in the event_type

SELECT event_type, COUNT(event_type) AS event_count
FROM [2019-Oct]
WHERE event_type IS NULL OR event_type = ''
GROUP BY event_type;




SELECT category_code, COUNT(category_code) AS category_code_count
FROM [2019-Oct]
WHERE category_code IS NULL OR category_code = ''
GROUP BY category_code;



SELECT COUNT(category_code)
FROM [2019-Oct]
WHERE category_code = ''






-----------Error Documentation --------



