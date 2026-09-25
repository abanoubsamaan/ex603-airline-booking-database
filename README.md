# Airline Booking System

**Name:** Abanoub Samaan

**Theme:** Airline Booking

This system manages airline flights, passengers, bookings, and routes through a relational database.

---
## Domain

The Airline Booking platform is designed to manage information related to flights, passengers, bookings, airports, and the routes connecting flights to airports. The system keeps track of passengers and their bookings, the flights available, and the airports associated with each flight. The goal is to organize this information in a relational database so that it can be stored, updated, and queried efficiently.

The platform should be able to answer questions such as which passengers are booked on a specific flight, which flights are associated with a specific airport, and which airports are part of a specific flight route. It should also allow us to find information about available seats, passengers, bookings, and flights, while maintaining the relationships between these different parts of the system.

---
## ERD

![Airline Booking ERD](./schema/ERD.png)

---
## Schema

The schema contains five tables: `passengers` stores passenger information, `flights` stores flight information, `bookings` connects passengers to flights, `airports` stores airport information, and `flight_routes` connects flights to airports.

Each table has its own primary key, and `BIGINT` is used for the identifiers. The `bookings` table uses foreign keys to connect passengers and flights, while `flight_routes` is a junction table with a composite primary key of `flight_id` and `airport_id` to prevent duplicate flight-airport relationships. The foreign keys also use different `ON DELETE` choices based on how the related data should be handled.
