-- 3.1a Active flights with large seat capacity.
-- Requirement: SELECT, WHERE, ORDER BY, LIMIT.
SELECT flight_id, seat_capacity
FROM flights
WHERE is_active = TRUE
AND seat_capacity >= 180
ORDER BY seat_capacity DESC
LIMIT 10;

-- 3.1b All possible booking statuses. Requirement: DISTINCT.
-- Note: there is no 'no_show' value, even though the scenario is about no-shows.
-- 'disputed' is the unexpected one.
SELECT DISTINCT booking_status
FROM bookings
ORDER BY booking_status;


-- 3.1c Bookings with a mid-range fare.
-- Requirement: WHERE with a numeric range (BETWEEN).
SELECT *
FROM bookings
WHERE fare_paid BETWEEN 30 AND 50
LIMIT 10;


-- 3.1d Bookings that did not complete normally.
-- Requirement: WHERE with IN (explicit list of values).
SELECT *
FROM bookings
WHERE booking_status IN ('cancelled', 'disputed')
LIMIT 10;

-- 3.1e Flights whose flight number starts with "VN2".
-- Requirement: LIKE.
SELECT flight_id, flight_number, origin_country, seat_capacity
FROM flights
WHERE flight_number LIKE 'VN2%'
LIMIT 10;

-- 3.1f Bookings with a missing cancellation reason, shown with a readable label.
-- Requirement: IS NULL, COALESCE.
SELECT booking_id,
       booking_status,
       COALESCE(cancellation_reason, 'No reason provided') AS reason
FROM bookings
WHERE booking_status = 'cancelled' AND cancellation_reason IS NULL
LIMIT 10;

-- 3.1g Bookings with plain-language labels.
-- Requirement: computed columns, CASE.
SELECT booking_id,
       booking_status,
       fare_paid,
       CASE
           WHEN fare_paid < 10 THEN 'Budget'
           WHEN fare_paid < 30 THEN 'Standard'
           ELSE 'Premium'
       END AS fare_category,
       CASE
           WHEN checked_in_at IS NULL THEN 'Not checked in'
           ELSE 'Checked in'
       END AS check_in_status
FROM bookings
ORDER BY booked_at
LIMIT 10;