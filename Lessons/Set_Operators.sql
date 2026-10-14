
CREATE TEMPORARY TABLE jobs_2023 AS
SELECT * EXCLUDE(job_id, job_posted_date)
FROM job_postings_fact
WHERE YEAR(job_posted_date) == 2023;

CREATE TEMPORARY TABLE jobs_2024 AS
SELECT * EXCLUDE(job_id, job_posted_date)
FROM job_postings_fact
WHERE YEAR(job_posted_date) == 2024;

SELECT * FROM jobs_2023;
SELECT * FROM jobs_2024;

-- 1) Which unique job postings appeared in either 2023 or 2024?

SELECT * FROM jobs_2023
UNION
SELECT * FROM jobs_2024;

SELECT 
    'jobs_2023' AS table_name,
    COUNT(*) AS record_count
FROM jobs_2023
UNION
SELECT 
    'jobs_2024' AS table_name,
    COUNT(*)
FROM jobs_2024;

-- 2) Which job postings appeared across both years, counting duplicates?

SELECT * FROM jobs_2023
UNION ALL
SELECT * FROM jobs_2024;

-- 3) Which job postings appeared in both 2023 and 2024?

SELECT * FROM jobs_2023
INTERSECT
SELECT * FROM jobs_2024;

-- 4) Which job postings appeared in both years, preserving duplicate counts?

SELECT * FROM jobs_2023
INTERSECT ALL
SELECT * FROM jobs_2024;

-- 5) Which job postings appeared in 2023 but not in 2024?

SELECT * FROM jobs_2023
EXCEPT
SELECT * FROM jobs_2024;

-- 6) Which job postings appeared more times in 2023 than 2024, one-for-one?

SELECT * FROM jobs_2023
EXCEPT ALL
SELECT * FROM jobs_2024;