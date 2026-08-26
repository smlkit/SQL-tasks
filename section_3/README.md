# SQL Window Functions Practice — E-commerce Analytics

Набор из **40 задач исключительно на оконные функции**.

Задачи построены на датасете интернет-магазина и специально подобраны так, чтобы несколько раз потренировать:

- `ROW_NUMBER()`
- `RANK()`
- `DENSE_RANK()`
- `NTILE()`
- `PERCENT_RANK()`
- `CUME_DIST()`
- `LAG()`
- `LEAD()`
- `FIRST_VALUE()`
- `LAST_VALUE()`
- `NTH_VALUE()`
- `SUM() OVER`
- `AVG() OVER`
- `MIN() OVER`
- `MAX() OVER`
- `COUNT() OVER`
- `ROWS BETWEEN`
- `RANGE BETWEEN`
- cumulative calculations
- rolling calculations
- moving averages
- running totals
- comparisons with previous/next rows
- `PARTITION BY`
- несколько оконных функций в одном запросе

> **Важно:** все задачи должны решаться с использованием оконных функций. Не заменяйте оконные функции обычными `GROUP BY`, коррелированными подзапросами или self join без необходимости.

---

# Database Schema

Датасет моделирует интернет-магазин.

```text
customers
    │
    │ 1:N
    ▼
orders
    │
    ├───────────────► order_items
    │                      │
    │                      ▼
    │                  products
    │                      │
    │                      ▼
    │                  categories
    │
    └───────────────► payments

products
    │
    └───────────────► sellers

orders
    │
    └───────────────► reviews
```

---

# Tables

## customers

```sql
customer_id
customer_name
registration_date
country
city
customer_segment
```

Пример `customer_segment`:

```text
New
Regular
Premium
VIP
```

---

## orders

```sql
order_id
customer_id
order_date
order_status
total_amount
shipping_cost
discount_amount
```

Возможные значения `order_status`:

```text
completed
cancelled
returned
processing
```

---

## order_items

```sql
order_item_id
order_id
product_id
quantity
unit_price
discount_percent
```

---

## products

```sql
product_id
product_name
category_id
seller_id
cost_price
list_price
```

---

## categories

```sql
category_id
category_name
parent_category_id
```

---

## sellers

```sql
seller_id
seller_name
country
rating
```

---

## payments

```sql
payment_id
order_id
payment_date
payment_method
payment_amount
```

---

## reviews

```sql
review_id
product_id
customer_id
review_date
rating
```

---

# Part 1 — ROW_NUMBER(), RANK(), DENSE_RANK()

## 1. Последний заказ клиента

Для каждого клиента пронумеровать его заказы от самого нового к самому старому.

Вывести:

```text
customer_id
order_id
order_date
total_amount
order_number
```

Где `order_number = 1` — последний заказ клиента.

Использовать `ROW_NUMBER()`.

---

## 2. Первый заказ клиента

Для каждого клиента пронумеровать заказы от самого старого к самому новому.

Определить:

```text
first_order
repeat_order
```

с помощью `ROW_NUMBER()`.

Вывести только дату и сумму первого заказа.

---

## 3. Топ-3 заказа каждого клиента

Для каждого клиента найти его три самых дорогих заказа.

Использовать:

```sql
ROW_NUMBER()
```

с `PARTITION BY customer_id`.

---

## 4. Рейтинг продавцов по revenue

Рассчитать revenue каждого продавца.

Затем присвоить продавцам места:

```text
1
2
3
...
```

Использовать `RANK()`.

Обратить внимание на ситуацию, когда несколько продавцов имеют одинаковый revenue.

---

## 5. Рейтинг товаров внутри категории

Для каждого товара рассчитать его revenue.

Затем определить место товара среди товаров той же категории.

Использовать:

```sql
RANK() OVER (
    PARTITION BY category_id
    ORDER BY revenue DESC
)
```

---

## 6. DENSE_RANK для клиентов

Рассчитать total revenue каждого клиента.

Присвоить клиентам рейтинг с помощью `DENSE_RANK()`.

Сравнить результат с `RANK()` для клиентов с одинаковым revenue.

---

# Part 2 — NTILE(), PERCENT_RANK(), CUME_DIST()

## 7. Квартиль клиентов по revenue

Рассчитать total revenue каждого клиента.

Разделить клиентов на 4 группы:

