-- 3.2a-0 What values does cancellation_reason contain, including NULL?
--    Requirement: GROUP BY.
SELECT cancellation_reason, COUNT(*) AS count
FROM bookings
GROUP BY cancellation_reason
ORDER BY count DESC;

-- 3.2a-1 Dashboard-style filter: bookings whose reason is not 'Passenger no show'.
SELECT COUNT(*) AS returned_rows
FROM bookings
WHERE cancellation_reason != 'Passenger no show';

-- 3.2a-2 Rows the filter silently omitted (NULL reason).
SELECT COUNT(*) AS omitted_rows
FROM bookings
WHERE cancellation_reason IS NULL;

-- 3.2a-3 Equal, not-equal, NULL and total counts in one table.
--  Requirement: UNION ALL, COUNT, IS NULL.
SELECT 'equal' AS label, COUNT(*) AS count FROM bookings WHERE cancellation_reason = 'Passenger no show'
UNION ALL
SELECT 'not equal', COUNT(*) FROM bookings WHERE cancellation_reason != 'Passenger no show'
UNION ALL
SELECT 'null', COUNT(*) FROM bookings WHERE cancellation_reason IS NULL
UNION ALL
SELECT 'table total', COUNT(*) FROM bookings;

-- 3.2a-4 Repaired: bookings whose reason is not 'Passenger no show',
-- now including the rows with no reason (NULL).
-- Requirement: IS NULL (or COALESCE).
SELECT COUNT(*) AS repaired_rows
FROM bookings
WHERE cancellation_reason != 'Passenger no show'
   OR cancellation_reason IS NULL;

-- 3.2b-1 Alias defined in SELECT, used in WHERE. This query fails on purpose.
-- Requirement: show the error caused by evaluation order.
-- [42703] ERROR: column "fare_with_tax" does not exist
--   Position: 99
SELECT booking_id,
       fare_paid,
       fare_paid * 6.75 AS fare_with_tax
FROM bookings
WHERE fare_with_tax > 20;


-- 3.2b-2 Fix 1: repeat the expression in WHERE.
SELECT booking_id,
       fare_paid,
       fare_paid * 1.1 AS fare_with_tax
FROM bookings
WHERE fare_paid * 1.1 > 20
ORDER BY fare_with_tax
LIMIT 10;

-- 3.2b-3 Fix 2: a CTE turns the alias into a real column.
WITH price_with_tax AS (
    SELECT booking_id,
           fare_paid,
           fare_paid * 1.1 AS fare_with_tax
    FROM bookings
)
SELECT booking_id, fare_paid, fare_with_tax
FROM price_with_tax
WHERE fare_with_tax > 20
ORDER BY fare_with_tax
LIMIT 10;