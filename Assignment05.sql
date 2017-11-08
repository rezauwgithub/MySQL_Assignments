/* Reza Naeemi - SQL, ITAD 138
Spring 2014
Lake Washington Institute of Technology 
Instructor: Julien Feis

Assignment 05
*/

-- Following are the questions related to the data stored in the “world” database. Write SQL queries that will provide the requested information.
USE world;

-- 1.	(10 pts.) Find all the countries that have surface area less than the surface area of Andorra.  (Requirement: Do not find and then hard code the surface area number. Formulate your query so that it retrieves the number). Include country name, continent, and surface area into the result. Order by surface area in ascending order. Returns 43 rows.
SELECT name AS country_name,
		Continent AS continent,
		SurfaceArea
FROM country
WHERE SurfaceArea < (SELECT SurfaceArea
						FROM country
						WHERE name = 'Andorra')
ORDER BY SurfaceArea;


-- 2.	(10 pts.) Find all the countries that have the same official language as Belgium. Please note that Belgium has more than one official language. Order results first by language, then by country name. Returns 28 rows.
SELECT co.name AS country_name, 
	   cl.Language
FROM country co JOIN countrylanguage cl
	ON co.Code = cl.CountryCode
WHERE cl.IsOfficial = 'T' AND
		cl.Language IN (SELECT language
						FROM countrylanguage
						WHERE CountryCode = (SELECT Code
											 FROM country
											 WHERE name = 'Belgium') AND
							  IsOfficial = 'T')
ORDER BY cl.Language, 
		 co.Name;


-- 3.	(10 pts.) Find all the countries on continent Africa that have French as official language. Order results by country name. Returns 5 rows.
SELECT name AS 'French-Speaking African Countries'
FROM country
WHERE Continent = 'Africa' AND
	  Code IN (SELECT CountryCode
			   FROM countrylanguage
			   WHERE Language = 'French' AND
					IsOfficial = 'T');


-- Following are the questions related to the data stored in the “om” database. Write the SQL queries that will provide the requested information.
USE om;

-- 4.	(10 pts.) For each customer calculate the total number of items purchased. Keep in mind that each order may contain more than one purchased item. Find those that purchased more than 5 items. Returns 4 rows.
SELECT c.customer_first_name, c.customer_last_name, SUM(od.order_qty)
FROM customers c JOIN orders o
	USING (customer_id) JOIN order_details od
	USING (order_id)
GROUP BY customer_id
HAVING SUM(order_qty) > 5;

		
-- 5.	(10 pts.) Create a full copy of the orders table, call it orders_copy01.  Insert two new rows into this table: 
-- a.	Order number 830, for customer number 3, order date – today’s date (use function that returns today’s date), no shipping date available yet (use null)
-- b.	Order number 831, for customer number 2, order date – yesterday’s date (subtract a day from today’s date), no shipping date available yet (use null)
	/*
	The resulting table screenshot is below (result of the query 
	SELECT * FROM orders_copy01
	ORDER BY shipped_date ASC;)
	*/

DROP TABLE IF EXISTS orders_copy01;
CREATE TABLE orders_copy01 AS
SELECT *
FROM orders; 

INSERT INTO orders_copy01 VALUES
(830, 3, CURDATE(), null),
(831, 2, CURDATE() - 1, null);

SELECT * FROM orders_copy01
ORDER BY shipped_date ASC;


-- 6.	(10 pts.) Make updates to the orders_copy01 table. For all the entries where shipping date is null 
-- a.	replace nulls with the current date.
-- b.	change the order date to a day before (subtract 1 from the date that is currently stored in the order_date field)
	/*
	Below is the result of the query 
	SELECT * FROM orders_copy01
	ORDER BY shipped_date DESC;
	*/
UPDATE orders_copy01
SET shipped_date = CURDATE(),
	order_date = order_date - 1
WHERE shipped_date IS NULL;

SELECT * FROM orders_copy01
ORDER BY shipped_date DESC;


-- 7.	(10 pts.) Make more changes to the orders_copy01 table: Delete all orders of the customers from California. 20 rows must be affected.
DELETE FROM orders_copy01
WHERE customer_id IN
	(SELECT customer_id 
	 FROM customers
	 WHERE customer_state = 'CA');

/*
DELETE FROM orders_copy01
WHERE order_id IN (SELECT order_id
				   FROM orders oc JOIN customers cu
				   USING (customer_id)
				   WHERE cu.customer_state = 'CA');
*/

-- 8.	(10 pts.) Create a full copy of items table, call it items_copy01. Find the item(s) created by artist 'The Ubernerds' and increase their price by $3.
DROP TABLE IF EXISTS items_copy01; 
CREATE TABLE items_copy01 AS
SELECT *
FROM items;

UPDATE items_copy01
SET unit_price = unit_price + 3
WHERE artist = 'The Ubernerds';
