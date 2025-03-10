/*
4.	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
*/

CREATE VIEW yearly_avg_price_growth AS
SELECT 
    year,
    ROUND(AVG(avg_price)::NUMERIC,2) AS avg_price_year,
    ROUND(
        (((AVG(avg_price) - LAG(AVG(avg_price)) OVER (ORDER BY year)) 
          / LAG(AVG(avg_price)) OVER (ORDER BY year)) * 100)::NUMERIC, 
        2
    ) AS growth_food
FROM t_Kristyna_Cadkova_project_SQL_primary_final
GROUP BY year;
 -- mezirocni rust cen vsech potravin 


CREATE VIEW yearly_avg_salary_growth AS
SELECT 
    year,
    ROUND(AVG(avg_gross_salary)::NUMERIC) AS avg_salary_year,
    ROUND(
        (((AVG(avg_gross_salary) - LAG(AVG(avg_gross_salary)) OVER (ORDER BY year)) 
          / LAG(AVG(avg_gross_salary)) OVER (ORDER BY year)) * 100)::NUMERIC, 
        2
    ) AS growth_salary
FROM t_Kristyna_Cadkova_project_SQL_primary_final
GROUP BY year;
 -- mezirocni rust mezd

--Porovnání růstu cen potravin a mezd, hledání let s vyšším než 10% rozdílem
WITH comparison_food_salary AS (
    SELECT 
        YEAR,
        yearly_avg_salary_growth.growth_salary
    FROM yearly_avg_salary_growth
)
SELECT 
    cfs.YEAR,  
    cfs.growth_salary,  
    yapg.growth_food  
FROM comparison_food_salary cfs
JOIN yearly_avg_price_growth yapg 
    ON cfs.YEAR = yapg.YEAR;  


--Porovnání růstu cen potravin a mezd, hledání let s vyšším než 10% rozdílem
SELECT 
    p.year, 
    p.growth_food, 
    s.growth_salary, 
    (p.growth_food - s.growth_salary) AS difference -- Rozdíl mezi růstem cen potravin a mezd
FROM yearly_avg_price_growth p
JOIN yearly_avg_salary_growth s ON p.year = s.year
WHERE (p.growth_food - s.growth_salary) > 10 -- roky, kde rozdíl překročil 10 %
ORDER BY p.year;

