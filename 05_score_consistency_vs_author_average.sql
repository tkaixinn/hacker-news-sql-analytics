-- This query identifies stories that significantly over- or underperformed
-- relative to their author's average score: specifically, which stories scored
-- 2x or more above their author's baseline (outperformed) or below 0.5x (underperformed).

WITH author_stats AS (
  SELECT
    `by`,
    AVG(score) AS avg_score
  FROM `bigquery-public-data.hacker_news.full`
  WHERE type = 'story' AND score IS NOT NULL
  GROUP BY `by`
  HAVING COUNT(*) >= 10
),
story_scores AS (
  SELECT
    `by`,
    id,
    score,
    title
  FROM `bigquery-public-data.hacker_news.full`
  WHERE type = 'story' AND score IS NOT NULL
)
SELECT
  s.`by`,
  s.id,
  s.title,
  s.score,
  a.avg_score,
  s.score / a.avg_score AS score_ratio,
  CASE
    WHEN s.score / a.avg_score >= 2 THEN 'outperformed'
    WHEN s.score / a.avg_score < 0.5 THEN 'underperformed'
    ELSE 'normal'
  END AS performance_label
FROM story_scores s
JOIN author_stats a ON s.`by` = a.`by`
ORDER BY score_ratio DESC