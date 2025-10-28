-- \x shows one row per line
\x

-- A query using an INNER JOIN to retrieve all bookings and the respective users who made those bookings
SELECT *
FROM bookings AS b
INNER JOIN users AS u
    ON b.user_id = u.user_id;


-- A query using aLEFT JOIN to retrieve all properties and their reviews, including properties that have no reviews
SELECT *
FROM properties AS p
LEFT JOIN reviews AS r
    ON p.property_id = r.property_id
ORDER BY p.name;;


-- A query using a FULL OUTER JOIN to retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user
SELECT *
FROM users AS u
FULL OUTER JOIN bookings AS b
    ON u.user_id = b.user_id;