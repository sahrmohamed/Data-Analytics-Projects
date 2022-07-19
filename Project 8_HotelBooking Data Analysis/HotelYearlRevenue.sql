/*
Combining Hotel Data & Looking at the total revenue by hotel type
*/

-- First, we've to combine these tables and create a CTE --

WITH HotelData AS 
(
SELECT *
FROM dbo.[2018]
UNION
SELECT *
FROM dbo.[2019]
UNION
SELECT *
FROM dbo.[2020]
)
SELECT *
FROM HotelData
GO

-- Calculating the Yearly Revenue --

WITH HotelData AS 
(
SELECT *
FROM dbo.[2018]
UNION
SELECT *
FROM dbo.[2019]
UNION
SELECT *
FROM dbo.[2020]
)
SELECT hotel, arrival_date_year, ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights) * adr), 2) revenue
FROM HotelData
GROUP BY  arrival_date_year, hotel 

