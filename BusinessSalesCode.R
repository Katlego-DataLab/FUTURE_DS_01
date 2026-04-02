# E-COMMERCE SALES PERFORMANCE ANALYSIS
# Analyst: Katlego Mathebula 
# Date: 26 March 2026
# Dataset: UCI E-Commerce Dataset (Kaggle)
# Purpose: Business KPI analysis ready for Power BI dashboard


## Step 1: Loading all the required  libraries for the project

library(tidyverse)       # Core data manipulation & ggplot2
library(lubridate)       # Date/time handling
library(scales)          # Number formatting
library(janitor)         # Column name cleaning
library(skimr)           # Quick data profiling
library(writexl)         # Export to Excel for Power BI
  
  

## Step 2 : Loading the CSV file, will be working with 
raw_data <- read_csv("BusinessSales.csv", 
                     locale = locale(encoding = "latin1"),  # UCI dataset uses latin1
                     show_col_types = FALSE)

# Quick first look
glimpse(raw_data)
skim(raw_data)


#  Step 3: DATA CLEANING


# --- Step A : Standardise column names ------------------
Sale_data <- raw_data %>%
  clean_names()   # Converts "Invoice No" → "invoice_no".

# Print cleaned column names
cat("\n--- Column names after cleaning ---\n")
print(names(Sale_data))


# --- Step B: Understand missing values ----------------------------------------
cat("\n--- Missing values per column ---\n")
print(colSums(is.na(Sale_data)))


# --- Step C: Remove problematic rows ------------------------------------------
Sales_clean <- Sale_data %>%
  
  # Remove rows with no customer ID (can't do customer-level analysis)
  filter(!is.na(customer_id)) %>%
  
  # Remove cancellations (invoices starting with "C")
  filter(!str_starts(invoice_no, "C")) %>%
  
  # Remove rows with zero or negative quantity (data errors / returns)
  filter(quantity > 0) %>%
  
  # Remove rows with zero or negative unit price
  filter(unit_price > 0) %>%
  
  # Remove test/internal stock codes
  filter(!stock_code %in% c("POST", "D", "M", "BANK CHARGES", "PADS", "DOT", "CRUK")) %>%
  filter(!str_detect(stock_code, "^[A-Z]+$"))  # Pure-letter codes are usually admin entries

cat("\n--- Rows remaining after cleaning ---\n")
cat("Original rows: ", nrow(raw_data), "\n")
cat("Clean rows:    ", nrow(Sales_clean), "\n")
cat("Rows removed:  ", nrow(raw_data) - nrow(Sales_clean), "\n")


# --- Step D: Fix data types & create key business fields ---------------------
Sales_clean <- Sales_clean %>%
  
  mutate(
    # Parse invoice date — UCI Kaggle format is "12/1/2010 8:26" (M/D/YYYY H:MM)
    # We try mdy_hm first; fall back to dmy_hm if any NAs are produced
    invoice_date = {
      parsed <- mdy_hm(invoice_date, quiet = TRUE)
      if (sum(is.na(parsed)) > sum(is.na(invoice_date))) {
        parsed <- dmy_hm(invoice_date, quiet = TRUE)
      }
      parsed
    },
    
    # Derived date fields (used heavily in Power BI slicers)
    year          = year(invoice_date),
    month         = month(invoice_date, label = TRUE, abbr = FALSE),
    month_num     = month(invoice_date),
    quarter       = paste0("Q", quarter(invoice_date)),
    week_num      = week(invoice_date),
    day_of_week   = wday(invoice_date, label = TRUE, abbr = FALSE),
    hour_of_day   = hour(invoice_date),
    
    # Core financial metric
    revenue       = quantity * unit_price,
    
    # Standardise country name
    country       = str_to_title(trimws(country)),
    
    # Tidy product description
    description   = str_to_title(trimws(description)),
    
    # Customer ID as character (UCI stores as "17850.0" — strip decimal)
    customer_id   = as.character(as.integer(as.numeric(customer_id)))
  )

cat("\n--- Sample of cleaned data ---\n")
print(head(Sales_clean, 10))



##  Step 4: FEATURE ENGINEERING


# --- Overall business snapshot --------------------------------
total_revenue    <- sum(Sales_clean$revenue)
total_orders     <- n_distinct(Sales_clean$invoice_no)
total_customers  <- n_distinct(Sales_clean$customer_id)
total_products   <- n_distinct(Sales_clean$stock_code)
avg_order_value  <- total_revenue / total_orders

