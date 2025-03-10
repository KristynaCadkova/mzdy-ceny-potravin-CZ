-- Seznamení se strukturou tabulek a zjištění dostupných sloupců 

SELECT * FROM czechia_payroll LIMIT 10; 
SELECT * FROM czechia_price LIMIT 10; 
SELECT * FROM czechia_district cd LIMIT 10;
SELECT * FROM czechia_payroll_industry_branch cpib LIMIT 10;
SELECT * FROM czechia_payroll_unit cpu LIMIT 10;
SELECT * FROM czechia_payroll_value_type cpvt  LIMIT 10;
SELECT * FROM czechia_price_category cpc  LIMIT 10;
SELECT * FROM czechia_payroll_calculation cpc  LIMIT 10;


--Zjištění jaké období je možné porovnávat mezi oběma datovými sadami.

SELECT DISTINCT 
    cp.payroll_year AS year_payroll,
    date_part('year', cp2.date_from) AS year_price
FROM czechia_payroll cp
JOIN czechia_price cp2 
    ON cp.payroll_year = date_part('year', cp2.date_from)
ORDER BY cp.payroll_year;

-- ověření jedinečnosti dat

SELECT value, payroll_year, value_type_code, calculation_code,industry_branch_code, payroll_quarter, COUNT(*) AS duplicate
FROM czechia_payroll
GROUP BY value, payroll_year, value_type_code,calculation_code, industry_branch_code, payroll_quarter
HAVING COUNT(*) > 1;

SELECT cp.value, cp.category_code,cp.region_code, cp.date_from, cp.date_to,COUNT(*) AS duplicate
FROM czechia_price cp 
GROUP BY cp.value, cp.category_code, cp.region_code, cp.date_from, cp.date_to
HAVING COUNT(*) > 1;

-- Vytvoření dočasné tabulky pro průměrné mzdy

CREATE TEMPORARY TABLE temp_salaries AS
SELECT 
	cp.payroll_year AS year, 
	avg(cp.value) AS avg_gross_salary, 
	cpu."name" AS currency, 
	cpib."name"	AS branch 
FROM czechia_payroll cp
JOIN czechia_payroll_unit cpu ON cp.unit_code = cpu.code
JOIN czechia_payroll_industry_branch cpib on cp.industry_branch_code = cpib.code
WHERE 
	cp.value_type_code  = '5958' -- průměrná hrubá mzda na zaměstnance
	AND cp.unit_code = '200' -- částka v CZK
	AND cp.calculation_code  = '100' -- fyzický
	AND cp.payroll_year  BETWEEN 2006 AND 2018
GROUP BY year, cpu.name, cpib.name
ORDER BY "year" ;

-- Vytvoření tabulky cen všech základních potravin.

CREATE TEMPORARY TABLE temp_food_prices AS
SELECT 
    cpc.name AS type_of_food_item,
    cpc.price_value,
    cpc.price_unit,
    AVG(cp.value) AS avg_price,
    date_part('year', cp.date_from) AS year
FROM czechia_price cp
JOIN czechia_price_category cpc ON cp.category_code = cpc.code 
WHERE cp.region_code IS NULL -- vyběr jen pro celou ČR
GROUP BY 
    cp.category_code,
    cpc.name,
    cpc.price_value,
    cpc.price_unit,
    date_part('year', cp.date_from)
ORDER BY year;

-- Vytvoření první finální tabulky, která obsahuje data z obou dočasných tabulek

CREATE TABLE t_Kristyna_Cadkova_project_SQL_primary_final AS
SELECT 
    COALESCE(ts.year, tf.year) AS year, 
    ts.avg_gross_salary,
    ts.currency,
    ts.branch,
    tf.type_of_food_item,
    tf.avg_price,
    tf.price_value,
    tf.price_unit
FROM 
    temp_salaries ts
FULL OUTER JOIN 
    temp_food_prices tf
ON 
    ts.year = tf.year
    AND ts.branch = tf.type_of_food_item
ORDER BY 
    year, tf.type_of_food_item;




--Seznamení se strukturou tabulek a zjistit dostupné sloupce pomocí základních dotazů pro druhou tabulku

SELECT * FROM economies e LIMIT 10;
SELECT * FROM countries c  LIMIT 10;


-- porvnání jestli obě tabulky obsahují všechny evropské státy
SELECT DISTINCT c.country, e.country
FROM countries AS c
FULL JOIN economies AS e ON c.country = e.country
WHERE c.continent = 'Europe';

-- Výběr HDP, GINI koeficient a údaje o populaci ostatních evropských zemí.
CREATE TABLE t_Kristyna_Cadkova_project_SQL_secondary_final AS
WITH europe AS (
    SELECT 
        c.country,
        c.population
    FROM countries AS c
    WHERE c.continent = 'Europe'
)
SELECT 
    e.year,
    europe.country,
    e.gdp,
    e.gini, 
    europe.population
FROM europe
LEFT JOIN economies AS e ON europe.country = e.country
WHERE e.year BETWEEN 2006 AND 2018 OR e.year IS NULL;


SELECT * FROM t_Kristyna_Cadkova_project_SQL_secondary_final;




