## Task 5.1:
**Question 1: What feature or report could use the three-table join?**
I think this join could be used for a booking activity report that customer service or operations would look at. Each row shows who booked (passenger id and name), the booking id, which flight it was, and when it was booked. Right now the bookings table only has ids, which doesn't tell a person much, so the join makes it readable. Customer service could use it when a passenger calls and asks about their booking, and operations could use it to see whats being booked recently. If a booking status column was added, they could also follow up on bookings that end up as no-shows.

**Question 2: Why is the junction table important?**
A flight can go through more than one airport and an airport can have lots of flights, so its a many to many relationship. The flight_routes table is the junction that connects them, one row for each flight and airport pair. In my data it has 25 rows connecting 12 flights to 5 airports. Because of that I could just filter on SIN and get every flight linked to it.

Without it I would have to put the airports inside the flights table somehow, like a comma separated list or columns like airport_1, airport_2. That would make it way harder to filter or count by airport, and adding a new airport to a flight would mean changing the whole table. The junction table avoids all that, and it also lets me keep effective_from, which belongs to the link itself and not to the flight or the airport.

For the tag I picked SIN (Changi) since it's the only airport connected to both flagged flights (2 and 3). But SIN is linked to 5 of the 12 flights that have routes, so with only 2 flights it could just be a coincidence. The data shows they share an airport, not that the airport causes the no-shows. Also 3 of the 15 flights have no route at all, so the catalog can't say anything about those.

**Question 3 note:**
For the self join I compared flights that share the same origin country. Flights 2 and 3 were the ones I flagged because of their no-show rates (3 and 2 no-shows). Flight 2 (Japan) shares its origin country with 2 other flights and flight 3 (Korea) shares with 3 other flights. The other flights have between 11 and 21 bookings, compared to 16 and 13 for mine, so activity level looks pretty similar. The other flights from the same countries have much lower no-show rates (0% to 6.3%, from my no-show rate query), so I don't think activity alone explains it, and sharing an origin country doesn't seem to explain it either since their neighbors don't have the same problem. But honestly the numbers are really small (3 and 2 no-shows), so I'd treat this as something to look into more and not a final answer.


## Task 5.2:
**Which producers were excluded by the inner join?**
Flights 14 (VN214) and 15 (VN215). The LEFT JOIN returned all 15 flights and the INNER JOIN only 13, because these two have no rows in bookings.

**What does it mean when a producer has no events?**
The flight exists but nobody has ever booked it. Both are active and were first scheduled in 2022, so they're not retired or new. Maybe they aren't being sold, maybe their bookings are missing from the data, or maybe nobody booked them.

**How could an inner-join-only report give an incomplete picture?**
It would show 13 flights and leadership would think that's everything. Flights 14 and 15 would just disappear, which is also why they never showed up in Unit 4.

**Why would leadership want to identify producers who have never been active?**
Active flights with zero bookings could mean wasted aircraft or crew, lost revenue, or a data problem.

**What action could leadership take?**
Check whether flights 14 and 15 are really open for sale. If not, mark them inactive. If it's a data loading issue, fix it.

**Data shows vs. needs investigation**
The data shows 2 active flights have no bookings, and NOT EXISTS and EXCEPT both found the same 2. It can't tell us why. Someone would need to check with operations.

## Task 5.3:
**Cartesian product example:**
My CROSS JOIN of flights (15 rows) and airports (5 rows) gave 75 rows, which is 15 x 5. On my platform it could be useful to list every possible flight and airport pair and compare it to flight_routes, to see which combinations don't exist yet. It would be a mistake if I forgot the ON condition in a normal join, because the row count would multiply and with big tables like bookings it could freeze the database.

**Execution plan (Part B):**
```
Sort  (cost=35.98..36.48 rows=200 width=540)
  Sort Key: b.booked_at
  ->  Nested Loop  (cost=12.40..28.34 rows=200 width=540)
        ->  Hash Join  (cost=12.25..17.80 rows=200 width=282)
              Hash Cond: (b.passenger_id = p.passenger_id)
              ->  Seq Scan on bookings b  (cost=0.00..5.00 rows=200 width=24)
              ->  Hash  (cost=11.00..11.00 rows=100 width=262)
                    ->  Seq Scan on passengers p  (cost=0.00..11.00 rows=100 width=262)
        ->  Memoize  (cost=0.15..0.41 rows=1 width=262)
              Cache Key: b.flight_id
              Cache Mode: logical
              ->  Index Scan using flights_pkey on flights f  (cost=0.14..0.40 rows=1 width=262)
                    Index Cond: (flight_id = b.flight_id)
```

**Which join algorithms did PostgreSQL choose?**
Two. A Hash Join between bookings and passengers (Hash Cond: b.passenger_id = p.passenger_id), then a Nested Loop that joins that result to flights. The flights side uses a Memoize node on top of an Index Scan using flights_pkey.

**What in the plan explains those choices?**
Passengers is small (rows=100), so it gets hashed into memory and bookings (rows=200, Seq Scan) is checked against it. Flights is tiny (15 rows) and has a primary key index, so for each booking it can look up the flight with an Index Scan (Index Cond: flight_id = b.flight_id) at a cost of 0.14..0.40 per lookup. The Memoize caches the result by b.flight_id, which helps because 200 bookings only point to 15 different flights. Bookings has no index on its join columns, so it is read with a Seq Scan. The Sort at the top is for ORDER BY booked_at.

**Which part gets less efficient as data grows?**
Mostly the Sort on booked_at, since there's no index on it and sorting gets more expensive as bookings grows (it could spill to disk). The Seq Scan on bookings and the hash table for passengers would also grow, and the hash has to fit in memory. The nested loop on flights should stay okay because each lookup uses the primary key index.

**Why is it useful to understand the selected join algorithms?**
It helps me figure out why a query is slow and what to fix. A hash join needs memory for the hash table, a nested loop is cheap with an index but slow without one, and a merge join needs sorted data. Knowing which one was picked shows where the problem would come from when the data gets bigger.

**What changes to the data or database might make another algorithm more appropriate?**
If passengers grew to millions of rows, the hash table might not fit in memory and PostgreSQL could switch to a Merge Join. If I filtered to only a few bookings, for example one passenger, it could use a Nested Loop with an index on bookings.passenger_id instead of scanning the whole table. PostgreSQL already used an index on flights here, so adding indexes on bookings.passenger_id and bookings.flight_id would mostly help selective queries, not one that returns every booking like mine.