```text
1 — top 25%
2 — 25–50%
3 — 50–75%
4 — bottom 25%
```

Использовать:

```sql
NTILE(4)
```

---

## 8. Дециль товаров по продажам

Рассчитать revenue каждого товара.

Разделить товары на 10 групп по revenue.

Использовать:

```sql
NTILE(10)
```

---

## 9. Percent Rank продавцов

Рассчитать revenue каждого продавца.

Определить относительное положение каждого продавца среди остальных продавцов.

Использовать:

```sql
PERCENT_RANK()
```

---

## 10. Cumulative Distribution клиентов

Рассчитать total revenue каждого клиента.

Определить `CUME_DIST()` клиента по revenue.

Ответ должен содержать:

```text
customer_id
revenue
cume_distribution
```

---

## 11. Сравнение NTILE и PERCENT_RANK

Для каждого клиента одновременно рассчитать:

- `NTILE(4)`;
- `PERCENT_RANK()`;
- `CUME_DIST()`.

Проанализировать, почему результаты разных функций могут отличаться.

---

# Part 3 — LAG() и LEAD()

## 12. Предыдущий заказ клиента

Для каждого заказа вывести:

```text
customer_id
order_date
total_amount
previous_order_amount
```

Использовать `LAG()`.

---

## 13. Изменение суммы заказа

Для каждого клиента показать:

- текущую сумму заказа;
- сумму предыдущего заказа;
- абсолютное изменение;
- процентное изменение.

Использовать `LAG()`.

---

## 14. Интервал между заказами

Для каждого клиента определить количество дней между текущим заказом и предыдущим.

Использовать `LAG(order_date)`.

---

## 15. Следующий заказ клиента

Для каждого заказа определить:

- дату следующего заказа;
- сумму следующего заказа.

Использовать `LEAD()`.

---

## 16. Изменение цены товара

Для каждого товара определить предыдущую по времени цену продажи.

Вывести:

```text
product_id
order_date
unit_price
previous_unit_price
price_change
```

Использовать `LAG()`.

---

## 17. Следующая покупка

Для каждого клиента определить:

- текущий заказ;
- дату следующего заказа;
- количество дней до следующего заказа.

Использовать `LEAD()`.

Для последнего заказа клиента значение должно быть `NULL`.

---

# Part 4 — FIRST_VALUE(), LAST_VALUE(), NTH_VALUE()

## 18. Первый заказ клиента

Для каждого заказа показать сумму первого заказа клиента.

Использовать:

```sql
FIRST_VALUE()
```

Результат должен выглядеть примерно так:

```text
customer_id | order_date | amount | first_order_amount
```

---

## 19. Первый товар продавца

Для каждого товара продавца показать название самого дорогого товара этого продавца.

Использовать `FIRST_VALUE()`.

---

## 20. Последний заказ клиента

Для каждого заказа показать:

- текущую сумму;
- сумму последнего заказа клиента.

Использовать `LAST_VALUE()`.

Обязательно самостоятельно определить правильный оконный frame.

---

## 21. Последний рейтинг товара

Для каждого отзыва показать последний рейтинг, который получил данный товар.

Использовать `LAST_VALUE()`.

Обратить внимание на оконный frame.

---

## 22. Второй заказ клиента

Для каждого заказа показать сумму второго заказа соответствующего клиента.

Использовать:

```sql
NTH_VALUE(..., 2)
```

---

## 23. Третий самый дорогой товар продавца

Для каждого товара показать цену третьего по стоимости товара соответствующего продавца.

Использовать:

```sql
NTH_VALUE(..., 3)
```

---

# Part 5 — Running Total / Cumulative SUM

## 24. Накопительная выручка

Рассчитать дневную выручку магазина.

Для каждого дня показать:

```text
date
daily_revenue
cumulative_revenue
```

Использовать:

```sql
SUM(...) OVER (
    ORDER BY date
)
```

---

## 25. Накопительная выручка каждого продавца

Для каждого продавца рассчитать продажи по дням.

Добавить:

```text
cumulative_seller_revenue
```

Использовать:

```sql
PARTITION BY seller_id
```

---

## 26. Накопительная выручка по категориям

Для каждой категории рассчитать месячную выручку.

Затем добавить cumulative revenue внутри каждой категории.

Использовать:

