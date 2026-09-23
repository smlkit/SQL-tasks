DROP TABLE IF EXISTS product_reviews;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customer_addresses;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;


CREATE TABLE customers (
    customer_id      INT PRIMARY KEY,
    first_name       VARCHAR(50) NOT NULL,
    last_name        VARCHAR(50) NOT NULL,
    email            VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE NOT NULL,
    birth_date       DATE,
    country          VARCHAR(50) NOT NULL,
    city             VARCHAR(50),
    segment          VARCHAR(30),
    referred_by      INT REFERENCES customers(customer_id)
);


CREATE TABLE employees (
    employee_id      INT PRIMARY KEY,
    first_name       VARCHAR(50) NOT NULL,
    last_name        VARCHAR(50) NOT NULL,
    department       VARCHAR(50) NOT NULL,
    manager_id       INT REFERENCES employees(employee_id),
    hire_date        DATE NOT NULL,
    salary           NUMERIC(12, 2) NOT NULL
);


CREATE TABLE categories (
    category_id      INT PRIMARY KEY,
    category_name    VARCHAR(100) NOT NULL,
    parent_category_id INT REFERENCES categories(category_id)
);


CREATE TABLE products (
    product_id       INT PRIMARY KEY,
    product_name     VARCHAR(150) NOT NULL,
    category_id      INT NOT NULL REFERENCES categories(category_id),
    price            NUMERIC(12, 2) NOT NULL,
    cost             NUMERIC(12, 2) NOT NULL,
    stock_quantity   INT NOT NULL,
    created_at       DATE NOT NULL,
    discontinued_at  DATE
);


CREATE TABLE customer_addresses (
    address_id       INT PRIMARY KEY,
    customer_id      INT NOT NULL REFERENCES customers(customer_id),
    address_type     VARCHAR(20) NOT NULL,
    country          VARCHAR(50) NOT NULL,
    city             VARCHAR(50) NOT NULL,
    postal_code      VARCHAR(20),
    is_default       BOOLEAN NOT NULL DEFAULT FALSE
);


CREATE TABLE orders (
    order_id         INT PRIMARY KEY,
    customer_id      INT NOT NULL REFERENCES customers(customer_id),
    order_date       TIMESTAMP NOT NULL,
    status           VARCHAR(30) NOT NULL,
    shipping_country VARCHAR(50) NOT NULL,
    shipping_city    VARCHAR(50) NOT NULL,
    sales_employee_id INT REFERENCES employees(employee_id),
    discount         NUMERIC(5, 2) NOT NULL DEFAULT 0
);


CREATE TABLE order_items (
    order_id         INT NOT NULL REFERENCES orders(order_id),
    product_id       INT NOT NULL REFERENCES products(product_id),
    quantity         INT NOT NULL,
    unit_price       NUMERIC(12, 2) NOT NULL,
    PRIMARY KEY (order_id, product_id)
);


CREATE TABLE payments (
    payment_id       INT PRIMARY KEY,
    order_id         INT NOT NULL REFERENCES orders(order_id),
    payment_date     TIMESTAMP NOT NULL,
    amount           NUMERIC(12, 2) NOT NULL,
    payment_method   VARCHAR(30) NOT NULL,
    status           VARCHAR(30) NOT NULL
);


CREATE TABLE product_reviews (
    review_id        INT PRIMARY KEY,
    product_id       INT NOT NULL REFERENCES products(product_id),
    customer_id      INT NOT NULL REFERENCES customers(customer_id),
    rating           INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_date      DATE NOT NULL,
    review_text      TEXT
);

