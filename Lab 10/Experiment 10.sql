

CREATE TABLE ECommerce_Transactions (
    txn_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_category VARCHAR(50),
    amount DECIMAL(10, 2),
    txn_date DATE,
    status VARCHAR(20)
);

-- Stored Procedure to generate 10,000 rows
DELIMITER //

CREATE PROCEDURE Generate_10K_Rows()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 10000 DO
        INSERT INTO ECommerce_Transactions (customer_id, product_category, amount, txn_date, status)
        VALUES (
            FLOOR(1 + RAND() * 1000), -- Random Customer ID between 1 and 1000
            ELT(FLOOR(1 + RAND() * 4), 'Electronics', 'Clothing', 'Books', 'Home'),
            ROUND(RAND() * 5000, 2), -- Random amount up to 5000
            DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 1000) DAY), -- Random date over ~3 years
            ELT(FLOOR(1 + RAND() * 3), 'Completed', 'Pending', 'Failed')
        );
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

-- Execute the procedure to populate the table (This might take a few seconds)
CALL Generate_10K_Rows();

-- Verify row count
SELECT COUNT(*) FROM ECommerce_Transactions;

-- BEFORE (Slow): Using YEAR() causes a Full Table Scan (type: ALL)
EXPLAIN SELECT * FROM ECommerce_Transactions 
WHERE YEAR(txn_date) = 2025;

-- OPTIMIZATION: Create an index and rewrite to use a date range instead of a function
CREATE INDEX idx_txn_date ON ECommerce_Transactions(txn_date);

-- AFTER (Fast): Uses Index Range Scan (type: range)
EXPLAIN SELECT * FROM ECommerce_Transactions 
WHERE txn_date >= '2025-01-01' AND txn_date <= '2025-12-31';



-- BEFORE (Slow): Math on the column causes a Full Table Scan (type: ALL)
EXPLAIN SELECT * FROM ECommerce_Transactions 
WHERE amount * 0.9 > 1000;

-- OPTIMIZATION: Create an index and move the math to the right side of the operator
CREATE INDEX idx_amount ON ECommerce_Transactions(amount);

-- AFTER (Fast): Uses Index Range Scan (type: range)
EXPLAIN SELECT * FROM ECommerce_Transactions 
WHERE amount > (1000 / 0.9);


-- BEFORE (Slow): Leading wildcard causes Full Table Scan (type: ALL)
EXPLAIN SELECT * FROM ECommerce_Transactions 
WHERE product_category LIKE '%ronics';

-- OPTIMIZATION: Create an index and rewrite to use a trailing wildcard (or exact match)
CREATE INDEX idx_category ON ECommerce_Transactions(product_category);

-- AFTER (Fast): Uses Index Range Scan (type: range)
EXPLAIN SELECT * FROM ECommerce_Transactions 
WHERE product_category LIKE 'Electro%';

-- BEFORE (Slow): OR condition causes Full Table Scan (type: ALL)
EXPLAIN SELECT * FROM ECommerce_Transactions 
WHERE customer_id = 500 OR status = 'Pending';

-- OPTIMIZATION: Index both columns separately, and rewrite using UNION to merge two fast lookups
CREATE INDEX idx_cust ON ECommerce_Transactions(customer_id);
CREATE INDEX idx_status ON ECommerce_Transactions(status);

-- AFTER (Fast): Both queries in the UNION use an Index Seek (type: ref)
EXPLAIN 
SELECT * FROM ECommerce_Transactions WHERE customer_id = 500
UNION
SELECT * FROM ECommerce_Transactions WHERE status = 'Pending';

-- BEFORE (Slow): Shows "Using temporary; Using filesort" in the Extra column, which is very slow
EXPLAIN SELECT status, SUM(amount) 
FROM ECommerce_Transactions 
WHERE product_category = 'Clothing' 
GROUP BY status;

-- OPTIMIZATION: Create a Composite Covering Index (matches WHERE clause first, then GROUP BY clause, then includes the SELECTed column)
CREATE INDEX idx_covering ON ECommerce_Transactions(product_category, status, amount);

-- AFTER (Fast): Shows "Using index" in the Extra column. No temporary tables or filesorts needed!
EXPLAIN SELECT status, SUM(amount) 
FROM ECommerce_Transactions 
WHERE product_category = 'Clothing' 
GROUP BY status;
