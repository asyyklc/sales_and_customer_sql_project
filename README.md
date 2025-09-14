# sales_and_customer_sql_project

# Sales & Customer Data Analysis

For this project, I used the **Sales and Customer Data** dataset from Kaggle: [Link](https://www.kaggle.com/datasets/dataceo/sales-and-customer-data?select=customer_data.csv)
Note: I corrected the 'invoice_date' format in Excel before importing the data into SQL Server to ensure proper date handling for analysis.

## Project Objective

The goal of this project is to analyze sales and customer behavior, answer key business questions, and provide actionable insights. Specifically, I aimed to investigate:

* Total revenue generated per year.
* Customer counts and total sales volume per year.
* Revenue performance by shopping mall and gender.
* Most popular product categories and their sales.
* Customer age groups and their purchasing preferences.
* Payment methods and associated spending patterns.

---

## Step 1: Database & Table Creation

I started by creating a **SQL Server database** and the two source tables (`customer_data` and `sales_data`) using the following commands:

```sql
CREATE DATABASE CustomerDB;
USE CustomerDB;

CREATE TABLE customer_data (...);
CREATE TABLE sales_data (...);
```

Then I loaded the CSV files into the tables using **BULK INSERT**.

---

## Step 2: Data Exploration

I explored the datasets to check their structure and ensure data quality:

```sql
SELECT TOP 100 * FROM customer_data;
SELECT TOP 100 * FROM sales_data;
SELECT invoice_no, COUNT(*) AS invoice_count
FROM sales_data
GROUP BY invoice_no
HAVING COUNT(*) > 1;
```

I checked for duplicate invoices, null values, and confirmed that each invoice could contain multiple items.

---

## Step 3: Creating a Consolidated Table

To simplify analysis, I created a **single source of truth** table `sales_customer_data` by joining sales and customer data:

```sql
CREATE TABLE sales_customer_data (...);

INSERT INTO sales_customer_data
SELECT s.customer_id, s.category, s.quantity, s.price,
       s.quantity * s.price AS total_price, s.invoice_date,
       s.shopping_mall, c.gender, c.age, c.payment_method
FROM sales_data AS s
INNER JOIN customer_data AS c
ON s.customer_id = c.customer_id;
```

This allowed all analyses to be performed in a **centralized, structured table**.

---

## Step 4: Data Analysis

### 4.1 Total Revenue, Customers, and Sales Per Year

| Year | Total Revenue (₺) | Customer Count | Total Sales | Avg Spending per Customer (₺) |
| ---- | ----------------- | -------------- | ----------- | ----------------------------- |
| 2021 | 114,560,570.59    | 45,382         | 136,096     | 2,524.36                      |
| 2022 | 115,436,814.08    | 45,551         | 137,147     | 2,534.23                      |
| 2023 | 21,508,409.58     | 8,524          | 25,469      | 2,523.28                      |

**Observations:**

* 2022 was the peak year for revenue, customer count, and total sales.
* Slight increase from 2021 to 2022 (\~0.76%).
* Significant decline in 2023 (\~81% drop in revenue and customer count).
* Average spending per customer remained stable; decline is due to fewer customers and sales.

---

### 4.2 Mall-Based Revenue

**Top Malls by Revenue:**

* Mall of Istanbul: 50,872,481.68 ₺
* Kanyon: 50,554,231.10 ₺
* Metrocity: 37,302,787.33 ₺

**Revenue by Gender (Top Stores):**

* **Women:**

  * Kanyon: 30,449,278.74 ₺
  * Mall of Istanbul: 30,109,431.59 ₺
* **Men:**

  * Mall of Istanbul: 20,763,050.09 ₺
  * Kanyon: 20,104,952.36 ₺

Some stores show women contributing more than 60% of revenue.

---

### 4.3 Product Categories & Popularity

**Top Categories by Sales Volume:**

1. Clothing: 103,558
2. Cosmetics: 45,465
3. Food & Beverage: 44,277
4. Toys: 30,321
5. Shoes: 30,217

**Top Categories by Mall Revenue:**

* Mall of Istanbul & Kanyon lead in Clothing and Shoes.
* Technology and Cosmetics show strong sales in Kanyon.

---

### 4.4 Payment Methods

| Payment Method | Total Revenue (₺) | Avg Invoice (₺) |
| -------------- | ----------------- | --------------- |
| Cash           | 112,832,243.02    | 2,538.58        |
| Credit Card    | 88,077,123.77     | 2,521.46        |
| Debit Card     | 50,596,427.46     | 2,519.87        |

Cash payments dominate total revenue; average invoice amounts are similar across methods.

---

### 4.5 Age Groups & Category Analysis

**Observations:**

* 18–29: Prefer Clothing, Shoes, and Technology.
* 30–45: Clothing and Shoes dominate both revenue and volume.
* 46–59 & 60+: Clothing remains top; Technology and Shoes are secondary.
* Older customers focus more on Clothing, while younger groups diversify purchases.

---

## Step 5: Key Conclusions

1. **2022 was the peak year**; 2023 shows a steep decline in revenue and customer count.
2. **Average spending per customer remained stable**, indicating the decline is due to reduced transactions, not lower individual spending.
3. **Clothing is consistently the most popular category** across malls and age groups.
4. **Mall of Istanbul and Kanyon** are the highest revenue-generating malls.
5. **Cash payments dominate**, but the spending pattern per payment method is fairly uniform.

