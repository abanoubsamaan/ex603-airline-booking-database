# Finding: the no-show number on the dashboard is wrong

**To:** The dashboard team

The dashboard said about half of all bookings end in a passenger no-show,
so the route profitability review was put on hold. The booking records
do not support this.

Out of 200 bookings, only 12 are passenger no-shows. Not half.
Even if we count every booking that was not confirmed, we only get 44.

The mistake comes from bookings with no cancellation reason. Most bookings
(166 of 200) have none, and when a report asks for "everything except" one
reason, it silently skips all of them without any warning. We recommend
lifting the freeze and fixing the dashboard so it includes these bookings.