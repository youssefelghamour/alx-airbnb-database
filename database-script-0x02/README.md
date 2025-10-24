# AirBnB Database Schema DDL

PostgreSQL schema for our AirBnB clone, including tables, relationships, constraints, and sample data.

- **Database:** `airbnb_db` 

## UUID Extension

PostgreSQL includes the `pgcrypto` extension, which provides the `gen_random_uuid()` function to generate unique UUIDs for each row. The function is built into PostgreSQL but must be enabled in the database with the following query before it can be used:

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

Once enabled, we can automatically generate unique IDs for inserted rows using `gen_random_uuid()`.

## Running the Schema

To execute the schema and sample data:

```bash
psql -U <username> -d airbnb_db -f seed.sql
```

`INSERT ... SELECT` uses emails or property names instead of IDs because UUIDs are generated on insert.