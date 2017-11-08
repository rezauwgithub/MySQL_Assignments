
/* Reza Naeemi - SQL, ITAD 138
Spring 2014
Lake Washington Institute of Technology 
Instructor: Julien Feis

Assignment 03
*/

-- Following are questions related to the data stored in the “album” database. Write SQL queries that will provide the requested information.
USE album;

-- 1.	This query is for the track table. Assume that the track duration stored is measured in seconds. Get track number, title, duration in minutes (has to calculate that value) and duration in seconds for all the tracks in album with album_id 13. Sort the result by track number. See the screenshot below, make sure your column names are the same. There are 10 rows in resulting table.
SELECT track_number, title, 
	TRUNCATE((duration / 60), 0) AS 'Duration in min', 
	duration AS 'Duration in sec' 
FROM track
WHERE album_id = 13
ORDER BY track_number;


-- 2.	Get title, artist, release date, and label information from the album table for all the albums that were produced by Columbia label after Jan 1 1970. Release date should be in the format  ‘Mon-year’, the results should be ordered alphabetically by the title. There will be 2 rows in result. Make sure that the columns are names as appears in the screen shot below.
SELECT title, artist, 
		DATE_FORMAT(released, '%M-%Y') AS 'Release Date', label
FROM album
WHERE label = 'Columbia' AND
		released > '1970-01-01'
ORDER BY title;


-- Following are two questions related to the data stored in the “world” database. Write SQL queries that will provide the requested information.
USE world;

-- 3.	(10 pts.) Find five largest cities, their population, and countries they are in.  See the screen shot below. Rename the columns so they are named as in the screen shot.
SELECT ci.Name AS city_name, ci.Population AS population, co.Name AS country_name
FROM city ci JOIN country co
	ON ci.CountryCode = co.Code
ORDER BY ci.population DESC
LIMIT 5;


-- 4.	(10 pts.)  List all the cities that are located in the countries that have Khmer or Tamil as their official language. Include country name and language in the results. Order results first by country name, then by city name. Make sure that the columns are named exactly as in the screen shot. Returns 11 rows.

SELECT ci.Name AS city_name, co.name AS country_name, cl.Language AS language
FROM city ci NATURAL JOIN countrylanguage cl
				LEFT JOIN country co
					ON cl.CountryCode = co.Code
WHERE (Language = 'Khmer' OR
		Language = 'Tamil') AND
		cl.IsOfficial = 'T'
ORDER BY co.name, ci.name;


-- 5.	 (10 pts.) Find countries which population is less than population of the country named Anguilla. Do not include countries with population 0. Retrieve country names, region and their population.  Sort the results first by population, then by region, then by country name. You should get 11 rows. See screen shot below.  HINT: Use self-join.
SELECT DISTINCT c1.name, c1.region, c1.population
FROM country c1 JOIN country c2
WHERE c1.population != 0 AND
		c1.population < (SELECT population FROM country WHERE name = 'Anguilla')
ORDER BY c1.population, c1.region, c1.name;


-- 6.	(10 pts.) Find the list of all the countries in the database that don’t have information about country language. Retrieve country names, region, and SurfaceArea fields. Sort results by country name. Returns 6 rows.  Requirement: Use LEFT JOIN
SELECT co.name, co.region, co.SurfaceArea, cl.language
FROM country co LEFT JOIN countrylanguage cl
	ON co.Code = cl.CountryCode
WHERE cl.language IS NULL
ORDER BY co.name;
	-- Note: The screenshot that was provided in the homework assignment did not have the results sorted by country name. :)


-- Following are the questions related to the data stored in the “om” database. Write SQL queries that will provide the requested information.
USE om;

-- 7.	(10 pts.)  Find customer first, last names, and item titles for all the orders that were placed in 2010. Order by date, then by item title. Rename the columns, combine first and last name in one column. Returns 20 rows. See screen shot below.  Requirement: Use regular JOIN ON syntax.
SELECT o.order_date, i.title, 
		CONCAT(c.customer_first_name, ' ', c.customer_last_name) AS customer_name
FROM customers c JOIN orders o
	ON c.customer_id = o.customer_id
		JOIN order_details od
	ON o.order_id = od.order_id
		JOIN items i
	ON od.item_id = i.item_id
WHERE YEAR(order_date) = 2010
ORDER BY order_date, title;


-- 8.	(10 pts.) Find title, artist name and unit price of all the items that are priced the same as the item named 'Umami In Concert'.  Include 'Umami In Concert' into the resulting set. Order results by title. The result contains 3 rows.   HINT: Use self-join.
SELECT DISTINCT i1.title, i1.artist, i1.unit_price
FROM items i1 JOIN items i2
WHERE i1.title = i2.title AND
		i1.unit_price = (SELECT unit_price FROM items WHERE title = 'Umami In Concert')
ORDER BY i1.title;


-- 9.	(10 pts.)Retrieve order_id, customer address together with city, state and zip as one field, order_date and shipped_date. If the shipped_date not available, replace null with current date. Order by order_date.  Query should produce 47 rows. See screenshot below. See page 255 of the text book to learn how to insert current date into the query results.  Requirement: use UNION operator.
SELECT o.order_id, 
	CONCAT(c.customer_address, ' ', c.customer_city, ', ', c.customer_state, 
			c.customer_zip) AS address,
		o.order_date, IFNULL(o.shipped_date, CURDATE()) AS shipped_date
FROM customers c JOIN orders o
	USING (customer_id)
ORDER BY order_date DESC; 