INSERT INTO customers
(customer_id, first_name, last_name, email, registration_date, birth_date, country, city, segment, referred_by)
VALUES
(1, 'Anna', 'Miller', 'anna@example.com', '2021-01-15', '1992-04-12', 'Germany', 'Berlin', 'Premium', NULL),
(2, 'John', 'Smith', 'john@example.com', '2021-02-10', '1988-09-21', 'Germany', 'Hamburg', 'Standard', 1),
(3, 'Maria', 'Garcia', 'maria@example.com', '2021-03-05', '1995-07-13', 'Spain', 'Madrid', 'Premium', NULL),
(4, 'David', 'Brown', 'david@example.com', '2021-04-18', '1985-11-02', 'UK', 'London', 'Standard', 2),
(5, 'Sophie', 'Wilson', 'sophie@example.com', '2021-05-22', '1998-02-17', 'France', 'Paris', 'Standard', 1),
(6, 'Daniel', 'Taylor', 'daniel@example.com', '2021-06-01', '1990-12-25', 'Germany', 'Munich', 'Premium', NULL),
(7, 'Emma', 'Anderson', 'emma@example.com', '2021-07-14', '1993-03-08', 'USA', 'Boston', 'Standard', 3),
(8, 'Michael', 'Thomas', 'michael@example.com', '2021-08-19', '1987-06-30', 'USA', 'Chicago', 'Premium', NULL),
(9, 'Olivia', 'Jackson', 'olivia@example.com', '2021-09-23', '1996-01-14', 'Italy', 'Rome', 'Standard', 5),
(10, 'James', 'White', 'james@example.com', '2021-10-11', '1989-08-19', 'Germany', 'Berlin', 'Standard', 6),
(11, 'Laura', 'Harris', 'laura@example.com', '2021-11-03', '1994-05-22', 'Spain', 'Barcelona', 'Premium', 3),
(12, 'Robert', 'Martin', 'robert@example.com', '2022-01-07', '1983-10-11', 'France', 'Lyon', 'Standard', NULL),
(13, 'Isabella', 'Thompson', 'isabella@example.com', '2022-02-12', '1997-09-05', 'Italy', 'Milan', 'Standard', 9),
(14, 'William', 'Moore', 'william@example.com', '2022-03-21', '1986-01-27', 'UK', 'Manchester', 'Premium', NULL),
(15, 'Charlotte', 'Clark', 'charlotte@example.com', '2022-04-04', '1991-12-03', 'Germany', 'Frankfurt', 'Standard', 10);


INSERT INTO employees
(employee_id, first_name, last_name, department, manager_id, hire_date, salary)
VALUES
(1, 'Thomas', 'King', 'Sales', NULL, '2018-01-10', 85000),
(2, 'Sarah', 'Scott', 'Sales', 1, '2019-03-15', 62000),
(3, 'James', 'Green', 'Sales', 1, '2020-06-01', 58000),
(4, 'Emily', 'Adams', 'Support', NULL, '2017-09-20', 70000),
(5, 'Daniel', 'Baker', 'Support', 4, '2021-02-14', 45000),
(6, 'Olivia', 'Nelson', 'Marketing', NULL, '2019-11-05', 68000);


INSERT INTO categories
(category_id, category_name, parent_category_id)
VALUES
(1, 'Electronics', NULL),
(2, 'Computers', 1),
(3, 'Phones', 1),
(4, 'Accessories', 1),
(5, 'Home', NULL),
(6, 'Kitchen', 5),
(7, 'Furniture', 5),
(8, 'Books', NULL),
(9, 'Fiction', 8),
(10, 'Non-fiction', 8);


INSERT INTO products
(product_id, product_name, category_id, price, cost, stock_quantity, created_at, discontinued_at)
VALUES
(1, 'Laptop Pro', 2, 1500, 1000, 15, '2021-01-10', NULL),
(2, 'Laptop Air', 2, 1100, 750, 20, '2021-02-12', NULL),
(3, 'Phone X', 3, 900, 600, 30, '2021-03-15', NULL),
(4, 'Phone Mini', 3, 650, 430, 40, '2021-04-10', NULL),
(5, 'Wireless Mouse', 4, 50, 20, 100, '2021-05-01', NULL),
(6, 'Keyboard Pro', 4, 120, 60, 70, '2021-05-10', NULL),
(7, 'Coffee Machine', 6, 300, 180, 25, '2021-06-01', NULL),
(8, 'Blender', 6, 150, 90, 35, '2021-06-15', NULL),
(9, 'Office Chair', 7, 400, 250, 12, '2021-07-01', NULL),
(10, 'Desk', 7, 600, 350, 10, '2021-07-15', NULL),
(11, 'Novel A', 9, 25, 10, 200, '2021-08-01', NULL),
(12, 'Novel B', 9, 30, 12, 150, '2021-08-10', NULL),
(13, 'History Book', 10, 45, 20, 80, '2021-09-01', NULL),
(14, 'Science Book', 10, 55, 25, 60, '2021-09-10', NULL),
(15, 'Old Phone', 3, 400, 300, 0, '2020-01-01', '2022-01-01');


