# Lab 9: Indexing and Performance Benchmarking

## 🎯 Objective
Optimize data retrieval in a large dataset by applying single and composite indexes.

## 🧠 Concepts Covered
- Database Indexing (B-Trees)
- Single vs. Composite Indexes
- Query Performance Benchmarking
- Execution Plan Analysis (`EXPLAIN`)

## 🏗️ Implementation Overview
Generate a `Railway Booking` table with 5,000+ rows. Test search speeds before and after creating indexes.

## 📝 Procedure
1. Create the table and populate 5,000 records.
2. Write search queries targeting specific columns (e.g., Date and Destination).
3. Measure execution time and analyze the full table scan using `EXPLAIN`.
4. Create appropriate single and composite indexes.
5. Re-run queries to compare execution plans and performance gains.

## 🎓 Learning Outcomes
Understanding of how database indexes work under the hood and how they drastically reduce lookup times.

[🔗 Open Experiment 9](./Experiment%209.sql)
[🔗 View Outputs](./output.md)
