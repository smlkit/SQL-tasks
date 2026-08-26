-- ============================================================
-- CLEANUP
-- ============================================================

DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;


-- ============================================================
-- CUSTOMERS
-- ============================================================

CREATE TABLE customers (
    customer_id     INT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    city            VARCHAR(50),
    registration_date DATE NOT NULL,
    birth_date      DATE,
    referred_by     INT REFERENCES customers(customer_id)
);


-- ============================================================
-- EMPLOYEES
-- SELF JOIN через manager_id
-- ============================================================

CREATE TABLE employees (
    employee_id     INT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    department      VARCHAR(50),
    position        VARCHAR(50),
    salary          NUMERIC(10, 2),
    manager_id      INT REFERENCES employees(employee_id),
    hire_date       DATE
);


-- ============================================================
-- CATEGORIES
-- ============================================================

CREATE TABLE categories (
    category_id     INT PRIMARY KEY,
    category_name   VARCHAR(100) NOT NULL,
    parent_category_id INT REFERENCES categories(category_id)
);


-- ============================================================
-- PRODUCTS
-- ============================================================

CREATE TABLE products (
    product_id      INT PRIMARY KEY,
    product_name    VARCHAR(100) NOT NULL,
    category_id     INT REFERENCES categories(category_id),
    price           NUMERIC(10, 2) NOT NULL,
    stock_quantity  INT NOT NULL,
    supplier        VARCHAR(100),
    discontinued    BOOLEAN DEFAULT FALSE
);


-- ============================================================
-- ORDERS
-- ============================================================

CREATE TABLE orders (
    order_id        INT PRIMARY KEY,
    customer_id     INT REFERENCES customers(customer_id),
    employee_id     INT REFERENCES employees(employee_id),
    order_date      DATE NOT NULL,
    status          VARCHAR(30) NOT NULL,
    discount        NUMERIC(5, 2) DEFAULT 0
);


-- ============================================================
-- ORDER ITEMS
-- ============================================================

CREATE TABLE order_items (
    order_id        INT REFERENCES orders(order_id),
    product_id      INT REFERENCES products(product_id),
    quantity        INT NOT NULL,
    unit_price      NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY (order_id, product_id)
);


-- ============================================================
-- PAYMENTS
-- ============================================================

CREATE TABLE payments (
    payment_id      INT PRIMARY KEY,
    order_id        INT REFERENCES orders(order_id),
    payment_date    DATE,
    amount          NUMERIC(10, 2),
    payment_method  VARCHAR(30),
    status          VARCHAR(30)
);


-- ============================================================
-- DELIVERIES
-- ============================================================

CREATE TABLE deliveries (
    delivery_id     INT PRIMARY KEY,
    order_id        INT UNIQUE REFERENCES orders(order_id),
    delivery_date   DATE,
    delivery_status VARCHAR(30),
    delivery_city   VARCHAR(50)
);


-- ============================================================
-- DATA: CUSTOMERS
-- ============================================================

INSERT INTO customers
(customer_id, first_name, last_name, email, city, registration_date, birth_date, referred_by)
VALUES
(1, 'Иван', 'Петров', 'ivan@example.com', 'Москва', '2023-01-15', '1990-05-12', NULL),
(2, 'Анна', 'Смирнова', 'anna@example.com', 'Санкт-Петербург', '2023-02-10', '1988-08-20', 1),
(3, 'Олег', 'Иванов', 'oleg@example.com', 'Москва', '2023-03-05', '1995-01-15', 1),
(4, 'Мария', 'Соколова', 'maria@example.com', 'Казань', '2023-03-20', '1992-11-03', 2),
(5, 'Дмитрий', 'Кузнецов', 'dmitry@example.com', 'Москва', '2023-04-01', '1985-04-17', NULL),
(6, 'Елена', 'Попова', 'elena@example.com', 'Сочи', '2023-04-15', '1998-09-22', 2),
(7, 'Алексей', 'Волков', 'alex@example.com', 'Казань', '2023-05-12', '1991-06-30', NULL),
(8, 'Ольга', 'Морозова', 'olga@example.com', 'Москва', '2023-06-01', '1987-02-14', 3),
(9, 'Сергей', 'Новиков', 'sergey@example.com', 'Санкт-Петербург', '2023-06-18', '1993-12-01', NULL),
(10, 'Наталья', 'Федорова', 'natalia@example.com', 'Самара', '2023-07-01', '1996-03-19', 5),
(11, 'Роман', 'Орлов', 'roman@example.com', 'Москва', '2023-07-20', '1989-10-10', NULL),
(12, 'Татьяна', 'Белова', 'tatiana@example.com', 'Казань', '2023-08-01', '1994-07-07', 7),
(13, 'Павел', 'Титов', 'pavel@example.com', 'Воронеж', '2023-08-15', '1990-02-11', NULL),
(14, 'Виктория', 'Громова', 'victoria@example.com', 'Москва', '2023-09-01', '1997-05-25', 1),
(15, 'Максим', 'Лебедев', 'maxim@example.com', 'Самара', '2023-09-10', '1986-12-18', NULL);


