# Bookings Query Performance Analysis

## BEFORE (SELECT *)

Query selects all columns from bookings, users, properties, and payments.

```sql
ANALYZE;
EXPLAIN SELECT b.*, u.*, p.*, pay.*
FROM bookings b
JOIN users AS u
    ON b.user_id = u.user_id
JOIN properties AS p
    ON b.property_id = p.property_id
JOIN payments AS pay
    ON b.booking_id = pay.booking_id;
```

**Result:**

```sql
ANALYZE
                                            QUERY PLAN
--------------------------------------------------------------------------------------------------
 Nested Loop  (cost=4891.93..13279.57 rows=100000 width=335)
   ->  Hash Join  (cost=4891.50..10778.62 rows=100000 width=217)
         Hash Cond: (b.user_id = u.user_id)
         ->  Hash Join  (cost=4854.00..10477.51 rows=100000 width=134)
               Hash Cond: (pay.booking_id = b.booking_id)
               ->  Seq Scan on payments pay  (cost=0.00..2137.00 rows=100000 width=55)
               ->  Hash  (cost=2334.00..2334.00 rows=100000 width=79)
                     ->  Seq Scan on bookings b  (cost=0.00..2334.00 rows=100000 width=79)
         ->  Hash  (cost=25.00..25.00 rows=1000 width=83)
               ->  Seq Scan on users u  (cost=0.00..25.00 rows=1000 width=83)
   ->  Memoize  (cost=0.42..0.50 rows=1 width=118)
         Cache Key: b.property_id
         Cache Mode: logical
         ->  Index Scan using properties_pkey on properties p  (cost=0.41..0.49 rows=1 width=118)
               Index Cond: (property_id = b.property_id)
(15 rows)
```

**Observations:**

- Bookings: 100,000 rows: full table scan, heavy  
- Payments: 100,000 rows: full scan adds more cost  
- Users: 1,000 rows: joining is cheap  
- Properties: primary key index used: quick lookup  
- `SELECT *` increases width (335): more data moved in memory  
- Hash Joins and Nested Loops move large amounts of data: expensive  
- Would scale poorly if tables grow larger  

**Query Plan Highlights:**

- Nested Loop over Hash Joins  
- Seq Scans on bookings and payments  
- Index Scan only on properties  
- Execution cost: `4891..13279` 
- Width: `335`  

**Takeaway:** Works but inefficient. Could improve by selecting specific columns, applying filters, or reducing joins.

---

## AFTER (SELECT SPECIFIC COLUMNS)

Query selects only the necessary columns from bookings, users, properties, and payments.

```sql
ANALYZE;
EXPLAIN SELECT 
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    u.email,
    p.name AS property_name,
    p.city,
    p.country,
    pay.amount,
    pay.payment_method
FROM bookings b
JOIN users AS u
    ON b.user_id = u.user_id
JOIN properties AS p
    ON b.property_id = p.property_id
JOIN payments AS pay
    ON b.booking_id = pay.booking_id;
```

**Result:**

```sql
ANALYZE
                                              QUERY PLAN
-------------------------------------------------------------------------------------------------------
 Hash Join  (cost=3424.93..9898.06 rows=100000 width=100)
   Hash Cond: (b.booking_id = pay.booking_id)
   ->  Nested Loop  (cost=37.92..5136.06 rows=100000 width=101)
         ->  Hash Join  (cost=37.50..2635.11 rows=100000 width=88)
               Hash Cond: (b.user_id = u.user_id)
               ->  Seq Scan on bookings b  (cost=0.00..2334.00 rows=100000 width=71)
               ->  Hash  (cost=25.00..25.00 rows=1000 width=49)
                     ->  Seq Scan on users u  (cost=0.00..25.00 rows=1000 width=49)
         ->  Memoize  (cost=0.42..0.50 rows=1 width=45)
               Cache Key: b.property_id
               Cache Mode: logical
               ->  Index Scan using properties_pkey on properties p  (cost=0.41..0.49 rows=1 width=45)
                     Index Cond: (property_id = b.property_id)
   ->  Hash  (cost=2137.00..2137.00 rows=100000 width=31)
         ->  Seq Scan on payments pay  (cost=0.00..2137.00 rows=100000 width=31)
(15 rows)
```

**Observations:**

- Width dropped to `100`: less data moved in memory  
- Execution cost decreased: `3424..9898`: query should run faster  
- Indexes still used where possible (properties)  
- All joins remain necessary to get full details  

**Query Plan Highlights:**

- Nested Loop over Hash Joins  
- Index Scan on properties  
- Seq Scans on bookings, users, payments  
- Execution cost reduced  
- Width reduced  


## Summary

- Selecting only needed columns drastically reduces memory usage and execution cost  
- Joins on indexed columns are used, but indexes mainly help for filters, not full table scans  
- Hash Joins and Nested Loops are efficient for combining tables but scanning large tables adds cost
- If we used filtering PostgreSQL will use the indexes by adding WHERE clause on the Primary and Foreign Keys, which would make the query faster.
- Width went down from `335` to `100` when selecting specific columns instead of *. Less data per row moves in memory.
- Cost went down from `4891..13279` to `3424..9898`. So the second query is cheaper and should run faster.