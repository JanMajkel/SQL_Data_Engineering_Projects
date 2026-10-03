/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/

SELECT 
    sd.skills, 
    COUNT(jpf.*) AS demand_count, 
    CAST(ROUND(MEDIAN(jpf.salary_year_avg), 0) AS INT) AS median_salary,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    ROUND((CAST(ROUND(MEDIAN(jpf.salary_year_avg), 0) AS INT) * LN(COUNT(jpf.*)))/1_000_000, 2) AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
HAVING COUNT(jpf.*) > 100
ORDER BY optimal_score DESC
LIMIT 25;

/*
Here's a breakdown of the most optimal skills for Data Engineers, based on both high demand and high salaries:

Top Skills by Optimal Score:
- Terraform leads the list with a $184K median salary and 193 postings, resulting in the highest overall "optimal score".
- Python and SQL dominate demand (over 1100 postings each), with strong median salaries of $135K and $130K, respectively.
- AWS (783 postings, $137K median), Spark (503 postings, $140K median), and Airflow (386 postings, $150K median) are all highly sought-after cloud and big data technologies.
- Kafka offers high compensation ($145K median) and solid demand (292 postings).
- Tools like Snowflake, Azure, and Databricks each have 250–475 postings and median salaries between $128–$137K.

DevOps & Engineering Tools:
- Airflow ($150K), Kubernetes ($150.5K), and Docker ($135K) stand out for their mix of demand and top median salaries.
- Git ($140K/208 postings) and Github ($135K/127 postings) have broad utility and competitive compensation.

Noteworthy Languages:
- Java (303 postings, $135K median) and Scala (247 postings, $137K median) remain strong choices for well-paid data engineering roles.
- Go ($140K/113 postings) is another programming language with excellent compensation.

Databases & Cloud:
- Redshift ($130K/274 postings), GCP ($136K/196 postings), Hadoop ($135K/198 postings), NoSQL ($134.4K/193 postings), and MongoDB ($135.8K/136 postings) add to a well-rounded data engineering skill set.
- R, Pyspark, and BigQuery each deliver competitive salaries and meet the threshold for demand.

Summary:
Skills that consistently appear near the top balance a strong combination of market demand (job security) and financial benefit. Python, SQL, AWS, Spark, Airflow, and Terraform are particularly strategic for both immediate opportunities and longer-term career growth in data engineering.

────────────┬──────────────┬───────────────┬─────────────────┬───────────────┐
│   skills   │ demand_count │ median_salary │ ln_demand_count │ optimal_score │
│  varchar   │    int64     │     int32     │     double      │    double     │
├────────────┼──────────────┼───────────────┼─────────────────┼───────────────┤
│ terraform  │          193 │        184000 │             5.3 │          0.97 │
│ python     │         1133 │        135000 │             7.0 │          0.95 │
│ sql        │         1128 │        130000 │             7.0 │          0.91 │
│ aws        │          783 │        137320 │             6.7 │          0.91 │
│ airflow    │          386 │        150000 │             6.0 │          0.89 │
│ spark      │          503 │        140000 │             6.2 │          0.87 │
│ kafka      │          292 │        145000 │             5.7 │          0.82 │
│ snowflake  │          438 │        135500 │             6.1 │          0.82 │
│ azure      │          475 │        128000 │             6.2 │          0.79 │
│ java       │          303 │        135000 │             5.7 │          0.77 │
│ scala      │          247 │        137290 │             5.5 │          0.76 │
│ git        │          208 │        140000 │             5.3 │          0.75 │
│ kubernetes │          147 │        150500 │             5.0 │          0.75 │
│ databricks │          266 │        132750 │             5.6 │          0.74 │
│ redshift   │          274 │        130000 │             5.6 │          0.73 │
│ gcp        │          196 │        136000 │             5.3 │          0.72 │
│ nosql      │          193 │        134415 │             5.3 │          0.71 │
│ hadoop     │          198 │        135000 │             5.3 │          0.71 │
│ pyspark    │          152 │        140000 │             5.0 │           0.7 │
│ mongodb    │          136 │        135750 │             4.9 │          0.67 │
│ docker     │          144 │        135000 │             5.0 │          0.67 │
│ go         │          113 │        140000 │             4.7 │          0.66 │
│ r          │          133 │        134775 │             4.9 │          0.66 │
│ bigquery   │          123 │        135000 │             4.8 │          0.65 │
│ github     │          127 │        135000 │             4.8 │          0.65 │
├────────────┴──────────────┴───────────────┴─────────────────┴───────────────┤
│ 25 rows                                                           5 columns │
└─────────────────────────────────────────────────────────────────────────────┘
*/