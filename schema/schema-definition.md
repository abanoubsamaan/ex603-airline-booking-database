# Task 1.1: Define the relation schema

## Passengers
````
passengers(
    passenger_id: BIGINT,
    name: VARCHAR(100)
)
````
PRIMARY KEY: (passenger_id)

## Flights
````
flights(
    flight_id: BIGINT,
    name: VARCHAR(150),
    is_active: BOOLEAN,
    available_seats: INTEGER
)
````
PRIMARY KEY: (flight_id)

## Bookings
````
bookings(
    booking_id: BIGINT,
    passenger_id: BIGINT,
    flight_id: BIGINT,
)
````
PRIMARY KEY: (booking_id)


## Airports
````
airports(
    airport_id: BIGINT,
    name: VARCHAR(100),
)
````
PRIMARY KEY: (airport_id)

## Flight Routes
````
flight_routes(
    flight_id: BIGINT,
    airport_id: BIGINT
)
````
PRIMARY KEY: (flight_id, airport_id)
