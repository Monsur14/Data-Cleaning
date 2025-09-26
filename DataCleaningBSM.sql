Select * From bestsellingmanga; 

-- Data Cleaning 
-- 1. Remove all Duplicate Values 
-- 2. Standardize the data (basic grammer) 
-- 3. Null Values or blank values 
-- 4. Remove any columns uneccesary 

Create table mangasales 
Like bestsellingmanga; 

Select * 
From mangasales; 

Insert into mangasales 
Select * 
From bestsellingmanga; 

Select *, 
row_number() over( partition by Title,Author,Publisher, Demographic, 
Volumes, Start_Year,End_Year,Approx_Sales_Million,Notes,Countries_Sold,
Adaptation,Regional_Sales,Languages) as row_num 
From mangasales; 

SHOW COLUMNS FROM mangasales; 

SHOW CREATE TABLE mangasales; 

ALTER TABLE mangasales CHANGE COLUMN ﻿Title Title TEXT; 

Select *, row_number() over( partition by Title,Author,Publisher, Demographic, 
Volumes, Start_Year,End_Year,Approx_Sales_Million,Notes,Countries_Sold,
Adaptation,Regional_Sales,Languages) as row_num 
From mangasales; 

With duplicate_cte as 
(
Select *, row_number() over( partition by Title,Author,Publisher, Demographic, 
Volumes, Start_Year, End_Year,Approx_Sales_Million,Notes,Countries_Sold, Adaptation,Regional_Sales,Languages) as row_num 
From mangasales 
) 
Select * 
From duplicate_cte 
Where row_num > 1; 

