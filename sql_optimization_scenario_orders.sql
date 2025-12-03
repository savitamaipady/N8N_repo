-- Scenario: Order Management Query with Performance Issues
-- Purpose: Demonstrate SQL with optimization opportunities

-- Problem areas included:
-- 1. Inefficient JOIN sequence
-- 2. SELECT * usage
-- 3. Non-sargable predicates (functions on columns)
-- 4. OR filters reducing index effectiveness
-- 5. DISTINCT used to mask duplicates
-- 6. Correlated subquery for latest order
-- 7. ORDER BY on unindexed computed expression

-- Tables
CREATE TABLE order_header (
    order_id      NUMBER PRIMARY KEY,
    customer_id   NUMBER,
    order_date    DATE,
    order_status  VARCHAR2(20),
    total_amount  NUMBER
);

CREATE TABLE order_items (
    item_id       NUMBER PRIMARY KEY,
    order_id      NUMBER,
    product_id    NUMBER,
    quantity      NUMBER,
    unit_price    NUMBER
);

CREATE TABLE products (
    product_id    NUMBER PRIMARY KEY,
    category      VARCHAR2(50),
    product_name  VARCHAR2(100)
);

-- Sample query with optimization scope
SELECT DISTINCT *
FROM order_header oh
JOIN order_items oi ON oh.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE 
      LOWER(oh.order_status) = 'completed' -- function on column
      OR TRUNC(oh.order_date) = TRUNC(SYSDATE - 7) -- non-sargable
      OR p.category IN (
            SELECT category
            FROM products
            WHERE LENGTH(category) > 5 -- expensive function
        )
      AND oh.order_id IN (
            SELECT order_id
            FROM order_items
            WHERE quantity > 10 -- correlated subquery
        )
ORDER BY (oi.quantity * oi.unit_price) DESC;