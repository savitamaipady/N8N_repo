-- Unoptimized SQL Example: Orders Report

-- 1. Using SELECT *
SELECT *
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN products p
  ON o.product_id = p.product_id;

-- 2. Correlated subquery
SELECT o.order_id,
       o.customer_id,
       (SELECT COUNT(*) 
        FROM order_items oi 
        WHERE oi.order_id = o.order_id) AS item_count
FROM orders o;

-- 3. No filtering on large tables
SELECT order_id, order_date, total_amount
FROM orders
ORDER BY order_date;

-- 4. Using functions on indexed columns (prevents index usage)
SELECT *
FROM orders
WHERE YEAR(order_date) = 2025;

-- 5. Nested subqueries that could be joined
SELECT o.order_id, o.customer_id
FROM orders o
WHERE o.customer_id IN (
    SELECT customer_id
    FROM customers
    WHERE country = 'USA'
);
