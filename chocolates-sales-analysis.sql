# 1. List all salespeople from the 'People' table who are on the Team 'Delish'.
SELECT 
    Salesperson
FROM
    people
WHERE
    Team = 'Delish'

# 2. Show all products from the 'Products' table that belong to the 'Bars' category and have a 'Large' size.
SELECT 
    Product, Category, Size
FROM
    Products
WHERE
    category = 'Bars' AND Size = 'Large'
    
# 3. Find all sales records from the 'Sales' table that occurred after '2021-01-11'.
SELECT 
    *
FROM
    sales
WHERE
    Saledate > '2021-01-11'
    
# 4. What is the total number of boxes sold and the total sales amount?
SELECT 
    SUM(Boxes) total_boxes, SUM(Amount) total_amount
FROM
    sales
    
# 5. What is the total sales amount for each product category?
SELECT 
    p.Category, SUM(Amount) total_sales
FROM
    sales s
        JOIN
    products p ON s.PID = p.PID
GROUP BY p.Category

# 6. List the top 3 salespeople by customer count.
SELECT 
    p.Salesperson, SUM(Customers) total_customers
FROM
    sales s
        JOIN
    people p ON s.SPID = p.SPID
GROUP BY p.Salesperson
ORDER BY total_customers DESC
LIMIT 3

# 7. What is the average number of boxes sold per sale for each geographic region?
SELECT 
    g.Region, AVG(boxes) Avg_Boxes_Per_Sale
FROM
    geo g
        JOIN
    sales s ON g.GeoID = s.GeoID
GROUP BY g.Region

# 8. Generate a list of all sales, showing the salesperson's name, product name, and geo location instead of their ID
SELECT 
    p.Salesperson,
    pd.Product,
    g.Geo,
    s.SaleDate,
    s.Amount,
    s.Boxes
FROM
    geo g
        JOIN
    sales s ON g.GeoID = s.GeoID
        JOIN
    people p ON p.SPID = s.SPID
        JOIN
    products pd ON pd.PID = s.PID

# 9. Find all sales made by salespeople located in 'Wellington' for the product 'Milk Bars'.
SELECT 
    *
FROM
    people p
        JOIN
    sales s ON p.SPID = s.SPID
        JOIN
    products pd ON pd.PID = s.PID
WHERE
    Location = 'Wellington'
        AND Product = 'Milk Bars'

# 10. List all products that have never been sold.
SELECT 
    *
FROM
    products pd
        LEFT JOIN
    sales s ON pd.PID = s.PID
WHERE
    pd.PID IS NULL

# 11. Which salespeople have generated total revenue greater than $1800000?
SELECT 
    p.Salesperson, SUM(Amount) total_revenue
FROM
    people p
        JOIN
    sales s ON p.SPID = s.SPID
GROUP BY p.Salesperson
HAVING total_revenue > 1800000

# 12. Find all sales where the number of boxes sold was above the average number of boxes in a single sale.
SELECT 
    *
FROM
    sales
WHERE
    Boxes > (SELECT 
            AVG(Boxes)
        FROM
            sales)

# 13. Show the product that has the highest cost per box.
SELECT 
    Product, Cost_per_box
FROM
    products
ORDER BY Cost_per_box DESC
LIMIT 1
-- OR
SELECT 
    Product, Cost_per_box
FROM
    products
WHERE
    Cost_per_box = (SELECT 
            MAX(Cost_per_box)
        FROM
            products)

# 14. What was the total sales amount for each month in the year 2021?
SELECT 
    MONTH(SaleDate) AS sale_month, SUM(Amount)
FROM
    sales
WHERE
    YEAR(Saledate) = '2021'
GROUP BY sale_month

# 15. Who was the top-selling salesperson (by amount) in the last quarter? (Assume the last quarter is Q4 2021)
SELECT 
    p.Salesperson, SUM(amount) Q4_sales
FROM
    people p
        JOIN
    sales s ON p.SPID = s.SPID
WHERE
    s.SaleDate > '2021-10-01'
        AND s.SaleDate <= '2021-12-31'
GROUP BY p.Salesperson
ORDER BY Q4_sales DESC
LIMIT 1