INSERT INTO customer_addresses
(address_id, customer_id, address_type, country, city, postal_code, is_default)
VALUES
(1, 1, 'billing', 'Germany', 'Berlin', '10115', TRUE),
(2, 1, 'shipping', 'Germany', 'Berlin', '10115', TRUE),
(3, 2, 'billing', 'Germany', 'Hamburg', '20095', TRUE),
(4, 3, 'billing', 'Spain', 'Madrid', '28001', TRUE),
(5, 4, 'shipping', 'UK', 'London', 'SW1A', TRUE),
(6, 5, 'billing', 'France', 'Paris', '75001', TRUE),
(7, 6, 'shipping', 'Germany', 'Munich', '80331', TRUE),
(8, 7, 'billing', 'USA', 'Boston', '02108', TRUE),
(9, 8, 'shipping', 'USA', 'Chicago', '60601', TRUE),
(10, 9, 'billing', 'Italy', 'Rome', '00100', TRUE);


INSERT INTO orders
(order_id, customer_id, order_date, status, shipping_country, shipping_city, sales_employee_id, discount)
VALUES
(101, 1, '2022-01-10 10:30', 'completed', 'Germany', 'Berlin', 2, 5),
(102, 1, '2022-03-15 14:20', 'completed', 'Germany', 'Berlin', 3, 0),
(103, 2, '2022-01-20 09:15', 'completed', 'Germany', 'Hamburg', 2, 10),
(104, 2, '2022-04-11 16:00', 'cancelled', 'Germany', 'Hamburg', 2, 0),
(105, 3, '2022-02-05 12:00', 'completed', 'Spain', 'Madrid', 3, 5),
(106, 3, '2022-05-20 18:30', 'completed', 'Spain', 'Madrid', 3, 15),
(107, 4, '2022-02-18 11:45', 'completed', 'UK', 'London', 2, 0),
(108, 5, '2022-03-01 15:20', 'completed', 'France', 'Paris', 3, 10),
(109, 5, '2022-06-10 17:10', 'completed', 'France', 'Paris', 3, 0),
(110, 6, '2022-01-25 10:00', 'completed', 'Germany', 'Munich', 2, 5),
(111, 6, '2022-07-05 13:40', 'completed', 'Germany', 'Munich', 2, 20),
(112, 7, '2022-02-14 09:30', 'completed', 'USA', 'Boston', 3, 0),
(113, 8, '2022-02-20 19:00', 'completed', 'USA', 'Chicago', 3, 5),
(114, 8, '2022-08-01 12:15', 'completed', 'USA', 'Chicago', 2, 0),
(115, 9, '2022-03-10 14:00', 'completed', 'Italy', 'Rome', 3, 10),
(116, 10, '2022-03-20 16:45', 'completed', 'Germany', 'Berlin', 2, 0),
(117, 11, '2022-04-01 11:10', 'completed', 'Spain', 'Barcelona', 3, 5),
(118, 12, '2022-04-10 13:20', 'completed', 'France', 'Lyon', 2, 0),
(119, 13, '2022-05-01 10:30', 'completed', 'Italy', 'Milan', 3, 10),
(120, 14, '2022-05-15 15:00', 'completed', 'UK', 'Manchester', 2, 0),
(121, 15, '2022-06-01 17:30', 'completed', 'Germany', 'Frankfurt', 2, 5);


