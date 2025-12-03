-- Non-optimized SQL file for Product table

-- 1. Selecting all columns instead of only needed ones
SELECT *
FROM product;

-- 2. Using subquery instead of JOIN
SELECT p.product_name,
       (SELECT category_name 
        FROM category c
        WHERE c.category_id = p.category_id) AS category_name
FROM product p;

-- 3. Filtering with functions on column (prevents index usage)
SELECT *
FROM product
WHERE UPPER(product_name) = 'LAPTOP';

-- 4. Using OR conditions instead of IN
SELECT *
FROM product
WHERE category_id = 1 OR category_id = 2 OR category_id = 3;

-- 5. Using DISTINCT unnecessarily
SELECT DISTINCT product_name
FROM product;

-- 6. Using a CROSS JOIN instead of INNER JOIN
SELECT p.product_name, c.category_name
FROM product p
CROSS JOIN category c
WHERE p.category_id = c.category_id;

-- 7. Using multiple nested SELECTs instead of JOIN
SELECT *
FROM product
WHERE product_id IN (SELECT product_id 
                     FROM order_items 
                     WHERE quantity > 5);

-- 8. Using ORDER BY without LIMIT
SELECT *
FROM product
ORDER BY created_date DESC;

-- 9. Updating table row by row instead of set-based operation
UPDATE product
SET price = price * 1.1
WHERE product_id IN (SELECT product_id FROM product WHERE price < 100);

-- 10. Using subquery in SELECT for count
SELECT p.product_name,
       (SELECT COUNT(*) 
        FROM order_items o
        WHERE o.product_id = p.product_id) AS total_orders
FROM product p;