-- ============================================================
-- DATA: EMPLOYEES
-- ============================================================

INSERT INTO employees
(employee_id, first_name, last_name, department, position, salary, manager_id, hire_date)
VALUES
(1, 'Александр', 'Семенов', 'Sales', 'Director', 250000, NULL, '2018-01-10'),
(2, 'Екатерина', 'Павлова', 'Sales', 'Manager', 160000, 1, '2019-03-15'),
(3, 'Михаил', 'Крылов', 'Sales', 'Manager', 150000, 1, '2020-05-20'),
(4, 'Ирина', 'Макарова', 'Sales', 'Sales Manager', 90000, 2, '2021-02-10'),
(5, 'Артем', 'Фомин', 'Sales', 'Sales Manager', 85000, 2, '2021-06-01'),
(6, 'Светлана', 'Жукова', 'Support', 'Support Manager', 100000, 1, '2020-01-15'),
(7, 'Николай', 'Власов', 'Support', 'Support Specialist', 70000, 6, '2022-04-10'),
(8, 'Юлия', 'Котова', 'Support', 'Support Specialist', 68000, 6, '2022-07-01'),
(9, 'Денис', 'Баранов', 'IT', 'Developer', 180000, NULL, '2019-11-10'),
(10, 'Людмила', 'Зайцева', 'IT', 'Developer', 170000, 9, '2021-09-01');


-- ============================================================
-- DATA: CATEGORIES
-- ============================================================

INSERT INTO categories
(category_id, category_name, parent_category_id)
VALUES
(1, 'Электроника', NULL),
(2, 'Ноутбуки', 1),
(3, 'Смартфоны', 1),
(4, 'Аксессуары', 1),
(5, 'Бытовая техника', NULL),
(6, 'Кофемашины', 5),
(7, 'Пылесосы', 5),
(8, 'Одежда', NULL);


-- ============================================================
-- DATA: PRODUCTS
-- ============================================================

INSERT INTO products
(product_id, product_name, category_id, price, stock_quantity, supplier, discontinued)
VALUES
(1, 'MacBook Air', 2, 120000, 5, 'Apple', FALSE),
(2, 'Lenovo ThinkPad', 2, 95000, 8, 'Lenovo', FALSE),
(3, 'iPhone 15', 3, 90000, 10, 'Apple', FALSE),
(4, 'Samsung Galaxy S24', 3, 80000, 12, 'Samsung', FALSE),
(5, 'USB-C кабель', 4, 1500, 100, 'Baseus', FALSE),
(6, 'Беспроводная мышь', 4, 3000, 50, 'Logitech', FALSE),
(7, 'Клавиатура', 4, 7000, 30, 'Logitech', FALSE),
(8, 'Кофемашина DeLonghi', 6, 55000, 7, 'DeLonghi', FALSE),
(9, 'Кофемашина Philips', 6, 45000, 0, 'Philips', FALSE),
(10, 'Пылесос Dyson', 7, 70000, 4, 'Dyson', FALSE),
(11, 'Пылесос Bosch', 7, 35000, 20, 'Bosch', FALSE),
(12, 'Футболка', 8, 2500, 80, 'Nike', FALSE),
(13, 'Куртка', 8, 15000, 15, 'Nike', FALSE),
(14, 'Старый планшет', 1, 30000, 0, 'Samsung', TRUE),
(15, 'Наушники', 4, 12000, 25, 'Sony', FALSE);


-- ============================================================
-- DATA: ORDERS
-- ============================================================

INSERT INTO orders
(order_id, customer_id, employee_id, order_date, status, discount)
VALUES
(1, 1, 4, '2024-01-10', 'completed', 10),
(2, 2, 4, '2024-01-12', 'completed', 0),
(3, 3, 5, '2024-01-15', 'completed', 5),
(4, 1, 5, '2024-01-20', 'cancelled', 0),
(5, 4, 4, '2024-02-01', 'completed', 15),
(6, 5, 4, '2024-02-05', 'completed', 0),
(7, 6, 5, '2024-02-10', 'processing', 5),
(8, 7, 4, '2024-02-15', 'completed', 0),
(9, 8, 5, '2024-02-20', 'completed', 10),
(10, 9, 4, '2024-03-01', 'completed', 0),
(11, 10, 5, '2024-03-05', 'cancelled', 20),
(12, 1, 4, '2024-03-10', 'completed', 5),
(13, 11, 5, '2024-03-15', 'completed', 0),
(14, 12, 4, '2024-03-20', 'processing', 10),
(15, 13, 5, '2024-03-25', 'completed', 0),
(16, 14, 4, '2024-04-01', 'completed', 15),
(17, 15, 5, '2024-04-05', 'completed', 0),
(18, 5, 4, '2024-04-10', 'completed', 5),
(19, 3, 5, '2024-04-15', 'cancelled', 0),
(20, 2, 4, '2024-04-20', 'completed', 10);