INSERT INTO order_items
(order_id, product_id, quantity, unit_price)
VALUES
(101, 1, 1, 1500),
(101, 5, 2, 50),
(102, 3, 1, 900),
(102, 6, 1, 120),
(103, 2, 1, 1100),
(103, 5, 1, 50),
(104, 4, 1, 650),
(105, 7, 1, 300),
(105, 8, 1, 150),
(106, 1, 1, 1500),
(106, 9, 1, 400),
(107, 10, 1, 600),
(107, 6, 1, 120),
(108, 11, 3, 25),
(108, 12, 2, 30),
(109, 7, 1, 300),
(109, 8, 2, 150),
(110, 3, 1, 900),
(110, 5, 2, 50),
(111, 1, 1, 1500),
(111, 6, 1, 120),
(112, 13, 2, 45),
(113, 4, 1, 650),
(113, 5, 1, 50),
(114, 2, 1, 1100),
(114, 6, 2, 120),
(115, 14, 2, 55),
(116, 9, 1, 400),
(117, 7, 1, 300),
(118, 10, 1, 600),
(119, 12, 3, 30),
(120, 3, 1, 900),
(121, 5, 4, 50);


INSERT INTO payments
(payment_id, order_id, payment_date, amount, payment_method, status)
VALUES
(1, 101, '2022-01-10 10:35', 1520, 'card', 'paid'),
(2, 102, '2022-03-15 14:25', 1020, 'paypal', 'paid'),
(3, 103, '2022-01-20 09:20', 1035, 'card', 'paid'),
(4, 104, '2022-04-11 16:05', 650, 'card', 'refunded'),
(5, 105, '2022-02-05 12:05', 427.5, 'paypal', 'paid'),
(6, 106, '2022-05-20 18:35', 1615, 'card', 'paid'),
(7, 107, '2022-02-18 11:50', 720, 'card', 'paid'),
(8, 108, '2022-03-01 15:25', 84, 'paypal', 'paid'),
(9, 109, '2022-06-10 17:15', 600, 'card', 'paid'),
(10, 110, '2022-01-25 10:05', 950, 'card', 'paid'),
(11, 111, '2022-07-05 13:45', 1296, 'paypal', 'paid'),
(12, 112, '2022-02-14 09:35', 90, 'card', 'paid'),
(13, 113, '2022-02-20 19:05', 665, 'card', 'paid'),
(14, 114, '2022-08-01 12:20', 1340, 'paypal', 'paid'),
(15, 115, '2022-03-10 14:05', 99, 'card', 'paid'),
(16, 116, '2022-03-20 16:50', 400, 'card', 'paid'),
(17, 117, '2022-04-01 11:15', 285, 'paypal', 'paid'),
(18, 118, '2022-04-10 13:25', 600, 'card', 'paid'),
(19, 119, '2022-05-01 10:35', 81, 'card', 'paid'),
(20, 120, '2022-05-15 15:05', 900, 'paypal', 'paid'),
(21, 121, '2022-06-01 17:35', 190, 'card', 'paid');


INSERT INTO product_reviews
(review_id, product_id, customer_id, rating, review_date, review_text)
VALUES
(1, 1, 1, 5, '2022-01-20', 'Excellent'),
(2, 3, 1, 4, '2022-03-25', 'Very good'),
(3, 2, 2, 3, '2022-02-01', 'Good'),
(4, 7, 3, 5, '2022-02-20', 'Excellent'),
(5, 1, 3, 5, '2022-06-01', 'Amazing'),
(6, 10, 4, 4, '2022-03-01', 'Good'),
(7, 11, 5, 4, '2022-03-10', 'Nice'),
(8, 7, 5, 5, '2022-06-20', 'Excellent'),
(9, 3, 6, 2, '2022-02-15', 'Not great'),
(10, 1, 6, 5, '2022-07-20', 'Excellent'),
(11, 4, 7, 3, '2022-03-01', 'Average'),
(12, 4, 8, 4, '2022-03-05', 'Good'),
(13, 2, 8, 5, '2022-08-10', 'Excellent'),
(14, 14, 9, 5, '2022-03-20', 'Great'),
(15, 9, 10, 4, '2022-04-01', 'Good'),
(16, 7, 11, 5, '2022-04-15', 'Excellent'),
(17, 10, 12, 3, '2022-05-01', 'Average'),
(18, 12, 13, 4, '2022-05-20', 'Good'),
(19, 3, 14, 5, '2022-06-01', 'Excellent'),
(20, 5, 15, 2, '2022-06-10', 'Bad');