-- Finding the bookings along with passenger and flight details
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

-- Finding the airports associated with each flight
SELECT
    f.flight_id,
    f.flight_number,
    a.iata_code,
    a.airport_name
FROM flights f
JOIN flight_routes fr
    ON f.flight_id = fr.flight_id
JOIN airports a
    ON a.airport_id = fr.airport_id
WHERE a.iata_code = 'SIN'
ORDER BY f.flight_id;


-- Finding the number of bookings for flights using self join and subquery
WITH flight_activity AS (
    SELECT flight_id, COUNT(*) AS total_bookings
    FROM bookings
    GROUP BY flight_id
)
SELECT
    f1.flight_number   AS flight_a,
    fa1.total_bookings AS bookings_a,
    f2.flight_number   AS flight_b,
    fa2.total_bookings AS bookings_b,
    f1.origin_country
FROM flights f1
JOIN flights f2
    ON f1.origin_country = f2.origin_country
   AND f1.flight_id <> f2.flight_id
JOIN flight_activity fa1 
    ON f1.flight_id = fa1.flight_id
JOIN flight_activity fa2 
    ON f2.flight_id = fa2.flight_id;