-- This query examines how story posting activity changes over time:
-- specifically, how monthly story counts fluctuate, including month-to-month changes and cumulative posting volume.

WITH first_calc AS (
SELECT EXTRACT(YEAR FROM timestamp) AS year,
       EXTRACT(MONTH FROM timestamp) AS month,
       COUNT(*) AS monthly_count
FROM `bigquery-public-data.hacker_news.full`
WHERE type = 'story' AND timestamp IS NOT NULL 
GROUP BY year, month 
),
rolling AS (
  SELECT monthly_count,
         LAG(monthly_count, 1) OVER (ORDER BY year, month) AS prev_count,
         SUM(monthly_count) OVER (ORDER BY year, month) AS roll_count,
         year, 
         month
  FROM first_calc
)
SELECT prev_count, 
       year, 
       month,
       monthly_count,
      (monthly_count - prev_count)/ prev_count* 100 AS mth_change, 
      roll_count
FROM rolling 
ORDER BY year, month 