
/*
Otázka 3.	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
 */

WITH food_prices AS (
    SELECT 
        tfp.type_of_food_item AS item,
        tfp.YEAR,
        AVG(tfp.avg_price)::NUMERIC AS avg_price 
    FROM t_Kristyna_Cadkova_project_SQL_primary_final tfp
    GROUP BY tfp.type_of_food_item, tfp.YEAR
),
price_comparison AS (
    SELECT -- cena v roce 2006 a 2018 pro každou potravinu
        item,
        MAX(CASE WHEN YEAR = 2006 THEN avg_price END) AS price_2006,
        MAX(CASE WHEN YEAR = 2018 THEN avg_price END) AS price_2018
    FROM food_prices
    GROUP BY item
)
SELECT --Výpočet CAGR (Compound Annual Growth Rate - složená meziroční míra růstu)
    item,
    price_2006,
    price_2018,
    ROUND((POWER(COALESCE(price_2018, 1)::NUMERIC / COALESCE(price_2006, 1)::NUMERIC, 1.0 / 12) - 1) * 100, 2) 
    AS CAGR_percentage
FROM price_comparison
WHERE item IS NOT NULL 
ORDER BY cagr_percentage;

