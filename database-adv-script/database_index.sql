-- Select before indexing
EXPLAIN ANALYZE SELECT * FROM properties WHERE country = 'Country1' AND city = 'City1' ORDER BY pricepernight;

-- Create indexes to optimize queries
CREATE INDEX idx_properties_country ON properties(country);
CREATE INDEX idx_properties_city ON properties(city);
CREATE INDEX idx_properties_pricepernight ON properties(pricepernight);

-- Select after indexing
EXPLAIN ANALYZE SELECT * FROM properties WHERE country = 'Country1' AND city = 'City1' ORDER BY pricepernight;