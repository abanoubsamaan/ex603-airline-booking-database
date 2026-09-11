# Task 1.3: Integrity Constraints

Table definitions are specified in `schema-definition.md`.
 
---
 
## passengers
```
PRIMARY KEY: (passenger_id)
NOT NULL: name
```
 
## flights
```
PRIMARY KEY: (flight_id)
NOT NULL: name, is_active, available_seats
CHECK: available_seats >= 0
```
 
## airports
```
PRIMARY KEY: (airport_id)
NOT NULL: name
UNIQUE: name
```
 
## bookings
```
PRIMARY KEY: (booking_id)
NOT NULL: passenger_id, flight_id
FOREIGN KEY: (passenger_id) REFERENCES passengers(passenger_id) ON DELETE CASCADE
FOREIGN KEY: (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE
```
 
## flight_routes
```
PRIMARY KEY: (flight_id, airport_id)
FOREIGN KEY: (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE
FOREIGN KEY: (airport_id) REFERENCES airports(airport_id) ON DELETE RESTRICT
```