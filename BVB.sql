use BVB;

-- This line specifies the database to use for the following queries.


-- 1) Investment Count by Type

SELECT Investment_Type,
       COUNT(*) AS NumberOfInvestments
FROM dbo.Investments
GROUP BY Investment_Type;

-- This query retrieves the investment type from the 'Investments' table and counts the number of investments for each type. 
-- This helps understand the distribution of investments across different categories (equity, index, etc.).


-- 2) Top 10 Traded Stocks

SELECT TOP 10 Ticker,
             Investment_Name, 
             FORMAT(SUM(Traded_Volume), '0,00') AS TotalTradedVolume
FROM dbo.Market_price AS p
JOIN dbo.Investments AS i ON p.Ticker = i.Investment_Code
GROUP BY Ticker, Investment_Name
ORDER BY TotalTradedVolume DESC;

-- This query joins the 'Market_Price' and 'Investments' tables to find the top 10 most actively traded stocks (by total traded volume) 
-- in the dataset. The FORMAT function ensures comma separators for readability of large numbers.


-- 3) Average Closing Price by Sector (Year-End 2022 & 2023)

SELECT
  Ticker,
  Company_Name,
  Industry_Sector,
  Year(Price_Date) AS Year,
  FORMAT(AVG(Close_Price), '0.0000') AS AverageClosingPrice
FROM dbo.Market_price AS p
INNER JOIN dbo.Industry_Sector AS s ON p.Ticker = s.Investment_Code
GROUP BY Ticker, Company_Name, Industry_Sector, Year(Price_Date)
ORDER BY Industry_Sector, Ticker, Year;

-- This query joins the 'Market_Price' and 'Industry_Sector' tables. It calculates the average closing price for each industry sector 
-- at the end of 2022 (Year(Price_Date) = 2022) and beginning of 2023 (Year(Price_Date) = 2023). This helps identify potential industry trends.

-- 4) Investment Performance by Type

WITH InvestmentPerformance AS (
  SELECT
    i.Investment_Type, i.Currency,
    t.Ticker, t.Price_Date, t.Close_Price - (
      SELECT TOP 1 p.Close_Price
      FROM Market_Price AS p
      WHERE p.Ticker = t.Ticker
      AND p.Price_Date < t.Price_Date
      ORDER BY Price_Date DESC
    ) AS Price_Change
  FROM Investments AS i
  INNER JOIN Market_Price AS t ON i.Investment_Code = t.Ticker
)
SELECT 
  Investment_Type,
  FORMAT(AVG(Price_Change), '0.0000') AS AveragePriceChange,
  Currency
FROM InvestmentPerformance
GROUP BY Investment_Type, Currency;

-- This query utilizes a Common Table Expression (CTE) named 'InvestmentPerformance'. It calculates the price change for each investment 
-- by subtracting the previous closing price from the current closing price. The main query then calculates the average price change for each 
-- investment type and currency. This provides insights into overall investment performance across categories.
