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

/*
-- Clear the tables
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