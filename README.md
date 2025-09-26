# Data-Cleaning
Hello I have created a Sql project where I clean messy data and turn it into readable data This will be containing two sql files and two csv's

1. DataCleaningBSM.sql
This script focuses on cleaning and preparing the raw Best Selling Manga dataset.

Removed duplicates using ROW_NUMBER() and CTEs.

Standardized text fields (e.g., trimming spaces, fixing country names, consistent capitalization).

Handled missing/null values by updating authors, publishers, demographics, and countries.

Converted approximate sales into absolute numbers for analysis.

Extracted and normalized regional sales into separate columns.

Dropped unnecessary columns after cleaning.
The result is a structured and standardized table (mangasales2) ready for analysis.

2. EDA_BSM.sql
This script performs exploratory data analysis (EDA) on the cleaned dataset.

Counted rows, unique titles, authors, and publishers.

Examined publication year ranges and demographics distribution.

Generated insights on top-selling manga by total sales.

Analyzed sales by region and compared regional vs global sales.

Looked at sales efficiency by comparing sales vs. volume count.
