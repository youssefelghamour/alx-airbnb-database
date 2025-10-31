# Monitoring and Refining the Database Performance

This README summarizes the analysis of query performance on the Airbnb database.

## 1. Fast Queries Using Indexes

Some queries are very fast because they use indexes.  

**Example:** Filtering users by email

```sql
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'user600@example.com'; 
                                                       QUERY PLAN
------------------------------------------------------------------------------------------------------------------------
 Index Scan using idx_users_email on users  (cost=0.28..8.29 rows=1 width=83) (actual time=0.052..0.053 rows=1 loops=1)
   Index Cond: ((email)::text = 'user600@example.com'::text)
 Planning Time: 1.757 ms
 Execution Time: 0.210 ms
(4 rows)
```

- Index used: `idx_users_email`  
- Execution time: 0.210 ms  


## 2. Slow Queries Using Sequential Scan

Other queries are slower because they require a sequential scan.  

**Example:** Filtering properties by name

```sql
EXPLAIN ANALYZE SELECT * FROM properties WHERE name = 'Property50000';        
                                               QUERY PLAN
---------------------------------------------------------------------------------------------------------
 Seq Scan on properties  (cost=0.00..1894.00 rows=1 width=118) (actual time=9.458..9.459 rows=0 loops=1)
   Filter: ((name)::text = 'Property50000'::text)
   Rows Removed by Filter: 60000
 Planning Time: 1.180 ms
 Execution Time: 9.481 ms
(5 rows)
```

- Scan type: Sequential Scan  
- Execution time: 9.481 ms  
- Reason: Columns like `name` in `properties` are text-based and often queried with patterns using leading wildcards (e.g., `LIKE '%something%'`). Cannot benefit from normal B-tree indexes. 
- Plus, these columns are updated frequently, so adding indexes would increase write overhead without providing meaningful query speedup.



## 3. Partitioning Bookings Table

- We tested partitioning on a **copy** of the `bookings` table by `start_date`, and we found that using partitions is faster.  
- But because querying all bookings by date is mostly an admin task, there is no need to alter the original table.  
- The original table was **not altered**, avoiding a composite primary key that would break normalization.  
- A partitioned copy can be used for faster lookups if needed.  

> See `partition_performance.md` for details on the partitioning setup.


## 4. Index Performance

- Adding indexes significantly improved query performance.  
- Key indexes that I decided to add:  
  - `idx_properties_country`  
  - `idx_properties_city`  
  - `idx_properties_price_per_night`  

> See `index_performance.md` for full analysis.


## Conclusion

- Current indexes on key columns provide good performance for most frequent queries.  
- Text-based or non-unique columns that are filtered with leading wildcards remain slower; adding indexes here is not efficient.  
- Partitioning the bookings table is optional and mainly useful for admin queries on date ranges.  
- No additional indexes are necessary for now; the database design and existing indexes are sufficient for typical workloads.  
- Future optimization can focus on monitoring query patterns and adding indexes only if new bottlenecks arise.