\x

-- A query to find all properties where the average rating is greater than 4.0 using a subquery
SELECT *
FROM properties AS p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM reviews AS r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4
);


-- A correlated subquery to find users who have made more than 3 bookings
/* The outer query retrieves every user with the condition that the subquery returns a count of bookings greater than 3
    The subquery counts the number of bookings (rows: COUNT(*)) in the bookings table for each user in the outer query
*/
SELECT *
FROM users AS u
WHERE (
    SELECT COUNT(*) AS review_count
    FROM bookings b
    WHERE b.user_id = u.user_id
) > 3;