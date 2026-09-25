-- =================================================================
-- EX 603 Assignment 2 — schema.sql
-- Theme: <Airline Booking>
-- Author: <Abanoub Samaan>
-- Target: PostgreSQL 14+
-- =================================================================
-- Reset. Reverse creation order, so no dependency blocks a drop.
DROP TABLE IF EXISTS flight_routes   CASCADE;
DROP TABLE IF EXISTS airports   CASCADE;
DROP TABLE IF EXISTS bookings   CASCADE;
DROP TABLE IF EXISTS flights    CASCADE;
DROP TABLE IF EXISTS passengers CASCADE;

-- ----------------------------------------------------------------
-- 1. passengers — first, because it doesn't reference any other tables
-- ----------------------------------------------------------------
CREATE TABLE passengers (
    passenger_id BIGINT,
    name VARCHAR(100) NOT NULL,

    CONSTRAINT pk_passengers PRIMARY KEY (passenger_id)
);

-- ----------------------------------------------------------------
-- 2. airports
-- ----------------------------------------------------------------
CREATE TABLE airports (
    airport_id BIGINT,
    name VARCHAR(150) NOT NULL,

    CONSTRAINT pk_airports PRIMARY KEY (airport_id)
);

-- ----------------------------------------------------------------
-- 3. flights
-- ----------------------------------------------------------------
CREATE TABLE flights (
    flight_id BIGINT,
    name VARCHAR(150) NOT NULL,
    is_active BOOLEAN NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP NOT NULL,
    available_seats INTEGER NOT NULL CHECK (available_seats >= 0),

    CONSTRAINT pk_flights PRIMARY KEY (flight_id)
);

-- ----------------------------------------------------------------
-- 4. bookings
-- ----------------------------------------------------------------
CREATE TABLE bookings (
    booking_id BIGINT,
    passenger_id BIGINT NOT NULL,
    flight_id BIGINT NOT NULL,

    CONSTRAINT pk_bookings PRIMARY KEY (booking_id),
    CONSTRAINT fk_bookings_passengers FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id) ON DELETE CASCADE,
    CONSTRAINT fk_bookings_flights FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------
-- 5. flight_routes
-- ----------------------------------------------------------------
CREATE TABLE flight_routes (
    flight_id BIGINT,
    airport_id BIGINT,
    CONSTRAINT pk_flight_routes PRIMARY KEY (flight_id, airport_id),
    CONSTRAINT fk_flight_routes_flight FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE,
    CONSTRAINT fk_flight_routes_airport FOREIGN KEY (airport_id) REFERENCES airports(airport_id) ON DELETE  RESTRICT
);

