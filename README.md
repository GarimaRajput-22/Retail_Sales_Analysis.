# Retail Sales Analysis using SQL

## Overview
An SQL project that analyses a retail sales database to find insights on revenue, customers, products, employees and shipping.

## Database Schema
The database has 12 tables:
- *salesorder*: order details (customer, employee, shipper, dates, freight)
- *orderdetail*: products, price, quantity and discount per order
- *customer*: customer details and location
- *product*: product name, price, stock, supplier and category
- *category*: product categories
- *supplier*: supplier details
- *shipper*: shipping companies
- *employee*: employee details and manager
- *territory*: sales territories
- *region*: regions
- *employeeterritories*: links employees to territories
- *customerdemographics*: customer segments

## Business Questions
- What is the total revenue and how does it change over time?
- Which products and categories earn the most?
- Who are the top customers and which countries buy the most?
- Which employees have the highest sales?
- Which shipper handles the most orders?
- Which products are low on stock?

## SQL Concepts Used
- Joins
- GROUP BY and aggregate functions
- Subqueries and CTEs
- Window functions
- CASE statements

## Sample Query
sql
SELECT c.companyName,
       SUM(od.unitPrice * od.quantity * (1 - od.discount)) AS revenue
FROM customer c
JOIN salesorder o ON c.custId = o.custId
JOIN orderdetail od ON o.orderId = od.orderId
GROUP BY c.companyName
ORDER BY revenue DESC
LIMIT 10;


## Tools Used
MySQL, MySQL Workbench

