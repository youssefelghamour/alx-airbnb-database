-- Select before indexing
EXPLAIN SELECT * FROM properties WHERE country = 'Country1' AND city = 'City1' ORDER BY pricepernight;

-- Create indexes to optimize queries
CREATE INDEX idx_properties_country ON properties(country);
CREATE INDEX idx_properties_city ON properties(city);
CREATE INDEX idx_properties_price_per_night ON properties(pricepernight);

-- Select after indexing
ANALYZE;
EXPLAIN SELECT * FROM properties WHERE country = 'Country1' AND city = 'City1' ORDER BY pricepernight;