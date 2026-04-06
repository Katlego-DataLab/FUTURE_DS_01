# FUTURE_DS_01

#  E-Commerce Sales Performance Analysis

###  Data Analytics | Business Intelligence | Power BI Ready

**By Katlego Mathebula**

![ image alt](https://github.com/Katlego-DataLab/FUTURE_DS_01/blob/main/FUTURE%20INTERNS%20DASHBOARD%201.jpeg)
[POWER BI DASHBOARD](https://app.powerbi.com/groups/me/reports/c6baecd6-d8ef-42bc-9e7a-bb9d98181a66?experience=power-bi)
## Project Overview

This project delivers a **full end-to-end business analytics solution** using transactional e-commerce data.

The goal was to transform raw sales data into actionable business insights, answering key questions around:

- Revenue performance over time
- Top-performing products and markets
- Customer behavior and segmentation
- Operational trends (time-based sales patterns)

The final output is a Power BI-ready dataset and dashboard, designed to support real business decision-making.



## Business Problem

Many businesses collect large amounts of transactional data but struggle to:

- Identify what drives revenue
- Understand customer value and retention
- Detect underperforming products or markets
- Make data-driven strategic decisions

This project solves that by building a structured analytics pipeline + KPI framework.

##  Tech Stack

**Languages & Tools:**

- R (tidyverse, dplyr, ggplot2)
- Power BI (Dashboarding)
- Excel (Data export layer)

**Libraries Used:**

- `tidyverse` → Data manipulation
- `lubridate` → Date handling
- `janitor` → Cleaning column names
- `skimr` → Data profiling
- `scales` → Formatting
- `writexl` → Export to Power BI

##  Data Processing Pipeline

### **1** Data Loading

- Imported raw dataset (`BusinessSales.csv`)
- Performed initial structure checks and profiling

### **2** Data Cleaning

- Removed:

  - Missing customer IDs
  - Cancelled transactions
  - Negative quantities/prices
  - Internal/test product codes
- Standardized column names

### **3** Feature Engineering

Created key business fields:

- Revenue = Quantity × Unit Price
- Time features:

  - Year, Month, Quarter
  - Day of week, Hour of day
- Cleaned product descriptions & country names


##  Key KPIs Created

###  Business Performance

- Total Revenue
- Total Orders
- Unique Customers
- Average Order Value (AOV)

###  Time-Based Analysis

- Monthly revenue trends
- Seasonal patterns

###  Product Performance

- Top-selling products
- Revenue contribution per product

###  Market Analysis

- Revenue by country
- Customer distribution

###  Operational Insights

- Peak sales hours
- Best-performing days

##  Customer Segmentation (RFM Analysis)

Customers were segmented using:

- **Recency** → How recently they purchased
- **Frequency** → How often they purchase
- **Monetary** → How much they spend

### Segments Created:

- Champions
- Loyal Customers
- At-Risk Customers
- Lost Customers
- Potential Loyalists

This allows businesses to:

- Target high-value customers
- Run retention campaigns
- Increase lifetime value

## Key Business Insights

 **Revenue Drivers**

- A small group of products contributes the majority of revenue
- High-performing months indicate strong seasonality

 **Customer Value**

- “Champions” generate a significant portion of total revenue
- At-risk customers represent recoverable revenue opportunities

 **Market Opportunities**

* A few countries dominate sales → expansion potential exists

**Operational Efficiency**

- Certain hours and days consistently outperform others → optimize staffing & marketing timing


##  Deliverables

The project exports **Power BI-ready datasets**:

- Clean Transactions
- Monthly Revenue
- Top Products
- Country Revenue
- Customer Segments (RFM)
- Cohort Data (Retention)
- Time Analysis

 Located in:

```
powerbi_exports/
```

---

## Power BI Dashboard

The dashboard answers:

- How is revenue trending over time?
- What are the top products?
- Which countries generate the most revenue?
- Which customers are most valuable?
- When do sales peak?


##  Business Recommendations

- Focus marketing on **high-value customer segments (Champions & Loyal Customers)**
- Implement **win-back campaigns** for at-risk customers
- Optimize inventory around **top-performing products**
- Expand in **high-performing countries**
- Schedule promotions during **peak sales periods**


##  Author

**Katlego Mathebula**
📍 Johannesburg, South Africa
📧 [katlego3mathebula@gmail.com]





This project demonstrates my ability to bridge data and business strategy, turning raw data into clear, actionable insights that drive decision-making.

