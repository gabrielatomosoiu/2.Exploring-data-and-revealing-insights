use BVB

-- 1) This query shows the number of investments for each investment type.

SELECT Investment_Type,
	COUNT(*) AS NumberOfInvestments
FROM dbo.Investments
GROUP BY Investment_Type

-- 2) This query finds the top 10 most traded stocks (by total traded volume) in the data set.

SELECT TOP 10 Ticker, Investment_Name, FORMAT(SUM(Traded_Volume), '0,00') AS TotalTradedVolume
FROM dbo.Market_price AS p
JOIN dbo.Investments AS i ON p.Ticker = i.Investment_Code
GROUP BY Ticker, Investment_Name
ORDER BY TotalTradedVolume DESC

-- 3) This query joins the tables Industry_Sector and Market_Price to calculate the average closing price per industry sector 
-- at the end of year 2022 and begining of year 2023.

SELECT
  Ticker,
  Company_Name,
  Industry_Sector,
  Year(Price_Date) AS Year,
  FORMAT(AVG(Close_Price), '0.0000') AS AverageClosingPrice
FROM dbo.Market_price AS p
INNER JOIN dbo.Industry_Sector AS s ON p.Ticker = s.Investment_Code
GROUP BY Ticker, Company_Name, Industry_Sector, Year(Price_Date)
ORDER BY Industry_Sector, Ticker, Year

-- 4) This query creates a CTE that calculates the price change for each investment by subtracting the previous closing price.
-- The main query then calculates the average price change for each investment type. 

WITH InvestmentPerformance AS (
  SELECT
    i.Investment_Type,
	i.Currency,
    t.Ticker,
    t.Price_Date,
	t.Close_Price - (
      SELECT TOP 1 p.Close_Price
      FROM Market_Price as p
      WHERE p.Ticker = t.Ticker
      AND p.Price_Date < t.Price_Date
      ORDER BY Price_Date DESC
    ) AS Price_Change
  FROM Investments as i
  INNER JOIN Market_Price as t ON i.Investment_Code = t.Ticker
)
SELECT 
  Investment_Type,
  FORMAT(AVG(Price_Change), '0.0000') AS AveragePriceChange,
  Currency
FROM InvestmentPerformance
GROUP BY Investment_Type, Currency