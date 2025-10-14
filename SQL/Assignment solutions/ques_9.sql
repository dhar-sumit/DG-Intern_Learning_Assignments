-- =============================================
-- 9. Write an SQL query to find, for each month and country:
--    - the number of approved transactions and their total amount,
--    - the number of chargebacks and their total amount.
--
-- Table: Transactions
-- Column Name   Type
-- id            int
-- country       varchar
-- state         enum
-- amount        int
-- trans_date    date
--
-- id is the primary key of this table.
-- The table has information about incoming transactions.
-- The state column is an enum of type ["approved", "declined"].
--
-- Table: Chargebacks
-- Column Name   Type
-- trans_id      int
-- trans_date    date
--
-- Chargebacks contains basic information regarding incoming chargebacks
-- from some transactions placed in the Transactions table.
-- trans_id is a foreign key to the id column of Transactions table.
-- Each chargeback corresponds to a transaction made previously,
-- even if they were not approved.
--
-- Note: In your query, given the month and country, ignore rows with all zeros.
-- Return the result table in any order.
--
-- Input:
-- Transactions table:
-- +-----+---------+----------+--------+------------+
-- | id  | country | state    | amount | trans_date |
-- +-----+---------+----------+--------+------------+
-- | 101 | US      | approved | 1000   | 2019-05-18 |
-- | 102 | US      | declined | 2000   | 2019-05-19 |
-- | 103 | US      | approved | 3000   | 2019-06-10 |
-- | 104 | US      | declined | 4000   | 2019-06-13 |
-- | 105 | US      | approved | 5000   | 2019-06-15 |
-- +-----+---------+----------+--------+------------+
--
-- Chargebacks table:
-- +----------+------------+
-- | trans_id | trans_date |
-- +----------+------------+
-- | 102      | 2019-05-29 |
-- | 101      | 2019-06-30 |
-- | 105      | 2019-09-18 |
-- +----------+------------+
--
-- Output:
-- +---------+---------+----------------+------------------+------------------+--------------------+
-- | month   | country | approved_count | approved_amount  | chargeback_count | chargeback_amount  |
-- +---------+---------+----------------+------------------+------------------+--------------------+
-- | 2019-05 | US      | 1              | 1000             | 1                | 2000               |
-- | 2019-06 | US      | 2              | 8000             | 1                | 1000               |
-- | 2019-09 | US      | 0              | 0                | 1                | 5000               |
-- +---------+---------+----------------+------------------+------------------+--------------------+
--
-- Explanation:
-- May 2019: 1 approved transaction (ID 101 for $1000), 1 chargeback (ID 102 for $2000)
-- June 2019: 2 approved transactions (IDs 103 & 105 for $3000 + $5000), 1 chargeback (ID 101 for $1000)
-- September 2019: 1 chargeback (ID 105 for $5000), but no approved transactions
-- Rows with all zero values are excluded.
-- =============================================


WITH g1 AS (
    SELECT TO_CHAR(trans_date, 'YYYY-MM') AS month,
        country,
        COUNT(*) AS approved_count,
        SUM(amount) AS approved_amount
        FROM Transactions
        WHERE state = 'approved'
        GROUP BY month, country
), g2 AS (
    SELECT TO_CHAR(c.trans_date, 'YYYY-MM') AS month,
        country,
        COUNT(*) AS chargeback_count,
        SUM(t.amount) AS chargeback_amount
        FROM Chargebacks c
        JOIN Transactions t ON c.trans_id = t.id
        GROUP BY month, country
)
SELECT COALESCE(g1.month, g2.month) AS month,
    COALESCE(g1.country, g2.country) AS country,
    COALESCE(g1.approved_count, 0) AS approved_count,
    COALESCE(g1.approved_amount, 0) AS approved_amount,
    COALESCE(g2.chargeback_count, 0) AS chargeback_count,
    COALESCE(g2.chargeback_amount, 0) AS chargeback_amount
FROM g2 
LEFT JOIN g1 ON g1.month = g2.month
ORDER BY month;
    