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

Running `database_index.sql`:

```sql
                                                       QUERY PLAN
------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=10358.54..10507.32 rows=59510 width=118) (actual time=43.660..55.547 rows=60000 loops=1)
   Sort Key: pricepernight
   Sort Method: external merge  Disk: 7568kB
   ->  Seq Scan on properties  (cost=0.00..1974.65 rows=59510 width=118) (actual time=0.018..13.384 rows=60000 loops=1)
         Filter: (((country)::text = 'Country1'::text) AND ((city)::text = 'City1'::text))
 Planning Time: 0.722 ms
 Execution Time: 57.501 ms
(7 rows)


CREATE INDEX
CREATE INDEX
CREATE INDEX
                                                                      QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using idx_properties_pricepernight on properties  (cost=0.41..6464.41 rows=60000 width=118) (actual time=0.032..27.396 rows=60000 loops=1)
   Filter: (((country)::text = 'Country1'::text) AND ((city)::text = 'City1'::text))
 Planning Time: 0.409 ms
 Execution Time: 28.544 ms
(4 rows)
```

### Before Index

```sql
EXPLAIN ANALYZE SELECT * FROM properties WHERE country = 'Country1' AND city = 'City1' ORDER BY pricepernight;
```

**Result:** PostgreSQL scanned the entire table (sequential scan). This is slow when the table has many rows. Sorting required extra disk space.
- **Rows:** `60000`
- **Execution Time:** `57.501 ms`
- **Sort Disk Usage:** `7568 kB`

---

### After Adding Indexes

```sql
CREATE INDEX idx_properties_country ON properties(country);
CREATE INDEX idx_properties_city ON properties(city);
CREATE INDEX idx_properties_price_per_night ON properties(pricepernight);

EXPLAIN ANALYZE SELECT * FROM properties WHERE country = 'Country1' AND city = 'City1' ORDER BY pricepernight;
```

**Result:** PostgreSQL used the index instead of scanning all rows. This confirms the query became faster and more efficient: Query time was reduced by ~50%.
- **Rows:** `60000`
- **Execution Time:** `28.544 ms`


## Conclusion

- **Before indexing:**  
    - Sequential scan on all 60,000 rows  
    - Execution time: 57.5 ms  
    - Sorting required extra disk space (7,568 kB)  

- **After indexing:**  
    - Index scan on `pricepernight`  
    - Execution time: 28.5 ms (~50% faster)  
    - Query efficiently filtered and sorted rows without scanning the full table  

Adding an index on the column used for sorting and filtering (`pricepernight`) drastically improves query performance for large tables.