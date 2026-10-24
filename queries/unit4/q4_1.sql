-- Q1: Overall statistics for the bookings table
SELECT COUNT(*) AS total_bookings,
       SUM(fare_paid) AS total_paid,
       AVG(fare_paid) AS average_paid,
       MIN(fare_paid) AS minimum_paid,
       MAX(fare_paid) AS maximum_paid,
       COUNT(DISTINCT passenger_id) AS distinct_passengers
FROM bookings;

-- Q2: Booking count and average fare for each flight (most bookings first)
SELECT flight_id,
       COUNT(*) AS total_bookings,
       ROUND(AVG(fare_paid), 2) AS average_fare
FROM bookings
GROUP BY flight_id
ORDER BY total_bookings DESC;

-- Q3: Cancellation rate for flights with at least 10 bookings
-- Threshold = 10: with fewer bookings, one cancellation changes the rate
-- by more than 10 percentage points, so the rate would not be reliable.
SELECT flight_id,
       COUNT(*) AS total_bookings,
       SUM(
            CASE WHEN booking_status = 'cancelled' THEN 1 
            ELSE 0 END
        ) AS cancelled_bookings,
       ROUND(100.0 * SUM(CASE WHEN booking_status = 'cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancellation_rate
FROM bookings
GROUP BY flight_id
HAVING COUNT(*) >= 10
ORDER BY cancellation_rate DESC;

-- Q4: Results by two dimensions: country (region) and flight
-- One row for each country + flight combination
SELECT booking_country,
       flight_id,
       COUNT(*) AS total_bookings,
       SUM(CASE WHEN booking_status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings,
       ROUND(100.0 * SUM(CASE WHEN booking_status = 'cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancellation_rate,
       ROUND(AVG(fare_paid), 2) AS average_fare
FROM bookings
GROUP BY booking_country, flight_id
ORDER BY booking_country, total_bookings DESC;