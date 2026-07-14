-- Layoffs Data Cleaning -- 
SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging # creating a copy of the raw data
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

-- 1.0 Remove duplicates 

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging; 

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte 
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper'; # checking if query is working; delete the duplicate and keep the other one


 CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2 # inserted a copy of all layoffs data with a new column 'row_num'
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE company = 'Casper'; # check if query is correct

-- 2.0 Standardise the data

SELECT company, TRIM(company) #takes of white space 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2 # standardising crypto industry name so 'Crypto Currenry' change to 'Crypto'
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry # checking if query is correct 
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) # removing '.' from US 
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT *
FROM layoffs_staging2;

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3.0 Null values or blank values 

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2 # Bally does not have another populated row where its not NULL
WHERE company LIKE 'Bally%'; # trying to see company industry from null value rows

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1 
JOIN layoffs_staging2 t2
	ON t1.company = t2.company 
    AND t1.location = t2.location
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL
;

UPDATE layoffs_staging2 # setting blank as NULL values to standardised
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 t1 
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL
;

SELECT *
FROM layoffs_staging2;
    
-- 4.0 Remove any columns 

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL # deleted row where both columns are null as the data may not be very accurate for eda / useful
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Layoffs Exploratory Data Analysis --

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1  # companies that completely laid off all the staff 
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 1 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2; # layoffs between three years

SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY country
ORDER BY 1 DESC;

# industries with most layoffs: consumer, retail and others
# countries with most layoffs: US, India, Netherlands 

SELECT YEAR (`date`), SUM(total_laid_off) # 1) consumer 2) retail 3) other are the top ones 
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC; # order by YEAR(`date`)

SELECT stage, SUM(total_laid_off) # 1) consumer 2) retail 3) other are the top ones 
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; # order by SUM(total_laid_off)


-- 
# Calculate rolling total of the months
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) # take the 4 characters at position 6 from date column which is the month 
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR(`date`), SUM(total_laid_off) # looking at company by the year and how many they laid off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off) # first CTE based on company layoffs for each year
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS # second CTE to rank layoffs 
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5 ; # year by year snapshot of top 5 company layoffs every year
