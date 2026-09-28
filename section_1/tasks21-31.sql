// 21
WITH order_info AS (
	SELECT
		o.order_id,
		o.order_date,
		strftime('%Y-%m', order_date) AS order_month,
		oi.quantity,
		oi.unit_price,
		p.product_name,
		c.category_name,
		c.parent_category_id
	FROM orders AS o
	JOIN order_items AS oi
		ON oi.order_id = o.order_id
	JOIN products AS p
		ON p.product_id = oi.product_id
	JOIN categories AS c
		ON p.category_id = c.category_id
	WHERE o.status = 'completed'
)
SELECT
	order_month,
	SUM(quantity * unit_price) AS overall_total,
	SUM(quantity * unit_price) FILTER(WHERE category_name = 'Computers') AS computers_total,
	SUM(quantity * unit_price) FILTER(WHERE category_name = 'Phones') AS phones_total,
	SUM(quantity * unit_price) FILTER(WHERE category_name = 'Accessories') AS accessories_total
FROM order_info
GROUP BY order_month;

// 22
WITH avg_rating_table AS (
	SELECT
		p.product_id,
		p.product_name,
		AVG(pr.rating) AS avg_rating
	FROM products AS p
	LEFT JOIN product_reviews AS pr
		ON p.product_id = pr.product_id
	GROUP BY
		p.product_id,
		p.product_name
)
SELECT
	product_id,
	product_name,
	avg_rating,
	CASE
		WHEN avg_rating >= 4.5 THEN 'Excellent'
		WHEN avg_rating >= 4.0 THEN 'Good'
		WHEN avg_rating >= 3.0 THEN 'Average'
		WHEN avg_rating < 3.0 THEN 'Poor'
		ELSE 'n/a'
	END AS rating_category
FROM avg_rating_table;
	
// 23
WITH orders_onfo AS (
	SELECT
		c.customer_id,
		c.first_name,
		c.registration_date,
		MAX(o.order_date) AS last_order_date,
		COUNT(DISTINCT o.order_id) AS total_orders,
		SUM(oi.unit_price * oi.quantity) AS total_amount
	FROM customers AS c
	LEFT JOIN orders AS o
		ON o.customer_id = c.customer_id
	JOIN order_items AS oi
		ON oi.order_id = o.order_id
	WHERE o.status = 'completed'
	GROUP BY 
		c.customer_id,
		c.first_name
)
SELECT
	*,
	CASE
		WHEN total_orders >= 2 AND total_amount > 2000 THEN 'VIP'
		WHEN total_orders < 2 AND total_amount > 1000 THEN 'Potential VIP'
		WHEN (JULIANDAY('now') - JULIANDAY(last_order_date)) / 365.25 > 90 THEN 'At risk'
		WHEN (JULIANDAY('now') - JULIANDAY(registration_date)) / 365.25 < 60 THEN 'New'
		ELSE 'Regular'
	END AS customer_category
FROM orders_onfo;

// 24
SELECT
	*
FROM products
WHERE price > (
	SELECT AVG(price)
	FROM products
);

// 25
SELECT
	p1.product_name,
	p1.price,
	(
		SELECT AVG(p2.price)
		FROM products AS p2
		WHERE p1.category_id = p2.category_id
	) AS avg_category_price,
	p1.price - (
		SELECT AVG(p2.price)
		FROM products AS p2
		WHERE p1.category_id = p2.category_id
	) AS price_diff
FROM products AS p1;

// 26
SELECT 
	*
FROM customers AS c
WHERE EXISTS (
    SELECT 1
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON oi.order_id = o.order_id
    INNER JOIN products AS p
        ON oi.product_id = p.product_id
    INNER JOIN categories AS cat
        ON cat.category_id = p.category_id
    WHERE cat.category_name = 'Accessories'
      AND o.customer_id = c.customer_id
);

// 27
SELECT 
	*
FROM customers AS c
WHERE EXISTS (
	SELECT 1
	FROM orders AS o
	WHERE o.customer_id = c.customer_id
)
AND NOT EXISTS (
    SELECT 1
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON oi.order_id = o.order_id
    INNER JOIN products AS p
        ON oi.product_id = p.product_id
    INNER JOIN categories AS cat
        ON cat.category_id = p.category_id
    WHERE cat.category_name = 'Accessories'
      AND o.customer_id = c.customer_id
);

// 28

// 29

// 30