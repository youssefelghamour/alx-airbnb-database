# Airbnb Clone Database Normalization

This document explains **database normalization** and shows that **our database** is normalized up to **5NF**.  
Normalization organizes a database so that data is not repeated, updates and deletions do not cause errors, and information is stored logically with clear relationships between tables.  

Our Airbnb database stores each user, property, booking, review, payment, and message in a single place. This design prevents redundancy and ensures consistency, making it safe and reliable for updates, queries, and deletions.

![normalization_forms](./levels-of-normalization-forms.png)

## How Our Database Follows Normalization Rules

### 1. First Normal Form (1NF)
**Requirements:**  
- Each table has a **primary key**  
- Columns hold **one value per row**  
- Columns have **consistent data types**  
- Row order does not matter  

**Our database:**  
- All tables have single-column primary keys (`user_id`, `property_id`, `booking_id`, etc.)  
- Columns like `first_name`, `pricepernight`, and `email` store only one value per cell  
- Column types are consistent (e.g., `pricepernight` is always DECIMAL)

**Note:** `Property.location` combines multiple details (city, country and address) in one column, which violates 1NF. So it has been separated into different columns: country, city, address.

**Result:** 1NF satisfied

### 2. Second Normal Form (2NF)
**Requirements:**  
- Already in 1NF  
- Non-key columns must depend on the **whole primary key**  

**Our database:**  
- Since all primary keys are single columns, all non-key columns depend entirely on the primary key.
- Example: `Property.name` depends fully on `property_id`  

**Result:** 2NF satisfied

### 3. Third Normal Form (3NF)
**Requirements:**  
- Already in 2NF  
- Non-key columns must **not depend on other non-key columns**, they should depend on the primary key only.

**Our database:**  
- `Booking.total_price` depends only on `booking_id`  
- `Review.rating` depends only on `review_id`  
- No column is calculated from another non-key column  

**Result:** 3NF satisfied

### 4. Boyce-Codd Normal Form (BCNF)
**Requirements:**  
- If a column determines another column, the column that does the determining must be a **primary key**  

**Our database:**  
- `Payment.booking_id` determines `amount`  
- Since `booking_id` is the primary key, BCNF is satisfied  

**Result:** BCNF satisfied

### 5. Fourth Normal Form (4NF)
**Requirements:**  
- Already in BCNF  
- Each row should **only describe one type of thing**. We should not store multiple sets of unrelated data in the same row.  

**Our database:**  
- Each table handles a single type of information.  
- Example: The `Booking` table stores information about a booking. It does not include all payments or reviews for that booking.  
- Payments, reviews, and messages are each stored in their own tables, keeping different kinds of data separate.

**Result:** 4NF satisfied

### 6. Fifth Normal Form (5NF)
**Requirements:**  
- Already in 4NF  
- It must not be possible to describe the table as being the logical result of joining some other tables together.

**Our database:**  
- Each table stores one type of information and represents a single entity or relationship.  
- Example: `Booking`, `Payment`, and `Review` are independent tables. None of them can be recreated by joining smaller tables together.

**Result:** 5NF satisfied

## Conclusion

**Our database** is fully normalized from **1NF to 5NF**, avoiding redundant data, keeping information consistent, and organizing tables logically.