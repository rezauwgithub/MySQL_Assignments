-- 1)	(10 pts.) Write a script that creates and calls a stored procedure named Dividableby3. This procedure should display all numbers divisible by 3 starting from 333 to 360, the division expression, and the quotient of division by 3. See the screenshot below.ALTER
USE ap;
DROP PROCEDURE IF EXISTS Dividableby3;

DELIMITER //

CREATE PROCEDURE Dividableby3()
BEGIN
	DECLARE minNum INT DEFAULT 333;
	DECLARE maxNum INT DEFAULT 360;
	DECLARE dividableNum INT DEFAULT 3;
	DECLARE str VARCHAR(200) DEFAULT '';

	WHILE (minNum <= maxNum) DO
		SET str = CONCAT(str, minNum, ' / ',  dividableNum,  ' = ', TRUNCATE(minNum / dividableNum, 0), ' | ');
		SET minNum = minNum + dividableNum;
	END WHILE;

	SELECT str AS message;	
END //

DELIMITER ;

CALL Dividableby3();


-- 2)	(10 pts.) (Database tennis) Add to your script the creation of and call to a stored procedure named AverAge. This procedure should compare the average age of women players and the average age of men players. The procedure should output either the message “The average age of men is higher. It is ##” or the message “The average age of women is higher. It is ##” depending on your results. The ## must be replaced by the actual average age, as it been calculated. If the average ages are equal for both groups the message must be “The average age of men is the same as the average age of women. It is ##”. The screenshot of the result is below:
USE tennis;

DROP PROCEDURE IF EXISTS AverAge;

DELIMITER //

CREATE PROCEDURE AverAge()
BEGIN
	DECLARE maleAge INT;
	DECLARE femaleAge INT;
	
	SELECT AVG(TIMESTAMPDIFF(YEAR, BIRTH_DATE, CURDATE()))
	INTO maleAge
	FROM players
	WHERE SEX = 'M';
	
	SELECT AVG(TIMESTAMPDIFF(YEAR, BIRTH_DATE, CURDATE()))
	INTO femaleAge
	FROM players
	WHERE SEX = 'F';

	IF (maleAge > femaleAge) THEN
		SELECT CONCAT('The average age of men is higher. It is ', maleAge);
	ELSEIF (femaleAge > maleAge) THEN
		SELECT CONCAT('The average age of women is higher. It is ', femaleAge);
	ELSE
		SELECT CONCAT('The average age of men is the same as the average age of women. It is ', maleAge);
	END IF;	
END //

DELIMITER ;

CALL AverAge();

-- 3.	(15 pts) (Database “ap”) Add to your script a function that returns the firstname and another function that returns the lastname from the vendor_contacts table. Either of those functions will take invoice_id as (the only) input parameter. Add a SELECT statement that returns vendors firstname and lastname, balance due for all invoices with balance due >0. Sort by lastname. Requirement: USE the functions that you created in this exercise!
USE ap;

DELIMITER //

CREATE FUNCTION get_first_name
(
	invoice_id_param INT
)
RETURNS VARCHAR(50)

BEGIN
	DECLARE first_name_var VARCHAR(50);

	SELECT first_name
	INTO first_name_var
	FROM vendor_contacts JOIN invoices
		USING (vendor_id)
	WHERE invoice_id = invoice_id_param;

	RETURN(first_name_var);

END//

DELIMITER ;

DELIMITER //

CREATE FUNCTION get_last_name
(
	invoice_id_param INT
)
RETURNS VARCHAR(50)

BEGIN
	DECLARE last_name_var VARCHAR(50);

	SELECT last_name
	INTO last_name_var
	FROM vendor_contacts JOIN invoices
		USING (vendor_id)
	WHERE invoice_id = invoice_id_param;

	RETURN(last_name_var);

END //

DELIMITER ;

SELECT get_first_name(invoice_id), get_last_name(invoice_id),
	invoice_total - payment_total - credit_total AS balance_due
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0;


-- 4)	(15 pts) (Database “om”) Add to your script a function that returns the most recent order date for a customer. Input parameters are customer_first_name and customer_last_name. Add a SELECT statement that returns for each customer the most recent order date. Order by the order date from the most recent to the earlier ones. Display the rows as shown in the screenshot below. Requirement: USE the functions that you created in this exercise! Returns 25 rows.
USE om;


DROP FUNCTION IF EXISTS get_most_recent_order_date;
DELIMITER //

CREATE FUNCTION get_most_recent_order_date
(
	customer_first_name_param VARCHAR(50),
	customer_last_name_param VARCHAR(50)
)
RETURNS DATE

BEGIN
	DECLARE most_recent_order_date_var DATE;

	SELECT order_date
	INTO most_recent_order_date_var
	FROM orders JOIN customers
		USING (customer_id)
	WHERE customer_first_name_param = customer_first_name &&
			customer_last_name_param = customer_last_name
	ORDER BY order_date DESC
	LIMIT 1;

	RETURN(most_recent_order_date_var);

END //

DELIMITER ;

SELECT CONCAT(customer_first_name, ' ', customer_last_name) AS customer_name,
		get_most_recent_order_date(customer_first_name, customer_last_name) AS recent_order_date
FROM customers
ORDER BY get_most_recent_order_date(customer_first_name, customer_last_name) DESC;


