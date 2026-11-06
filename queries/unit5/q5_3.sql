-- ============================================================
-- Task 5.3, Part A: CROSS JOIN
-- ============================================================

-- Q5.3 Part A (1): How many rows are in each source table, and does the CROSS JOIN
-- row count equal flights x airports?
SELECT
    (SELECT COUNT(*) FROM flights)  AS flights_rows,
    (SELECT COUNT(*) FROM airports) AS airports_rows,
    (SELECT COUNT(*) FROM flights) * (SELECT COUNT(*) FROM airports) AS expected_rows,
    (SELECT COUNT(*) FROM flights CROSS JOIN airports) AS cross_join_rows;

-- Q5.3 Part A (2): What are all possible flight and airport pairs? (CROSS JOIN)
SELECT
    f.flight_id,
    f.flight_number,
    a.iata_code
FROM flights f
CROSS JOIN airports a
ORDER BY f.flight_id, a.iata_code;


-- ============================================================
-- Task 5.3, Part B: Execution plan for the three-table join from Task 5.1
-- ============================================================

-- Q5.3 Part B: How does PostgreSQL plan the three-table join from Task 5.1?
EXPLAIN
SELECT
    p.passenger_id,
    p.passenger_name,
    b.booking_id,
    b.booked_at,
    f.flight_id,
    f.flight_number
FROM bookings b
JOIN passengers p
    ON b.passenger_id = p.passenger_id
JOIN flights f
    ON b.flight_id = f.flight_id
ORDER BY b.booked_at;