-- =====================================================
-- ENABLE UUID EXTENSION
-- =====================================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =====================================================
-- SAMPLE DATA SEEDING
-- =====================================================



-- Users
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, user_role)
VALUES
    (gen_random_uuid(), 'Ravi',  'Patel',    'ravi.patel@example.com',    'hashed_pwd2', '0987654321', 'host'),
    (gen_random_uuid(), 'Samir', 'Hassan',   'samir.hassan@example.com',  'hashed_pwd4', '4444444444', 'host'),
    (gen_random_uuid(), 'Lior',  'Blue',     'lior.blue@example.com',     'hashed_pwd6', '3334445555', 'host'),
    (gen_random_uuid(), 'Tariq', 'Ali',      'tariq.ali@example.com',     'hashed_pwd8', '6667778888', 'host'),
    (gen_random_uuid(), 'Alex',  'Kim',      'alex.kim@example.com',      'hashed_pwd1', '1234567890', 'guest'),
    (gen_random_uuid(), 'Zoe',   'Martinez', 'zoe.martinez@example.com',  'hashed_pwd7', '7778889999', 'guest'),
    (gen_random_uuid(), 'Hana',  'Nakamura', 'hana.nakamura@example.com', 'hashed_pwd5', '2223334444', 'guest'),
    (gen_random_uuid(), 'Mei',   'Lin',      'mei.lin@example.com',       'hashed_pwd3', '5555555555', 'guest');



-- Properties
INSERT INTO properties (property_id, host_id, name, description, country, city, address, pricepernight)
    SELECT gen_random_uuid(), user_id, 'City Center Apartment', 'Modern apartment downtown', 'CountryX', 'Metropolis', '12 Main St', 120.00
    FROM users
    WHERE email = 'ravi.patel@example.com';

INSERT INTO properties (property_id, host_id, name, description, country, city, address, pricepernight)
    SELECT gen_random_uuid(), user_id, 'Beachside Retreat', 'Beautiful house near the beach', 'CountryY', 'Seaside City', '34 Ocean Drive', 250.00
    FROM users
    WHERE email = 'samir.hassan@example.com';

INSERT INTO properties (property_id, host_id, name, description, country, city, address, pricepernight)
    SELECT gen_random_uuid(), user_id, 'Mountain Cabin', 'Cozy cabin in the mountains', 'CountryZ', 'Highland', '78 Mountain Rd', 180.00
    FROM users
    WHERE email = 'lior.blue@example.com';



-- Property Images
INSERT INTO property_images (image_id, property_id, image_path, is_main)
    SELECT gen_random_uuid(), property_id, '/images/city_apartment.jpg', TRUE
    FROM properties
    WHERE name = 'City Center Apartment';

INSERT INTO property_images (image_id, property_id, image_path, is_main)
    SELECT gen_random_uuid(), property_id, '/images/beach_retreat.jpg', TRUE
    FROM properties
    WHERE name = 'Beachside Retreat';

INSERT INTO property_images (image_id, property_id, image_path, is_main)
    SELECT gen_random_uuid(), property_id, '/images/mountain_cabin.jpg', TRUE
    FROM properties
    WHERE name = 'Mountain Cabin';



-- Bookings
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
    SELECT gen_random_uuid(), p.property_id, u.user_id, '2025-11-01', '2025-11-05', 480.00, 'confirmed'
    FROM users u, properties p
    WHERE u.email = 'alex.kim@example.com' AND p.name = 'City Center Apartment';

INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
    SELECT gen_random_uuid(), p.property_id, u.user_id, '2025-12-10', '2025-12-15', 1250.00, 'pending'
    FROM users u, properties p
    WHERE u.email = 'mei.lin@example.com' AND p.name = 'Beachside Retreat';

INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
    SELECT gen_random_uuid(), p.property_id, u.user_id, '2025-10-20', '2025-10-25', 900.00, 'confirmed'
    FROM users u, properties p
    WHERE u.email = 'hana.nakamura@example.com' AND p.name = 'Mountain Cabin';



-- Payments
INSERT INTO payments (payment_id, booking_id, amount, payment_method)
    SELECT gen_random_uuid(), booking_id, 480.00, 'credit_card'
    FROM bookings
    WHERE total_price = 480.00;

INSERT INTO payments (payment_id, booking_id, amount, payment_method)
    SELECT gen_random_uuid(), booking_id, 1250.00, 'paypal'
    FROM bookings
    WHERE total_price = 1250.00;

INSERT INTO payments (payment_id, booking_id, amount, payment_method)
    SELECT gen_random_uuid(), booking_id, 900.00, 'stripe'
    FROM bookings
    WHERE total_price = 900.00;



-- Reviews
INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
    SELECT gen_random_uuid(), p.property_id, u.user_id, 5, 'Amazing stay!'
    FROM users u, properties p
    WHERE u.email = 'alex.kim@example.com' AND p.name = 'City Center Apartment';

INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
    SELECT gen_random_uuid(), p.property_id, u.user_id, 4, 'Lovely location!'
    FROM users u, properties p
    WHERE u.email = 'mei.lin@example.com' AND p.name = 'Beachside Retreat';

INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
    SELECT gen_random_uuid(), p.property_id, u.user_id, 5, 'Cozy and clean!'
    FROM users u, properties p
    WHERE u.email = 'hana.nakamura@example.com' AND p.name = 'Mountain Cabin';



-- Messages
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
    VALUES (
        gen_random_uuid(),
        (SELECT user_id FROM users WHERE email = 'alex.kim@example.com'),
        (SELECT user_id FROM users WHERE email = 'ravi.patel@example.com'),
        'Hi, is your apartment available next weekend?'
    );

INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
    VALUES (
        gen_random_uuid(),
        (SELECT user_id FROM users WHERE email = 'mei.lin@example.com'),
        (SELECT user_id FROM users WHERE email = 'samir.hassan@example.com'),
        'Hello, I am interested in your Beachside Retreat.'
    );

INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
    VALUES (
        gen_random_uuid(),
        (SELECT user_id FROM users WHERE email = 'hana.nakamura@example.com'),
        (SELECT user_id FROM users WHERE email = 'lior.blue@example.com'),
        'Hi, can I book your Mountain Cabin for next month?'
    );