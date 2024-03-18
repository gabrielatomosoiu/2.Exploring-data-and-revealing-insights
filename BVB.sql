use BVB;

-- This line specifies the database to use for the following queries.


-- 1) Investment Count by Type

SELECT Investment_Type,
       COUNT(*) AS NumberOfInvestments
FROM dbo.Investments
GROUP BY Investment_Type;

-- This query retrieves the investment type from the 'Investments' table and counts the number of investments for each type. 
-- This helps understand the distribution of investments across different categories (equity, index, etc.).

-----------------------------------------------------------------------------------------------------------------------------
--	Result:			
       				
--	Investment_Type		NumberOfInvestments	
				
--	Equity			103
--	Index			2
-- --------------------------------------------------------------------------------------------------------------------------


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

-----------------------------------------------------------------------------------------------------------------------------
--	Result:					
       						
--	Ticker		Investment_Name			TotalTradedVolume
						
--	AST		Arctic Stream SA		95,439
--	ARO		Aro-Palace SA Brasov		93,841
--	NRF		Norofert SA			903,182
--	MALI		Comalim Arad			9,737
--	BRNA		Romnav				9,431
--	BRD		BRD-Groupe Societe Generale	9,375,471
--	PREB		Prebet				867,529
--	ARTE		Artego SA			8,414
--	SINA		Sinatex				701
--	BRM		Bermas Suceava			7,882
-- --------------------------------------------------------------------------------------------------------------------------


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

-----------------------------------------------------------------------------------------------------------------------------
--       Result:

--	Ticker		Company_Name		Industry_Sector		Year		AverageClosingPrice
									
