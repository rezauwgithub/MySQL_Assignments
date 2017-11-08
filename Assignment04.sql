
/* Reza Naeemi - SQL, ITAD 138
Spring 2014
Lake Washington Institute of Technology 
Instructor: Julien Feis

Assignment 04
*/

-- Following are the questions related to the data stored in the “world” database. Write SQL queries that will provide the requested information.
USE world;

-- 1.	How many countries are there on each continent?  The query returns 7 rows. See screen shot below.
SELECT continent, Count(*) AS country_count
FROM country
GROUP BY Continent;


-- 2.	Find the number of cities and the total population of the cities in all the regions of the continent ‘Oceania’. The results should show the region, its city count, and total count of population living in those cities. Order results by region. See the screenshot below. Returns 4 rows.
SELECT Continent, Region , Count(*) AS city_count, SUM(ci.Population) AS sum_population
FROM city ci JOIN country co
	ON ci.CountryCode = co.Code
WHERE Continent = 'Oceania'
GROUP BY Region;


-- 3.	For each country find the city (in this country) with the largest population. Order results by population. Returns 232 rows. Format your results to look like the table below. 
SELECT co.Name AS country, ci.name AS city, MAX(ci.Population) AS population
FROM country co JOIN city ci
	ON co.Code = ci.CountryCode
GROUP BY co.Name
ORDER BY ci.Population DESC;


-- 4.	This one is a population analysis query. For each country in Europe (as continent) find countries’ population, sum of populations of all the cities in the database that are located in the country and percentage of country population that lives in the city (that is sum of all cities population divided by country population). Get all the countries that have more than 30% of population living in the cities.  Please format your output like one in the screen shot. Returns 20 rows.  NOTE: We can see the data flaws of the database right away because Gibraltar has more than 100% of population living in the cities…
SELECT co.Name AS country_name, co.Population AS country_population,
		SUM(ci.Population) AS city_population, ROUND((SUM(ci.Population) / co.Population) * 100, 0) AS city_population_percent
FROM country co JOIN city ci
	ON co.Code = ci.CountryCode
WHERE co.Continent = 'Europe'
GROUP BY co.Name
HAVING ROUND(SUM(ci.Population) / co.Population * 100) > 30
ORDER BY (SUM(ci.Population) / co.Population) * 100 DESC;


-- 5.	Find names and populations of the countries that have Dutch as their official language.  Order by country name. Returns 4 rows. See results below.  REQUIREMENT: Do not use JOIN, use subquery.
SELECT name AS country, region, surfaceArea
FROM country
WHERE code IN (SELECT countrycode FROM countrylanguage WHERE language = 'Dutch' AND isOfficial = "T")
ORDER BY name;


-- 6.	Find city names and populations of the cities in 'Western Europe' region that have the city population larger than the average population of the cities in the country they are in. Include names of countries, city names, and city populations in the query results. Order results by country name and then by city name. This will be a ‘correlated subquery’.  Returns 41 rows. See screen shot below.
SELECT co.name AS country, ci.name AS city, ci.Population AS city_population
FROM city ci JOIN country co
	ON ci.CountryCode = co.Code
WHERE ci.Population > (SELECT AVG(Population)
					FROM city
					WHERE CountryCode = ci.CountryCode) AND
		co.Region = 'Western Europe'
ORDER BY co.name;


-- 7.	Find the list of all the countries in the database that don’t have information about country language. Display region, country name and population. Returns 6 rows.  REQUIREMENT: Do NOT use JOIN, use subquery
SELECT region, name AS country_name, Population AS population
FROM country
WHERE NOT EXISTS (SELECT *
					FROM countrylanguage
					WHERE CountryCode = country.Code);


-- Following is the question related to the data stored in the “om” database. Write the SQL queries that will provide the requested information.
USE om;

-- 8.	For each customer get the most recent order date. Order by the order date from the most recent to the earlier ones. Returns 25 rows. Format the results same as they appear in the screenshot below.  REQUIREMENT: Use subquery, do not use JOIN
SELECT CONCAT(customer_first_name, ' ', customer_last_name) AS customer_name,
		(SELECT MAX(order_date)
			FROM orders
			GROUP BY customer_id
			HAVING customer_id = c.customer_id) AS recent_order_date
FROM customers c
ORDER BY (SELECT MAX(order_date)
			FROM orders
			GROUP BY customer_id
			HAVING customer_id = c.customer_id) DESC;
