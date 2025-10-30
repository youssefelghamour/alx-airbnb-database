/*
-- 60000 plain properties for testing indexing performance
INSERT INTO properties (property_id, name, description, country, city, address, pricepernight)
SELECT
    gen_random_uuid(),
    'Property ' || i,
    'Description ' || i,
    'Country1',
    'City1',
    'Address ' || i,
    50 + random() * 500
FROM generate_series(1,60000) AS s(i);
*/

/*
-- =====================================================
-- Clear tables
-- =====================================================
TRUNCATE TABLE
    messages,
    reviews,
    payments,
    bookings,
    property_images,
    properties,
    users
RESTART IDENTITY CASCADE;
*/

-- =====================================================
-- 1000 users
-- =====================================================
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, user_role)
SELECT
    gen_random_uuid(),
    'User' || i,
    'Test' || i,
    'user' || i || '@example.com',
    'hashed_pwd' || i,
    '555000' || i,
    CASE WHEN i % 2 = 0 THEN 'guest'::user_role ELSE 'host'::user_role END
FROM generate_series(1,1000) AS s(i);

-- =====================================================
-- 60000 properties
-- =====================================================
INSERT INTO properties (property_id, host_id, name, description, country, city, address, pricepernight)
SELECT
    gen_random_uuid(),
    (SELECT user_id FROM users ORDER BY random() LIMIT 1),
    'Property ' || i,
    'Description ' || i,
    'Country1',
    'City1',
    'Address ' || i,
    50 + random() * 500
FROM generate_series(1,60000) AS s(i);

-- =====================================================
-- 100000 bookings
-- =====================================================
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
SELECT
    gen_random_uuid(),
    (SELECT property_id FROM properties ORDER BY random() LIMIT 1),
    (SELECT user_id FROM users ORDER BY random() LIMIT 1),
    date '2025-01-01' + (random() * 365)::int,
    date '2025-01-01' + (random() * 365 + 1)::int,
    50 + random() * 1000,
    CASE WHEN random() < 0.5 THEN 'confirmed'::booking_status ELSE 'pending'::booking_status END
FROM generate_series(1,100000) AS s(i);

-- =====================================================
-- 100000 payments (one per booking)
-- =====================================================
INSERT INTO payments (payment_id, booking_id, amount, payment_method)
SELECT
    gen_random_uuid(),
    booking_id,
    total_price,
    CASE 
        WHEN random() < 0.33 THEN 'credit_card'::payment_method
        WHEN random() < 0.66 THEN 'paypal'::payment_method
        ELSE 'stripe'::payment_method
    END
FROM bookings;