-------WALMART ANALYSIS-----------

--Product Analysis
---Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.-----

--time_of_day--
SELECT time,
       (CASE WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
             WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
             ELSE "EVENING"
        END) AS TIME_OF_DAY
FROM sales



UPDATE sales_o
 SET TIME_OF_DAY = (CASE WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING" WHEN time               BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON" ELSE "EVENING" END);


 ----DAYNAME/MONTHNAME-----
 SELECT date,
        MONTHNAME(date) AS MONTH_NAME
FROM sales_o;


ALTER TABLE sales_o ADD COLUMN MONTH_NAME VARCHAR(20)

UPDATE sales_o
        SET MONTH_NAME = MONTHNAME(date)


---FEATURE ENGINEERING DONE----
---How many unique cities does the data have?
SELECT DISTINCT city
FROM sales_o
--3 distinct cities

--In which city is each branch?
SELECT  DISTINCT
branch,
       city
FROM sales_o
--A   Yangon
--B   Naypyitaw
--C   Mandalay

--How many unique product lines does the data have?
SELECT  DISTINCT product_line
FROM sales_o
--5

--What is the most common payment method?
SELECT payment,
       COUNT(payment) AS ctn 
FROM sales_o
GROUP BY payment
ORDER BY ctn DESC
---Ewallet

----What is the most selling product line?
SELECT product_line,
       COUNT(product_line) AS prod_line
FROM sales_o
GROUP BY product_line
ORDER BY prod_line DESC
--fashion accessories

--What is the total revenue by month?
SELECT MONTH_NAME,
       SUM(total) AS totz
FROM sales_o
GROUP BY MONTH_NAME
ORDER BY  totz DESC
--january has the highest total revenu generated

---What month had the largest COGS?
SELECT MONTH_NAME,
       SUM(cogs) AS totz
FROM sales_o
GROUP BY MONTH_NAME
ORDER BY  totz DESC
---january has the highest cogs generated

---What product line had the largest revenue?
SELECT product_line,
       SUM(total) AS totz
FROM sales_o
GROUP BY product_line
ORDER BY totz DESC
--FOOD AND BEVERAGE HAD THE HIGHEST REVENUE

--What is the city with the largest revenue?
SELECT city,
       SUM(total) AS totz
FROM sales_o
GROUP BY city
ORDER BY totz DESC

--What product line had the largest VAT?
SELECT product_line,
       ROUND(SUM(tax_pct),0) AS tix
FROM sales_o
GROUP BY product_line
ORDER BY tix DESC
--fiid and beverage had highest VAT

--STEP 1 FIND THE AVERAGE
SELECT AVG(quantity) as avvg
FROM sales_o
--AVG=6

--add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sale
SELECT
  product_line,
  CASE
    WHEN AVG(quantity) > (SELECT AVG(quantity) FROM sales_o) THEN 'Good' ---we must pass the avg calculation and select table needed 
    ELSE 'Bad'
  END AS remark
FROM sales_o
GROUP BY product_line;

---Which branch sold more products than average product sold?
SELECT branch,
       SUM(quantity) as qty
FROM sales_o
GROUP BY branch
HAVING SUM(quantity) > (  SELECT avg(quantity) FROM sales_o)
--all branches sold above avg 

---What is the most common product line by gender?
SELECT product_line
       COUNT(gender) as ctn,
       gender
       
FROM sales_o
GROUP BY gender ,product_line    --- groups the product lines by gender count per sale

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


----sales-----
---Number of sales made in each time of the day per weekday
SELECT TIME_OF_DAY, 
       COUNT(quantity) as qty 
FROM sales_o 
WHERE DAY_NAME = "MONDAY"
GROUP BY TIME_OF_DAY;
--most sales are in the afternoon


--Which of the customer types brings the most revenue?
SELECT customer_type,
       SUM(total) as totz
FROM sales_o
GROUP BY customer_type
--members bring in most of the revenue

--Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city,
       SUM(tax_pct) as VAT
FROM sales_o
GROUP BY city 
ORDER BY  VAT  DESC
--Naypyitaw

---Which customer type pays the most in VAT?
SELECT customer_type,
       	SUM(tax_pct) as VAT
FROM sales_o
GROUP BY customer_type
--MEMBERS

-------CUSTOMERS------
--How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales_o
--2

--How many unique payment methods does the data have?
SELECT DISTINCT payment
FROM sales_o
--3

--What is the most common customer type?
SELECT customer_type,
       COUNT(customer_type) as type
FROM sales_o
GROUP BY customer_type
--member

--Which customer type buys the most?
SELECT  customer_type,
        SUM(quantity) as qty
FROM sales_o
GROUP BY customer_type
---memebers

--What is the gender of most of the customers?
SELECT COUNT(gender) AS genz, 
       customer_type,
       gender
FROM sales_o
GROUP BY gender

--What is the gender distribution per branch?
SELECT branch,
       COUNT(gender) as genz,
       gender
FROM sales_o
GROUP BY  branch,gender


--Which time of the day do customers give most ratings?
SELECT TIME_OF_DAY,
        COUNT(rating) AS RAT 
FROM sales_o
WHERE DAY_NAME = "MONDAY"
GROUP BY TIME_OF_DAY
--AFTERNOON

--Which time of the day do customers give most ratings per branch?
SELECT TIME_OF_DAY,
        COUNT(rating) AS RAT,
        branch
FROM sales_o

GROUP BY branch

---Which day fo the week has the best avg ratings?--
SELECT DAY_NAME,
        round(AVG(rating),2) as RAT  
FROM sales_o
GROUP BY DAY_NAME
ORDER BY RAT DESC
--monday

--Which day of the week has the best average ratings per branch?
SELECT DAY_NAME,
        round(AVG(rating),2) as RAT,
        branch
FROM sales_o
WHERE DAY_NAME = "MONDAY"
GROUP BY branch
ORDER BY RAT DESC