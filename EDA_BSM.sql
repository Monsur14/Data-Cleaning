Select *
From mangasales2;

-- Explatory Data Analysis

-- 1.number of rows
Select count(*)
From mangasales2;

-- 2. number of authors, titles, and publishers
Select count(distinct title), count(distinct author), count(distinct publisher)
From mangasales2;

-- 3. range of start_year and end_year earliest to latest
Select start_year,end_year
From mangasales2 
Order by start_year, end_year desc;

-- 4. distribution of demographics
Select distinct demographic
From mangasales2;

-- Sales Analysis

-- 5. Top 10 manga by sales
Select title, author, countries_sold, sum(sales) as total_sales
From mangasales2
Group by title, author, countries_sold
Order by total_sales desc
Limit 10;

-- 6. Sales by region
Select region, region_sales
From mangasales2;

-- 7. region sales vs sales
Select region, sum(region_sales), sum(sales)
From mangasales2
Group by region;

-- 8. high sales low volumes
Select title, author, volumes, sales
From mangasales2
Order by volumes asc, sales desc;

-- END OF EDA




