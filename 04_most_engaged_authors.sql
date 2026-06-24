-- This query identifies the most impactful authors on the platform:
-- specifically, which authors accumulate the highest total score across all their stories,
-- filtered to authors with at least 10 stories posted to exclude low-volume outliers.

WITH engagement AS (
  SELECT 
    `by`,
    SUM(CASE WHEN type = 'story' THEN 1 ELSE 0 END) AS stories_posted,
    SUM(CASE WHEN type = 'comment' THEN 1 ELSE 0 END) AS comments_made,
    SUM(score) AS total_score,
    AVG(score) AS avg_score
FROM `bigquery-public-data.hacker_news.full`
WHERE `by` IS NOT NULL 
GROUP BY `by`
HAVING SUM(CASE WHEN type = 'story' THEN 1 ELSE 0 END) >= 10 
),
ranked AS (
  SELECT 
        `by`,
        stories_posted, 
         comments_made, 
         total_score, 
         avg_score,
         DENSE_RANK() OVER (ORDER BY total_score DESC) AS rank
  FROM engagement
)
SELECT *
FROM ranked 
WHERE rank <=25 
ORDER BY rank