```sql
SUM(revenue) OVER (
    PARTITION BY category_id
    ORDER BY month
)
```

---

## 27. Доля накопительной выручки

Для каждого продавца рассчитать:

- revenue товара;
- cumulative revenue;
- total revenue продавца;
- cumulative revenue share.

Пример:

```text
product | revenue | cumulative_revenue | cumulative_share
```

---

# Part 6 — Rolling SUM / AVG

## 28. Rolling 3-day revenue

Рассчитать дневную выручку.

Для каждого дня рассчитать сумму продаж за:

- текущий день;
- предыдущий день;
- два предыдущих дня.

Использовать:

```sql
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
```

---

## 29. Rolling 7-day revenue

Рассчитать ежедневную выручку и 7-дневную скользящую сумму.

Использовать:

```sql
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
```

---

## 30. Rolling 3-month revenue

Рассчитать месячную выручку.

Добавить:

```text
rolling_3_month_revenue
```

которая включает текущий месяц и два предыдущих.

---

## 31. Rolling average order value

Для каждого дня рассчитать:

- daily AOV;
- rolling 7-day AOV.

Использовать:

```sql
AVG(...) OVER (
    ORDER BY date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
)
```

---

## 32. Rolling average клиента

Для каждого клиента рассчитать среднюю стоимость его заказов с учётом:

- текущего заказа;
- двух предыдущих заказов.

Использовать:

```sql
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
```

---

## 33. Rolling 5-order average

Для каждого клиента рассчитать скользящее среднее последних пяти заказов.

Использовать:

```sql
ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
```

---

# Part 7 — MIN(), MAX(), COUNT() OVER

## 34. Минимальный и максимальный заказ клиента

Для каждого заказа показать:

```text
current_order_amount
minimum_customer_order
maximum_customer_order
```

Использовать:

```sql
MIN() OVER
MAX() OVER
```

---

## 35. Максимальная продажа продавца на текущий момент

Для каждого продавца и каждой продажи показать максимальную сумму продажи, которая была достигнута **к текущей строке**.

Использовать cumulative window frame.

---

## 36. Количество заказов клиента

Для каждого заказа показать:

```text
customer_id
order_id
order_date
customer_order_count
```

`customer_order_count` должен показывать общее количество заказов клиента.

Использовать:

```sql
COUNT(*) OVER (
    PARTITION BY customer_id
)
```

---

## 37. Номер месяца и количество заказов

Для каждого месяца вывести:

- количество заказов;
- накопительное количество заказов с начала года.

Использовать `COUNT() OVER`.

---

# Part 8 — Advanced Window Analytics

## 38. Customer Lifetime Progress

Для каждого заказа клиента рассчитать:

```text
order_number
order_amount
previous_order_amount
first_order_amount
customer_total_revenue
cumulative_customer_revenue
average_order_amount_to_date
```

Использовать комбинацию:

- `ROW_NUMBER()`;
- `LAG()`;
- `FIRST_VALUE()`;
- `SUM() OVER`;
- `AVG() OVER`.

---

## 39. Seller Performance Dashboard

Для каждого продавца и каждого месяца рассчитать:

```text
seller_id
month
monthly_revenue
previous_month_revenue
revenue_change
rolling_3_month_revenue
seller_total_revenue
seller_rank
seller_percent_rank
```

Использовать комбинацию:

- `LAG()`;
- `SUM() OVER`;
- `RANK()`;
- `PERCENT_RANK()`.

---

## 40. Advanced Product Analytics

Создать аналитическую таблицу по товарам.

Для каждого товара вывести:

```text
product_id
product_name
category_id
seller_id
revenue
category_rank
seller_rank
revenue_quartile
previous_product_revenue
next_product_revenue
cumulative_category_revenue
category_total_revenue
category_revenue_share
```

Необходимо использовать как можно больше различных оконных функций.

Минимально использовать:

- `RANK()`;
- `NTILE()`;
- `LAG()`;
- `LEAD()`;
- `SUM() OVER`;
- `PARTITION BY`.

---

# Window Functions Coverage

## Ranking Functions

| Function | Tasks |
|---|---|
| `ROW_NUMBER()` | 1, 2, 3, 38 |
| `RANK()` | 4, 5, 39, 40 |
| `DENSE_RANK()` | 6 |
| `NTILE()` | 7, 8, 11, 40 |
| `PERCENT_RANK()` | 9, 11, 39 |
| `CUME_DIST()` | 10, 11 |

