-- ============================================================
-- DROP TABLES
-- ============================================================

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;


-- ============================================================
-- CUSTOMERS
-- ============================================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    registration_date DATE,
    country VARCHAR(50),
    city VARCHAR(50),
    customer_segment VARCHAR(20)
);

INSERT INTO customers (
    customer_id,
    customer_name,
    registration_date,
    country,
    city,
    customer_segment
)
VALUES
    (1, 'Anna Smith',      '2023-01-10', 'Germany', 'Berlin',    'VIP'),
    (2, 'Max Miller',      '2023-02-15', 'Germany', 'Munich',    'Premium'),
    (3, 'Olivia Brown',    '2023-03-20', 'Germany', 'Hamburg',   'Regular'),
    (4, 'Liam Wilson',    '2023-04-05', 'Germany', 'Berlin',    'Regular'),
    (5, 'Emma Davis',      '2023-05-12', 'Germany', 'Frankfurt', 'Premium'),
    (6, 'Noah Taylor',     '2023-06-18', 'Germany', 'Munich',    'Regular'),
    (7, 'Sophia Anderson', '2023-07-01', 'Germany', 'Berlin',    'VIP'),
    (8, 'James Thomas',    '2023-08-10', 'Germany', 'Hamburg',   'Regular'),
    (9, 'Mia Jackson',     '2023-09-15', 'Germany', 'Frankfurt', 'Premium'),
    (10, 'Lucas White',    '2023-10-01', 'Germany', 'Berlin',    'Regular');


-- ============================================================
-- SELLERS
-- ============================================================

CREATE TABLE sellers (
    seller_id INT PRIMARY KEY,
    seller_name VARCHAR(100),
    country VARCHAR(50),
    rating NUMERIC(3,2)
);

INSERT INTO sellers (
    seller_id,
    seller_name,
    country,
    rating
)
VALUES
    (1, 'TechWorld',     'Germany', 4.80),
    (2, 'HomeStore',     'Germany', 4.50),
    (3, 'FashionHub',    'Germany', 4.70),
    (4, 'BookPlanet',    'Germany', 4.30),
    (5, 'SportMarket',   'Germany', 4.60);


-- ============================================================
-- CATEGORIES
-- ============================================================

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100),
    parent_category_id INT
);

INSERT INTO categories (
    category_id,
    category_name,
    parent_category_id
)
VALUES
    (1, 'Electronics', NULL),
    (2, 'Home',        NULL),
    (3, 'Fashion',     NULL),
    (4, 'Books',       NULL),
    (5, 'Sports',      NULL);


-- ============================================================
-- PRODUCTS
-- ============================================================

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    seller_id INT,
    cost_price NUMERIC(10,2),
    list_price NUMERIC(10,2)
);

INSERT INTO products (
    product_id,
    product_name,
    category_id,
    seller_id,
    cost_price,
    list_price
)
VALUES
    -- Electronics
    (1,  'Laptop Pro',       1, 1, 700.00, 1000.00),
    (2,  'Smartphone X',     1, 1, 350.00, 500.00),
    (3,  'Wireless Headset', 1, 1, 70.00,  120.00),
    (4,  'Smart Watch',      1, 1, 120.00, 200.00),

    -- Home
    (5,  'Coffee Machine',   2, 2, 180.00, 300.00),
    (6,  'Vacuum Cleaner',   2, 2, 200.00, 350.00),
    (7,  'Desk Lamp',        2, 2, 30.00,  60.00),
    (8,  'Office Chair',     2, 2, 150.00, 250.00),

    -- Fashion
    (9,  'Winter Jacket',    3, 3, 100.00, 180.00),
    (10, 'Sneakers',         3, 3, 70.00,  130.00),
    (11, 'Jeans',            3, 3, 40.00,  80.00),
    (12, 'T-Shirt',          3, 3, 20.00,  40.00),

    -- Books
    (13, 'SQL Handbook',     4, 4, 25.00,  50.00),
    (14, 'Data Science 101', 4, 4, 30.00,  60.00),
    (15, 'Python Guide',     4, 4, 28.00,  55.00),
    (16, 'Analytics Book',   4, 4, 35.00,  70.00),

    -- Sports
    (17, 'Running Shoes',    5, 5, 80.00,  150.00),
    (18, 'Yoga Mat',         5, 5, 20.00,  40.00),
    (19, 'Dumbbells',       5, 5, 45.00,  90.00),
    (20, 'Tennis Racket',   5, 5, 100.00, 180.00);


