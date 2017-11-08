
/* Reza Naeemi - SQL, ITAD 138
Spring 2014
Lake Washington Institute of Technology 
Instructor: Julien Feis

Assignment 02
*/

USE world;

-- 1.	Find the city with the largest population. Your query must produce the answer in the format shown below. Make sure that the columns (fields) are named exactly as in the screen shot.
SELECT Name AS 'City Name', CountryCode AS 'Country Code', Max(Population)
FROM city
WHERE CountryCode = 'IND';


-- 2.	Find all the country codes where English is not official language and more than 0% and less than 50% of population speak English.  Order the results by percentage from lowest to highest.See the expected result below, it should have a total of 10 rows.  Make sure that the fields are named exactly as in the screen shot.
SELECT CountryCode AS 'Code of Country', 
		Language AS 'Not Offical Language', 
		Percentage AS 'Percentage of Population Speaking the Language'
FROM CountryLanguage
WHERE IsOfficial = 'F' AND 
	Language = 'English' AND
	Percentage > 0 AND Percentage < 50
ORDER BY percentage;


-- 3.	Get the names and Life Expectancy for population of all the countries that have names starting from letters A, D, and F. Eliminate all countries with Life Expectancy value set to NULL and sort the resulting table in alphabetical order.  The result must have 24 rows. See part of it below.  REQUIREMET: Use LEFT function and IN phrase. DO NOT use LIKE.
SELECT Name, LifeExpectancy
FROM country
WHERE (Left(Name, 1) = 'A' OR
		Left(Name, 1) = 'D' OR
		Left(Name, 1) = 'F') AND
		LifeExpectancy IS NOT NULL;


-- 4.	Find small countries in the database. The country is small if the population of it is less than 100,000. Exclude the countries that belong to Antarctica region. The result should include region, country name and local country name in one column (see screen shot below), continent and population. Order the results by region and then by country name.  Make sure that the columns are named exactly as in the screen shot. There should be 42 rows in the result.
SELECT Region, CONCAT(Name, LocalName) AS 'Country Name and Local Name', Continent, Population
FROM country
WHERE Population < 100000 AND
		Region <> 'Antarctica'
ORDER BY Region, Name;