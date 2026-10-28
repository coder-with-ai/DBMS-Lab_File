# Lab 7: Database Normalization

## 🎯 Objective
Decompose a denormalized dataset step-by-step to eliminate anomalies and ensure data integrity up to BCNF.

## 🧠 Concepts Covered
- Functional Dependencies
- Unnormalized Form (UNF) to 1NF, 2NF, 3NF
- Boyce-Codd Normal Form (BCNF)
- Lossless Join Decomposition
- Dependency Preservation

## 🏗️ Implementation Overview
Given a massive denormalized `Sales` table, identify all functional dependencies and perform a structured decomposition.

## 📝 Procedure
1. Analyze the denormalized table to map functional dependencies.
2. Convert to 1NF by removing repeating groups.
3. Convert to 2NF by removing partial dependencies.
4. Convert to 3NF by removing transitive dependencies.
5. Ensure compliance with BCNF.
6. Write `JOIN` queries to verify that the decomposition was lossless.

## 🎓 Learning Outcomes
Strong grasp of database design theory and the ability to prevent data redundancy and update anomalies.
[🔗 Open Experiment 7](./Experiment%207.sql)
[🔗 View Outputs](./Output.md)
