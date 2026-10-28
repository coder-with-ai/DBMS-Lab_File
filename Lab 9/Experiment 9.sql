-- Create the Railway Booking Table
CREATE TABLE Railway_Booking (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_name VARCHAR(100),
    train_number VARCHAR(20),
    source_station VARCHAR(50),
    dest_station VARCHAR(50),
    travel_date DATE,
    ticket_class VARCHAR(10),
    fare DECIMAL(8, 2)
);
DELIMITER //

CREATE PROCEDURE Populate_Railway_Data()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE rand_train INT;
    DECLARE rand_src INT;
    DECLARE rand_dest INT;
    
    -- Loop 5000 times
    WHILE i <= 5000 DO
        -- Generate random numbers to pick random stations/trains
        SET rand_train = FLOOR(1 + (RAND() * 10));
        SET rand_src = FLOOR(1 + (RAND() * 5));
        SET rand_dest = FLOOR(1 + (RAND() * 5));
        
        -- Prevent source and destination from being the exact same
        IF rand_src = rand_dest THEN
            SET rand_dest = (rand_dest % 5) + 1;
        END IF;

        INSERT INTO Railway_Booking (
            passenger_name, 
            train_number, 
            source_station, 
            dest_station, 
            travel_date, 
            ticket_class, 
            fare
        ) VALUES (
            CONCAT('Passenger_', i),
            CONCAT('TRN-', 12000 + rand_train), -- e.g., TRN-12005
            ELT(rand_src, 'Delhi', 'Mumbai', 'Chennai', 'Kolkata', 'Bangalore'),
            ELT(rand_dest, 'Delhi', 'Mumbai', 'Chennai', 'Kolkata', 'Bangalore'),
            DATE_ADD('2026-11-01', INTERVAL FLOOR(RAND() * 30) DAY),
            ELT(FLOOR(1 + (RAND() * 3)), '1AC', '2AC', 'Sleeper'),
            ROUND((RAND() * 2000) + 500, 2)
        );
        
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

-- Call the procedure to actually insert the 5000 rows
CALL Populate_Railway_Data();

-- Verify the row count (Should be 5000)
SELECT COUNT(*) AS Total_Records FROM Railway_Booking;

EXPLAIN SELECT * FROM Railway_Booking WHERE train_number = 'TRN-12005';

EXPLAIN SELECT * FROM Railway_Booking 
WHERE source_station = 'Delhi' AND dest_station = 'Mumbai';


-- 1. Create a Single Index (Optimizes searches on just one column)
CREATE INDEX idx_train_no ON Railway_Booking(train_number);

-- 2. Create a Composite Index (Optimizes searches combining source and destination)
CREATE INDEX idx_route ON Railway_Booking(source_station, dest_station);

-- View the indexes on the table
SHOW INDEXES FROM Railway_Booking;

EXPLAIN SELECT * FROM Railway_Booking WHERE train_number = 'TRN-12005';

EXPLAIN SELECT * FROM Railway_Booking 
WHERE source_station = 'Delhi' AND dest_station = 'Mumbai';