cat("\n===============\n")
cat("  BUSINESS SNAPSHOT\n")
cat("===============\n")
cat("  Total Revenue:        ", dollar(total_revenue), "\n")
cat("  Total Orders:         ", comma(total_orders), "\n")
cat("  Unique Customers:     ", comma(total_customers), "\n")
cat("  Unique Products:      ", comma(total_products), "\n")
cat("  Avg Order Value (AOV):", dollar(avg_order_value), "\n")
cat("===============\n")


##  --- RFM Segmentation (Recency · Frequency · Monetary) -------------------
# R = How recently a customer bought
# F = How often they buy
# M = How much they spend total

analysis_date <- max(Sales_clean$invoice_date) + days(1)  # One day after last purchase

rfm <- Sales_clean %>%
  group_by(customer_id) %>%
  summarise(
    recency   = as.numeric(difftime(analysis_date, max(invoice_date), units = "days")),
    frequency = n_distinct(invoice_no),
    monetary  = sum(revenue),
    .groups   = "drop"
  ) %>%
  # Score each dimension 1–4 (4 = best)
  mutate(
    r_score = ntile(-recency,   4),   # Lower recency (more recent) = better
    f_score = ntile(frequency,  4),
    m_score = ntile(monetary,   4),
    rfm_score  = r_score + f_score + m_score,
    
    # Segment label for business use
    segment = case_when(
      rfm_score >= 11             ~ "Champions",
      rfm_score >= 9              ~ "Loyal Customers",
      rfm_score >= 7 & r_score >= 3 ~ "Potential Loyalists",
      rfm_score >= 7              ~ "At-Risk Customers",
      r_score <= 2 & f_score >= 3 ~ "Cannot Lose Them",
      r_score <= 2                ~ "Lost Customers",
      TRUE                        ~ "Need Attention"
    )
  )

cat("\n--- RFM Segment Distribution ---\n")
rfm %>%
  count(segment, sort = TRUE) %>%
  mutate(pct = percent(n / sum(n), accuracy = 1)) %>%
  print()



##  Step 5: KPI ( Key Performance Indicators)  ANALYSIS TABLES
 # This answers if  the business is doing well or not !

# --- KPI 1: Revenue by Month ---------------------------
monthly_revenue <-Sales_clean %>%
  group_by(year, month_num, month, quarter) %>%
  summarise(
    revenue        = sum(revenue),
    orders         = n_distinct(invoice_no),
    customers      = n_distinct(customer_id),
    avg_order_value = revenue / orders,
    .groups = "drop"
  ) %>%
  arrange(year, month_num)

cat("\n--- Monthly Revenue ---\n")
print(monthly_revenue)


# --- KPI 2: Top 20 Products by Revenue -----------------
top_products <- Sales_clean %>%
  group_by(stock_code, description) %>%
  summarise(
    total_revenue  = sum(revenue),
    total_quantity = sum(quantity),
    order_count    = n_distinct(invoice_no),
    avg_unit_price = mean(unit_price),
    .groups = "drop"
  ) %>%
  arrange(desc(total_revenue)) %>%
  head(20) %>%
  mutate(revenue_rank = row_number())

cat("\n--- Top 10 Products by Revenue ---\n")
print(top_products %>% head(10) %>% select(revenue_rank, description, total_revenue, total_quantity))


# --- KPI 3: Revenue by Country (Top 15) ---------------------------------------
country_revenue <- Sales_clean %>%
  group_by(country) %>%
  summarise(
    revenue        = sum(revenue),
    orders         = n_distinct(invoice_no),
    customers      = n_distinct(customer_id),
    avg_order_value = revenue / orders,
    .groups = "drop"
  ) %>%
  arrange(desc(revenue)) %>%
  head(15) %>%
  mutate(revenue_share = percent(revenue / sum(revenue), accuracy = 0.1))

cat("\n--- Top 10 Countries by Revenue ---\n")
print(country_revenue %>% head(10))


## --- KPI 4: Day-of-Week & Hour Analysis (for operational insights) -----------
time_analysis <- Sales_clean %>%
  group_by(day_of_week, hour_of_day) %>%
  summarise(
    orders  = n_distinct(invoice_no),
    revenue = sum(revenue),
    .groups = "drop"
  )


