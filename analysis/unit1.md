# Task 1.4: your modelling justification and reflection.

## Modelling justification
The primary keys are supposed to always be set on something unique that doesn't change over time, that's why I have chosen (`passenger_id`, `flight_id`, `booking_id`, `airport_id`) attributes for the primary keys. I have also chosen BIGINT as a domain and not INTEGER, as BIGINT is more scalable in the long term. Someone might think of using names as primary keys; yes, they might be different, but they are not unique, as two passengers might share the same name at some point, and the same thing applies to the flights relation.

The table `flight_routes` is a bit different as it's a junction table, which normally doesn't have a single primary key attribute. Instead, it has two foreign keys, and they can be used together as a composite primary key `(flight_id, airport_id)`. This enforces that the flight cannot be linked to the same airport more than once.

I have also decided to mark all the attributes other than the primary keys `NOT NULL`, as they are all needed, like the passenger name, airport name, and flight name (primary keys are always `NOT NULL` by default, that's why I didn't need to specify this in `constraints.md`).

I also have a `CHECK` constraint on the flights relation for the `available_seats` attribute, as I wanted to make sure that the numbers being set here are not negative. So, it has to be equal to or greater than zero. We could leave this validation to the application, but it's better if we have a guardrail on the database side as well.

For the Airport relation, I wanted to make sure that the airport name is unique across all the airports, and this makes complete sense.

For `ON DELETE` constraints, I always check first what it will mean to leave orphaned data. Will it be useful? Will it be used later for anything? By answering these two questions, I'm able to define the DELETE or UPDATE constraints. For example, in the `bookings` relation, I decided to have `passenger_id` and `flight_id` as foreign keys, one referencing the passengers relation and the other referencing the flights relation, and both of them will cascade on delete, as it doesn't make sense to me to delete the passenger without deleting their bookings. But the `flight` is a bit debatable, as some systems might need to keep the bookings even if the related flight gets deleted and assign `NULL` to the `flight_id`. In my case, I decided to cascade it, the same as `passenger_id`, for the sake of the requirements. Also, in the `flight_routes` junction table, we have both attributes as a composite primary key, so they will never be `NULL`, and this would not work with `ON DELETE SET NULL`.

Lastly, for the `flight_routes` junction table, I have a `RESTRICT` constraint on airport deletion, as in my opinion, to delete the Airport record, you need to first delete the associated routes.

---

## Reflection

One decision I made in my ERD that another designer could reasonably make differently was the `ON DELETE` constraint for the `airport_id` in the `flight_routes` relation. I decided to use `RESTRICT` when deleting an airport. My reasoning was that I don't want the database to automatically delete the routes associated with an airport just because the airport record is being deleted. Another designer could choose `CASCADE`, which would automatically remove those routes, but I think `RESTRICT` is safer because it forces us to delete the associated routes first. This gives us more control over the data and helps prevent accidental deletion of route information. For the way the platform will be used, keeping the routes until they are intentionally deleted means the data is easier to preserve and review. For adding and deleting data, `RESTRICT` adds a guardrail because the user has to deal with the related routes before deleting the airport. This makes the deletion more intentional and protects the relationships in the database.