-- This query uses the cleaned CPI-U dataset to create a new dataset 
-- that contains three colomns (month_year, cpi_index, annual_inflation_rate)

-- Temp table (inflation data calculated from the cleaned CPI-U dataset)
WITH 
InflationTable AS
(SELECT 
  "Year",
 -- Use the cpi data of current month and that from a year ago to calculate the annual inflation rate for the month
  ROUND(("Jan" - LAG("Jan") OVER (ORDER BY "Year"))
		/ LAG("Jan") OVER (ORDER BY "Year")*100, 2) 
		AS "Jan",
  ROUND(("Feb" - LAG("Feb") OVER (ORDER BY "Year"))
		/ LAG("Feb") OVER (ORDER BY "Year")*100, 2) 
		AS "Feb",
  ROUND(("Mar" - LAG("Mar") OVER (ORDER BY "Year"))
		/ LAG("Mar") OVER (ORDER BY "Year")*100, 2) 
		AS "Mar",
  ROUND(("Apr" - LAG("Apr") OVER (ORDER BY "Year"))
		/ LAG("Apr") OVER (ORDER BY "Year")*100, 2) 
		AS "Apr",
  ROUND(("May" - LAG("May") OVER (ORDER BY "Year"))
		/ LAG("May") OVER (ORDER BY "Year")*100, 2) 
		AS "May",
  ROUND(("Jun" - LAG("Jun") OVER (ORDER BY "Year"))
		/ LAG("Jan") OVER (ORDER BY "Year")*100, 2) 
		AS "Jun",
  ROUND(("Jul" - LAG("Jul") OVER (ORDER BY "Year"))
		/ LAG("Jul") OVER (ORDER BY "Year")*100, 2) 
		AS "Jul",
  ROUND(("Aug" - LAG("Aug") OVER (ORDER BY "Year"))
		/ LAG("Aug") OVER (ORDER BY "Year")*100, 2) 
		AS "Aug",
  ROUND(("Sep" - LAG("Sep") OVER (ORDER BY "Year"))
		/ LAG("Sep") OVER (ORDER BY "Year")*100, 2) 
		AS "Sep",
  ROUND(("Oct" - LAG("Oct") OVER (ORDER BY "Year"))
		/ LAG("Oct") OVER (ORDER BY "Year")*100, 2) 
		AS "Oct",
  ROUND(("Nov" - LAG("Nov") OVER (ORDER BY "Year"))
		/ LAG("Nov") OVER (ORDER BY "Year")*100, 2) 
		AS "Nov",
  ROUND(("Dec" - LAG("Dec") OVER (ORDER BY "Year"))
		/ LAG("Dec") OVER (ORDER BY "Year")*100, 2) 
		AS "Dec"
FROM sp500_index.cpi_u
),
-- temp table(inflation data formatted to 2 columns) like this:
-------------------------------
-- month_year  |   inflation_rate
-- 01/1991     |    5.61
-- 02/1991     |    5.65
---------------------------------
LongInflationTable AS
(SELECT 
   TempTable1.month, 
   InflationTable."Year" as year, 
   TempTable1.inflation_rate
 FROM
   InflationTable,
  LATERAL (VALUES
	        (InflationTable."Jan", '01'), 
			(InflationTable."Feb", '02'), 
			(InflationTable."Mar", '03'), 
			(InflationTable."Apr", '04'),
			(InflationTable."May", '05'),
			(InflationTable."Jun", '06'),
			(InflationTable."Jul", '07'),
			(InflationTable."Aug", '08'),
			(InflationTable."Sep", '09'),
			(InflationTable."Oct", '10'),
			(InflationTable."Nov", '11'),
			(InflationTable."Dec", '12')
		  ) AS TempTable1(inflation_rate, month)
 ORDER BY 
   InflationTable."Year", TempTable1.month
),

-- temp table(CPI data formatted to 2 columns) like this:
-------------------------------
-- month_year  |   cpi_index
-- 01/1990     |    132.0
-- 02/1990     |    132.8
---------------------------------
CPITempTable AS
(SELECT 
  TempTable2.month,
  CPITable."Year" AS year,
  TempTable2.cpi_index
FROM 
  sp500_index.cpi_u AS CPITable, 
  -- LATERAL join lets you look to the left hand table's row
  LATERAL (VALUES
	        (CPITable."Jan", '01'), 
			(CPITable."Feb", '02'), 
			(CPITable."Mar", '03'), 
			(CPITable."Apr", '04'),
			(CPITable."May", '05'),
			(CPITable."Jun", '06'),
			(CPITable."Jul", '07'),
			(CPITable."Aug", '08'),
			(CPITable."Sep", '09'),
			(CPITable."Oct", '10'),
			(CPITable."Nov", '11'),
			(CPITable."Dec", '12')
		  ) AS TempTable2(cpi_index, month)
ORDER BY
  CPITable."Year", TempTable2.month
 )
 
SELECT 
  CONCAT(CPITempTable.month, '/', CPITempTable.year) AS month_year, 
  CPITempTable.cpi_index, 
  LongInflationTable.inflation_rate  
FROM 
  LongInflationTable 
  INNER JOIN CPITempTable 
  ON LongInflationTable.month = CPITempTable.month AND 
     LongInflationTable.year = CPITempTable.year;
 
  
  
