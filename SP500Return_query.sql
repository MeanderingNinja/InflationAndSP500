-- This query is to create a new table with 10-year return data 
-- It is based on the data in the S&P500 index data
CREATE TABLE sp500_index."SP500TenYearReturn3" AS
  SELECT 
    "Id",
	month_year,
    ROUND((LEAD(sp500_index, 120) OVER(ORDER BY "Id")-sp500_index)*100/sp500_index, 2) AS ten_year_return_rate_percentage,
	ROUND(cpi_index/LEAD(cpi_index, 120) OVER(ORDER BY "Id"), 2) AS inflation_ten_year_adjustment_rate 
  FROM 
    sp500_index."SP500AndInflation"
  ORDER BY 
    "Id";
-- Add columns to show the 10-year return for $10K investment in S&P500 index	
ALTER TABLE sp500_index."SP500TenYearReturn3" 
  ADD COLUMN initial_investing_amount numeric, 
  ADD COLUMN ten_year_return numeric;
UPDATE sp500_index."SP500TenYearReturn3" 
  SET initial_investing_amount = 10000;
UPDATE sp500_index."SP500TenYearReturn3" 
  SET ten_year_return= ROUND(initial_investing_amount*ten_year_return_rate_percentage/100,2);
  
-- Add a column to show the adjusted 10-year return for $10K investment in S&P500 index
ALTER TABLE sp500_index."SP500TenYearReturn3"  
  ADD COLUMN adjusted_ten_year_return numeric;
UPDATE sp500_index."SP500TenYearReturn3" 
  SET adjusted_ten_year_return= ROUND(ten_year_return*inflation_ten_year_adjustment_rate, 2);


  
  