CREATE TABLE mangasales2 ( 
`Title` text, 
`Author` text, 
`Publisher` text, 
`Demographic` text, 
`Volumes` int DEFAULT NULL, 
`Start_Year` int DEFAULT NULL, 
`End_Year` int DEFAULT NULL, 
`Approx_Sales_Million` int DEFAULT NULL, 
`Notes` text, Countries_Sold text, 
`Adaptation` text, 
`Regional_Sales` text, 
`Languages` text, 
`Row_Num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci; 

Select * 
From mangasales2 
Where Row_Num > 1; 

Insert into mangasales2 
Select *, row_number() 
over( partition by Title,Author,Publisher, Demographic, 
Volumes, Start_Year, End_Year,Approx_Sales_Million,Notes,
Countries_Sold, Adaptation,Regional_Sales,Languages) as row_num 
From mangasales; 

Delete 
From mangasales2 
Where Row_Num > 1; 

Select * 
From mangasales2; 

-- Standardizing data 

Select Countries_Sold, TRIM(Countries_Sold) 
From mangasales2; 

Update mangasales2 
Set Countries_Sold = TRIM(Countries_Sold); 

Select Countries_Sold 
From mangasales2 
Where Countries_Sold = "Brasil"; 

Update mangasales2 
Set Countries_Sold = "Brazil" 
Where Countries_Sold = "Brasil"; 

Select * 
From mangasales2; 

UPDATE mangasales2 
SET Title = CONCAT(UCASE(LEFT(Title, 1)), LCASE(SUBSTRING(Title, 2))); 

Select Distinct Author, Replace(Author, '_',' ') 
From mangasales2; 

Update mangasales2 
Set Author = Replace(Author, '_',' '); 

Select * 
From mangasales2;

SELECT Demographic,
       CONCAT(UPPER(LEFT(Demographic, 1)), LOWER(SUBSTRING(Demographic, 2)))
FROM mangasales2;

Update mangasales2
Set Demographic = CONCAT(UPPER(LEFT(Demographic, 1)), LOWER(SUBSTRING(Demographic, 2)));

Select * 
From mangasales2;

Select distinct languages,
	Case languages
		When 'En' Then 'English'
        When 'Fr' Then 'French'
        When 'Jp only' Then 'Japanese only'
        When 'ES / PT' Then 'Spanish / Portuguese'
		When 'JP' Then 'Japanese'
		Else languages
	End As Languages
From mangasales2;

Update mangasales2
Set languages = Case languages
		When 'En' Then 'English'
        When 'Fr' Then 'French'
        When 'Jp only' Then 'Japanese only'
        When 'ES / PT' Then 'Spanish / Portuguese'
		When 'JP' Then 'Japanese'
		Else languages
End;

Select * 
From mangasales2;

Select distinct regional_sales,
	Case 
		When regional_sales Like 'JP:%' Then Replace(regional_sales,'JP:','Japan: ')
        When regional_sales Like 'DE:%' Then Replace(regional_sales,'DE:','Germany: ')
        When regional_sales Like 'FR:%' Then Replace(regional_sales,'FR:','France: ')
        When regional_sales Like 'US:%' Then Replace(regional_sales,'US:','United States: ')
		Else regional_sales
	End As regional_sales
From mangasales2;

Update mangasales2
Set regional_sales = Case 
		When regional_sales Like 'JP:%' Then Replace(regional_sales,'JP:','Japan: ')
        When regional_sales Like 'DE:%' Then Replace(regional_sales,'DE:','Germany: ')
        When regional_sales Like 'FR:%' Then Replace(regional_sales,'FR:','France: ')
        When regional_sales Like 'US:%' Then Replace(regional_sales,'US:','United States: ')
		Else regional_sales
End;

Select * 
From mangasales2;

Select distinct regional_sales
From mangasales2;


SELECT distinct
    CASE 
        WHEN regional_sales LIKE '%:%' 
            THEN TRIM(SUBSTRING_INDEX(regional_sales, ':', 1))
        ELSE TRIM(regional_sales)  
    END AS Region,
    
    CASE 
		WHEN regional_sales = '' THEN NULL
        WHEN TRIM(SUBSTRING_INDEX(regional_sales, ':', -1)) = '??' THEN -1
        When SUBSTRING_INDEX(regional_sales,':',-1) Like '%M'
			Then CAST(Replace(Trim(Substring_index(regional_sales,':',-1)),'M','') as unsigned)*1000000
        WHEN regional_sales LIKE '%:%' THEN cast(TRIM(SUBSTRING_INDEX(regional_sales, ':', -1)) as unsigned)
        ELSE 0  
    END AS Region_Sales
FROM mangasales2;

ALTER TABLE mangasales2
ADD COLUMN Region TEXT,
ADD COLUMN Region_Sales INT;

Select * 
From mangasales2;

Update mangasales2
Set 
	Region = Case
			WHEN regional_sales LIKE '%:%' 
            THEN TRIM(SUBSTRING_INDEX(regional_sales, ':', 1))
        ELSE TRIM(regional_sales)  
    END,
    
    Region_Sales = Case
				WHEN regional_sales = '' THEN NULL
        WHEN TRIM(SUBSTRING_INDEX(regional_sales, ':', -1)) = '??' THEN -1
        When SUBSTRING_INDEX(regional_sales,':',-1) Like '%M'
			Then CAST(Replace(Trim(Substring_index(regional_sales,':',-1)),'M','') as unsigned)*1000000
        WHEN regional_sales LIKE '%:%' THEN cast(TRIM(SUBSTRING_INDEX(regional_sales, ':', -1)) as unsigned)
        ELSE 0  
    END;
    
Select * 
From mangasales2;

Select Approx_Sales_Million,
Approx_Sales_Million * 1000000 as sales
From mangasales2;

Alter table mangasales2
Add Column Sales Int;

Update mangasales2
Set Sales = Approx_Sales_Million * 1000000;


-- Null Values or Blanks

Select title, author
From mangasales2
Where title Like 'Attack on titan' And author = '';


SELECT Title, Author
FROM mangasales2
WHERE Title LIKE '%Attack on Titan%'
  AND (Author IS NULL OR Author = '');
  
Update mangasales2
Set author = 'Hajime Isayama'
WHERE Title LIKE '%Attack on Titan%'
  AND (Author IS NULL OR Author = '');

SELECT Title, Author
FROM mangasales2
WHERE Title LIKE '%Kochikame%'
  AND (Author IS NULL OR Author = '');

Update mangasales2
Set author = 'Osamu Akimoto'
WHERE Title LIKE '%Kochikame%'
  AND (Author IS NULL OR Author = '');

SELECT Title, Author
FROM mangasales2
WHERE Title LIKE '%Dragon ball%'
  AND (Author IS NULL OR Author = '');
  
Update mangasales2
Set author = 'Akira Toriyama'
WHERE Title LIKE '%Dragon ball%'
  AND (Author IS NULL OR Author = '');
  
Select * 
From mangasales2;

SELECT Title, Author
FROM mangasales2
WHERE Title LIKE '%Demon slayer%'
  AND (Author IS NULL OR Author = '');
  
Update mangasales2
Set author = 'Koyoharu Gotouge'
WHERE Title LIKE '%Demon slayer%'
  AND (Author IS NULL OR Author = '');
  
SELECT Title, Author
FROM mangasales2
WHERE Author LIKE '%Takehiko Inoue%'
  AND (Title IS NULL OR Title = '');
  
Update mangasales2
Set title = 'Bleach'
WHERE Author LIKE '%Takehiko Inoue%'
  AND (Title IS NULL OR Title = '');
  
SELECT Title, Author
FROM mangasales2
WHERE Author LIKE '%Osamu Akimoto%'
  AND (Title IS NULL OR Title = '');

Update mangasales2
Set title = 'Kochikame'
WHERE Author LIKE '%Osamu Akimoto%'
  AND (Title IS NULL OR Title = '');

SELECT Title, Author
FROM mangasales2
WHERE Author LIKE '%Masashi Kishimoto%'
  AND (Title IS NULL OR Title = '');
  
Update mangasales2
Set title = 'Naruto'
WHERE Author LIKE '%Masashi Kishimoto%'
  AND (Title IS NULL OR Title = '');
  
Update mangasales2
Set title = 'Demon slayer'
WHERE Author LIKE '%Koyoharu Gotouge%'
  AND (Title IS NULL OR Title = '');
  
Update mangasales2
Set title = 'Attack on titan'
WHERE Author LIKE '%Hajime Isayama%'
  AND (Title IS NULL OR Title = '');
  
Select * 
From mangasales2;

Update mangasales2
Set title = 'Dragon ball'
WHERE Author LIKE '%Akira Toriyama%'
  AND (Title IS NULL OR Title = '');
  
Select *
From mangasales2
Where (author IS NULL Or author = '')
And (title IS NULL Or title = '');

Delete
From mangasales2
Where (author IS NULL Or author = '')
And (title IS NULL Or title = '');

Select * 
From mangasales2;

SELECT Title, publisher,demographic
FROM mangasales2
WHERE Title LIKE '%Dragon ball%'
  AND (publisher IS NULL OR publisher = '')
  AND (demographic IS NULL OR demographic = '');
  
Update mangasales2
Set publisher = 'Shueisha', demographic = 'Shōnen'
WHERE title LIKE '%Dragon ball%'
  AND (publisher IS NULL OR publisher = '%Shueisha%')
  AND (demographic IS NULL OR demographic = '%Shōnen%');
  
Update mangasales2
Set publisher = 'Shueisha'
WHERE title LIKE '%Dragon ball%'
  AND (publisher IS NULL OR publisher = '');
  
Update mangasales2
Set demographic = 'Shōnen'
WHERE title LIKE '%Dragon ball%'
  AND (demographic IS NULL OR demographic = '');
  
Update mangasales2
Set demographic = 'Shōnen'
WHERE title LIKE '%Attack on titan%'
  AND (demographic IS NULL OR demographic = '');
  
Update mangasales2
Set publisher = 'Kodansha'
WHERE title LIKE '%Attack on titan%'
  AND (publisher IS NULL OR publisher = '');
  
Update mangasales2
Set publisher = 'Shueisha'
WHERE title LIKE '%Demon slayer%'
  AND (publisher IS NULL OR publisher = '');

Update mangasales2
Set demographic = 'Shōnen'
WHERE title LIKE '%Demon slayer%'
  AND (demographic IS NULL OR demographic = '');
  
Update mangasales2
Set publisher = 'Shueisha'
WHERE title LIKE '%Naruto%'
  AND (publisher IS NULL OR publisher = '');
  
Update mangasales2
Set demographic = 'Shōnen'
WHERE title LIKE '%Naruto%'
  AND (demographic IS NULL OR demographic = '');
  
Update mangasales2
Set publisher = 'Shueisha'
WHERE title LIKE '%Kochikame%'
  AND (publisher IS NULL OR publisher = '');
  
Update mangasales2
Set demographic = 'Shōnen'
WHERE title LIKE '%Kochikame%'
  AND (demographic IS NULL OR demographic = '');


Update mangasales2
Set publisher = 'Shueisha'
WHERE title LIKE '%Bleach%'
  AND (publisher IS NULL OR publisher = '');
  
Select *
From mangasales2;

Update mangasales2
Set title = 'Slam dunk'
Where title = 'Bleach';

SELECT *
FROM mangasales2
WHERE Countries_Sold IS NULL 
   OR Countries_Sold = '';

UPDATE mangasales2
SET Countries_Sold = NULL
WHERE Countries_Sold = '';

Select adaptation
From mangasales2
Where adaptation IS NULL
	Or adaptation = ''
    Or adaptation = '???';
    
Update mangasales2
Set adaptation = 'Anime'
Where adaptation IS NULL
	Or adaptation = ''
    Or adaptation = '???';

UPDATE mangasales2
SET Countries_Sold = 'Japan'
WHERE Countries_Sold = ''
	Or Countries_Sold = Null;
    
Select *
From mangasales2;

UPDATE mangasales2
SET Countries_Sold = 'Japan'
WHERE Countries_Sold IS NULL;

Update mangasales2
Set languages = 'Japanese'
Where languages = ''
	Or languages IS NULL;
    
Update mangasales2
Set region = NULL 
Where region = '';

Update mangasales2
Set region = 'Japan'
Where region = 'Mixed Data';

Select *
From mangasales2;

SELECT  Region_Sales
FROM mangasales2
WHERE Region_Sales IN (0, -1);

UPDATE mangasales2
SET Region_Sales = 150000000
WHERE Region_Sales IN (0, -1);

UPDATE mangasales2
SET Region = 'France'
WHERE Region = 'Unknown';

Select Languages
From mangasales2
Where Languages = 'Spanish / Portuguese';

Update mangasales2
Set Languages = 'Portuguese'
Where Languages = 'Spanish / Portuguese';

Select Languages
From mangasales2
Where Languages = 'Japanese only';

Update mangasales2
Set Languages = 'Japanese'
Where Languages = 'Japanese only';

Select distinct Countries_Sold, languages
From mangasales2;

Update mangasales2
Set Countries_Sold = 'United States'
Where Countries_Sold = 'U.S.A';

Update mangasales2
Set Countries_Sold = 'United States'
Where Countries_Sold = 'US';

Update mangasales2
Set Countries_Sold = 'United Kingdom'
Where Countries_Sold = 'UK';

Select distinct title,author
From mangasales2;

Update mangasales2
Set author = 'Masashi Kishimoto'
Where author = '';

Update mangasales2
Set demographic = 'Shōnen'
Where demographic = '';

Select distinct title, author
From mangasales2
Where title IS NULL;

Update mangasales2
Set title = NULL 
Where title = '';

Select distinct title, author
From mangasales2;

Update mangasales2
Set author = NULL
Where title IS NULL;

Update mangasales2
Set author = 'Koyoharu Gotouge'
Where trim(title) = 'Demon slayer';

Update mangasales2
Set author = 'Akira Toriyama'
Where trim(title) = 'Dragon ball';

Update mangasales2
Set author = 'Osamu Akimoto'
Where trim(title) = 'Kochikame';

Update mangasales2
Set author = 'Takehiko Inoue'
Where trim(title) = 'Slam dunk';

Update mangasales2
Set title = 'Attack on titan'
Where trim(author) = 'Hajime Isayama';

Update mangasales2
Set title = 'Demon slayer'
Where trim(author) = 'Koyoharu Gotouge';

Update mangasales2
Set title = 'Kochikame'
Where trim(author) = 'Osamu Akimoto';

Update mangasales2
Set title = 'Slam dunk'
Where trim(author) = 'Takehiko Inoue';

Update mangasales2
Set title = 'Dragon ball'
Where trim(author) = 'Akira Toriyama';

Update mangasales2
Set title = 'Naruto'
Where trim(author) = 'Masashi Kishimoto';

Update mangasales2
Set author = 'Masashi Kishimoto'
Where trim(title) = 'Naruto';

Update mangasales2
Set author = 'Hajime Isayama'
Where trim(title) = 'Attack on titan';

Update mangasales2
Set author = 'Takehiko Inoue'
Where trim(title) = 'Slam dunk';

Update mangasales2
Set title = 'Slam dunk'
Where trim(author) = 'Takehiko Inoue';

-- Removing Columns

Alter table mangasales2
Drop Column Approx_Sales_Million, 
Drop Column Row_Num,
Drop Column Regional_Sales,
Drop Column Notes;

DELETE
FROM mangasales2
WHERE title IS NULL
  AND author IS NULL;
  
Select *
From mangasales2;