-- ============================================================
-- DATA: ORDER ITEMS
-- ============================================================

INSERT INTO order_items
(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 120000),
(1, 5, 2, 1500),

(2, 3, 1, 90000),
(2, 5, 1, 1500),

(3, 4, 1, 80000),
(3, 6, 1, 3000),

(4, 2, 1, 95000),

(5, 8, 1, 55000),
(5, 5, 2, 1500),

(6, 10, 1, 70000),
(6, 15, 1, 12000),

(7, 9, 1, 45000),

(8, 11, 1, 35000),
(8, 6, 2, 3000),

(9, 12, 3, 2500),
(9, 15, 1, 12000),

(10, 2, 1, 95000),

(11, 13, 1, 15000),

(12, 3, 1, 90000),
(12, 7, 1, 7000),

(13, 8, 1, 55000),

(14, 13, 1, 15000),
(14, 12, 2, 2500),

(15, 4, 1, 80000),

(16, 1, 1, 120000),
(16, 15, 1, 12000),

(17, 10, 1, 70000),

(18, 11, 1, 35000),
(18, 5, 3, 1500),

(19, 3, 1, 90000),

(20, 6, 2, 3000),
(20, 7, 1, 7000);


-- ============================================================
-- DATA: PAYMENTS
-- ============================================================

INSERT INTO payments
(payment_id, order_id, payment_date, amount, payment_method, status)
VALUES
(1, 1, '2024-01-10', 110700, 'card', 'paid'),
(2, 2, '2024-01-12', 91500, 'card', 'paid'),
(3, 3, '2024-01-15', 78850, 'cash', 'paid'),
(4, 4, '2024-01-20', 95000, 'card', 'refunded'),
(5, 5, '2024-02-01', 48875, 'card', 'paid'),
(6, 6, '2024-02-05', 82000, 'card', 'paid'),
(7, 7, '2024-02-10', 42750, 'card', 'pending'),
(8, 8, '2024-02-15', 41000, 'cash', 'paid'),
(9, 9, '2024-02-20', 18750, 'card', 'paid'),
(10, 10, '2024-03-01', 95000, 'card', 'paid'),
(11, 11, '2024-03-05', 12000, 'card', 'refunded'),
(12, 12, '2024-03-10', 92150, 'card', 'paid'),
(13, 13, '2024-03-15', 55000, 'cash', 'paid'),
(14, 14, '2024-03-20', 18000, 'card', 'pending'),
(15, 15, '2024-03-25', 80000, 'card', 'paid'),
(16, 16, '2024-04-01', 112200, 'card', 'paid'),
(17, 17, '2024-04-05', 70000, 'cash', 'paid'),
(18, 18, '2024-04-10', 37525, 'card', 'paid'),
(19, 19, '2024-04-15', 90000, 'card', 'refunded'),
(20, 20, '2024-04-20', 11700, 'card', 'paid');


-- ============================================================
-- DATA: DELIVERIES
-- ============================================================

INSERT INTO deliveries
(delivery_id, order_id, delivery_date, delivery_status, delivery_city)
VALUES
(1, 1, '2024-01-13', 'delivered', 'Москва'),
(2, 2, '2024-01-16', 'delivered', 'Санкт-Петербург'),
(3, 3, '2024-01-18', 'delivered', 'Москва'),
(4, 5, '2024-02-04', 'delivered', 'Казань'),
(5, 6, '2024-02-09', 'delivered', 'Москва'),
(6, 7, NULL, 'in_transit', 'Сочи'),
(7, 8, '2024-02-19', 'delivered', 'Казань'),
(8, 9, '2024-02-24', 'delivered', 'Москва'),
(9, 10, '2024-03-05', 'delivered', 'Санкт-Петербург'),
(10, 12, '2024-03-14', 'delivered', 'Москва'),
(11, 13, '2024-03-19', 'delivered', 'Москва'),
(12, 14, NULL, 'in_transit', 'Казань'),
(13, 15, '2024-03-29', 'delivered', 'Воронеж'),
(14, 16, '2024-04-05', 'delivered', 'Москва'),
(15, 17, '2024-04-10', 'delivered', 'Самара'),
(16, 18, '2024-04-14', 'delivered', 'Москва'),
(17, 20, '2024-04-24', 'delivered', 'Санкт-Петербург');
