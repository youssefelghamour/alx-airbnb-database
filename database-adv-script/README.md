# Advanced Querying and Optimization

This project focuses on advanced SQL querying, performance optimization, indexing, and partitioning techniques on our Airbnb database.

## Project Structure

```
database-adv-script/
│
├─ joins_queries.sql                       # JOIN queries on users, bookings, properties, reviews
├─ subqueries.sql                          # Correlated & non-correlated subqueries
├─ aggregations_and_window_functions.sql   # Aggregations and window functions
├─ database_index.sql                      # CREATE INDEX commands for optimization
├─ performance.sql                         # Complex queries and refactoring
├─ partitioning.sql                        # Partitioned copy of bookings table
├─ README.md
├─ seed2.sql
├─ index_performance.md                    # Analysis of indexing impact
├─ optimization_report.md                  # Performance improvements after query refactoring
├─ partition_performance.md                # Partitioning observations and performance
└─ performance_monitoring.md               # EXPLAIN ANALYZE monitoring and refinements
```

## Steps & Optimization Process

1. **Analyzed Queries**
   - Ran complex queries using joins, subqueries, and aggregations.
   - Observations and query results are documented in:
     - `joins_queries.sql`
     - `subqueries.sql`
     - `aggregations_and_window_functions.sql`

2. **Tested Indexing**
   - Identified frequently used columns and created indexes in `database_index.sql`.
   - Checked performance improvements with `EXPLAIN ANALYZE`.
   - Documentation and before/after comparisons in `index_performance.md`.

3. **Optimized Complex Queries**
   - Refactored queries to reduce execution time using indexing and query restructuring.
   - Queries stored in `performance.sql`, results and analysis in `optimization_report.md`.

4. **Partitioned Large Tables**
   - Created a partitioned copy of the `bookings` table by `start_date` in `partitioning.sql`.
   - Compared performance of date-range queries before and after partitioning.
   - Observations documented in `partition_performance.md`.
   - Original `bookings` table kept intact to preserve primary key and normalization.

5. **Monitored and Refined Performance**
   - Used `EXPLAIN ANALYZE` to identify bottlenecks for possible additional indexes or schema adjustments when needed.
   - Full monitoring results in `performance_monitoring.md`.