---

## Offset Functions

| Function | Tasks |
|---|---|
| `LAG()` | 12, 13, 14, 16, 38, 39, 40 |
| `LEAD()` | 15, 17, 40 |

---

## Value Functions

| Function | Tasks |
|---|---|
| `FIRST_VALUE()` | 18, 19, 38 |
| `LAST_VALUE()` | 20, 21 |
| `NTH_VALUE()` | 22, 23 |

---

## Aggregate Window Functions

| Function | Tasks |
|---|---|
| `SUM() OVER` | 24, 25, 26, 27, 28, 29, 30, 38, 39, 40 |
| `AVG() OVER` | 31, 32, 33, 38 |
| `MIN() OVER` | 34 |
| `MAX() OVER` | 34, 35 |
| `COUNT() OVER` | 36, 37 |

---

# Window Frames Practice

Особое внимание уделить оконным frame'ам.

## Running total

```sql
SUM(revenue) OVER (
    ORDER BY date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

Используется в задачах:

- 24
- 25
- 26
- 27
- 35
- 38
- 39
- 40

---

## Rolling 3 rows

```sql
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
```

Используется в:

- 28
- 30
- 32

---

## Rolling 7 rows

```sql
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
```

Используется в:

- 29
- 31

---

## Rolling 5 rows

```sql
ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
```

Используется в:

- 33

---

## Full partition

```sql
ROWS BETWEEN UNBOUNDED PRECEDING
     AND UNBOUNDED FOLLOWING
```

Особенно полезен для:

- `FIRST_VALUE()`;
- `LAST_VALUE()`;
- `NTH_VALUE()`.

Используется в:

- 20
- 21
- 22
- 23

---

# Recommended Difficulty

| Tasks | Difficulty |
|---|---|
| 1–6 | 🟡 Intermediate |
| 7–11 | 🟡 Intermediate+ |
| 12–17 | 🟠 Intermediate+ |
| 18–23 | 🟠 Advanced |
| 24–27 | 🟠 Advanced |
| 28–33 | 🔴 Advanced |
| 34–37 | 🔴 Advanced |
| 38–40 | 🔥 Advanced+ |

---

# Skills Checklist

После выполнения этого набора желательно уверенно владеть:

- [ ] `ROW_NUMBER()`
- [ ] `RANK()`
- [ ] `DENSE_RANK()`
- [ ] `NTILE()`
- [ ] `PERCENT_RANK()`
- [ ] `CUME_DIST()`
- [ ] `LAG()`
- [ ] `LEAD()`
- [ ] `FIRST_VALUE()`
- [ ] `LAST_VALUE()`
- [ ] `NTH_VALUE()`
- [ ] `SUM() OVER`
- [ ] `AVG() OVER`
- [ ] `MIN() OVER`
- [ ] `MAX() OVER`
- [ ] `COUNT() OVER`
- [ ] `PARTITION BY`
- [ ] `ORDER BY` внутри окна
- [ ] `ROWS BETWEEN`
- [ ] `UNBOUNDED PRECEDING`
- [ ] `UNBOUNDED FOLLOWING`
- [ ] running total
- [ ] rolling sum
- [ ] rolling average
- [ ] cumulative percentage
- [ ] сравнение с предыдущей строкой
- [ ] сравнение со следующей строкой
- [ ] ranking внутри группы
- [ ] ranking без `PARTITION BY`
- [ ] несколько оконных функций в одном запросе
- [ ] комбинация нескольких оконных функций в одном аналитическом пайплайне

---

# Final Challenge

Попробуйте решить задачи **38–40 без подсказок**, используя несколько оконных функций одновременно.

Главная цель — научиться видеть задачу не как:

> «Какую оконную функцию здесь использовать?»

а как:

> «Какую аналитическую информацию я хочу получить и какие окна нужны для каждого показателя?»

Например:

```text
customer
   ↓
orders
   ↓
ROW_NUMBER()      → номер заказа
LAG()             → предыдущий заказ
FIRST_VALUE()     → первый заказ
SUM() OVER        → накопительная сумма
AVG() OVER        → среднее на текущий момент
RANK()            → место клиента
NTILE()           → сегмент
```

Именно такое комбинирование оконных функций является основной целью этого набора.
