// 11
WITH order_totals AS (
	SELECT
		o.order_id,
		o.customer_id,
		SUM(oi.quantity * oi.unit_price) AS orders_total
	FROM orders AS o
	LEFT JOIN order_items AS oi
		ON o.order_id = oi.order_id
	WHERE o.status != 'cancelled'
	GROUP BY
		o.order_id,
		o.customer_id
)
SELECT
	ot.customer_id,
	c.first_name,
	COUNT(ot.order_id) AS orders,
    COUNT(DISTINCT ot.order_id) AS distinct_orders,
	orders_total,
	AVG(ot.orders_total) AS avg_order,
    MIN(ot.orders_total) AS min_order,
    MAX(ot.orders_total) AS max_order
FROM order_totals AS ot
LEFT JOIN customers AS c
	ON c.customer_id = ot.customer_id
GROUP BY
	ot.customer_id,
	c.first_name;
	
// 12
WITH orders_total AS (
	SELECT
		o.shipping_country,
		o.order_id,
		o.customer_id,
		SUM(oi.quantity * oi.unit_price) AS order_total
	FROM orders AS o
	LEFT JOIN order_items AS oi
		ON o.order_id = oi.order_id
	GROUP BY
		o.shipping_country,
		o.order_id
	ORDER BY o.shipping_country
)
SELECT
	ot.shipping_country,
	COUNT(DISTINCT ot.order_id) AS total_orders,
	COUNT(DISTINCT ot.customer_id) AS total_customers,
	AVG(ot.order_total) AS avg_order,
    MIN(ot.order_total) AS min_order,
    MAX(ot.order_total) AS max_order
FROM orders_total AS ot
GROUP BY ot.shipping_country;

// 13
SELECT
	c.customer_id,
	c.first_name,
	COUNT(*),
	COUNT(order_id),
	COUNT(order_date)
FROM customers AS c
LEFT JOIN orders AS o
	ON o.customer_id = c.customer_id
GROUP BY
	c.customer_id,
	c.first_name;

// 14
SELECT
	c.customer_id,
    c.first_name,
    GROUP_CONCAT(DISTINCT p.product_name) AS all_products
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN order_items AS oi
    ON o.order_id = oi.order_id
LEFT JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY 
	c.customer_id,
    c.first_name;

// 15
SELECT
	c.customer_id,
    c.first_name,
    GROUP_CONCAT(DISTINCT cat.category_name) AS all_categories
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN order_items AS oi
    ON o.order_id = oi.order_id
LEFT JOIN products AS p
    ON oi.product_id = p.product_id
LEFT JOIN categories AS cat
    ON cat.category_id = p.category_id
GROUP BY 
	c.customer_id,
    c.first_name;

// 16
SELECT
	c.customer_id,
	COUNT(DISTINCT o.order_id) FILTER(WHERE status = 'completed') AS completed_orders,
	SUM(oi.quantity * oi.unit_price) FILTER(WHERE status = 'completed') AS completed_revenue,
	COUNT(DISTINCT o.order_id) FILTER(WHERE status = 'cancelled') AS cancelled_orders,
	SUM(oi.quantity * oi.unit_price) FILTER(WHERE status = 'cancelled') AS cancelled_revenue
FROM customers AS c
LEFT JOIN orders AS o
	ON c.customer_id = o.customer_id
LEFT JOIN order_items AS oi
	ON oi.order_id = o.order_id
GROUP BY c.customer_id;

// 17
SELECT
	*,
	CASE
		WHEN price > 100 THEN 'Medium'
		WHEN price > 500 THEN 'Medium'
		WHEN price >= 1000 THEN 'Premium'
		ELSE 'Cheap'
	END AS price_category
FROM products;

// 18
WITH total_spends AS (
	SELECT
		c.customer_id,
		c.first_name,
		COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total
	FROM customers AS c
	LEFT JOIN orders AS o
		ON o.customer_id = c.customer_id
	LEFT JOIN order_items AS oi
		ON oi.order_id = o.order_id
	GROUP BY
		c.customer_id,
		c.first_name
)
SELECT
	*,
	CASE
		WHEN total >= 2500 THEN 'Vip'
		WHEN total >= 1000 THEN 'Active'
		WHEN total > 0 THEN 'Low activity'
		 ELSE 'No purchases'
	END AS customer_segment
FROM total_spends;

// 19
SELECT
	customer_id,
	first_name,
	birth_date,
	CASE
        WHEN (JULIANDAY('now') - JULIANDAY(birth_date)) / 365.25 < 13  THEN 'Gen Alpha'
        WHEN (JULIANDAY('now') - JULIANDAY(birth_date)) / 365.25 < 29  THEN 'Gen Z'
        WHEN (JULIANDAY('now') - JULIANDAY(birth_date)) / 365.25 < 45  THEN 'Millennial'
        WHEN (JULIANDAY('now') - JULIANDAY(birth_date)) / 365.25 < 61  THEN 'Gen X'
        WHEN (JULIANDAY('now') - JULIANDAY(birth_date)) / 365.25 < 80  THEN 'Boomer'
        ELSE 'Silent Generation'
    END AS age_group
FROM customers;

// 20
SELECT
	c.customer_id,
	c.first_name,
	COALESCE(SUM(oi.quantity * oi.unit_price) FILTER(WHERE o.status = 'completed'), 0)  AS total_amount,
	COALESCE(SUM(oi.quantity * oi.unit_price) FILTER(WHERE o.status = 'completed' AND oi.unit_price >= 500), 0)  AS vip_amount,
	COALESCE(SUM(oi.quantity * oi.unit_price) FILTER(WHERE o.status = 'completed' AND oi.unit_price < 500), 0)  AS normal_amount
FROM customers AS c
LEFT JOIN orders AS o
	ON o.customer_id = c.customer_id
LEFT JOIN order_items AS oi
	ON oi.order_id = o.order_id
GROUP BY
	c.customer_id,
	c.first_name;