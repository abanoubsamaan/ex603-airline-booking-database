-- ============================================================
-- Task 5.2, Part A: Compare INNER JOIN and LEFT JOIN
-- ============================================================

-- Q5.2 Part A (1): Which flights exist, including ones that never had a booking?
SELECT
    f.flight_id,
    f.flight_number,
    b.booking_id
FROM flights f
LEFT JOIN bookings b
    ON f.flight_id = b.flight_id
ORDER BY f.flight_id;

-- Q5.2 Part A (2): Same question, but with INNER JOIN (only flights with bookings)
SELECT
    f.flight_id,
    f.flight_number,
    b.booking_id
FROM flights f
INNER JOIN bookings b
    ON f.flight_id = b.flight_id
ORDER BY f.flight_id;

-- Q5.2 Part A (3): How many flights does the inner join exclude?
SELECT
    COUNT(DISTINCT f.flight_id) AS all_flights,
    COUNT(DISTINCT b.flight_id) AS flights_with_bookings,
    COUNT(DISTINCT f.flight_id) - COUNT(DISTINCT b.flight_id) AS excluded_by_inner_join
FROM flights f
LEFT JOIN bookings b
    ON f.flight_id = b.flight_id;

-- Q5.2 Part A (4): Which flights have no bookings, and how many are there?
SELECT f.flight_id, f.flight_number
FROM flights f
LEFT JOIN bookings b
    ON f.flight_id = b.flight_id
WHERE b.booking_id IS NULL
ORDER BY f.flight_id;

-- Result: the LEFT JOIN returned all 15 flights and the INNER JOIN only 13, so the
-- inner join excluded 2 producers (flight_id 14 and 15). I counted them with
-- COUNT(DISTINCT flight_id) so a flight with many bookings is only counted once.
-- They're missing because they have no rows in bookings. The inner join only keeps
-- flights with a matching booking, while the LEFT JOIN keeps them and shows NULL in
-- the booking columns.
-- Flights 14 and 15 are both active (is_active = true) and were first scheduled in
-- 2022, so they're not retired or new. The data shows they have no bookings but
-- can't tell me why. It could be that they aren't being sold, a data loading
-- problem, or that nobody booked them, so someone would need to look into it.


-- ============================================================
-- Task 5.2, Part B: RIGHT JOIN and FULL OUTER JOIN
-- ============================================================

-- Q5.2 Part B (1): Which flights exist, including ones with no bookings? (RIGHT JOIN)
SELECT
    f.flight_id,
    f.flight_number,
    b.booking_id
FROM bookings b
RIGHT JOIN flights f
    ON f.flight_id = b.flight_id
ORDER BY f.flight_id;

-- Q5.2 Part B (2): Do the LEFT JOIN and RIGHT JOIN return the same number of rows?
SELECT
    (SELECT COUNT(*)
     FROM flights f
     LEFT JOIN bookings b ON f.flight_id = b.flight_id) AS left_join_rows,
    (SELECT COUNT(*)
     FROM bookings b
     RIGHT JOIN flights f ON f.flight_id = b.flight_id) AS right_join_rows;

-- Q5.2 Part B (3a): What does a FULL OUTER JOIN return, matched and unmatched rows from both tables?
SELECT
    f.flight_id,
    f.flight_number,
    b.booking_id
FROM flights f
FULL OUTER JOIN bookings b
    ON f.flight_id = b.flight_id
ORDER BY f.flight_id, b.booking_id;

-- Q5.2 Part B (3b): How many rows are matched and unmatched on each side?
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN f.flight_id IS NOT NULL AND b.booking_id IS NOT NULL THEN 1 ELSE 0 END) AS matched_rows,
    SUM(CASE WHEN b.booking_id IS NULL THEN 1 ELSE 0 END) AS flights_without_bookings,
    SUM(CASE WHEN f.flight_id IS NULL THEN 1 ELSE 0 END) AS bookings_without_flights
FROM flights f
FULL OUTER JOIN bookings b
    ON f.flight_id = b.flight_id;

-- Part B notes: the RIGHT JOIN is the LEFT JOIN with the tables swapped. Both return
-- 202 rows, including flights 14 and 15 with NULL bookings. The FULL OUTER JOIN also
-- returned 202 rows: 200 matched, 2 flights with no bookings, and 0 bookings with no
-- flight. A full outer join can show unmatched rows on both sides in one query, which
-- a left or right join alone can't. Here the bookings side is always 0 because
-- bookings.flight_id has a foreign key to flights, so it didn't show anything extra.


-- ============================================================
-- Task 5.2, Part C: Producers with no events, two approaches
-- ============================================================

-- Q5.2 Part C (1): Which flights have never had a booking? (NOT EXISTS)
SELECT
    f.flight_id,
    f.flight_number
FROM flights f
WHERE NOT EXISTS (
    SELECT 1
    FROM bookings b
    WHERE b.flight_id = f.flight_id
)
ORDER BY f.flight_id;

-- Q5.2 Part C (2): Same question using EXCEPT
-- (all flight ids minus the flight ids that appear in bookings)
SELECT flight_id
FROM flights
EXCEPT
SELECT flight_id
FROM bookings
ORDER BY flight_id;

-- Part C notes: NOT EXISTS checks each flight for a matching booking and keeps it only
-- if there is none. EXCEPT subtracts the flight ids found in bookings from the full
-- list of flight ids. Both returned the same 2 flights (14 and 15).