# Inflation and S&P 500 Index
## Introduction
This project showcases my attempt to follow the steps of the data analysis process: **ask, prepare, process, analyze, share**, and **act** for my own analysis. 
It aims to educate myself and any stock market novices in investing in funds that mimic S&P 500 index.
## Datasets Used
- S&P 500 index historical monthly data from https://www.investing.com/indices/us-spx-500-historical-data
- Consumer Price Index (CPI) from [U.S. Bureau of Labor Statistics](https://data.bls.gov/cgi-bin/surveymost?cu) 
## Ask 
#### Identify the business task: 
- Is there any correlation between inflation and the S&P 500 index? 
- What does a 10-year return on S&P 500 index fund investment look like?
#### Shareholders 
Beginner investors who seek to invest in funds that mimic S&P 500 Index such as Vanguard 500 ETF (VOO) for a long term.
#### Metrics
Ten year return in investing in S&P 500 index.
## Prepare 
### [S&P 500 index dataset](https://github.com/emma-jinger/InflationAndSP500/blob/main/RawSP500HistoricalData.csv) 
- It was retrieved on May 9, 2022.
- It contains monthly S&P 500 index data between Jan 1990 and May 2022.
- It is used to calcualte 10-year returns investing in funds that mimic S&P 500 index. 
- Disclaimer: Thre returns calculated from this project are only used for references, since dividends, investment management fee and such are not considered during the calculation.
### [CPI dataset](https://github.com/emma-jinger/InflationAndSP500/blob/main/RawCPIData.xlsx) 
- It was retrieved on May 9, 2022. 
- It contains monthly CPI-U (Consumer Price Index for All Urban Consumers) less food and energy data between Jan 1990 and Mar 2022.
- It can be used to [calculate annual core inflation rates](https://www.usinflationcalculator.com/inflation/inflation-vs-consumer-price-index-cpi-how-they-are-different/). 
- The [core inflation rate](https://www.thebalance.com/core-inflation-rate-3305918) excludes food and energy prices because they vary too much from month to month. This exclusion makes the core rate more accurate in measuring underlying inflation trends. 
- Disclaimer: The inflation rates calculated in this project might have some discrepencies with that done by the Federal Reserve.    
## Process
This step is done in Google Sheet. 
### Rationale for using Google Sheet
I chose to process the datasets in Google Sheet because the datasets are fairly small, with 389 records in S&P 500 dataset and 33 records in CPI dataset. Besides, using spreadsheet functions and menu tools to do the initial cleaning like removing duplicate data, checking for incorrectly entered data, and formatting data for consistency is very straightforward.
### What did I do to process the S&P 500 dataset?
1. Checked that there was no duplicate data. 
2. Formatted the column that contains month and year data to the DATE data type.
3. Checked there was no missing month or year.
4. Checked the min and max of each column to make sure there was no incorrectly entered data. 
5. Formatted numbers like 4,123.34 to 4123.34, and percent like -0.21% to -0.21.
6. Added Id column for later use (primary key in PostgreSQL).
7. Sorted date column from old to new. 
### What did I do to process the CPI-U data? 
1. Deleted the description part of the dataset.
2. Checked that there was no duplicate data.
3. Checked that there was no missing year. 
### The cleaned datasets after this step
- [Cleaned S&P 500 data](https://github.com/emma-jinger/InflationAndSP500/blob/main/CleanedSP500HistoricalData.csv)
- [Cleaned CPI data](https://github.com/emma-jinger/InflationAndSP500/blob/main/CleanedCPIData.csv)
## Analyze
This step is done in PostgreSQL. 
### Rationale for anaylzing the data using PostgreSQL. 
I chose to use a SQL database because of its fast and powerful functionality. Simply write down all I want to do with the data in a query, I will get the transformed data in merely several seconds. The queries also enables traceability of my analysis. 
### What did I do to analyze the cleaned data? 
- **[S&P 500 and Inflation Query](https://github.com/emma-jinger/InflationAndSP500/blob/main/SP500AndInflation_query.sql)** 
  1. Calculated the annual inflation rate
  2. Transformed CPI table to resemble the organization of the cleaned S&P 500 table
  3. Created a new table [SP500AndInflation](https://github.com/emma-jinger/InflationAndSP500/blob/main/SP500AndInflation052522.csv) by joining with the S&P 500 table
- **[S&P 500 10 Year Return and Inflation-adjusted Return Query](https://github.com/emma-jinger/InflationAndSP500/blob/main/SP500Return_query.sql)** 
  - Created a new table [SP500TenYearReturn&Adjusted](https://github.com/emma-jinger/InflationAndSP500/blob/main/SP500TenYearReturn%26Adjusted052422.csv) that contains 10 year returns and adjusted 10 year returns on S&P 500 
## Share
The visualizations were created using [Tableau Public](https://public.tableau.com/app/profile/emma.li2382/viz/SP500VsInflation_052422/InflationVsSP500) and the slides were created in Gooogle Slides. 

An accompanying slides are [here]([https://www.thebalance.com/best-time-to-invest-in-index-funds-2466412](https://github.com/MeanderingNinja/InflationAndSP500/blob/main/Inflation%20and%20S%26P%20500%20Index%20Analysis%20052622.pptx)) to share my analysis. 
### A scatter plot 
The following plot is used to show any correlation between inflation rate and S&P 500 index. 
![scatterplot](https://github.com/emma-jinger/InflationAndSP500/blob/main/InflationVsSP500_052022.png)
By examining the above plot, we see no obvious correlation between the inflation rate and S&P 500 index. This is further confirmed by looking at the [correlation coefficient](https://www.investopedia.com/terms/c/correlationcoefficient.asp) ([see how -0.04 is calculated](https://github.com/emma-jinger/InflationAndSP500/blob/main/Correlation%20Coefficient%20.png)). Values of correlation coefficient near 0 indicate a very weak linear relationship.
### Two stacked bar charts  
*The following chart is used to compare the 10 year rolling returns if one invests $10K in S&P 500 index starting from different months and years. The cutoff month and year is May 2012. This is because May 2012 is the latest starting investment date for which we are able to calculate the 10-year return based on historical S&P 500 index data.*  
![10-year return](https://github.com/emma-jinger/InflationAndSP500/blob/main/SP500TenYearReturn.png) 
- With $10K investment in S&P 500 index, the highest 10-year rolling return is $37,051, whereas the lowest is -$4,064.
- The possibility of increasing your money within 10 years is 89.59%. 
#### What would a [inflation-adjusted](https://www.investopedia.com/terms/i/inflation_adjusted_return.asp#:~:text=The%20inflation%2Dadjusted%20return%20is,removing%20the%20effects%20of%20inflation.) 10 year rolling return look like? 
> Removing the effects of inflation from the return of an investment allows the investor to see the **true earning potential** of the security without external economic forces. 

*The cutoff month and year is Mar 2012. This is because Mar 2012 lastest date for which we are able to calculate the inflation-adjusted 10-year return (CPI index for Mar 2022 is the latest data we have).*
![10-year adjusted return](https://github.com/emma-jinger/InflationAndSP500/blob/main/SP500AdjustedTenYearReturn.png) 
- The highest adjusted 10-year rolling return is adjusted to $27,778, whereas the lowest is adjusted to -$3,292. 
- The possibility of increasing your money within 10 years is still 89.59%.
## Act
### Conclusion
- Inflation rate cannot be used as a reference for one to decide when to invest in funds that mimic S&P 500 index, as no obvious correlation between them is found. 
- The likelihood of one growing their money by investing in funds that mimic S&P 500 index is quite high (89.59%). It could be considered as a fairly safe investment option.  
- Further analysis can be done to see if there is a better strategy on investing in funds that mimic S&P 500 index. Questions like "Would a longer term like 15 or 20 years make it safer?" 