-- ============================================================
-- ORDERS
-- ============================================================

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(20),
    total_amount NUMERIC(10,2),
    shipping_cost NUMERIC(10,2),
    discount_amount NUMERIC(10,2)
);

INSERT INTO orders (
    order_id,
    customer_id,
    order_date,
    order_status,
    total_amount,
    shipping_cost,
    discount_amount
)
VALUES

    -- Customer 1: many orders
    (1,  1, '2024-01-05', 'completed', 1000.00, 10.00,  0.00),
    (2,  1, '2024-02-10', 'completed',  500.00, 10.00, 20.00),
    (3,  1, '2024-03-15', 'completed',  300.00,  5.00,  0.00),
    (4,  1, '2024-05-20', 'completed',  800.00, 10.00, 50.00),
    (5,  1, '2024-07-10', 'completed',  200.00,  5.00,  0.00),

    -- Customer 2
    (6,  2, '2024-01-20', 'completed',  500.00, 10.00,  0.00),
    (7,  2, '2024-03-05', 'completed',  350.00,  5.00, 10.00),
    (8,  2, '2024-04-18', 'completed', 1000.00, 10.00,  0.00),
    (9,  2, '2024-08-01', 'completed',  200.00,  5.00,  0.00),

    -- Customer 3
    (10, 3, '2024-01-12', 'completed',  120.00, 5.00,  0.00),
    (11, 3, '2024-02-25', 'completed',  250.00, 5.00, 10.00),
    (12, 3, '2024-06-10', 'completed',  500.00, 10.00, 0.00),

    -- Customer 4
    (13, 4, '2024-02-01', 'completed',  800.00, 10.00, 0.00),
    (14, 4, '2024-04-15', 'completed',  200.00, 5.00,  0.00),
    (15, 4, '2024-06-20', 'completed',  500.00, 10.00, 20.00),

    -- Customer 5
    (16, 5, '2024-01-10', 'completed', 1000.00, 10.00, 0.00),
    (17, 5, '2024-02-14', 'completed',  500.00, 10.00, 0.00),
    (18, 5, '2024-05-05', 'completed',  800.00, 10.00, 30.00),

    -- Customer 6
    (19, 6, '2024-03-01', 'completed',  300.00, 5.00,  0.00),
    (20, 6, '2024-05-12', 'completed',  700.00, 10.00, 0.00),

    -- Customer 7
    (21, 7, '2024-01-15', 'completed', 1000.00, 10.00, 0.00),
    (22, 7, '2024-02-15', 'completed',  500.00, 10.00, 0.00),
    (23, 7, '2024-03-15', 'completed',  500.00, 10.00, 0.00),
    (24, 7, '2024-04-15', 'completed',  200.00, 5.00,  0.00),

    -- Customer 8
    (25, 8, '2024-02-10', 'completed',  130.00, 5.00,  0.00),
    (26, 8, '2024-05-10', 'completed',  260.00, 5.00, 10.00),

    -- Customer 9
    (27, 9, '2024-01-25', 'completed',  600.00, 10.00, 0.00),
    (28, 9, '2024-04-25', 'completed',  400.00, 5.00,  0.00),
    (29, 9, '2024-07-25', 'completed',  800.00, 10.00, 20.00),

    -- Customer 10
    (30, 10, '2024-03-10', 'completed',  180.00, 5.00,  0.00),
    (31, 10, '2024-06-10', 'completed',  360.00, 5.00,  0.00),
    (32, 10, '2024-08-10', 'completed',  540.00, 10.00, 20.00);


-- ============================================================
-- ORDER ITEMS
-- ============================================================

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price NUMERIC(10,2),
    discount_percent NUMERIC(5,2)
);

