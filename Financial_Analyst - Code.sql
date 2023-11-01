### Sales Analysis
-- 1. Determine yearly and monthly sales figures in terms of gross revenue and absolute margin.
SELECT 
YEAR(created_at) AS year,
MONTH(created_at) AS month,
FORMAT(SUM(price_usd*items_purchased),2,'es_ESP') AS gross_sales,
FORMAT(SUM((price_usd-cogs_usd)*items_purchased),2,'es_ESP') AS margin_usd
FROM orders
GROUP BY year, month
ORDER BY year, month;

-- 2. Calculate the average gross sales for each month and year, identifying the top 10 performers. Draw any noteworthy observations.
SELECT
YEAR(created_at) AS year,
MONTH(created_at) AS month,
AVG(price_usd*items_purchased) AS gross_sales
FROM orders
GROUP BY year, month
ORDER BY gross_sales DESC
LIMIT 10;

-- 3. Identify the product with the highest monetary sales (Gross Sales).
SELECT
oi.product_id,
p.product_name,
FORMAT(SUM(o.price_usd*items_purchased),2,'es_ES') AS gross_sales
FROM orders o LEFT JOIN order_items oi ON o.order_id=oi.order_id 
LEFT JOIN products p ON oi.product_id=p.product_id
GROUP BY product_id;

-- 4. Determine the product with the highest margin.
SELECT
oi.product_id,
p.product_name,
SUM((o.price_usd-o.cogs_usd)*items_purchased) AS Margin
FROM orders o LEFT JOIN order_items oi ON o.order_id=oi.order_id 
LEFT JOIN products p ON oi.product_id=p.product_id
GROUP BY product_id
ORDER BY Margin DESC;

-- 5. Retrieve the release date for each product.
SELECT
product_name,
DATE(created_at) AS release_date
FROM products;

-- 6. Compute the yearly gross sales, as well as the numerical and percentage margins for each product, and organize the data by product.
SELECT
oi.product_id,
p.product_name,
YEAR(o.created_at) AS year,
SUM(o.price_usd*o.items_purchased) AS gross_sales,
SUM((o.price_usd-o.cogs_usd)*o.items_purchased) AS numerical_margin,
ROUND(((SUM((o.price_usd-o.cogs_usd)*o.items_purchased)/(SUM(o.price_usd*o.items_purchased)))*100),4) AS porcentage_margin
FROM orders o INNER JOIN order_items oi ON o.order_id=oi.order_id INNER JOIN products p ON p.product_id=oi.product_id
GROUP BY year, oi.product_id, product_name;

-- 7. Identify the months with the highest gross sales, providing the top 3.
SELECT
YEAR(created_at) AS year,
MONTH(created_at) AS month,
SUM(price_usd*items_purchased) AS gross_sales
FROM orders
GROUP BY year, month
ORDER BY gross_sales DESC
LIMIT 3;

### Web Traffic Analysis

-- 8. Identify the advertisements or content pieces that have generated the highest number of sessions.
SELECT
COUNT(distinct website_session_id) AS session_quantity,
utm_content AS content_type
FROM website_sessions
GROUP BY utm_content
ORDER BY session_quantity DESC;

-- 9. Clarify if sessions equate to users. Provide the count of individual users.
SELECT COUNT(distinct user_id) AS quant_users
FROM website_sessions;

-- 10. Break down users and sessions by source.
SELECT 
utm_source AS source,
COUNT(distinct user_id) AS quant_users,
COUNT(website_session_id) AS quant_sessions
FROM website_sessions
GROUP BY utm_source;

-- 11. Identify the sources that have resulted in the most sales.
SELECT
utm_source AS source,
SUM(price_usd*items_purchased) AS gross_sales
FROM orders o LEFT JOIN website_sessions ws ON o.user_id=ws.user_id
GROUP BY source
ORDER BY gross_sales DESC;

-- 12. Determine the months with the highest traffic.
SELECT
YEAR(created_at) AS year,
MONTH(created_at) AS month,
COUNT(DISTINCT website_session_id) AS quant_sessions
FROM website_sessions
GROUP BY year, month
ORDER BY quant_sessions DESC;

-- 13. For the highest traffic month, provide the number of sessions from mobile devices and computers.
SELECT
YEAR(created_at) AS year,
MONTH(created_at) AS month,
device_type,
COUNT(DISTINCT website_session_id) AS quant_sessions
FROM website_sessions
WHERE YEAR(created_at)= 2012 AND MONTH(created_at)=11
GROUP BY year, month, device_type
ORDER BY quant_sessions DESC;

-- 14. Identify the campaigns that have generated the highest margin for products.
SELECT
p.product_name ,
ws.utm_campaign AS campaign_type,
SUM((o.price_usd-o.cogs_usd)*o.items_purchased) AS numerical_margin
FROM orders o 
LEFT JOIN website_sessions ws ON o.website_session_id=ws.website_session_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p on p.product_id = oi.product_id
GROUP BY product_name, campaign_type
ORDER BY numerical_margin DESC;

