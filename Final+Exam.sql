-- 1)
USE classicmodels;

SELECT *
FROM customers
WHERE city = (SELECT city
FROM customers
WHERE customerName = 'Vitachrome Inc.')
ORDER BY customerNumber;


-- 2)
SELECT DISTINCT customerNumber, 
				DATE_FORMAT(paymentDate, '%b %e %Y') AS paymentDate, 
				customerName, phone
FROM customers JOIN payments
	USING(customerNumber) JOIN orders
	USING(customerNumber)
WHERE YEAR(paymentDate) = 2004 &&
		MONTH(paymentDate) = 6
ORDER BY orderDate;


-- 3)
SELECT employeeNumber, firstName, lastName, COUNT(*) AS num_of_customers
FROM employees JOIN customers
	ON salesRepEmployeeNumber = employeeNumber
WHERE jobTitle = 'Sales Rep'
GROUP BY salesRepEmployeeNumber
HAVING COUNT(*) > 6
ORDER BY COUNT(*) DESC;


-- 4)
CREATE OR REPLACE VIEW train_orders AS
	SELECT orderNumber, orderDate, shippedDate, customerNumber
	FROM orders JOIN orderdetails
		USING(orderNumber) JOIN products
		USING(productCode)
	WHERE productLine = 'Trains' && 
			YEAR(orderDate) = 2003
	GROUP BY orderNumber;

SELECT * FROM train_orders;


-- 5)
DROP PROCEDURE IF EXISTS direct_subordinates;

DELIMITER //

CREATE PROCEDURE direct_subordinates
(
	IN firstName_param VARCHAR(50),
	IN lastName_param VARCHAR(50)
)
BEGIN

	SELECT *
	FROM employees
	WHERE reportsTo = (SELECT employeeNumber FROM employees
						WHERE firstName = firstName_param && 
								lastName = lastName_param);
	
END //

DELIMITER ;

CALL direct_subordinates('Mary', 'Patterson');


-- 6)
DROP FUNCTION IF EXISTS get_orders_total;

DELIMITER //

CREATE FUNCTION get_orders_total
(
	customerNumber_param INT
)
RETURNS DOUBLE

BEGIN

	DECLARE orders_total_var DOUBLE;
	
	SELECT SUM(quantityOrdered * priceEach)
	INTO orders_total_var
	FROM orders JOIN orderdetails
		USING (orderNumber)
	WHERE customerNumber = customerNumber_param;

	RETURN(orders_total_var);
END //

DELIMITER ;

SELECT customerNumber, customerName, get_orders_total(103) AS 'Orders Total'
FROM customers
WHERE customerNumber = 103;


-- 7)
DROP PROCEDURE IF EXISTS delete_order;

DELIMITER //

CREATE PROCEDURE delete_order
(
	orderNumber_param INT
)

BEGIN

	DECLARE sql_error TINYINT DEFAULT FALSE;
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;

	START TRANSACTION;
	
	DELETE FROM orderdetails
	WHERE orderNumber = orderNumber_param;
	
	DELETE FROM orders
	WHERE orderNumber = orderNumber_param;

	IF sql_error = FALSE THEN
		COMMIT;
		SELECT 'The transaction was successful!';
	ELSE
		ROLLBACK;
		SELECT 'The transaction was not successful! RollBack occured.';
	END IF;

END //

DELIMITER ;

CALL delete_order(10100);

SELECT *
FROM orders
WHERE orderNumber = 10100;

SELECT *
FROM orders
WHERE orderNumber = 10100;


-- 8)
DROP PROCEDURE IF EXISTS app_rep;

DELIMITER //

CREATE PROCEDURE app_rep()
BEGIN

	DECLARE sql_error TINYINT DEFAULT FALSE;
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;


	START TRANSACTION;	
	
	INSERT INTO employees VALUES
	(1324, 'Smith', 'Sam', 'x105', 'samsmith@classicmodelcards.com', 3, 1143, 'Sales Rep');
	
	UPDATE customers
	SET salesRepEmployeeNumber = 1324
	WHERE country = 'Canada';

	IF sql_error = FALSE THEN
		COMMIT;
		SELECT 'The transaction was successful!';
		SELECT CONCAT('The new employee has ', 
				(SELECT COUNT(*) FROM CUSTOMERS WHERE salesRepEmployeeNumber = 1324), 'customers now.');
	ELSE
		ROLLBACK;
		SELECT 'The transaction was not successful! RollBack occured.';
	END IF;
	

END //

DELIMITER ;

CALL app_rep();
