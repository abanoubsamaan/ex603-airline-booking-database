# Analysis (Task 4.1 writeup)
An airline operations manager can use the results to see which flights have more bookings and which ones have higher cancellation rates. Regional managers can also compare the results between countries.

However, the summary doesn't show everything. The average fare doesn't tell us how much individual passengers paid, and the total number of bookings doesn't tell us who made them or if some passengers booked more than once.

Next, I would look at the individual bookings, including their fare, status, and country, to better understand why some flights have higher cancellation rates or different average fares.

# Task 4.2 writeup

## Part A
This query answers two questions side by side for each flight: how many bookings did it get in total, and how many of those were cancelled? Putting both numbers in one row makes it easy to see which flights have unusually high cancellations compared with their size.

## Part B
The regional director is the reader who needs subtotals rather than detail rows. They care about how each country is doing overall, not about every individual flight. The grand total supports a decision the country rows can’t: whether a region’s cancellation numbers are a local problem or just part of a platform-wide trend. A country can look bad on its own, but only the grand total shows whether it’s worse than the platform as a whole.

## Part C
The pipeline answers this question: what does a normal cancellation rate look like for flights with enough bookings to be reliable? The first step summarizes every flight, and the second step keeps only the high-volume ones and averages their rates. That gives leadership a baseline to judge whether any single flight is doing better or worse than normal.