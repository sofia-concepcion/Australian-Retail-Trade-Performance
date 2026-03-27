-- Query 1: Total turnover by year and category
SELECT
    year,
    category,
    ROUND(SUM(turnover_m), 1) AS total_turnover_m
FROM retail_turnover
WHERE category != 'Total (Industry)'
GROUP BY year, category
ORDER BY year, total_turnover_m DESC;


'-- Query 2: YoY growth by category
WITH annual AS (
    SELECT year, category,
    SUM(turnover_m) AS turnover_m
    FROM retail_turnover
    WHERE category != 'Total (Industry)'
    GROUP BY year, category
)
SELECT
    a.year,
    a.category,
    ROUND(a.turnover_m, 1) AS current_year_m,
    ROUND(b.turnover_m, 1) AS prior_year_m,
    ROUND((a.turnover_m - b.turnover_m) / b.turnover_m * 100, 2) AS yoy_growth_pct
FROM annual a
JOIN annual b
    ON a.category = b.category
    AND a.year = b.year + 1
ORDER BY a.year DESC, yoy_growth_pct ASC;


-- Query 3: Latest 12 months — which categories are growing fastest?
SELECT
    category,
    ROUND(SUM(turnover_m), 1) AS total_m
FROM retail_turnover
WHERE date >= date('now', '-12 months')
    AND category != 'Total (Industry)'
GROUP BY category
ORDER BY total_m DESC;