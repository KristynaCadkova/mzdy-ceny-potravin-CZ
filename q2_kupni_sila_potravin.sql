
/*
Otázka 2.	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední 
srovnatelné období v dostupných datech cen a mezd?
*/

WITH bread_and_milk_power_cte AS (	
	SELECT 
		tfp.type_of_food_item,
		tfp.YEAR,
		round(AVG(tfp.avg_price)::NUMERIC,0) AS price
	FROM t_Kristyna_Cadkova_project_SQL_primary_final tfp
	WHERE (tfp.type_of_food_item ILIKE 'chléb%' --pouze chléb a mléko
		OR tfp.type_of_food_item ILIKE 'mléko%')
		AND tfp.YEAR IN (2006, 2018) -- pouze rok 2006 a 2008
	GROUP BY tfp.type_of_food_item, tfp.YEAR 
),
salary_cte AS (
	SELECT 
		ts.YEAR,
		ROUND(AVG(ts.avg_gross_salary)) AS salary
	FROM t_Kristyna_Cadkova_project_SQL_primary_final ts
	WHERE ts.YEAR IN (2006, 2018)
	GROUP BY ts.YEAR -- průměrná mzda za celou ČR pro první a posledlní rok sledovaného období
)
SELECT 
	s.YEAR,
	f.type_of_food_item,
	s.salary,
	f.price,
	round((s.salary / f.price)::numeric)  AS quantity -- výpočet kolik jednotek (kg/litrů) lze koupit za mzdu
FROM salary_cte s
JOIN bread_and_milk_power_cte f ON s.YEAR = f.YEAR
ORDER BY f.type_of_food_item, s.YEAR;