## --- KPI 5: Customer Segment Revenue --------
segment_summary <- rfm %>%
  group_by(segment) %>%
  summarise(
    customer_count  = n(),
    avg_recency     = round(mean(recency), 1),
    avg_frequency   = round(mean(frequency), 1),
    avg_monetary    = round(mean(monetary), 2),
    total_revenue   = sum(monetary),
    .groups = "drop"
  ) %>%
  arrange(desc(total_revenue)) %>%
  mutate(revenue_share = percent(total_revenue / sum(total_revenue), accuracy = 0.1))

cat("\n--- Customer Segment Summary ---\n")
print(segment_summary)


##  --- KPI 6: Cohort retention prep (month customer first purchased) ----------
cohort_data <- Sales_clean %>%
  group_by(customer_id) %>%
  mutate(first_purchase_month = floor_date(min(invoice_date), "month")) %>%
  ungroup() %>%
  mutate(
    cohort_month   = floor_date(invoice_date, "month"),
    months_since   = as.integer(
      interval(first_purchase_month, cohort_month) / months(1)
    )
  ) %>%
  group_by(first_purchase_month, months_since) %>%
  summarise(
    customers = n_distinct(customer_id),
    revenue   = sum(revenue),
    .groups   = "drop"
  )



##  Step 6: EXPORT FOR POWER BI


# Create output folder if it doesn't exist
if (!dir.exists("powerbi_exports")) dir.create("powerbi_exports")

# Convert factor columns to character before export (Because Excel doesn't handle factors)
Sales_export <- Sales_clean %>%
  mutate(
    month       = as.character(month),
    day_of_week = as.character(day_of_week)
  )

monthly_export <- monthly_revenue %>%
  mutate(month = as.character(month))

## --- Export all tables to a single Excel workbook (easiest Power BI import) --
write_xlsx(
  list(
    "Clean Transactions"  = Sales_export,
    "Monthly Revenue"     = monthly_export,
    "Top Products"        = top_products,
    "Country Revenue"     = country_revenue,
    "Time Analysis"       = time_analysis,
    "RFM Scores"          = rfm,
    "Segment Summary"     = segment_summary,
    "Cohort Data"         = cohort_data
  ),
  path = "powerbi_exports/ecommerce_analysis_export.xlsx"
)

cat("\n All tables exported to: powerbi_exports/ecommerce_analysis_export.xlsx\n")
cat("   Ready to connect to Power BI!\n")

# --- Also export individual CSVs (alternative import method) ------------------
write_csv(Sales_export,       "powerbi_exports/01_clean_transactions.csv")
write_csv(monthly_export,  "powerbi_exports/02_monthly_revenue.csv")
write_csv(top_products,    "powerbi_exports/03_top_products.csv")
write_csv(country_revenue, "powerbi_exports/04_country_revenue.csv")
write_csv(rfm,             "powerbi_exports/05_rfm_scores.csv")
write_csv(segment_summary, "powerbi_exports/06_segment_summary.csv")
write_csv(cohort_data,     "powerbi_exports/07_cohort_data.csv")
write_csv(time_analysis,   "powerbi_exports/08_time_analysis.csv")

cat("Individual CSVs also saved to: powerbi_exports/\n")

## Insights for GitHub readme 


cat("\n\n===============\n")
cat("  KEY BUSINESS INSIGHTS\n")
cat("===============\n")

# Best month
best_month <- monthly_revenue %>% slice_max(revenue, n = 1)
cat(" Best Revenue Month: ", as.character(best_month$month), best_month$year,
    "→", dollar(best_month$revenue), "\n")

# Top country
cat("Top Country:        ", country_revenue$country[1],
    "→", dollar(country_revenue$revenue[1]),
    "(", country_revenue$revenue_share[1], "of total)\n")

# Top product
cat("Top Product:        ", top_products$description[1],
    "→", dollar(top_products$total_revenue[1]), "\n")

# Champion customers
champions <- rfm %>% filter(segment == "Champions")
cat(" Champion Customers: ", nrow(champions), "customers worth",
    dollar(sum(champions$monetary)), "\n")

# At-risk flag
at_risk <- rfm %>% filter(segment %in% c("At-Risk Customers", "Cannot Lose Them"))
cat("At-Risk Customers:  ", nrow(at_risk), "customers worth",
    dollar(sum(at_risk$monetary)), "— prioritise win-back campaigns\n")

cat("===============\n")
cat("\n nalysis complete. Open powerbi_exports/ to begin your dashboard.\n\n")



### END OF CODE ###