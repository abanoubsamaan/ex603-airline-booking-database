-- 3.3a Passengers with a no-show booking, using IN.
SELECT passenger_id
FROM passengers
WHERE passenger_id IN (
    SELECT passenger_id FROM bookings
    WHERE cancellation_reason = 'Passenger no show'
)
ORDER BY passenger_id;

-- 3.3b Same question, using a CTE (WITH).
WITH no_show_bookings AS (
    SELECT passenger_id FROM bookings
    WHERE cancellation_reason = 'Passenger no show'
)
SELECT passenger_id
FROM passengers
WHERE passenger_id IN (SELECT passenger_id FROM no_show_bookings)
ORDER BY passenger_id;

-- 3.3c Same question, using EXISTS.
SELECT p.passenger_id
FROM passengers p
WHERE EXISTS (
    SELECT 1 FROM bookings b
    WHERE b.passenger_id = p.passenger_id
      AND b.cancellation_reason = 'Passenger no show'
)
ORDER BY p.passenger_id;

-- 3.3d IN minus EXISTS: rows in IN but not in EXISTS. Expected: 0 rows.
SELECT passenger_id FROM passengers
WHERE passenger_id IN (SELECT passenger_id FROM bookings
                       WHERE cancellation_reason = 'Passenger no show')
EXCEPT
SELECT passenger_id FROM passengers p
WHERE EXISTS (SELECT 1 FROM bookings b
              WHERE b.passenger_id = p.passenger_id
                AND b.cancellation_reason = 'Passenger no show');

-- 3.3e EXISTS minus IN: rows in EXISTS but not in IN. Expected: 0 rows.
SELECT passenger_id FROM passengers p
WHERE EXISTS (SELECT 1 FROM bookings b
              WHERE b.passenger_id = p.passenger_id
                AND b.cancellation_reason = 'Passenger no show')
EXCEPT
SELECT passenger_id FROM passengers
WHERE passenger_id IN (SELECT passenger_id FROM bookings
                       WHERE cancellation_reason = 'Passenger no show');

-- Where equivalence breaks: NULLs.
-- If the subquery returned a NULL, NOT IN would return zero rows
-- (every comparison becomes UNKNOWN), while NOT EXISTS would still
-- return the correct rows. Here bookings.passenger_id is NOT NULL,
-- so all three forms agree on this dataset.