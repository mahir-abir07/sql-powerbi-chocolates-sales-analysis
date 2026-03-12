# 🍫 Awesome Chocolates: Sales Performance & Analytics

## 📌 Project Overview
This project is a comprehensive sales analysis for **Awesome Chocolates**, a global confectionery distributor. By leveraging **SQL** for deep-dive data extraction and **Power BI** for executive-level visualization, this project transforms raw transactional data into actionable business insights regarding regional performance, product profitability, and salesperson efficiency.

---

## 🛠️ Tech Stack
* **Database:** SQL (MySQL/PostgreSQL)
* **Data Visualization:** Power BI Desktop
* **Key SQL Concepts:** CTEs, Window Functions (RANK, AVG, SUM OVER), Multi-table Joins, Subqueries, and Data Aggregations.

---

## 📊 Business Dashboard
The interactive Power BI dashboard provides a snapshot of the **$43.6M** in total revenue, tracking trends from 2021 through early 2022.

![Awesome Chocolates Dashboard](image_023377.png)

> 🔗 **[Click Here to View the Interactive Dashboard](PASTE_YOUR_POWER_BI_LINK_HERE)**

### **Key Business Insights:**
* **Regional Performance:** The **APAC** region is the primary revenue driver, accounting for over **50.5%** of global sales.
* **Product Strategy:** **Bars** are the most popular category, though "Bites" show significant potential for growth.
* **Efficiency:** Identified a 9.56% "LBS" (Low Box Shipment) rate, highlighting opportunities for supply chain optimization.

---

## 📂 Database Schema
The analysis is conducted across a relational schema including:
* `sales`: Fact table containing transaction amounts, box counts, and keys.
* `products`: Dimensions for category, size, and manufacturing cost.
* `people`: Salesperson details and team assignments.
* `geo`: Geographic mapping by Region and Country.
* `customers`: Client acquisition data.

---

## 🔍 SQL Analysis: Problem Solving
I have categorized the analysis into three levels of complexity to demonstrate a full range of SQL proficiency.

### 1. Basic Data Exploration
*Focus: Filtering, Sorting, and Basic Aggregations.*

```sql
-- List all salespeople on the 'Delish' team
SELECT Salesperson
FROM people
WHERE Team = 'Delish';

-- Find total revenue and total boxes sold globally
SELECT 
    SUM(Boxes) AS total_boxes, 
    SUM(Amount) AS total_amount
FROM sales;

-- Identify products with the highest manufacturing cost per box
SELECT Product, Cost_per_box
FROM products
ORDER BY Cost_per_box DESC
LIMIT 1;                     

### 2. Intermediate Business Logic
*Focus: Multi-table Joins and Grouped Analysis.