# 16. Rank the salespeople within each team based on their total sales amount.
Select p.Salesperson, p.Team, sum(s.Amount) total_sales,
Rank() Over (partition by p.Team order by sum(s.Amount) desc) as team_rank
FROM
    people p
        JOIN
    sales s ON p.SPID = s.SPID
    group by  p.Team, p.Salesperson

# 17. For each sale, show the sale amount and the running total of sales amount for that salesperson ordered by date.
select p.Salesperson, s.SaleDate, s.Amount,
Sum(s.Amount) Over (partition by s.SPID order by s.SaleDate) as running_total
from sales s
join people p 
on s.SPID = p.SPID

# 18. Compare each sale's amount to the average sale amount of that salesperson's team.
SELECT s.SPID, s.Amount, p.Team,
avg(s.Amount) over (partition by p.Team) as avg_team_sale
from sales s 
join people p
on s.SPID = p.SPID

# 19. Using a CTE, find the total profit for each product (Profit = (Amount) - (Cost_per_box * Boxes)).
WITH profit_calc AS (
    SELECT s.*, pd.Cost_per_box,
    (s.Amount - (pd.Cost_per_box * s.Boxes)) AS profit
    FROM sales s
    JOIN products pd ON s.PID = pd.PID
)
SELECT 
    pd.Product, ROUND(SUM(pc.profit), 0) AS total_profit
FROM
    products pd
        JOIN
    profit_calc pc ON pd.PID = pc.PID
GROUP BY pd.Product
ORDER BY total_profit DESC

# 20. Identify the month with the highest sales for each region.
WITH RegionalMonthlySales AS (
    SELECT 
        g.Region, 
        MONTH(s.SaleDate) AS sale_month, 
        SUM(s.Amount) AS monthly_sale
    FROM sales s
    JOIN geo g ON s.GeoID = g.GeoID
    GROUP BY g.Region, sale_month
),
RankedMonths AS ( 
    SELECT 
        Region, 
        sale_month, 
        monthly_sale,
        RANK() OVER (PARTITION BY Region ORDER BY monthly_sale DESC) AS sale_rank
    FROM RegionalMonthlySales 
)
SELECT 
    Region, sale_month, monthly_sale, sale_rank
FROM RankedMonths
WHERE sale_rank = 1;

# 21. Create a report that shows the salesperson, their team, their total sales, and what percentage of their team's total sales they contributed.
WITH TeamTotal AS(
SELECT 
    p.Team, SUM(s.Amount) TeamSales
FROM
    people p
        JOIN
    sales s ON p.SPID = s.SPID
GROUP BY p.Team
),
IndividualTotal AS
(SELECT 
    p.Salesperson, p.Team, SUM(s.Amount) IndividualSales
FROM
    people p
        JOIN
    sales s ON p.SPID = s.SPID
GROUP BY p.Salesperson , p.Team
)
SELECT 
    it.Salesperson,
    it.Team,
    it.IndividualSales,
    ROUND((it.IndividualSales / TeamSales) * 100,
            2) AS Team_Percentage
FROM
    IndividualTotal it
        JOIN
    TeamTotal tt ON it.Team = tt.Team
ORDER BY it.Team , Team_Percentage DESC

# 22. Find products that are in the top 3 most sold (by boxes) in every region.
WITH RegionProductSale AS(
SELECT 
    g.Region,
    pd.Product,
    sum(s.Boxes) total_boxes
FROM
    sales s
        JOIN
    geo g ON s.GeoID = g.GeoID
        JOIN
    products pd ON pd.PID = s.PID
    Group by g.Region, pd.Product
),
RegionProductRank AS(
Select Region, Product, total_boxes,
Rank() Over(Partition BY Region Order by total_boxes DESC) AS Region_Rank
from RegionProductSale
)
SELECT 
    Region, Product, total_boxes, Region_Rank
FROM
    RegionProductRank
WHERE
    Region_Rank <= 3
    
# 23. Calculate a 7-day moving average of sales amount.
SELECT
    SaleDate,
    Amount,
    AVG(Amount) OVER (ORDER BY SaleDate ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS 7DayMovingAvg
FROM sales
ORDER BY SaleDate;