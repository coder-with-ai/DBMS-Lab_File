
--Part 1: Setup and Basic Transactions (Single Session)

--Run these queries in your first query tab to set up the environment and demonstrate COMMIT, ROLLBACK, and SAVEPOINT.
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    balance DECIMAL(12, 2)
);

-- Insert starting balances
INSERT INTO Accounts (account_id, customer_name, balance) VALUES
(101, 'Alice', 5000.00),
(102, 'Bob', 3000.00),
(103, 'Charlie', 4000.00);

-- 2. Successful Transaction (COMMIT)
-- Transfer 1000 from Alice to Bob
START TRANSACTION;
UPDATE Accounts SET balance = balance - 1000 WHERE account_id = 101;
UPDATE Accounts SET balance = balance + 1000 WHERE account_id = 102;
COMMIT;
-- Verify: Alice should have 4000, Bob 4000
SELECT * FROM Accounts;

-- 3. Failed Transaction (ROLLBACK)
-- Attempt to transfer 5000 from Bob to Charlie, but Bob doesn't have enough
START TRANSACTION;
UPDATE Accounts SET balance = balance - 5000 WHERE account_id = 102;
UPDATE Accounts SET balance = balance + 5000 WHERE account_id = 103;
-- Realize error (insufficient funds), cancel the transaction
ROLLBACK;
-- Verify: Balances revert to 4000 and 4000
SELECT * FROM Accounts;

-- 4. Partial Failure (SAVEPOINT)
START TRANSACTION;
-- Action 1: Deduct monthly fee from everyone (Successful)
UPDATE Accounts SET balance = balance - 50;
SAVEPOINT fee_deducted;

-- Action 2: Transfer 10000 from Charlie to Alice (Error - Insufficient funds)
UPDATE Accounts SET balance = balance - 10000 WHERE account_id = 103;
UPDATE Accounts SET balance = balance + 10000 WHERE account_id = 101;

-- Rollback ONLY Action 2, keep Action 1 intact
ROLLBACK TO fee_deducted;
COMMIT;
-- Verify: Fees were deducted, but the massive transfer was canceled.
SELECT * FROM Accounts;

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- Bob checks Alice's balance and sees the uncommitted 9000 deposit! (This is the Dirty Read)
SELECT customer_name, balance FROM Accounts WHERE account_id = 101;

-- Bob checks again, and the money vanished. He made a decision on "dirty" data.
SELECT customer_name, balance FROM Accounts WHERE account_id = 101;

START TRANSACTION;
-- Bank automatically deducts a 100 penalty fee from Alice
UPDATE Accounts SET balance = balance - 100 WHERE account_id = 101;
COMMIT;

--Part 2: Concurrency Anomalies (Two Sessions)

-- Anomaly 1: The Dirty Read
-- Occurs when a transaction reads data written by a concurrent uncommitted transaction.
-- Session 1:
-- Set the lowest isolation level to allow dirty reads
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
-- Alice deposits 9000, but the transaction is NOT committed yet
UPDATE Accounts SET balance = balance + 9000 WHERE account_id = 101;
-- Alice decides to cancel the deposit
ROLLBACK;

-- Set level to READ COMMITTED (prevents dirty reads, but allows non-repeatable reads)
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
-- Alice checks her balance (Say it is 3950)
SELECT customer_name, balance FROM Accounts WHERE account_id = 101;

-- Alice checks her balance again in the SAME transaction, but it changed to 3850!
-- (This is the Non-Repeatable Read)
SELECT customer_name, balance FROM Accounts WHERE account_id = 101;
COMMIT;
