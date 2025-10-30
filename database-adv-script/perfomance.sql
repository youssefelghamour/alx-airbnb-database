-- =================================================================
-- A query that retrieves all bookings along with the user details, property details, and payment details
-- =================================================================
SELECT b.*, u.*, p.*, pay.*
FROM bookings b
JOIN users AS u
    ON b.user_id = u.user_id
JOIN properties AS p
    ON b.property_id = p.property_id
JOIN payments AS pay
    ON b.booking_id = pay.booking_id;

-- =================================================================
-- A query plan for the above query to analyze its performance
-- =================================================================
ANALYZE;
EXPLAIN SELECT b.*, u.*, p.*, pay.*
FROM bookings b
JOIN users AS u
    ON b.user_id = u.user_id
JOIN properties AS p
    ON b.property_id = p.property_id
JOIN payments AS pay
    ON b.booking_id = pay.booking_id;


-- =================================================================
-- An optimized version of the above query
-- =================================================================
SELECT 
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    u.email,
    p.name AS property_name,
    p.city,
    p.country,
    pay.amount,
    pay.payment_method
FROM bookings b
JOIN users AS u
    ON b.user_id = u.user_id
JOIN properties AS p
    ON b.property_id = p.property_id
LEFT JOIN payments AS pay
    ON b.booking_id = pay.booking_id;


-- =================================================================
-- A query plan for the optimized query to analyze its performance
-- =================================================================
ANALYZE;
EXPLAIN SELECT 
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    u.email,
    p.name AS property_name,
    p.city,
    p.country,
    pay.amount,
    pay.payment_method
FROM bookings b
JOIN users AS u
    ON b.user_id = u.user_id
JOIN properties AS p
    ON b.property_id = p.property_id
LEFT JOIN payments AS pay
    ON b.booking_id = pay.booking_id;