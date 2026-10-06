SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
FROM
    job_postings_fact
LIMIT 10;   

SELECT * 
FROM company_dim
WHERE name in ('Facebook', 'Meta');

PRAGMA show_tables_expanded;

DESCRIBE job_postings_fact;

SELECT 
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skill_id
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id;


EXPLAIN ANALYZE
SELECT 
    DISTINCT cd.name AS company_name, 
    COUNT(jpf.*) AS posting_count
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.*) > 3000
ORDER BY posting_count DESC
LIMIT 10;

SELECT
    CAST(job_id AS VARCHAR) || '-' || CAST(company_id AS VARCHAR),
    CAST(job_work_from_home AS INT) AS job_work_from_home,
    CAST(job_posted_date AS DATE) AS job_posted_date,
    CAST(salary_year_avg AS DECIMAL(10, 0)) AS salary_year_avg
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

SELECT
    job_id:: VARCHAR || '-' || company_id:: VARCHAR,
    job_work_from_home:: INT AS job_work_from_home,
    job_posted_date:: DATE AS job_posted_date,
    salary_year_avg:: DECIMAL(10, 0) AS salary_year_avg
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;