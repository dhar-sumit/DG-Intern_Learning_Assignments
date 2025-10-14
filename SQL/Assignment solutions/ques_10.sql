-- =============================================
-- 10. Write an SQL query that selects the team_id, team_name, and num_points
--     of each team in the tournament after all described matches.
--
-- Table: Teams
-- Column Name   Type
-- team_id       int
-- team_name     varchar
--
-- team_id is the primary key of this table.
-- Each row of this table represents a single football team.
--
-- Table: Matches
-- Column Name   Type
-- match_id      int
-- host_team     int
-- guest_team    int
-- host_goals    int
-- guest_goals   int
--
-- match_id is the primary key of this table.
-- Each row is a record of a finished match between two different teams.
-- Teams host_team and guest_team are represented by their IDs in the Teams table (team_id),
-- and they scored host_goals and guest_goals goals, respectively.
--
-- You would like to compute the scores of all teams after all matches.
-- Points are awarded as follows:
-- - A team receives 3 points if they win a match.
-- - A team receives 1 point if they draw a match.
-- - A team receives 0 points if they lose a match.
--
-- Return the result table ordered by num_points in decreasing order.
-- In case of a tie, order the records by team_id in increasing order.
--
-- Input:
-- Teams table:
-- +---------+--------------+
-- | team_id | team_name    |
-- +---------+--------------+
-- | 10      | Leetcode FC  |
-- | 20      | NewYork FC   |
-- | 30      | Atlanta FC   |
-- | 40      | Chicago FC   |
-- | 50      | Toronto FC   |
-- +---------+--------------+
--
-- Matches table:
-- +----------+-----------+-------------+-------------+---------------+
-- | match_id | host_team | guest_team  | host_goals  | guest_goals   |
-- +----------+-----------+-------------+-------------+---------------+
-- | 1        | 10        | 20          | 3           | 0             |
-- | 2        | 30        | 10          | 2           | 2             |
-- | 3        | 10        | 50          | 5           | 1             |
-- | 4        | 20        | 30          | 1           | 0             |
-- | 5        | 50        | 30          | 1           | 0             |
-- +----------+-----------+-------------+-------------+---------------+
--
-- Output:
-- +---------+--------------+-------------+
-- | team_id | team_name    | num_points  |
-- +---------+--------------+-------------+
-- | 10      | Leetcode FC  | 7           |
-- | 20      | NewYork FC   | 3           |
-- | 50      | Toronto FC   | 3           |
-- | 30      | Atlanta FC   | 1           |
-- | 40      | Chicago FC   | 0           |
-- +---------+--------------+-------------+
-- =============================================


WITH all_teams AS (
    SELECT host_team AS team_id,
        CASE
            WHEN host_goals > guest_goals THEN 3
            WHEN host_goals = guest_goals THEN 1
            ELSE 0
        END AS host_points
    FROM Matches
    UNION ALL
    SELECT guest_team AS team_id,
        CASE
            WHEN guest_goals > host_goals THEN 3
            WHEN guest_goals = host_goals THEN 1
            ELSE 0
        END AS guest_points
    FROM Matches
),
SELECT t.team_id,
    t.team_name,
    COALESCE(SUM(host_points), 0) AS num_points
FROM Teams t
LEFT JOIN all_teams a ON t.team_id = a.team_id
GROUP BY t.team_id, t.team_name
ORDER BY num_points DESC, t.team_id;