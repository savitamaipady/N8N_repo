-- Sample SQL script with optimization opportunities
-- Scenario: Sales reporting on large tables

-- Problem areas intentionally included:
-- 1. SELECT *
-- 2. Unindexed filtering columns
-- 3. OR conditions instead of UNION
-- 4. Functions on indexed columns
-- 5. Correlated subquery instead of JOIN
-- 6. Missing appropriate WHERE clauses
-- 7. GROUP BY on expressions

-- Create sample tables
CREATE TABLE customers (
    customer_id   NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100),
    region        VARCHAR2(20)
);

CREATE TABLE orders (
    order_id      NUMBER PRIMARY KEY,
    customer_id   NUMBER,
    order_date    DATE,
    order_amount  NUMBER,
    status        VARCHAR2(20)
);

-- Sample query with optimization scope
SELECT *
FROM orders o
WHERE 
      TO_CHAR(o.order_date, 'YYYY-MM-DD') BETWEEN '2024-01-01' AND '2024-12-31'
      OR o.status = 'SHIPPED'
      OR o.customer_id IN (
            SELECT c.customer_id
            FROM customers c
            WHERE UPPER(c.region) = 'NORTH'
        )
ORDER BY o.order_amount;
