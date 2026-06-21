-- This query examines whether posting frequency differs across active authors:
-- specifically, whether authors who post more regularly tend to receive higher or lower average scores.


WITH post_gaps AS (
  SELECT 
    `by`,
    score,
    timestamp,
    LAG(timestamp, 1) OVER (PARTITION BY `by` ORDER BY timestamp) AS prev_timestamp
  FROM `bigquery-public-data.hacker_news.full`
  WHERE type = 'story' 
    AND score IS NOT NULL
    AND `by` IS NOT NULL
),
average AS (
  SELECT 
    AVG(TIMESTAMP_DIFF(timestamp, prev_timestamp, DAY)) AS avg_diff,
    AVG(score) AS avg_score,
    `by`,
    COUNT(*) AS total_posts
  FROM post_gaps
  GROUP BY `by`
) 
SELECT `by`, avg_diff, avg_score, total_posts
FROM average 
WHERE total_posts >= 10
ORDER BY avg_score DESC