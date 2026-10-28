
-- Create 1NF Table
CREATE TABLE Sales_1NF (
    order_id INT,
    product_id INT,
    customer_id INT,
    customer_name VARCHAR(50),
    product_name VARCHAR(50),
    quantity INT,
    discount_code VARCHAR(20),
    PRIMARY KEY (order_id, product_id)
);

-- Insert Denormalized Data
INSERT INTO Sales_1NF VALUES
(1, 101, 501, 'Aarav Sharma', 'Laptop', 1, 'LAP10'),
(1, 102, 501, 'Aarav Sharma', 'Mouse', 2, 'MOU20'),
(2, 101, 502, 'Diya Kumar', 'Laptop', 1, 'LAP10'),
(3, 103, 501, 'Aarav Sharma', 'Keyboard', 1, 'KEY50');
-- Table 1: Orders (Depends only on order_id)
CREATE TABLE Orders_2NF (
    order_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(50)
);
INSERT INTO Orders_2NF (order_id, customer_id, customer_name)
SELECT DISTINCT order_id, customer_id, customer_name FROM Sales_1NF;

-- Table 2: Products (Depends only on product_id)
CREATE TABLE Products_2NF (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50)
);
INSERT INTO Products_2NF (product_id, product_name)
SELECT DISTINCT product_id, product_name FROM Sales_1NF;

-- Table 3: Order Details (Depends on the full composite key)
CREATE TABLE OrderDetails_2NF (
    order_id INT,
    product_id INT,
    quantity INT,
    discount_code VARCHAR(20),
    PRIMARY KEY (order_id, product_id)
);
INSERT INTO OrderDetails_2NF (order_id, product_id, quantity, discount_code)
SELECT order_id, product_id, quantity, discount_code FROM Sales_1NF;
-- Table 1: Customers
CREATE TABLE Customers_3NF (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);
INSERT INTO Customers_3NF (customer_id, customer_name)
SELECT DISTINCT customer_id, customer_name FROM Orders_2NF;

-- Table 2: Orders (Cleaned of transitive dependency)
CREATE TABLE Orders_3NF (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers_3NF(customer_id)
);
INSERT INTO Orders_3NF (order_id, customer_id)
SELECT order_id, customer_id FROM Orders_2NF;
-- Table 1: Discounts (Handles the BCNF violation)
CREATE TABLE Discounts_BCNF (
    discount_code VARCHAR(20) PRIMARY KEY,
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES Products_2NF(product_id)
);
INSERT INTO Discounts_BCNF (discount_code, product_id)
SELECT DISTINCT discount_code, product_id FROM OrderDetails_2NF;

-- Table 2: Order Items (Uses the determinant as the foreign key)
CREATE TABLE OrderItems_BCNF (
    order_id INT,
    discount_code VARCHAR(20),
    quantity INT,
    PRIMARY KEY (order_id, discount_code),
    FOREIGN KEY (order_id) REFERENCES Orders_3NF(order_id),
    FOREIGN KEY (discount_code) REFERENCES Discounts_BCNF(discount_code)
);
INSERT INTO OrderItems_BCNF (order_id, discount_code, quantity)
SELECT order_id, discount_code, quantity FROM OrderDetails_2NF;

SELECT 
    o.order_id, 
    d.product_id, 
    c.customer_id, 
    c.customer_name, 
    p.product_name, 
    oi.quantity, 
    oi.discount_code
FROM Orders_3NF o
JOIN Customers_3NF c ON o.customer_id = c.customer_id
JOIN OrderItems_BCNF oi ON o.order_id = oi.order_id
JOIN Discounts_BCNF d ON oi.discount_code = d.discount_code
JOIN Products_2NF p ON d.product_id = p.product_id
ORDER BY o.order_id, d.product_id;
-- Test FD3 (customer_id -> customer_name): 
-- If we update a customer's name, it updates everywhere (No update anomaly)
UPDATE Customers_3NF SET customer_name = 'Aarav S.' WHERE customer_id = 501;
SELECT * FROM Customers_3NF;

-- Test FD4 (discount_code -> product_id):
-- Because discount_code is the Primary Key in the Discounts_BCNF table, 
-- it is mathematically impossible to assign the same discount code to a different product.
-- Running this will throw a Primary Key constraint error, proving preservation:
INSERT INTO Discounts_BCNF (discount_code, product_id) VALUES ('LAP10', 103);