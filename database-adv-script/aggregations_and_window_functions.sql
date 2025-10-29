\x

-- ===================================================================================
-- A query to find the total number of bookings made by each user, using the COUNT function and GROUP BY clause

-- 1. Selecting user information along with the count of their bookings
SELECT u.user_id, u.email, u.first_name, u.last_name, COUNT(b.booking_id) AS total_bookings
FROM users u
JOIN bookings b
  ON u.user_id = b.user_id
GROUP BY u.user_id;

-- 2. Only selecting the user_id and the count of bookings
SELECT user_id, COUNT(*) AS total_bookings
FROM bookings
GROUP BY user_id;


-- ===================================================================================
-- A query that uses a window function (RANK) to rank properties based on the total number of bookings they have received

-- 1. Only selecting property_id, total bookings, and their rank
SELECT
    property_id,
    COUNT(*) AS total_bookings,
    RANK() OVER(ORDER BY COUNT(*) DESC) AS property_rank,
    ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS row_number_rank
FROM bookings
GROUP BY property_id;

-- 2. Selecting property information along with the count of their bookings and their rank
SELECT
    p.property_id,
    p.name, 
    p.country, 
    p.city,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER(ORDER BY COUNT(b.booking_id) DESC) AS property_rank,
    ROW_NUMBER() OVER(ORDER BY COUNT(b.booking_id) DESC) AS row_number_rank
FROM properties p
LEFT JOIN bookings b
  ON p.property_id = b.property_id
GROUP BY p.property_id, p.name, p.country, p.city;