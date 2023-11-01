### Sales Analysis
-- 1. Determine yearly and monthly sales figures in terms of gross revenue and absolute margin.
SELECT 
YEAR(created_at) AS year,
MONTH(created_at) AS mes,
FORMAT(SUM(price_usd*items_purchased),2,'es_ESP') AS ventas_brutas,
FORMAT(SUM((price_usd-cogs_usd)*items_purchased),2,'es_ESP') AS margen_usd
FROM orders
GROUP BY year, mes
ORDER BY year, mes;

-- 2. Calculate the average gross sales for each month and year, identifying the top 10 performers. Draw any noteworthy observations.
SELECT
YEAR(created_at) AS year,
MONTH(created_at) AS mes,
AVG(price_usd*items_purchased) AS Ventas_brutas
FROM orders
GROUP BY year, mes
ORDER BY ventas_brutas DESC
LIMIT 10;

-- 3. Identify the product with the highest monetary sales (Gross Sales).
SELECT
oi.product_id,
p.product_name,
FORMAT(SUM(o.price_usd*items_purchased),2,'es_ES') AS Ventas_brutas
FROM orders o LEFT JOIN order_items oi ON o.order_id=oi.order_id 
LEFT JOIN products p ON oi.product_id=p.product_id
GROUP BY product_id;

-- 4. Determine the product with the highest margin.
SELECT
oi.product_id,
p.product_name,
SUM((o.price_usd-o.cogs_usd)*items_purchased) AS Margen
FROM orders o LEFT JOIN order_items oi ON o.order_id=oi.order_id 
LEFT JOIN products p ON oi.product_id=p.product_id
GROUP BY product_id
ORDER BY Margen DESC;

-- 5. Retrieve the release date for each product.
SELECT
product_name,
DATE(created_at) AS fecha_lanzamiento
FROM products;

-- 6. Compute the yearly gross sales, as well as the numerical and percentage margins for each product, and organize the data by product.
SELECT
oi.product_id,
p.product_name AS nombre_producto,
YEAR(o.created_at) AS año,
SUM(o.price_usd*o.items_purchased) AS ventas_brutas,
SUM((o.price_usd-o.cogs_usd)*o.items_purchased) AS margen_numerico,
ROUND(((SUM((o.price_usd-o.cogs_usd)*o.items_purchased)/(SUM(o.price_usd*o.items_purchased)))*100),4) AS margen_porcentual
FROM orders o INNER JOIN order_items oi ON o.order_id=oi.order_id INNER JOIN products p ON p.product_id=oi.product_id
GROUP BY año, oi.product_id, nombre_producto;

-- 7. Identify the months with the highest gross sales, providing the top 3.
SELECT
YEAR(created_at) AS año,
MONTH(created_at) AS mes,
SUM(price_usd*items_purchased) AS ventas_brutas
FROM orders
GROUP BY año, mes
ORDER BY ventas_brutas DESC
LIMIT 3;

### Web Traffic Analysis

-- 8. Identify the advertisements or content pieces that have generated the highest number of sessions.
SELECT
COUNT(distinct website_session_id) AS Cantidad_sesiones,
utm_content AS tipo_campaña
FROM website_sessions
GROUP BY utm_content
ORDER BY cantidad_sesiones DESC;

-- 9. Clarify if sessions equate to users. Provide the count of individual users.
SELECT COUNT(distinct user_id) AS cant_usuarios
FROM website_sessions;

-- 10. Break down users and sessions by source.
SELECT 
utm_source AS fuente,
COUNT(distinct user_id) AS cant_usuarios,
COUNT(website_session_id) AS cant_sesiones
FROM website_sessions
GROUP BY utm_source;

-- 11. Identify the sources that have resulted in the most sales.
SELECT
utm_source AS fuente,
SUM(price_usd*items_purchased) AS ventas_brutas
FROM orders o LEFT JOIN website_sessions ws ON o.user_id=ws.user_id
GROUP BY fuente
ORDER BY ventas_brutas DESC;

-- 12. Determine the months with the highest traffic.
SELECT
YEAR(created_at) AS año,
MONTH(created_at) AS mes,
COUNT(DISTINCT website_session_id) AS cantidad_sesiones
FROM website_sessions
GROUP BY año, mes
ORDER BY cantidad_sesiones DESC;

-- 13. For the highest traffic month, provide the number of sessions from mobile devices and computers.
SELECT
YEAR(created_at) AS año,
MONTH(created_at) AS mes,
device_type,
COUNT(DISTINCT website_session_id) AS cantidad_sesiones
FROM website_sessions
WHERE YEAR(created_at)= 2012 AND MONTH(created_at)=11
GROUP BY año, mes, device_type
ORDER BY cantidad_sesiones DESC;

-- 14. Identify the campaigns that have generated the highest margin for products.
SELECT
p.product_name AS nombre_producto,
ws.utm_campaign AS tipo_campaña,
SUM((o.price_usd-o.cogs_usd)*o.items_purchased) AS margen_numerico
FROM orders o 
LEFT JOIN website_sessions ws ON o.website_session_id=ws.website_session_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p on p.product_id = oi.product_id
GROUP BY nombre_producto, tipo_campaña
ORDER BY margen_numerico DESC;

