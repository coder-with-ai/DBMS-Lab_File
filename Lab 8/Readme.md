# Lab 8: Transaction Management & Concurrency Control

## 🎯 Objective
Simulate banking transactions to understand ACID properties, isolation levels, and concurrent data access.

## 🧠 Concepts Covered
- ACID Properties
- `BEGIN`, `COMMIT`, `ROLLBACK`, `SAVEPOINT`
- Concurrency Anomalies (Dirty Read, Non-repeatable Read)
- Transaction Isolation Levels

## 🏗️ Implementation Overview
Write SQL scripts simulating multi-step financial transfers. Open multiple concurrent sessions to observe locking and isolation behaviors.

## 📝 Procedure
1. Implement a transfer script using `BEGIN` and `COMMIT`.
2. Introduce an error midway and use `ROLLBACK`.
3. Use `SAVEPOINT` to demonstrate partial rollbacks.
4. Open two separate database sessions.
5. Simulate concurrency anomalies (e.g., lost update) by altering isolation levels.

## 🎓 Learning Outcomes
Practical experience with database transaction safety and handling concurrent user operations.

[🔗 Open Experiment 8](./Experiment%208.sql)
[🔗 View Outputs](./output.md)
