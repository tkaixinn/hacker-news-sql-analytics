# Hacker News SQL Analytics

Five SQL queries analysing engagement patterns, creator behaviour, and platform growth on Hacker News, using the BigQuery public dataset (48.5M rows).

**Dataset:** `bigquery-public-data.hacker_news.full`  
**Tools:** BigQuery, Python, pandas, matplotlib

---

## Analyses

| # | Question |
|---|---|
| 1 | How concentrated is engagement across stories? |
| 2 | Do authors who post more frequently score higher? |
| 3 | How has platform posting volume changed over time? |
| 4 | Which authors have accumulated the highest total scores? |
| 5 | Which stories over- or underperformed relative to their author's baseline? |

---

## Key Findings

- The top 1% of stories capture 33.9% of total platform score; the top 5% capture 71.3%
- No clear relationship emerged between posting frequency and average score
- Monthly story submissions have grown consistently from 2007 to the present, exceeding 6 million stories cumulatively
- High total score is not purely a function of story volume, some authors accumulate outsized scores through fewer submissions
- The majority of individual stories (3.1M out of 4.8M) score below their author's average baseline; outperformance is rare

---

## Data Quality Note

November 2006 and January 2007 are missing from the dataset, causing `LAG()` to compare non-consecutive months in Query 3. All growth analysis is scoped to mid-2007 onwards. This highlights a real-world consideration: window functions assume consecutive ordering, and sparse early data can produce statistically valid but contextually misleading results.

---

## Notebook

`hacker_news_sql_analytics.ipynb` runs all five queries via the BigQuery Python client and produces visualisations for each analysis.