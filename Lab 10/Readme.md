# Lab 10: Advanced Query Optimization

## 🎯 Objective
Analyze and rewrite poorly performing queries on a large dataset to minimize execution time.

## 🧠 Concepts Covered
- Query Rewriting
- Performance Profiling
- Index Optimization
- Cost-based Optimization

## 🏗️ Implementation Overview
Work with a 10,000-row dataset. Identify bottlenecks in 5 intentionally slow queries and optimize them using best practices.

## 📝 Procedure
1. Generate a dataset of 10,000 rows.
2. Write 5 suboptimal queries (e.g., utilizing `SELECT *`, non-sargable conditions, or unoptimized subqueries).
3. Profile the slow queries using `EXPLAIN`.
4. Optimize the queries via rewriting (e.g., switching `IN` to `EXISTS`) and indexing.
5. Document the performance differential.

## 🎓 Learning Outcomes
Advanced skills in database tuning, profiling, and writing efficient SQL for enterprise-scale applications.
[🔗 Open Experiment 10](./Experiment%2010.sql)
[🔗 View Outputs](./Output.md)
