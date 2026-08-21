select * from category ; 
select * from customer ;
select * from customerdemographics;
select * from employees ; 
select * from employeeterritory ; 
select * from orderdetail;
select * from product;
select * from region ;
select * from salesorder ; 
select * from shipper ; 
select*from supplier ; 
select * from territory ; 

-- Basic data exploration 

select * from retail_sales.product ;

-- products which have unit price above 50.
SELECT productName, unitPrice
FROM retail_sales.product
WHERE unitPrice > 50;

-- customers from germany .
SELECT contactName
FROM retail_sales.customer
WHERE city = "Germany";

-- number of order placed .
SELECT count(orderId)
FROM retail_sales.orderdetail ; 

-- avg unit price of all products 
SELECT avg(unitprice)
FROM retail_sales.product;

-- total revenue generated . 
SELECT 
    SUM(quantity) AS total_quantity_sold,
    SUM(unitPrice) AS total_sales,
    SUM(discount) AS total_discount_given,
    (SUM(quantity) * SUM(unitPrice) - SUM(discount)) AS total_revenue
FROM retail_sales.orderdetail;

-- Product category analysis.
SELECT 
    c.categoryName AS category_name,
    p.productName AS product_name,
    p.unitPrice AS unit_price
FROM retail_sales.product p
RIGHT JOIN retail_sales.category c 
    ON p.categoryId = c.categoryId;
    
-- customer and order analysis .
    
SELECT 
    c.companyName AS customer_company_name,
    s.orderId AS order_id,
    s.orderdate AS order_date
FROM retail_sales.customer c
RIGHT JOIN retail_sales.salesorder s 
    ON c.custId = s.custId ; 
    
-- Employee and cutomer analysis . 
    
select concat(firstname," ",lastname) as employee_name  from retail_sales.employee;

SELECT 
    c.contactname  AS customer_name,
    s.orderId AS order_id,
	concat(e.firstname," ",lastname) as employee_name 
FROM retail_sales.customer c
inner JOIN retail_sales.salesorder s on c.custId = s.custId 
inner join retail_sales.employee e on e.employeeId = s.employeeId ;
 
 -- Products which have greater unit price then average unit price of all products .
 
select avg(unitPrice) from retail_sales.product ;

SELECT productName
FROM retail_sales.product
WHERE unitPrice>
(SELECT AVG(unitPrice) FROM retail_sales.product);

-- customer who have placed order more than 5 times .

use retail_sales ;

SELECT contactName as customer_name 
FROM retail_sales.customer WHERE custId In (SELECT custId FROM salesorder GROUP BY custId
HAVING COUNT(orderID) > 5);

-- products that have never been ordered . 

SELECT p.productName FROM product p
WHERE NOT EXISTS (SELECT 1 FROM orderdetail od
WHERE od.productId  = p.productId );

 -- Ranking products by price 
 
 SELECT 
    p.productName,
    p.unitPrice,
    c.categoryName,
    RANK() OVER (PARTITION BY c.categoryName ORDER BY p.unitPrice DESC) AS price_rank
FROM retail_sales.product p
JOIN retail_sales.category c 
    ON p.categoryId = c.categoryId;
    
-- Calculating running total

SELECT 
    s.orderDate,
    SUM(od.unitPrice * od.quantity - od.discount) AS order_revenue,
    SUM(SUM(od.unitPrice * od.quantity - od.discount)) 
        OVER (ORDER BY s.orderDate) AS running_total_revenue
FROM retail_sales.salesorder s
join retail_sales.orderdetail od
on od.orderId = s.orderId
GROUP BY s.orderDate
ORDER BY s.orderDate;

-- Ranking customers by revenue 

SELECT 
    c.contactName AS customer_name,
    SUM(od.unitPrice * od.quantity - od.discount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(od.unitPrice * od.quantity - od.discount) DESC) AS customer_rank
FROM retail_sales.customer c
JOIN retail_sales.orderdetail od
JOIN retail_sales.salesorder s ON c.custId = s.custId
GROUP BY c.contactName
ORDER BY customer_rank;

-- Advanced anlytics 
-- 1. which category generates higher revenue . 

SELECT 
    c.categoryName,
    SUM(od.unitPrice * od.quantity - od.discount) AS total_revenue
FROM retail_sales.product p
JOIN retail_sales.category c 
    ON p.categoryId = c.categoryId
JOIN retail_sales.orderdetail od 
    ON p.productId = od.productId
GROUP BY c.categoryName
ORDER BY total_revenue DESC
LIMIT 1;

-- 2. Customer who placed most orders .

SELECT 
    cu.contactName AS customer_name,
    COUNT(s.orderId) AS total_orders
FROM retail_sales.customer cu
JOIN retail_sales.salesorder s 
    ON cu.custId = s.custId
GROUP BY cu.contactName
ORDER BY total_orders DESC
LIMIT 1;

-- 3. Employee handeling most orders 

SELECT 
    CONCAT(e.firstName, ' ',lastName) AS employee_name,
    COUNT(s.orderId) AS orders_handled
FROM retail_sales.employee e
JOIN retail_sales.salesorder s 
    ON e.employeeId = s.employeeId
GROUP BY e.firstName, e.lastName
ORDER BY orders_handled DESC
LIMIT 1;
