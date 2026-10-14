-- Cleanup this using Text Functions

WITH title_lower AS (
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact
)

SELECT 
    job_title,
    CASE 
        WHEN job_title_clean LIKE '%data%' 
            AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%' 
            AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        WHEN job_title_clean LIKE '%data%' 
            AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;


-- NULLIF:

SELECT 
    MEDIAN(NULLIF(salary_year_avg, 0)),   -- If 0 is found, it'll be replaced for NULL - no zeros in MEDIAN() formula
    MEDIAN(NULLIF(salary_hour_avg, 0))
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;

-- COALESCE

SELECT 
    salary_year_avg,   
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080)
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;


-- Final Example - Simplify with COALESCE

SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080) AS standardized_salary,
    CASE 
            WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) IS NULL THEN 'Missing'
            WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 75_000 THEN 'Low'
            WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 150_000 THEN 'Medium'
            ELSE 'High'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC
LIMIT 30;