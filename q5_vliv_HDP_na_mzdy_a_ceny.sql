/*
Otázka 5.	Má výška HDP vliv na změny ve mzdách a cenách potravin? 
Neboli, pokud HDP vzroste výrazněji v jednom roce, 
projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
 */


CREATE VIEW gdp AS 
SELECT
    sf.country,
    sf.year,
    sf.gdp,
    ROUND(((sf.gdp - LAG(sf.gdp) OVER (PARTITION BY sf.country ORDER BY sf.year)) 
          / LAG(sf.gdp) OVER (PARTITION BY sf.country ORDER BY sf.year) * 100)::NUMERIC, 2) AS growth_gdp
FROM t_Kristyna_Cadkova_project_SQL_secondary_final sf
WHERE sf.year BETWEEN 2006 AND 2018
AND sf.country = 'Czech Republic'; --mezirocni rust gdp pro CZ

--Sloučení dat do jedné výstupní tabulky pro analýzu vztahů mezi HDP, mzdami a cenami potravin
CREATE VIEW avg_price_salary_gdp_growth AS
SELECT 
    p.year,
    p.avg_price_year,
    p.growth_food,
    s.avg_salary_year,
    s.growth_salary,
    g.gdp,
    g.growth_gdp
FROM yearly_avg_price_growth p
JOIN yearly_avg_salary_growth s ON p.year = s.year
LEFT JOIN gdp g ON p.year = g.year
ORDER BY p.year;


-- vystup
SELECT * FROM avg_price_salary_gdp_growth;

