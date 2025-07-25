SELECT * FROM COFFEE.SALES.SHOP_TRANSACTIONS;

---TOTAL REVENUE
SELECT SUM(unit_price * transaction_qty) AS total_sales
FROM COFFEE.SALES.SHOP_TRANSACTIONS;

-----total revenue per day
SELECT DATE(transaction_date) AS day_num,
       SUM(unit_price) AS total_sales,
       COUNT(DISTINCT transaction_id) AS number_of_customers,
       (total_sales / COUNT(DISTINCT transaction_id)) AS order_value
FROM COFFEE.SALES.SHOP_TRANSACTIONS
GROUP BY day_num;

----total revenue per week
SELECT DATE_TRUNC('week', transaction_date) AS week_start,
       SUM(unit_price) AS weekly_sales,
       COUNT(DISTINCT transaction_id) AS number_of_customers,
       (weekly_sales / COUNT(DISTINCT transaction_id)) AS order_value
FROM COFFEE.SALES.SHOP_TRANSACTIONS
GROUP BY week_start;

---total revenue per month
SELECT DATE_TRUNC('month', transaction_date) AS month_start,
       SUM(unit_price) AS monthly_sales,
       COUNT(DISTINCT transaction_id) AS number_of_customers,
       (monthly_sales / COUNT(DISTINCT transaction_id)) AS order_value
FROM COFFEE.SALES.SHOP_TRANSACTIONS
GROUP BY month_start;

-----total revenue per category
SELECT product_category, SUM(unit_price * transaction_qty) AS total_sales_per_category
FROM COFFEE.SALES.SHOP_TRANSACTIONS
GROUP BY product_category
ORDER BY total_sales_per_category DESC;

------ number of customer per day
SELECT DATE(transaction_date) AS transactional_date,
       COUNT(DISTINCT transaction_id) AS number_of_customers
FROM COFFEE.SALES.SHOP_TRANSACTIONS
GROUP BY transaction_date
ORDER BY transaction_date ASC;

----number of customers per hour
SELECT DATE_TRUNC('hour',transaction_time) AS hour,
       COUNT(DISTINCT transaction_id) AS number_of_customer_per_hour
FROM COFFEE.SALES.SHOP_TRANSACTIONS
GROUP BY hour;

-----final query
SELECT transaction_id, 
       store_location,
           product_category,
           product_type,
           unit_price,
           transaction_qty,
           SUM(unit_price*transaction_qty) AS total_revenue,
           COUNT(transaction_id) AS num_of_sales,
           DAYNAME(transaction_date) AS day_name,
           MONTHNAME(transaction_date) AS month_name,
CASE 
     WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
     WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
     WHEN transaction_time BETWEEN '17:00:00' AND '20:00:59' THEN 'Evening'
     ELSE 'Night'
END AS Time_frame,
CASE 
         WHEN SUM(unit_price*transaction_qty) BETWEEN 0 AND 20 THEN 'low'
         WHEN SUM(unit_price*transaction_qty) BETWEEN 21 AND 40 THEN 'Med'
         WHEN SUM(unit_price*transaction_qty) BETWEEN 41 AND 60 THEN 'High'
         ELSE 'Very High'
END AS Spenders_range,
FROM COFFEE.SALES.SHOP_TRANSACTIONS 
GROUP BY time_frame,
             transaction_date,
             unit_price,
             transaction_id, 
             store_location,
             product_category,
             product_type,
             transaction_qty;


