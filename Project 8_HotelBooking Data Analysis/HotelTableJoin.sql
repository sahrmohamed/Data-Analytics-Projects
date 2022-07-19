/*
Joining the market and meal cost tables with the HotelData
*/

SELECT *
FROM market_segment
GO

SELECT *
FROM meal_cost
GO

-- NOW LET'S DO OUR JOIN, SINCE WE WANT EVERYTHING FROM THE LEFT TABLE HENCE 'LEFT JOIN' --

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
FROM market_segment ms
LEFT OUTER JOIN HotelData HD
 ON HD.market_segment = ms.market_segment
LEFT OUTER JOIN meal_cost mc
 ON HD.meal = mc.meal 
