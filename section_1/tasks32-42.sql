// 32
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY c.customer_id ORDER BY o.order_date) AS order_rank
FROM orders AS o
INNER JOIN customers AS c
	ON o.customer_id = c.customer_id;

// 33
WITH orders_info AS (
	SELECT
		c.customer_id,
		c.first_name,
		strftime('%Y-%m', o.order_date) AS order_month,
		o.order_id,
		oi.unit_price * oi.quantity AS total_price
	FROM orders AS o
	INNER JOIN customers AS c
		ON o.customer_id = c.customer_id
	INNER JOIN order_items AS oi
		ON oi.order_id = o.order_id
)	
SELECT
	customer_id,
	first_name,
	order_month,
	SUM(total_price) AS spends,
	RANK() OVER(PARTITION BY order_month ORDER BY SUM(total_price)) AS spends_rank
FROM orders_info
GROUP BY
	order_month,
	customer_id;

// 34
SELECT
	strftime('%Y-%m', o.order_date) AS order_month,
	COUNT(oi.quantity) AS total_products,
	RANK() OVER(PARTITION BY strftime('%Y-%m', o.order_date) ORDER BY COUNT(oi.quantity) DESC) AS rank,
	DENSE_RANK() OVER(PARTITION BY strftime('%Y-%m', o.order_date) ORDER BY COUNT(oi.quantity) DESC) AS dense_rank
FROM orders AS o
INNER JOIN order_items AS oi
	ON o.order_id = oi.order_id
GROUP BY
	strftime('%Y-%m', o.order_date),
	oi.product_id;

// 35
WITH product_info AS (
	SELECT
		p.product_name,
		c.category_name,
		SUM(oi.quantity * oi.unit_price) AS total_amount
	FROM orders AS o
	INNER JOIN order_items AS oi
		ON o.order_id = oi.order_id
	INNER JOIN products AS p
		ON p.product_id = oi.product_id
	INNER JOIN categories AS c
		ON c.category_id = p.category_id
	GROUP BY
		p.product_id,
		p.product_name,
		c.category_name
)
SELECT 
	*,
	RANK() OVER(PARTITION BY category_name ORDER BY total_amount DESC) AS revenue_rank
FROM product_info;

// 36
WITH order_info AS (
	SELECT 
		o.order_id,
		o.order_date,
		o.customer_id,
		SUM(oi.quantity * oi.unit_price) AS order_price
	FROM orders AS o
	INNER JOIN order_items AS oi
		ON oi.order_id = o.order_id
	GROUP BY
		o.order_id,
		o.order_date,
		o.customer_id
)
SELECT
	*,
	LAG(order_price) OVER(PARTITION BY customer_id ORDER BY order_date) AS prev_order_price,
	order_price - LAG(order_price) OVER(PARTITION BY customer_id ORDER BY order_date) AS order_price_diff
FROM order_info;

// 37
WITH order_info AS (
	SELECT 
		o.order_id,
		o.order_date,
		o.customer_id
	FROM orders AS o
	INNER JOIN order_items AS oi
		ON oi.order_id = o.order_id
	GROUP BY
		o.order_id,
		o.order_date,
		o.customer_id
)
SELECT
	*,
	LEAD(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS next_order_date,
	CAST(
        julianday(
            LEAD(order_date) OVER (
                PARTITION BY customer_id 
                ORDER BY order_date
            )
        ) - julianday(order_date)
        AS INTEGER
    ) AS days_to_next_order
FROM order_info;

// 38
WITH order_info AS (
	SELECT 
		o.order_id,
		o.order_date,
		o.customer_id
	FROM orders AS o
	INNER JOIN order_items AS oi
		ON oi.order_id = o.order_id
	GROUP BY
		o.order_id,
		o.order_date,
		o.customer_id
)
SELECT
	*,
	FIRST_VALUE(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS first_order_date,
	LAST_VALUE(order_date) OVER(PARTITION BY customer_id ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_order_date,
	julianday(
        LAST_VALUE(order_date) OVER (
            PARTITION BY customer_id 
            ORDER BY order_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        )
    ) 
    - julianday(
        FIRST_VALUE(order_date) OVER (
            PARTITION BY customer_id 
            ORDER BY order_date
        )
    ) AS days_between_orders
FROM order_info;

// 39
WITH order_info AS (
	SELECT 
		o.order_id,
		o.order_date,
		o.customer_id,
		SUM(oi.quantity * oi.unit_price) AS order_price
	FROM orders AS o
	INNER JOIN order_items AS oi
		ON oi.order_id = o.order_id
	GROUP BY
		o.order_id,
		o.order_date,
		o.customer_id
)
SELECT
	*,
	SUM(order_price) OVER(PARTITION BY customer_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM order_info;

// 40
WITH order_info AS (
	SELECT 
		o.order_id,
		o.order_date,
		o.customer_id,
		SUM(oi.quantity * oi.unit_price) AS order_price
	FROM orders AS o
	INNER JOIN order_items AS oi
		ON oi.order_id = o.order_id
	GROUP BY
		o.order_id,
		o.order_date,
		o.customer_id
)
SELECT
	*,
	AVG(order_price) OVER(PARTITION BY customer_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg
FROM order_info;

// 41
WITH order_info AS (
	SELECT 
		o.order_id,
		o.order_date,
		SUM(oi.quantity * oi.unit_price) AS order_price
	FROM orders AS o
	INNER JOIN order_items AS oi
		ON oi.order_id = o.order_id
	GROUP BY
		o.order_id,
		o.order_date,
		o.customer_id
)
SELECT
	*,
	SUM(order_price) OVER () AS total_revenue,
	ROUND((CAST(order_price AS FLOAT) / SUM(order_price) OVER ()) * 100, 2) AS revenue_percent
FROM order_info;

// 42
WITH order_info AS (
	SELECT
        o.order_id,
        o.customer_id,
        o.shipping_country,
        SUM(oi.unit_price * oi.quantity) AS order_price
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON oi.order_id = o.order_id
    GROUP BY
        o.order_id,
        o.customer_id,
        o.shipping_country
),
customer_info AS (
	SELECT
		customer_id,
		shipping_country,
		SUM(order_price) OVER(PARTITION BY customer_id) AS customer_revenue,
		SUM(order_price) OVER(PARTITION BY shipping_country) AS country_revenue
	FROM order_info
	GROUP BY
		customer_id,
		shipping_country
)
SELECT
	*,
	ROUND((CAST(customer_revenue AS FLOAT) / country_revenue) * 100, 2) AS revenue_percent
FROM customer_info
ORDER BY shipping_country;