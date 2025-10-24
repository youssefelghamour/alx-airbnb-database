# AirBnB Database Schema DDL

This repository contains the PostgreSQL database schema for an AirBnB clone application. It defines the tables, relationships, constraints, and indexes needed to manage users, properties, bookings, payments, reviews, messages, and property images.


## Database

- **Database name:** `airbnb_db`
- **DBMS:** PostgreSQL
- **UUID support:** Used for all primary keys.

## Executing the SQL File

Create the database first before executing the schema:

```bash
psql -U <username> -c "CREATE DATABASE airbnb_db;"
```

To run the database schema in PostgreSQL, use:

```bash
psql -U <username> -d airbnb_db -f schema.sql
```


## Custom Types

| Type | Values |
|------|--------|
| `user_role` | guest, host, admin |
| `booking_status` | pending, confirmed, canceled |
| `payment_method` | credit_card, paypal, stripe |


## Tables and Key Columns

### **Users**
- `user_id`: UUID, PK  
- `first_name`, `last_name`: VARCHAR, required  
- `email`: VARCHAR, UNIQUE, required  
- `password_hash`: VARCHAR, required  
- `phone_number`: VARCHAR, optional  
- `user_role`: ENUM, default `'guest'`  
- `created_at`: TIMESTAMP  

### **Properties**
- `property_id`: UUID, PK  
- `host_id`: FK → users(user_id)  
- `name`, `description`, `country`, `city`, `address`: required  
- `pricepernight`: DECIMAL  
- `created_at`, `updated_at`: TIMESTAMP  

### **Property Images**
- `image_id`: UUID, PK  
- `property_id`: FK → properties(property_id)  
- `image_path`: TEXT, required  
- `is_main`: BOOLEAN, default FALSE  
- `created_at`: TIMESTAMP  

### **Bookings**
- `booking_id`: UUID, PK  
- `property_id`: FK → properties(property_id)  
- `user_id`: FK → users(user_id)  
- `start_date`, `end_date`: DATE, required  
- `total_price`: DECIMAL, required  
- `status`: ENUM, default `'pending'`  
- `created_at`: TIMESTAMP  

### **Payments**
- `payment_id`: UUID, PK  
- `booking_id`: FK → bookings(booking_id)  
- `amount`: DECIMAL, required  
- `payment_date`: TIMESTAMP  
- `payment_method`: ENUM  

### **Reviews**
- `review_id`: UUID, PK  
- `property_id`: FK → properties(property_id)  
- `user_id`: FK → users(user_id), `ON DELETE SET NULL`  
- `rating`: INT, CHECK 1–5  
- `comment`: TEXT, required  
- `created_at`: TIMESTAMP  

### **Messages**
- `message_id`: UUID, PK  
- `sender_id`, `recipient_id`: FK → users(user_id), `ON DELETE SET NULL`  
- `message_body`: TEXT, required  
- `sent_at`: TIMESTAMP  


## Indexes

- **Users:** `email`  
- **Properties:** `host_id`  
- **Property Images:** `property_id`  
- **Bookings:** `property_id`, `user_id`, `status`  
- **Payments:** `booking_id`  
- **Reviews:** `property_id`, `user_id`  
- **Messages:** `sender_id`, `recipient_id`  


## Notes

- `updated_at` in `properties` is handled in the application code.  
- Only one main image per property is enforced in code.  
- All foreign keys are indexed to optimize queries.  
- UUIDs are used for all primary keys for consistency.