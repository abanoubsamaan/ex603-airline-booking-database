### Constraints Table

| Foreign Key                                         | ON DELETE  | Reason                                                                 |
| --------------------------------------------------- | ---------- | ---------------------------------------------------------------------- |
| `bookings.passenger_id`  `passengers.passenger_id` | `CASCADE`  | If a passenger is removed, their bookings should also be removed.      |
| `bookings.flight_id`  `flights.flight_id`          | `CASCADE`  | If a flight is removed, its bookings should also be removed.           |
| `flight_routes.flight_id`  `flights.flight_id`     | `CASCADE`  | If a flight is removed, its route records should also be removed.      |
| `flight_routes.airport_id`  `airports.airport_id`  | `RESTRICT` | An airport cannot be removed while it is still used by a flight route. |

### Explanation

When a **passenger is removed**, `CASCADE` removes their bookings because those bookings no longer have a valid passenger. With `RESTRICT`, the passenger could not be removed until the bookings were deleted.

When a **flight is removed**, `CASCADE` removes its bookings because they refer to that flight. It also removes the flight's records from `flight_routes` because those records only exist for that flight.

When an **airport is removed**, `RESTRICT` prevents the deletion if the airport is still part of a flight route. Without this, we could end up with a route that refers to an airport that no longer exists.

### CHECK Constraint

The `available_seats >= 0` check prevents a flight from having a negative number of available seats. Without this constraint, an incorrect insert or update could store a value such as `-5`, which would not make sense in the airline booking system.
