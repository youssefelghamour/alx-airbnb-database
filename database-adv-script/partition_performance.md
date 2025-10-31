# Partitioning Performance Report – Bookings Table

## Context

The `bookings` table has 100,000 rows for the year 2025.  
We wanted to test query performance when filtering by the first quarter of 2025.

### Original Table Query

Filtering Q1 bookings on the original `bookings` table gave:

```sql
EXPLAIN ANALYZE SELECT * FROM bookings WHERE start_date >= '2025-01-01' AND start_date < '2025-04-01';

                                                  QUERY PLAN
---------------------------------------------------------------------------------------------------------------
 Seq Scan on bookings  (cost=0.00..2834.00 rows=23974 width=79) (actual time=0.036..11.001 rows=24259 loops=1)
   Filter: ((start_date >= '2025-01-01'::date) AND (start_date < '2025-04-01'::date))
   Rows Removed by Filter: 75741
 Planning Time: 0.313 ms
 Execution Time: 11.682 ms
(5 rows)
```

- Execution time: `11.682 ms`
- PostgreSQL did a sequential scan, scanning all 100000 rows.

## Partitioning Strategy

- Created a **copy of the `bookings` table** called `bookings_partitioned`.
- Partitioned by `start_date` into four quarters (Q1–Q4).
- Each partition holds bookings for its respective quarter.
- The primary key on the partitioned copy is **composite**: `(booking_id, start_date)`.
- See the `partitioning.sql` file for the full partitioning setup and details.

### Reasoning

- We **cannot partition the original table directly** without changing its primary key.
- Changing the primary key would break 2NF normalization and affect the database design and would require me to change the whole database.
- Using a copy allows testing partitioning without modifying the original schema.

### Partitioned Table Query

Filtering Q1 bookings on the partitioned table gave:

```sql
EXPLAIN ANALYZE SELECT * FROM bookings_partitioned WHERE start_date >= '2025-01-01' AND start_date < '2025-04-01';
                                                                QUERY PLAN
------------------------------------------------------------------------------------------------------------------------------------------
 Seq Scan on bookings_q1_2025 bookings_partitioned  (cost=0.00..687.88 rows=24259 width=79) (actual time=0.023..5.276 rows=24259 loops=1)
   Filter: ((start_date >= '2025-01-01'::date) AND (start_date < '2025-04-01'::date))
 Planning Time: 1.567 ms
 Execution Time: 6.275 ms
(4 rows)
```

- Execution time: `6.275 ms`
- PostgreSQL scanned **only the Q1 partition**, improving performance by almost 50%.

## Conclusion

| Table                          | Execution Time |
|--------------------------------|----------------|
| Original `bookings`            | 11.682 ms      |
| Partitioned `bookings_q1_2025` | 6.275 ms       |

- Partitioning improves query performance by limiting scans to the relevant partitions.  
- For large tables with date-based queries, partitioning can almost halve execution time.