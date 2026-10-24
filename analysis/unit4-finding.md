# Unit 4 Finding: Booking Cancellations

**The true failure rate.** Out of 200 bookings, 34 were cancelled, which works out to 17%. If we only look at flights with at least 10 bookings, the usual rate is closer to 17, and that's the number I'd use as our "normal."

**How it varies.** Most flights land close to that normal. A few are clearly higher. I left out flights with fewer than 10 bookings, because with so few bookings a single cancellation can make a flight look much better or worse than it really is.

**Where I'd start looking.** I'd investigate these flights first:
1. **Flight 11**: 31.25% cancelled (5 of 16 bookings)
2. **Flight 9**: 28.57% cancelled (4 of 14 bookings)
3. **Flight 2**: 25% cancelled (4 of 16 bookings)

Each one has a high cancellation rate and enough bookings that I trust the number.

-----------

## Reflection

Conditional aggregation lets me get several answers in one trip through the data. With `SUM(CASE WHEN ...)`, the database goes through each booking once and keeps two running counts: all bookings, and cancelled ones. If I ran two separate queries instead, one for the total and one with `WHERE booking_status = 'cancelled'`, the database would have to read the whole table twice.

With a few thousand rows, you'd never notice. With a million rows, it matters. Every extra pass means reading a million rows again, so the work and the waiting time roughly double, and that slows things down for everyone else using the database. And if someone later asks for a third number, like late check-ins, separate queries mean a third pass, while conditional aggregation only needs one more column.

It's also safer. Two separate queries run at slightly different moments, so if new bookings come in between them, the totals and the cancellations might not line up, and my rate would be a little off. One pass means both numbers come from the same snapshot.

The query looks a bit more complicated, but it's faster, more consistent, and gives me both numbers side by side in one result.