
-- Part A: total bookings and total cancelled bookings per flight, in one pass
SELECT flight_id,
       COUNT(*) AS total_bookings,
       SUM(CASE WHEN booking_status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings
FROM bookings
GROUP BY flight_id
ORDER BY cancelled_bookings DESC;

-- Part B: regional subtotals and a platform grand total (no detail rows)
SELECT booking_country,
       COUNT(*) AS total_bookings,
       SUM(CASE WHEN booking_status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings
FROM bookings
GROUP BY ROLLUP (booking_country)
ORDER BY booking_country, total_bookings DESC;
-- In the results, every row that shows a country name is that region’s subtotal, so you can see
-- how many bookings each country had and how many of them were cancelled.
-- The last row, where the country column is empty (NULL), is the grand total for the whole platform,
-- adding up all the countries together. There are no flight-level rows in the output because I only
-- put the region column inside the ROLLUP.


-- Part C: baseline cancellation rate for high-volume flights
-- Step 1: summarize each flight
WITH flight_summary AS (
    SELECT flight_id,
           COUNT(*) AS total_bookings,
           SUM(CASE WHEN booking_status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings,
           ROUND(100.0 * SUM(CASE WHEN booking_status = 'cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancellation_rate
    FROM bookings
    GROUP BY flight_id
)
-- Step 2: filter to high-volume flights and calculate the baseline
SELECT COUNT(*) AS high_volume_flights,
       ROUND(AVG(cancellation_rate), 2) AS baseline_cancellation_rate
FROM flight_summary
WHERE total_bookings >= 10;