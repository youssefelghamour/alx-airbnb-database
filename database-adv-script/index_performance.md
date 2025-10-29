# Indexing for Optimization

This document summarizes the indexing decisions for Users, Bookings, and Properties tables.

## Users Table

- **Already indexed:**
  - `user_id` (PRIMARY KEY)
  - `email` (used for login and WHERE queries)
- **Decision:**
  - No additional indexes needed.  
    - `password_hash` is queried only after filtering by email, so indexing it is unnecessary.  
    - `user_role` is checked after querying the user; we don’t filter users by role in normal queries.

## Properties Table

- **Already indexed:**
  - `property_id` (PRIMARY KEY)
  - `host_id` (FOREIGN KEY)
- **Decision:**
  - Index `country` and `city` because we filter properties by location.  
  - Index `pricepernight` because we filter properties by price.  
  - No indexes for `name`, `description`, `updated_at` since they either change frequently or are not filtered.

## Bookings Table

- **Already indexed:**
  - `booking_id` (PRIMARY KEY)
  - `property_id` and `user_id` (FOREIGN KEYS)
- **Decision:**
  - No additional indexes for `start_date`/`end_date`, `status` or `total_price` since filters on these are rare (mostly admin use).

## Conclusion

- Additional indexes added:
  - `properties(country, city, pricepernight)` 
- Users table remains as-is (only primary key and email indexed).  
- Indexes are only added where filtering is common and updates are not a concern (mostly read-only, not frequently updated and filtered often).


## Index Performance Test

We tested how indexes improve query speed in PostgreSQL using the **properties** table.

### Before Index

```sql
airbnb_db=# EXPLAIN SELECT * FROM properties WHERE country = 'Country1' AND city = 'City1' ORDER BY pricepernight;
                                        QUERY PLAN
-------------------------------------------------------------------------------------------
 Sort  (cost=10436.30..10586.30 rows=60000 width=118)
   Sort Key: pricepernight
   ->  Seq Scan on properties  (cost=0.00..1982.00 rows=60000 width=118)
         Filter: (((country)::text = 'Country1'::text) AND ((city)::text = 'City1'::text))
(4 rows)
```

**Result:** PostgreSQL scanned the entire table (sequential scan). This is slow when the table has many rows.

---

### After Adding Indexes

Running `database_index.sql` to create the new indexes:
```
psql -U postgres -d airbnb_db -f .\database_index.sql
```

Indexes added:

```sql
CREATE INDEX idx_properties_country ON properties(country);
CREATE INDEX idx_properties_city ON properties(city);
CREATE INDEX idx_properties_price_per_night ON properties(pricepernight);
```

```sql
airbnb_db=# ANALYZE;
airbnb_db=# EXPLAIN SELECT * FROM properties WHERE country = 'Country1' AND city = 'City1' ORDER BY pricepernight;
                                                QUERY PLAN
----------------------------------------------------------------------------------------------------------
 Index Scan using idx_properties_price_per_night on properties  (cost=0.41..6464.41 rows=60000 width=118)
   Filter: (((country)::text = 'Country1'::text) AND ((city)::text = 'City1'::text))
(2 rows)
```

**Result:** PostgreSQL used the index instead of scanning all rows. This confirms the query became faster and more efficient.


## Conclusion

- **Before indexing**, the query cost was around `10586` because PostgreSQL had to scan the entire table.
- **After indexing**, the cost dropped to about `6464`, meaning the query became faster and more efficient.

PostgreSQL used the pricepernight index since it helped both with filtering and sorting, giving the best overall performance.