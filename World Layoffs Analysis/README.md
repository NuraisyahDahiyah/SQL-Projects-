# World Layoffs - Data Cleaning and Exploratory Analysis

Following [Alex the Analyst's](https://www.youtube.com/watch?v=OT1RErkfLNQ&t=12125s) 'SQL Beginner to Advanced' online tutorial, I did a SQL-based analysis of global layoff data, focusing on data cleaning, standardisation, exploratory analysis, and year-over-year company rankings.

The project transforms a raw layoffs dataset into a cleaner analytical dataset before using SQL to investigate trends across companies, industries, countries, and time.

**Database:** `MySQL`

## Business Problem

This project explores:
- How have global layoffs changed over time?
- Which companies, industries, and countries experienced the highest number of layoffs?
- Which companies recorded the largest layoffs each year?
- What patterns emerge across different company stages and industries?

## Data Cleaning 

The raw dataset was prepared for analysis through several cleaning steps:

- Removed duplicate records using `ROW_NUMBER()`
- Standardised company and industry values
- Cleaned inconsistent country names
- Converted date values from text to `DATE`
- Identified and handled missing/blank industry values
- Removed records where both `total_laid_off` and `percentage_laid_off` were unavailable
- Removed temporary cleaning columns after validation

## Exploratory Analysis

| Area of Analysis | What Was Done |
|---|---|
| Layoffs by Company, Industry a Country | Analysed total layoffs across different dimensions to identify the companies, industries, and countries most affected. |
| Layoffs Over Time | Examined the minimum and maximum dates in the dataset and calculated monthly and yearly layoffs to identify changes in layoff activity. | 
| Rolling Layoff Total | Used a monthly aggregation and window function to calculate a cumulative rolling total of layoffs over time.
| Top Companies by Year | Calculated annual layoffs by company and used `DENSE_RANK()` with partitioning by year to identify the top five companies with the highest layoffs each year. |

## Key Insights

<details> 
  <summary>
    <strong> 01 — Layoffs are concentrated across specific industries and countries </strong> 
  </summary>

The analysis shows that layoffs are not evenly distributed globally, with certain industries and countries accounting for substantially larger shares of total layoffs.

**Implication:** Industry and geographic concentration can provide context when assessing broader labour-market and economic trends.

</details>

<details> 
  <summary>
    <strong> 02 — Layoff activity varies significantly over time </strong>
  </summary>

Monthly and yearly aggregation reveals periods of substantially higher layoff activity, allowing broader changes in the global technology and business environment to be identified.

**Implication:** Tracking layoffs over time can help contextualise periods of economic or industry-wide disruption.

</details>

<details> 
  <summary>
    <strong> 03 — A small number of companies account for substantial layoffs </strong> 
  </summary>

Ranking companies by annual layoffs highlights organisations that contributed disproportionately to total layoffs in individual years.

**Implication:** Company-level analysis provides a more granular view of how large-scale workforce reductions contribute to overall trends.

</details>

---

**SQL Techniques Used**

`CTE` · `ROW_NUMBER()` · `DENSE_RANK()` · `Window Functions` · `PARTITION BY` · `JOIN` · `GROUP BY` · `Date Functions`
