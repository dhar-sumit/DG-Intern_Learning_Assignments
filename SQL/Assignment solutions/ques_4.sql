-- =============================================
-- 4. Write an SQL query to swap the seat id of every two consecutive students.
-- If the number of students is odd, the id of the last student is not swapped.
--
-- Column Name  Type
-- id           int
-- name         varchar
--
-- id is the primary key column for this table.
-- Each row of this table indicates the name and the ID of a student.
-- id is a continuous increment.
--
-- Return the result table ordered by id in ascending order.
--
-- Input: Seat table:
-- +----+---------+
-- | id | student |
-- +----+---------+
-- | 1  | Abbot   |
-- | 2  | Doris   |
-- | 3  | Emerson |
-- | 4  | Green   |
-- | 5  | Jeames  |
-- +----+---------+
--
-- Output:
-- +----+---------+
-- | id | student |
-- +----+---------+
-- | 1  | Doris   |
-- | 2  | Abbot   |
-- | 3  | Green   |
-- | 4  | Emerson |
-- | 5  | Jeames  |
-- +----+---------+
--
-- Explanation:
-- Note that if the number of students is odd, there is no need to change the last one's seat.
-- =============================================


WITH grp1 AS (
    SELECT *, FLOOR((ROW_NUMBER() OVER (ORDER BY id) - 1) / 2) AS rn
    FROM Seat
), grp2 AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY rn ORDER BY id DESC) AS pos
    FROM grp1
)
SELECT ROW_NUMBER() OVER() AS id, name
FROM grp2
ORDER BY rn, pos;