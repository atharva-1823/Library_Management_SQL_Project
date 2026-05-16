Library Management System | MySQL Project
Overview

The Library Management System is a relational database project developed using MySQL to manage and analyze library operations efficiently. This project demonstrates practical database design, SQL querying, CRUD operations, analytical SQL queries, and stored procedures.

The system manages books, members, employees, branches, issued books, and returned books while maintaining relationships between tables using primary and foreign keys.

Objectives
Design a relational database schema for library operations
Implement relationships using primary and foreign keys
Perform CRUD operations on library data
Execute analytical SQL queries for business insights
Create stored procedures for automation
Practice real-world SQL problem solving
Database Tables
Table Name	Description
branch	Stores branch details
employees	Stores employee information
members	Stores member records
books	Stores library book details
issued_status	Tracks issued books
return_status	Tracks returned books
SQL Concepts Used
Database Design
Primary Keys
Foreign Keys
CRUD Operations
INNER JOIN
LEFT JOIN
SELF JOIN
GROUP BY
HAVING
Aggregate Functions
CTAS (Create Table As Select)
Stored Procedures
Date Functions
Data Analysis Queries
Features Implemented
Database Design
Created relational schema
Established relationships between tables
Designed ER Diagram
CRUD Operations
Inserted records
Updated records
Deleted records
Retrieved filtered data
Analytical Queries

Implemented SQL queries for:

Revenue analysis
Branch performance reports
Overdue books
Most issued books
Active members
Books not returned
Stored Procedures

Created procedures for:

Book return processing
Automatic book status updates
Book issue management
Sample SQL Query
Retrieve Books Not Yet Returned
SELECT * 
FROM issued_status ist
LEFT JOIN return_status rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;
Project Structure
Library_Management_SQL_Project/
│
├── README.md
├── app_library.sql
├── Day_1.sql
├── Day_2.sql
├── Day_3_Basic_Queries.sql
├── Day_4_Complex_Queries.sql
│
├── books.csv
├── branch.csv
├── employees.csv
├── issued_status.csv
├── return_status.csv
│
└── ER_Diagram.png
Tools & Technologies Used
MySQL
MySQL Workbench
Git
GitHub
Key Learnings

Through this project, I gained practical experience in:

Relational Database Design
Writing complex SQL queries
Managing Foreign Key Relationships
Data Analysis using SQL
Stored Procedure Development
Real-world Database Operations
Future Enhancements
Power BI Dashboard Integration
Fine Management System
Book Reservation System
Authentication System
Web-Based Library Application
