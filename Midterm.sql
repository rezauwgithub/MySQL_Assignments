USE classicmodels;

-- 1)
SELECT productName AS 'Bike Name', 
		productScale AS Scale,
		productDescription AS Description
FROM products
WHERE productScale != '1:18'
ORDER BY productScale;


-- 2)
SELECT firstName, lastName, email, country, city, territory
FROM employees JOIN offices
	USING (officeCode)
WHERE jobTitle = 'Sales Rep' AND
		(territory = 'NA' OR territory = 'EMEA')
ORDER BY territory, country DESC, city;


-- 3)
SELECT customerNumber, customerName
FROM customers
WHERE customerNumber NOT IN (SELECT customerNumber
								FROM orders)
ORDER BY customerName;


-- 4)
SELECT customerName, country, status, productname, quantityOrdered
FROM customers JOIN orders
	USING (customerNumber)
				JOIN orderdetails od
	USING (orderNumber)
				JOIN products
	USING (productCode)
WHERE country != 'USA' AND
		status != 'Shipped' AND status != 'Resolved'
ORDER BY customerName;


-- 5)
SELECT customerName
FROM customers c JOIN orders o
	USING (customerNumber)
GROUP BY customerNumber
HAVING COUNT(*) >= 4 AND 
		(LEFT(customerName, 1) = 'A' OR
		LEFT(customerName, 1) = 'D' OR
		LEFT(customerName, 1) = 'E' OR
		LEFT(customerName, 1) = 'M')
ORDER BY COUNT(*);


-- 6)
SELECT productname, productLine, buyPrice, MSRP
FROM products
WHERE buyPrice > (SELECT AVG(buyPrice)
					FROM products)
ORDER BY buyPrice DESC;


-- 7)
SELECT productName, productLine, SUM(quantityOrdered) AS totalQuantityOrdered
FROM products p JOIN orderdetails od
	USING (productCode)
GROUP BY productCode
ORDER BY SUM(quantityOrdered) DESC
LIMIT 7;


-- 8)
SELECT customerName, country, ROUND(SUM(amount), 2) AS totalPaid
FROM customers LEFT JOIN payments
	USING (customerNumber)
WHERE country = 'Germany' OR
		country = 'France'
GROUP BY customerNumber
ORDER BY SUM(amount) DESC;

-- 9)
DROP TABLE IF EXISTS orders_test;
CREATE TABLE orders_test AS
SELECT *
FROM orders;

UPDATE orders_test
SET shippedDate = Now(),
	status = 'Shipped'
WHERE status = 'in Process';


-- 10)
DELETE FROM orders_test
WHERE customerNumber IN
	(SELECT customerNumber
	 FROM customers
	 WHERE country = 'Switzerland');

/*
DELETE FROM orders_test
WHERE orderNumber 
	IN (SELECT orderNumber
		FROM customers JOIN orders
			USING (customerNumber)
		WHERE country = "Switzerland");
*/

