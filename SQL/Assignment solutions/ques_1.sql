-- =============================================
-- 1. Write an SQL query to report the managers with at least five direct reports.
-- Return the result table in any order.
--
-- Input: Employee table
-- +-----+--------+------------+-----------+
-- | id  | name   | department | managerId |
-- +-----+--------+------------+-----------+
-- | 101 | John   | A          | NULL      |
-- | 102 | Dan    | A          | 101       |
-- | 103 | James  | A          | 101       |
-- | 104 | Amy    | A          | 101       |
-- | 105 | Anne   | A          | 101       |
-- | 106 | Ron    | B          | 101       |
-- +-----+--------+------------+-----------+
--
-- Output:
-- +--------+
-- | name   |
-- +--------+
-- | John   |
-- +--------+
-- =============================================

SELECT m.name
FROM Employee e
JOIN Employee m ON e.managerId = m.id
GROUP BY m.id, m.name
HAVING COUNT(e.id) >= 5;