-- This query checks how concentrated engagement is across stories:
-- specifically, what share of total platform score the top 1% and 5% of stories capture.
WITH new_t AS (
  SELECT 
    PERCENT_RANK() OVER (ORDER BY score DESC) AS percentile_rank, 
    SUM(score) OVER (ORDER BY score DESC) AS running_sum,
    SUM(score) OVER () AS total_score
  FROM `bigquery-public-data.hacker_news.full`
  WHERE type = 'story' 
    AND score IS NOT NULL
)
SELECT '1%' AS cutoff,
       MAX(running_sum) / MAX(total_score) AS pct_of_total_engagement
FROM new_t
WHERE percentile_rank <= 0.01

UNION ALL

SELECT '5%' AS cutoff,
       MAX(running_sum) / MAX(total_score) AS pct_of_total_engagement
FROM new_t
WHERE percentile_rank <= 0.05