# FUTURE_DS_01
# E-Commerce Sales Performance Analysis
### Data Analytics | Business Intelligence | Power BI Ready
**By Katlego Mathebula**

![Dashboard](https://github.com/Katlego-DataLab/FUTURE_DS_01/blob/main/FUTURE%20INTERNS%20DASHBOARD%201.jpeg)

[![Power BI Dashboard](https://img.shields.io/badge/Power%20BI-View%20Dashboard-yellow?style=for-the-badge&logo=powerbi)](https://app.powerbi.com/groups/me/reports/c6baecd6-d8ef-42bc-9e7a-bb9d98181a66?experience=power-bi)

---

## The Business Problem

Many e-commerce businesses collect millions of rows of transactional data but struggle to answer the most basic questions:

- **Which products are actually driving revenue?**
- **Which customers are at risk of leaving?**
- **When do sales peak — and are we staffed for it?**
- **Which markets should we expand into?**

Without a structured analytics pipeline, this data sits unused while businesses make decisions based on gut feel. This project solves that.

---

## What This Project Does

This is a **full end-to-end business analytics pipeline** built in R, transforming raw transactional e-commerce data into a Power BI-ready dashboard and 7 publication-quality charts.

The pipeline covers:

- Raw data ingestion and profiling
- Multi-layer data cleaning and validation
- Feature engineering (revenue, time fields, customer metrics)
- 6 KPI tables built for Power BI
- RFM customer segmentation
- Cohort retention analysis (completed with retention rates)
- 7 ggplot2 visualisations with a consistent professional theme
- Excel + CSV export ready for Power BI import

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| R | Core analytics language |
| tidyverse | Data manipulation and ggplot2 charts |
| lubridate | Date and time engineering |
| janitor | Column name standardisation |
| skimr | Data profiling |
| scales | Number formatting |
| ggtext | Rich text in plot titles |
| patchwork | Multi-panel chart layouts |
| writexl | Excel export for Power BI |
| Power BI | Interactive dashboard layer |

---

## Data Pipeline

```
Raw CSV
   │
   ▼
Step 1 — Load & Profile
   │  glimpse(), skim(), encoding fix
   │
   ▼
Step 2 — Clean
   │  Remove: missing IDs, cancellations,
   │  negative quantities, admin stock codes
   │
   ▼
Step 3 — Feature Engineering
   │  revenue = quantity × unit_price
   │  year, month, quarter, week,
   │  day_of_week, hour_of_day
   │
   ▼
Step 4 — Business Snapshot
   │  Total revenue, orders, customers,
   │  products, avg order value
   │
   ▼
Step 5 — RFM Segmentation
   │  Recency · Frequency · Monetary
   │  7 customer segments
   │
   ▼
Step 6 — KPI Tables (6 tables)
   │  Monthly revenue, top products,
   │  country revenue, time analysis,
   │  segment summary, cohort retention
   │
   ▼
Step 7 — Visualisations (7 charts)
   │
   ▼
Step 8 — Export
   └  Excel workbook + 9 individual CSVs
      → powerbi_exports/
```

---

## Business KPIs Built

### Revenue Performance
- Total revenue across the full period
- Month-on-month growth rate
- Average order value (AOV) trend
- Best and worst performing months

### Product Intelligence
- Top 20 products ranked by revenue
- Units sold vs revenue contribution
- Average unit price per product

### Market Analysis
- Top 15 countries by total revenue
- Revenue share per market
- Average order value by country (expansion signal)

### Customer Segmentation — RFM Analysis
Customers scored on three dimensions:

| Dimension | What it measures |
|-----------|-----------------|
| Recency | How recently they last purchased |
| Frequency | How many times they have purchased |
| Monetary | How much they have spent in total |

**Seven segments produced:**

| Segment | What it means |
|---------|--------------|
| Champions | Bought recently, buy often, spend the most |
| Loyal Customers | Regular buyers with strong spend |
| Potential Loyalists | Recent buyers with growing frequency |
| At-Risk Customers | Used to buy well but going quiet |
| Cannot Lose Them | High frequency buyers going cold |
| Lost Customers | Haven't bought in a long time |
| Need Attention | Mid-range across all three scores |

### Operational Insights
- Orders by day of week and hour of day
- Peak trading windows identified
- Staffing and promotion timing recommendations

### Cohort Retention
- Month-by-month retention rates per acquisition cohort
- Identifies which cohorts have the strongest long-term loyalty

---

## The 7 Charts

### Chart 1 — Monthly Revenue & Average Order Value
Tracks total revenue per month as bars, with average order value as a dashed overlay line. Month-on-month growth percentages label each bar. The coral bar marks the peak revenue month.

![Monthly Revenue](powerbi_exports/charts/01_monthly_revenue.png)

---

### Chart 2 — Top 20 Products by Revenue
Lollipop chart ranking the top 20 products. Dot size encodes units sold, so you can instantly spot high-revenue / low-volume products (high margin) vs high-revenue / high-volume products (high turnover).

![Top Products](https://github.com/Katlego-DataLab/FUTURE_DS_01/blob/main/A%20.jpeg)

---

### Chart 3 — Revenue by Country
Horizontal bar chart of the top 15 markets. Bar colour encodes average order value — darker teal = higher spend per order. The percentage label shows each country's share of top-15 revenue.

![Country Revenue](https://github.com/Katlego-DataLab/FUTURE_DS_01/blob/main/D.jpeg)

---

### Chart 4 — RFM Customer Segmentation Dashboard
Two-panel view. Left panel: bubble chart placing each segment by average frequency (x) and average spend (y), with bubble size showing customer count. Right panel: revenue contribution bar chart showing what each segment is actually worth.

![RFM Segments](https://github.com/Katlego-DataLab/FUTURE_DS_01/blob/main/B%20.jpeg)

---

### Chart 5 — Sales Heatmap (Day × Hour)
Calendar heatmap with days of the week on the y-axis and hours of the day on the x-axis. Darker green = more orders. White labels highlight the top-quartile trading hours — these are the windows to prioritise for promotions and staffing.

![Sales Heatmap](https://github.com/Katlego-DataLab/FUTURE_DS_01/blob/main/C%20.jpeg)

---

### Chart 6 — Customer Cohort Retention
Each row represents customers who made their first purchase in a given month. Each column shows the percentage still purchasing in subsequent months. Green = strong retention, orange/coral = drop-off. This directly answers: *do customers come back?*

![Cohort Retention](powerbi_exports/charts/06_cohort_retention.png)

---

### Chart 7 — Customer Lifetime Value Distribution
Histogram of total spend per customer, coloured by RFM segment. The dashed line marks the median CLV. The long right tail of Champions is clearly visible — the business case for protecting that segment.

![CLV Distribution](powerbi_exports/charts/07_clv_distribution.png)

---

## Key Business Insights

> These are the answers the pipeline was built to find.

**Revenue is seasonal** — the monthly trend chart reveals clear peaks. Marketing and inventory planning should align with these windows rather than be spread evenly across the year.

**A small number of products drives most revenue** — the top 20 products represent a disproportionate share of total sales. Stock availability and promotional budget should be concentrated here first.

**Champions are a small group worth protecting** — this segment generates a significant portion of total revenue from a fraction of the customer base. Losing even a few of them has outsized impact.

**At-risk customers represent recoverable revenue** — customers in the At-Risk and Cannot Lose Them segments have demonstrated they buy. A targeted win-back campaign costs far less than acquiring new customers at the same value.

**A few markets dominate but some smaller markets have higher AOV** — the country chart reveals which markets punch above their weight on spend per order. These are the best candidates for focused expansion investment.

**Peak trading hours are concentrated** — the heatmap shows orders cluster into predictable windows. Promotions, email sends, and staffing can be timed to match actual demand rather than assumption.

---

## Business Recommendations

| Priority | Recommendation | Insight source |
|----------|---------------|----------------|
| High | Launch win-back email campaign for At-Risk and Cannot Lose Them segments | RFM segmentation |
| High | Protect Champions with loyalty rewards or early access offers | CLV distribution |
| Medium | Concentrate inventory investment on top 20 revenue products | Product chart |
| Medium | Schedule promotions during identified peak hours and days | Heatmap |
| Medium | Investigate high-AOV smaller markets for expansion | Country chart |
| Low | Monitor cohorts with strong M1–M3 retention for upsell opportunities | Cohort retention |

---

## Project Files

```
FUTURE_DS_01/
│
├── BusinessSales.csv                        ← raw input data
├── ecommerce_visuals.R                      ← full R pipeline script
├── README.md                                ← this file
│
└── powerbi_exports/
    ├── ecommerce_analysis_export.xlsx       ← all tables in one workbook
    ├── 01_clean_transactions.csv
    ├── 02_monthly_revenue.csv
    ├── 03_top_products.csv
    ├── 04_country_revenue.csv
    ├── 05_rfm_scores.csv
    ├── 06_segment_summary.csv
    ├── 07_cohort_data.csv
    ├── 08_time_analysis.csv
    ├── 09_cohort_retention.csv
    │
    └── charts/
        ├── 01_monthly_revenue.png
        ├── 02_top_products.png
        ├── 03_country_revenue.png
        ├── 04_rfm_segments.png
        ├── 05_sales_heatmap.png
        ├── 06_cohort_retention.png
        └── 07_clv_distribution.png
```

---

## How to Run

```r
# 1. Clone the repository
# 2. Place BusinessSales.csv in your working directory
# 3. Install required packages if needed:

install.packages(c("tidyverse", "lubridate", "scales", "janitor",
                   "skimr", "writexl", "ggtext", "patchwork"))

# 4. Open ecommerce_visuals.R in RStudio and click Source
# All charts and exports will be generated automatically
```

---

## Author

**Katlego Mathebula**
📍 Johannesburg, South Africa
📧 katlego3mathebula@gmail.com

---

*This project demonstrates the ability to bridge data engineering and business strategy — turning raw transactional data into clear, actionable insights that drive real decisions.*
