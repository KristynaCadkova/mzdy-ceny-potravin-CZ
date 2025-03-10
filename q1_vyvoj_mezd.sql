
/* Otázka 1: Rostou mzdy ve všech odvětvích, nebo v některých klesají? */

SELECT 
	pr."year" ,
	pr.branch ,
	pr.avg_gross_salary 
FROM t_Kristyna_Cadkova_project_SQL_primary_final AS pr
WHERE pr.branch IS NOT NULL 
ORDER BY pr."year" ;



WITH salary_cte AS (
	SELECT 
		pr."year" ,
		pr.branch ,
		pr.avg_gross_salary,
		LAG(pr.avg_gross_salary) OVER (PARTITION BY pr.branch ORDER BY pr.year) AS previous_year  
	FROM t_Kristyna_Cadkova_project_SQL_primary_final AS pr
),
trend_cte AS (
    SELECT 
        year,
        branch,
        avg_gross_salary,
        previous_year,
        CASE 
            WHEN previous_year IS NOT NULL AND avg_gross_salary < previous_year THEN 'pokles'
            WHEN previous_year IS NOT NULL AND avg_gross_salary = previous_year THEN 'beze změny'
            ELSE 'růst'
        END AS trend
    FROM salary_cte
)
SELECT * 
FROM trend_cte
WHERE branch IS NOT NULL
--AND trend = 'pokles' -- pro odvětví, kdy byl zaznamenán pokles
ORDER BY branch, year;


