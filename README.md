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

> 🔗 **[Click Here to View the Interactive Dashboard]([https://app.powerbi.com/view?r=eyJrIjoiZDQyZmUxNTgtNDRiNC00YmUwLTgyNjAtNTMyYTk2MTIzNzhiIiwidCI6IjExMzdlMDUyLWRiNjktNDMyMS04YWRjLWViNzgwNGRiMjVmNCIsImMiOjEwfQ%3D%3D])**

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
```

### 2. Intermediate Business Logic
*Focus: Multi-table Joins and Grouped Analysis.*

```sql
-- Calculate total sales revenue per product category
SELECT 
    p.Category, 
    SUM(s.Amount) AS total_sales
FROM sales s
JOIN products p ON s.PID = p.PID
GROUP BY p.Category;

-- Identify the top 3 salespeople by customer reach
SELECT 
    p.Salesperson, 
    SUM(s.Customers) AS total_customers
FROM sales s
JOIN people p ON s.SPID = p.SPID
GROUP BY p.Salesperson
ORDER BY total_customers DESC
LIMIT 3;

-- Analysis of average shipment size by Geographic Region
SELECT 
    g.Region, 
    AVG(s.boxes) AS Avg_Boxes_Per_Sale
FROM geo g
JOIN sales s ON g.GeoID = s.GeoID
GROUP BY g.Region;
```

### 3. Advanced Analytical Solutions
*Focus: Window Functions, CTEs, and Complex Subqueries*

### Salesperson Performance Ranking (Window Functions)
```sql
SELECT 
    p.Salesperson, 
    p.Team, 
    SUM(s.Amount) AS total_sales,
    RANK() OVER (PARTITION BY p.Team ORDER BY SUM(s.Amount) DESC) AS team_rank
FROM people p
JOIN sales s ON p.SPID = s.SPID
GROUP BY p.Team, p.Salesperson;
```

### Profitability Analysis (CTEs)
```sql
WITH profit_calc AS (
    SELECT s.*, pd.Cost_per_box,
    (s.Amount - (pd.Cost_per_box * s.Boxes)) AS profit
    FROM sales s
    JOIN products pd ON s.PID = pd.PID
)
SELECT 
    pd.Product, 
    ROUND(SUM(pc.profit), 0) AS total_profit
FROM products pd
JOIN profit_calc pc ON pd.PID = pc.PID
GROUP BY pd.Product
ORDER BY total_profit DESC;
```

### Regional Market Leaders (Top 3 Products per Region)
```sql
WITH RegionProductSale AS (
    SELECT g.Region, pd.Product, SUM(s.Boxes) AS total_boxes
    FROM sales s
    JOIN geo g ON s.GeoID = g.GeoID
    JOIN products pd ON pd.PID = s.PID
    GROUP BY g.Region, pd.Product
),
RegionProductRank AS (
    SELECT *,
    RANK() OVER(PARTITION BY Region ORDER BY total_boxes DESC) AS Region_Rank
    FROM RegionProductSale
)
SELECT * FROM RegionProductRank WHERE Region_Rank <= 3;
```

---

## 💡 Conclusion & Recommendations

* **🌎 Regional Expansion:** Given the significant success in the **APAC** region, the business should conduct a deep-dive analysis into the specific sales strategies used there. Adapting these proven tactics for the **Canada** and **USA** markets could help bridge the current performance gap.
* **🍫 Product Optimization:** Marketing efforts and inventory priority should remain focused on **"Bars."** As the primary driver of both sales volume and total revenue, this category offers the highest return on investment.
* **🏆 Performance Tracking:** Implement a structured monthly **"Top Performer"** incentive program. By utilizing the **team-based ranking system**, management can foster healthy competition and data-driven recognition across all sales teams.

---

