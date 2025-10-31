-- =====================================================
-- Create the bookings_partitioned table (copy for partitioning task)
-- =====================================================
CREATE TABLE bookings_partitioned (
    booking_id UUID,
    property_id UUID REFERENCES properties(property_id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL NOT NULL,
    status booking_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);

-- =====================================================
-- Create partitions for bookings_partitioned table
-- =====================================================
-- Q1
CREATE TABLE IF NOT EXISTS bookings_q1_2025
    PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');

-- Q2
CREATE TABLE IF NOT EXISTS bookings_q2_2025
    PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');

-- Q3
CREATE TABLE IF NOT EXISTS bookings_q3_2025
    PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');

-- Q4
CREATE TABLE IF NOT EXISTS bookings_q4_2025
    PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-10-01') TO ('2026-01-02');

-- =====================================================
-- Copy some data into the partitioned table (optional for testing)
-- =====================================================
INSERT INTO bookings_partitioned
SELECT * FROM bookings;

-- =====================================================
-- Create indexes on the partitioned table (indexes apply to parent and partitions)
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_bookings_partitioned_property_id ON bookings_partitioned(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_partitioned_user_id ON bookings_partitioned(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_partitioned_status ON bookings_partitioned(status);


/*
DROP TABLE IF EXISTS bookings_q1_2025;
DROP TABLE IF EXISTS bookings_q2_2025;
DROP TABLE IF EXISTS bookings_q3_2025;
DROP TABLE IF EXISTS bookings_q4_2025;
DROP TABLE IF EXISTS bookings_partitioned;
*/

-- See full report and explanation in partition_performance.md