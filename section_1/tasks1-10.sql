// 1
SELECT
	o.order_id,
	c.first_name,
	o.discount,
	oi.unit_price AS orinilap_price,
	oi.unit_price * (CAST((100 - discount) AS FLOAT) / 100) AS final_price
FROM orders AS o
INNER JOIN customers AS c
	ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi
	ON oi.order_id = o.order_id;
	
// 2
SELECT
	c.customer_id,
	c.first_name,
	c.registration_date,
	SUM(CASE WHEN order_id IS NOT NULL THEN 1 ELSE 0 END) AS order_count 
FROM customers AS c
LEFT JOIN orders AS o
	ON c.customer_id = o.customer_id
GROUP BY
	c.customer_id,
    c.first_name,
    c.registration_date;

SELECT
    c.customer_id,
    c.first_name,
    c.registration_date,
    COUNT(o.order_id) AS order_count
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.registration_date
HAVING COUNT(o.order_id) = 0;

// 3
SELECT
	*
FROM products AS p
LEFT JOIN order_items AS oi
	ON oi.product_id = p.product_id
WHERE oi.order_id IS NULL;

SELECT
	*
FROM products AS p
WHERE NOT EXISTS (
	SELECT 1
	FROM order_items AS oi
	WHERE oi.product_id = p.product_id
);

// 4
SELECT
	c.customer_id,
	c.first_name,
	SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS order_count
FROM orders AS o
LEFT JOIN customers AS c
	ON c.customer_id = o.customer_id
GROUP BY 
	c.customer_id,
	c.first_name;

SELECT
    c.customer_id,
    c.first_name,
    COUNT(o.order_id) AS order_count
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
    AND o.status = 'completed'
GROUP BY
    c.customer_id,
    c.first_name;
	
// 5
SELECT
	c.category_id,
	c.category_name,
	COALESCE(SUM(p.product_id), 0) AS units_sold
FROM categories AS c
LEFT JOIN products AS p
	ON c.category_id = p.category_id
LEFT JOIN order_items AS oi
	ON oi.product_id = p.product_id
GROUP BY
	c.category_id,
	c.category_name;
	
// 6
SELECT
	p.product_id,
	p.product_name,
	p.price,
	c.category_name,
	COALESCE(SUM(quantity), 0) AS quantity_sold,
	COALESCE(SUM(quantity), 0) * p.price AS total_revenue
FROM products AS p
LEFT JOIN categories AS c
	ON p.category_id = c.category_id
LEFT JOIN order_items AS oi
	ON p.product_id = oi.product_id
LEFT JOIN orders AS o
	ON o.order_id = oi.order_id
GROUP BY
	p.product_id,
	p.product_name;

// 7
SELECT
	e1.first_name AS emp_name,
	e1.salary AS emp_salary,
	e2.first_name AS mngr_name,
	e2.salary AS mngr_salary,
	e2.salary - e1.salary AS salary_diff
FROM employees AS e1
LEFT JOIN employees AS e2
	ON e1.manager_id = e2.employee_id
WHERE e1.department = 'Sales';

// 8
SELECT 
	e1.*
FROM employees AS e1
LEFT JOIN employees AS e2
	ON e1.manager_id = e2.employee_id
WHERE e1.salary > e2.salary;

// 9
SELECT
	o.order_id,
	o.customer_id,
	p.product_name,
	oi.quantity,
	oi.unit_price,
	oi.quantity * oi.unit_price AS revenue,
	c.category_name,
	e.first_name,
	p.payment_method
FROM order_items AS oi
LEFT JOIN orders AS o
	ON oi.order_id = o.order_id
LEFT JOIN products AS p
	ON p.product_id = oi.product_id
LEFT JOIN categories AS c
	ON c.category_id = p.category_id
LEFT JOIN employees AS e
	ON o.sales_employee_id = e.employee_id
LEFT JOIN payments AS p
	ON p.order_id = o.order_id;

// 10
SELECT
	c.category_id,
	c.category_name,
	COUNT(DISTINCT p.product_id) AS distinct_products,
	COALESCE(SUM(oi.quantity), 0) AS quantity_sold,
	COALESCE(SUM(oi.quantity * p.price), 0) AS revenue,
	AVG(p.price) AS avg_price
FROM categories AS c
LEFT JOIN products AS p
	ON c.category_id = p.category_id
LEFT JOIN order_items AS oi
	ON oi.product_id = p.product_id
LEFT JOIN orders AS o
	ON o.order_id = oi.order_id
GROUP BY
	c.category_id,
	c.category_name
HAVING
	COALESCE(SUM(oi.quantity), 0) > 3
	AND COALESCE(SUM(oi.quantity * p.price), 0) > 500;
