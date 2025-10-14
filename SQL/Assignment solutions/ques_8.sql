-- =============================================
-- 8. Write an SQL query to find the prices of all products on 2019-08-16.
--    Assume the price of all products before any change is 10.
--
-- Column Name    Type
-- product_id     int
-- new_price      int
-- change_date    date
--
-- (product_id, change_date) is the primary key of this table.
-- Each row of this table indicates that the price of some product
-- was changed to a new price at some date.
--
-- Return the result table in any order.
--
-- Input:
-- Products table:
-- +------------+-----------+-------------+
-- | product_id | new_price | change_date |
-- +------------+-----------+-------------+
-- | 1          | 20        | 2019-08-14  |
-- | 2          | 50        | 2019-08-14  |
-- | 1          | 30        | 2019-08-15  |
-- | 1          | 35        | 2019-08-16  |
-- | 2          | 65        | 2019-08-17  |
-- | 3          | 20        | 2019-08-18  |
-- +------------+-----------+-------------+
--
-- Output:
-- +------------+-------+
-- | product_id | price |
-- +------------+-------+
-- | 2          | 50    |
-- | 1          | 35    |
-- | 3          | 10    |
-- +------------+-------+
--
-- Explanation:
-- Product 1 was updated to 35 on 2019-08-16.
-- Product 2 had its last change on 2019-08-14 before 2019-08-16, so its price was 50.
-- Product 3 had no changes before or on 2019-08-16, so its price is the default of 10.
-- =============================================


WITH change_price AS (
    SELECT product_id, new_price,
    ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY change_date DESC) AS row_num
    FROM Products
    WHERE change_date <= '2019-08-16'
), all_products AS (
    SELECT DISTINCT product_id FROM Products
)
SELECT a.product_id, COALESCE(cp.new_price, 10) AS price
FROM all_products a
LEFT JOIN change_price cp
ON a.product_id = cp.product_id AND cp.row_num = 1
ORDER BY price DESC;