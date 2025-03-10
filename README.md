# mzdy-ceny-potravin-CZ
Repozitář obsahuje SQL skripty a datový podklad pro analýzu životní úrovně v ČR. Projekt zkoumá vztah mezi mzdami a cenami potravin za období 2006–2018.
**ŽIVOTNÍ ÚROVEŇ OBČANŮ A DOSTUPNOST ZÁKLADNÍCH POTRAVIN**

Autor: Kristýna Čadková  
Email: [kristyna.posingerova@seznam.cz](mailto:kristyna.posingerova@seznam.cz)  
Discord: kristyna_90682

**O PROJEKTU**  
Projekt analyzuje vztah mezi mzdami a cenami potravin v České republice za období 2006–2018 pomocí SQL. Cílem je zkoumat trendy v mzdách, cenách potravin a vliv HDP na tyto ukazatele. Projekt dále zahrnuje dodatečná data o HDP, GINI koeficientu a populaci evropských států.

**DATOVÉ SADY A ZDROJE**

_Primární datové sady (ČR):_

- czechia_payroll: Data o mzdách z Portálu otevřených dat ČR
- czechia_price: Data o cenách potravin z Portálu otevřených dat ČR
- Doplňkové číselníky: czechia_payroll_calculation, czechia_payroll_industry_branch, czechia_payroll_unit, czechia_payroll_value_type, czechia_price_category

_Dodatečné datové sady (Evropa):_

- countries: Informace o zemích (hlavní město, měna, národní jídlo, populace)
- economies: Ekonomické ukazatele (HDP, GINI, daňová zátěž) pro daný stát a rok

Poznámka: V sekundární datové sadě chybí cca 7 % údajů pro HDP a 22 % pro GINI.

**VÝSLEDNÉ TABULKY**

_t_kristyna_cadkova_project_SQL_primary_final_  
Obsahuje sjednocená data o mzdách a cenách potravin pro ČR.  
Sloupce:

- year – kalendářní rok
- avg_gross_salary – průměrná hrubá mzda pro daný rok
- currency – měna (např. CZK)
- branch – odvětví, ke kterému se mzda vztahuje
- type_of_food_item – druh potraviny
- avg_price – průměrná cena potraviny v Kč
- price_value – počet měrných jednotek, za které je cena uvedena
- price_unit – měrná jednotka (např. kg, l)

_t_kristyna_cadkova_project_SQL_secondary_final_  
Obsahuje data o evropských státech.  
Sloupce:

- year – kalendářní rok
- country – jméno země
- gdp – hrubý domácí produkt
- gini – GINI koeficient
- population – velikost populace

**SQL SKRIPTY**

- 01_create_tables.sql – Vytvoření tabulek a import sjednocených dat
- q1_vyvoj_mezd.sql – Analýza meziročního vývoje mezd dle odvětví
- q2_kupni_sila_potravin.sql – Výpočet kupní síly (kolik potravin lze zakoupit za průměrnou mzdu)
- q3_potraviny_s_nizkym_rustem.sql – Identifikace potravin s nejnižším meziročním růstem (CAGR)
- q4_extremni_rust_cen.sql – Hledání případů, kdy růst cen potravin převyšuje růst mezd o více než 10 %
- q5_vliv_HDP_na_mzdy_a_ceny.sql – Analýza vlivu HDP na vývoj mezd a cen potravin