--	DIGI		Digi Communications ( DIGI )		Communication Services		2022		31.5
--	DIGI		Digi Communications ( DIGI )		Communication Services		2023		34.0276
--	CMP		Compa ( CMP )		Consumer Discretionary		2022		0.392
--	CMP		Compa ( CMP )		Consumer Discretionary		2023		0.4388
--	EFO		Turism, Hoteluri, Restaurante Marea Neagra ( EFO )		Consumer Discretionary		2022		0.203
--	EFO		Turism, Hoteluri, Restaurante Marea Neagra ( EFO )		Consumer Discretionary		2023		0.2562
--	SFG		Sphera Franchise Group ( SFG )		Consumer Discretionary		2022		14
--	SFG		Sphera Franchise Group ( SFG )		Consumer Discretionary		2023		15.6037
--	ATB		Antibiotice ( ATB )		Consumer Staples		2022		0.566
--	ATB		Antibiotice ( ATB )		Consumer Staples		2023		0.5799
--	BIO		Biofarm ( BIO )		Consumer Staples		2022		0.616
--	BIO		Biofarm ( BIO )		Consumer Staples		2023		0.6535
--	BRM		Bermas ( BRM )		Consumer Staples		2022		2.4
--	BRM		Bermas ( BRM )		Consumer Staples		2023		2.399
--	M		Med Life ( M )		Consumer Staples		2022		16.9
--	M		Med Life ( M )		Consumer Staples		2023		18.4758
--	RMAH		Farmaceutica Remedia Deva ( RMAH )		Consumer Staples		2022		0.59
--	RMAH		Farmaceutica Remedia Deva ( RMAH )		Consumer Staples		2023		0.6388
--	SOCP		SOCEP S.A. ( SOCP )		Consumer Staples		2022		0.79
--	SOCP		SOCEP S.A. ( SOCP )		Consumer Staples		2023		0.8715
--	WINE		Purcari Wineries Public Company Limited ( WINE )		Consumer Staples		2022		8.49
--	WINE		Purcari Wineries Public Company Limited ( WINE )		Consumer Staples		2023		9.1472
--	COTE		Conpet Ploiesti ( COTE )		Energy		2022		67.8
--	COTE		Conpet Ploiesti ( COTE )		Energy		2023		74.963
--	OIL		Oil Terminal ( OIL )		Energy		2022		0.161
--	OIL		Oil Terminal ( OIL )		Energy		2023		0.1427
--	PTR		Rompetrol Well Services ( PTR )		Energy		2022		0.592
--	PTR		Rompetrol Well Services ( PTR )		Energy		2023		0.5883
--	SNG		Romgaz ( SNG )		Energy		2022		37.75
--	SNG		Romgaz ( SNG )		Energy		2023		39.8822
--	SNN		Nuclearelectrica ( SNN )		Energy		2022		42.8
--	SNN		Nuclearelectrica ( SNN )		Energy		2023		44.8575
--	SNP		OMV Petrom ( SNP )		Energy		2022		0.42
--	SNP		OMV Petrom ( SNP )		Energy		2023		0.4712
--	BRD		BRD - Groupe Societe Generale ( BRD )		Financials		2022		13
--	BRD		BRD - Groupe Societe Generale ( BRD )		Financials		2023		13.0559
--	BRK		Ssif Brk Financial Group ( BRK )		Financials		2022		0.1132
--	BRK		Ssif Brk Financial Group ( BRK )		Financials		2023		0.1258
--	BVB		SC Bursa de Valori Bucuresti ( BVB )		Financials		2022		35.3
--	BVB		SC Bursa de Valori Bucuresti ( BVB )		Financials		2023		42.4469
--	EVER		Evergent Investments ( EVER )		Financials		2022		1.37
--	EVER		Evergent Investments ( EVER )		Financials		2023		1.2994
--	FP		Fondul Proprietatea ( FP )		Financials		2022		2.04
--	FP		Fondul Proprietatea ( FP )		Financials		2023		2.0841
--	IMP		Impact Developer & Contractor ( IMP )		Financials		2022		0.36
--	IMP		Impact Developer & Contractor ( IMP )		Financials		2023		0.3627
--	ONE		One United Properties ( ONE )		Financials		2022		0.856
--	ONE		One United Properties ( ONE )		Financials		2023		0.8704
--	PBK		Patria Bank ( PBK )		Financials		2022		0.0784
--	PBK		Patria Bank ( PBK )		Financials		2023		0.0853
--	SIF4		SIF Muntenia ( SIF4 )		Financials		2022		1.2
--	SIF4		SIF Muntenia ( SIF4 )		Financials		2023		1.1912
--	SIF5		SIF Oltenia ( SIF5 )		Financials		2022		1.72
--	SIF5		SIF Oltenia ( SIF5 )		Financials		2023		1.7463
--	TLV		Banca Transilvania ( TLV )		Financials		2022		19.92
--	TLV		Banca Transilvania ( TLV )		Financials		2023		19.8935
--	TRANSI		Transilvania Investments Alliance ( TRANSI )		Financials		2022		0.276
--	TRANSI		Transilvania Investments Alliance ( TRANSI )		Financials		2023		0.2849
--	AAG		Aages ( AAG )		Industrials		2022		3.52
--	AAG		Aages ( AAG )		Industrials		2023		3.7513
--	AQ		Aquila Part Prod Com ( AQ )		Industrials		2022		0.552
--	AQ		Aquila Part Prod Com ( AQ )		Industrials		2023		0.6546
--	ARM		Armatura ( ARM )		Industrials		2023		0.0911
--	ARS		Aerostar ( ARS )		Industrials		2022		7.7
--	ARS		Aerostar ( ARS )		Industrials		2023		7.5911
--	CEON		Cemacon Cluj-Napoca ( CEON )		Industrials		2022		0.448
--	CEON		Cemacon Cluj-Napoca ( CEON )		Industrials		2023		0.4768
--	COMI		Condmag ( COMI )		Industrials		2022		0.006
--	COMI		Condmag ( COMI )		Industrials		2023		0.0057
--	ELMA		Electromagnetica Bucuresti ( ELMA )		Industrials		2022		0.146
--	ELMA		Electromagnetica Bucuresti ( ELMA )		Industrials		2023		0.1733
--	MCAB		Romcab Mures ( MCAB )		Industrials		2022		0.0974
--	MCAB		Romcab Mures ( MCAB )		Industrials		2023		0.1414
--	MECE		Mecanica Fina Bucuresti ( MECE )		Industrials		2022		31.2
--	MECE		Mecanica Fina Bucuresti ( MECE )		Industrials		2023		31.2645
--	PREB		Prebet Aiud ( PREB )		Industrials		2023		1.8921
--	ROCE		Romcarbon Buzau ( ROCE )		Industrials		2022		0.357
--	ROCE		Romcarbon Buzau ( ROCE )		Industrials		2023		0.4367
--	SNO		Santierul Naval Orsova ( SNO )		Industrials		2022		5
--	SNO		Santierul Naval Orsova ( SNO )		Industrials		2023		5.0425
--	TBM		Turbomecanica ( TBM )		Industrials		2022		0.1815
--	TBM		Turbomecanica ( TBM )		Industrials		2023		0.2147
--	TRP		Teraplast ( TRP )		Industrials		2022		0.55
--	TRP		Teraplast ( TRP )		Industrials		2023		0.5884
--	TTS		Transport Trade Services ( TTS )		Industrials		2022		11.46
--	TTS		Transport Trade Services ( TTS )		Industrials		2023		12.6078
--	BNET		Bittnet Systems Bucuresti ( BNET )		Information Technology		2022		0.2955
--	BNET		Bittnet Systems Bucuresti ( BNET )		Information Technology		2023		0.2954
--	SAFE		Safetech Innovations ( SAFE )		Information Technology		2022		2.8
--	SAFE		Safetech Innovations ( SAFE )		Information Technology		2023		3.0598
--	ALR		ALRO S.A. ( ALR )		Materials		2022		1.57
--	ALR		ALRO S.A. ( ALR )		Materials		2023		1.726
--	ALU		Alumil Rom Industry ( ALU )		Materials		2022		1.705
--	ALU		Alumil Rom Industry ( ALU )		Materials		2023		1.8762
--	ARTE		Artego Jiu ( ARTE )		Materials		2023		13.2714
--	CBC		Carbochim ( CBC )		Materials		2023		32.6667
--	CRC		Chimcomplex Borzesti Onesti ( CRC )		Materials		2022		23.7
--	CRC		Chimcomplex Borzesti Onesti ( CRC )		Materials		2023		21.5513
--	VNC		Vrancart ( VNC )		Materials		2022		0.153
--	VNC		Vrancart ( VNC )		Materials		2023		0.1673
--	EL		Societatea Energetica Electrica ( EL )		Utilities		2022		8.09
--	EL		Societatea Energetica Electrica ( EL )		Utilities		2023		8.7456
--	TEL		Transelectrica ( TEL )		Utilities		2022		21.7
--	TEL		Transelectrica ( TEL )		Utilities		2023		23.8383
--	TGN		Transgaz ( TGN )		Utilities		2022		275.5
--	TGN		Transgaz ( TGN )		Utilities		2023		306.7222


-- --------------------------------------------------------------------------------------------------------------------------


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

-----------------------------------------------------------------------------------------------------------------------------
--	Result:

--	Investment_Type		AveragePriceChange	       Currency

--	Equity			0.0388                         RON
--	Index			10.9667                        RON
-- --------------------------------------------------------------------------------------------------------------------------
