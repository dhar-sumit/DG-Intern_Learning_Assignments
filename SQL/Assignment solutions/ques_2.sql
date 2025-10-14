-- =============================================
-- 2. Write an SQL query to report the nth highest salary from the Employee table.
-- If there is no nth highest salary, the query should report null.
--
-- Input: Employee table
-- +----+--------+
-- | id | salary |
-- +----+--------+
-- | 1  | 100    |
-- | 2  | 200    |
-- | 3  | 300    |
-- +----+--------+
-- n = 2
--
-- Output:
-- +------------------------+
-- | getNthHighestSalary(2) |
-- +------------------------+
-- | 200                    |
-- +------------------------+
--
-- Input: Employee table
-- +----+--------+
-- | id | salary |
-- +----+--------+
-- | 1  | 100    |
-- +----+--------+
-- n = 2
--
-- Output:
-- +------------------------+
-- | getNthHighestSalary(2) |
-- +------------------------+
-- | null                   |
-- +------------------------+
-- =============================================

WITH cte AS(
    SELECT id, salary,
            ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn
    FROM Employee
)
SELECT salary AS getNthHighestSalary
FROM cte
WHERE rn = 2;