INSERT INTO order_items (
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_percent
)
VALUES
    (1,  1,  1, 1, 1000.00, 0),
    (2,  2,  2, 1,  500.00, 0),
    (3,  3,  5, 1, 300.00, 0),
    (4,  4,  6, 2, 350.00, 10),
    (5,  5,  4, 1, 200.00, 0),

    (6,  6,  2, 1, 500.00, 0),
    (7,  7,  3, 3, 120.00, 5),
    (8,  8,  1, 1, 1000.00, 0),
    (9,  9,  4, 1, 200.00, 0),

    (10, 10, 3, 1, 120.00, 0),
    (11, 11, 13, 5, 50.00, 0),
    (12, 12, 14, 2, 250.00, 0),

    (13, 13, 6, 2, 350.00, 0),
    (14, 14, 7, 3, 60.00, 0),
    (15, 15, 8, 2, 250.00, 0),

    (16, 16, 1, 1, 1000.00, 0),
    (17, 17, 2, 1, 500.00, 0),
    (18, 18, 5, 2, 400.00, 0),

    (19, 19, 9, 2, 180.00, 0),
    (20, 20, 10, 5, 140.00, 0),

    (21, 21, 1, 1, 1000.00, 0),
    (22, 22, 2, 1, 500.00, 0),
    (23, 23, 2, 1, 500.00, 0),
    (24, 24, 4, 1, 200.00, 0),

    (25, 25, 10, 1, 130.00, 0),
    (26, 26, 17, 2, 130.00, 0),

    (27, 27, 9, 3, 200.00, 0),
    (28, 28, 11, 5, 80.00, 0),
    (29, 29, 12, 2, 400.00, 0),

    (30, 30, 18, 3, 60.00, 0),
    (31, 31, 19, 4, 90.00, 0),
    (32, 32, 20, 3, 180.00, 0);


-- ============================================================
-- PAYMENTS
-- ============================================================

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(30),
    payment_amount NUMERIC(10,2)
);

INSERT INTO payments (
    payment_id,
    order_id,
    payment_date,
    payment_method,
    payment_amount
)
SELECT
    order_id,
    order_id,
    order_date,
    CASE
        WHEN order_id % 3 = 0 THEN 'PayPal'
        WHEN order_id % 3 = 1 THEN 'Credit Card'
        ELSE 'Bank Transfer'
    END,
    total_amount
FROM orders;


-- ============================================================
-- REVIEWS
-- ============================================================

CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    review_date DATE,
    rating INT
);

INSERT INTO reviews (
    review_id,
    product_id,
    customer_id,
    review_date,
    rating
)
VALUES
    (1,  1,  1, '2024-01-20', 5),
    (2,  1,  5, '2024-02-20', 4),
    (3,  1,  7, '2024-04-20', 5),

    (4,  2,  2, '2024-02-20', 4),
    (5,  2,  7, '2024-03-20', 5),
    (6,  2,  5, '2024-05-20', 4),

    (7,  3,  3, '2024-01-25', 4),
    (8,  3,  8, '2024-03-25', 3),

    (9,  5,  1, '2024-03-20', 5),
    (10, 5, 5, '2024-06-20', 4),

    (11, 9,  6, '2024-04-10', 5),
    (12, 9,  9, '2024-05-10', 4),

    (13, 10, 8, '2024-05-20', 5),
    (14, 10, 9, '2024-06-20', 4),

    (15, 13, 3, '2024-03-01', 5),
    (16, 13, 4, '2024-05-01', 5),

    (17, 14, 3, '2024-07-01', 4),
    (18, 17, 6, '2024-06-01', 5),
    (19, 18, 10, '2024-07-01', 4),
    (20, 20, 10, '2024-08-20', 5);


-- ============================================================
-- QUICK CHECKS
-- ============================================================

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT 'sellers', COUNT(*)
FROM sellers

UNION ALL

SELECT 'categories', COUNT(*)
FROM categories

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'payments', COUNT(*)
FROM payments

UNION ALL

SELECT 'reviews', COUNT(*)
FROM reviews;
