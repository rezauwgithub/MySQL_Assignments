/*
You will need the ‘world’ database for the following exercise. The sql file can be found in the “Files” section in Canvas.
1.	(14 pts.) Using Workbench graphical tool, create an ER diagram of the world database. Take a screenshot of the diagram and turn it in.
*/
-- See 'World_EER.png' file for screenshot, which was included in the submission.


/*
You will need the ‘tennis’ database for the following exercises. The sql file along with the description of the database can be found in the “Files” section in Canvas. Write SQL statements and queries that will provide the requested information.
*/
USE tennis;

/*
2)	(6 pts.) Create a view called “numberplus” that contains all the team numbers and total number of players who have played for that team. (Assume that at least one player has competed for the team.).
a.	 Write a “SELECT all” statement to show the view.
b.	Is this an updatable view? Write an update statement to demonstrate if the view is updatable.  If not updatable – explain why.
c.	The screenshot of the “SELECT *” statement for the view is below. Returns 2 rows. 
*/
CREATE OR REPLACE VIEW numberplus 
	(teammo, number)
AS
	SELECT TEAMNO, COUNT(PLAYERNO)
	FROM matches
	GROUP BY TEAMNO;

/*
UPDATE numberplus
set number = 1
WHERE number = 8;
NOTE:  The above statement produces the following error:
Error Code: 1288. The target table numberplus of the UPDATE is not updatable
This is because our statement has an aggregate function.
In addition, the select statement cannot include a GROUP BY when updating.

Requirements for creating updateable views:
 - The select list can't include a DISTINCT clause.
 - The select list can't include aggregate functions.
 - The SELECT statement can't include a GROUP BY or HAVING clause.
 - The view can't include a UNION operator.
*/

SELECT *
FROM numberplus;


/*
3)	(6 pts.) Create a view called “winners” that contains the number and name of each player who, for at least one team, has won one match.
a.	Write a “SELECT all” statement to show the view.
b.	Is this an updatable view? Write an update statement to demonstrate if the view is updatable.  If not updatable – explain why.
c.	The screenshot of the “SELECT *” statement for the view is below. Returns 5 rows.
*/
CREATE OR REPLACE VIEW winners 
	(playerno, name)
AS
	SELECT DISTINCT PLAYERNO, NAME
	FROM players JOIN matches
		USING (PLAYERNO)
	WHERE WON > LOST
	ORDER BY PLAYERNO;

/*
UPDATE winners
SET NAME = '5'
WHERE NAME = '2';
NOTE:  The above statement produces the following error:
Error Code: 1288. The target table winners of the UPDATE is not updatable
This is because our statement is using the DISTINCT clause.

Requirements for creating updateable views:
 - The select list can't include a DISTINCT clause.
 - The select list can't include aggregate functions.
 - The SELECT statement can't include a GROUP BY or HAVING clause.
 - The view can't include a UNION operator.
*/

SELECT *
FROM winners;


/*
4.	(6 pts.) Create a view called “totals” that records the total amount of penalties for each player who has incurred at least one penalty.
a.	Write a “SELECT all” statement to show the view.
b.	Is this an updatable view? Write an update statement to demonstrate if the view is updatable.  If not updatable – explain why.
c.	The screenshot of the “SELECT *” statement is below. Returns 5 rows.
*/
CREATE OR REPLACE VIEW totals
	(playerno, sum_penalties)
AS
	SELECT PLAYERNO, SUM(AMOUNT)
	FROM penalties
	GROUP BY PLAYERNO;

/*
SELECT *
FROM totals;
NOTE:  The above statement produces the following error:
Error Code: 1288. The target table winners of the UPDATE is not updatable
This is because our statement is using an aggregate function.
In addition, the select statement cannot include a GROUP BY when updating.

Requirements for creating updateable views:
 - The select list can't include a DISTINCT clause.
 - The select list can't include aggregate functions.
 - The SELECT statement can't include a GROUP BY or HAVING clause.
 - The view can't include a UNION operator.
*/

SELECT *
FROM totals;


/*
5.	(6 pts.) Find player number, name, and date of birth in the format ‘January 1st 1945, Monday’. Display only those players, who were born on Saturday or Sunday. Returns 5 rows.
*/
SELECT PLAYERNO AS playerno, NAME AS name, 
		DATE_FORMAT(BIRTH_DATE, '%M %D %Y , %W') AS 'Birth Date'
FROM players
WHERE DAYNAME(BIRTH_DATE) = 'Saturday' OR
			DAYNAME(BIRTH_DATE) = 'Sunday';


/*
6.	(6 pts.) Find player number, name, birth date, birth date plus 3 month, and age of players. Pick only those who are older than 50. Returns 4 rows.
*/
SELECT PLAYERNO AS playerno, NAME AS name,
		BIRTH_DATE AS birth_date,
		DATE_ADD(BIRTH_DATE, INTERVAL 3 MONTH) AS 'Birth_Date plus 3 months',
		TIMESTAMPDIFF(YEAR, BIRTH_DATE, CURDATE()) AS Age
FROM players
WHERE TIMESTAMPDIFF(YEAR, BIRTH_DATE, CURDATE()) > 50;
/* 
NOTE:  I get more rows than the Homework Assignment screenshot shows because
		the CURDATE() now is different than when the author of the assignment
		ran it.  As time goes by, the players will be older, so the results 
		will change for each person running this query on this table.
*/


/*
7.	(6 pts.) Find player number, name (displayed in all capital letters), phone number displayed in format (070) 237893, gender displayed as ‘Male’ or ‘Female’, and league number with nulls replaced with ‘Not in League’. See screenshot below. Returns all 14 rows.
*/
SELECT PLAYERNO AS playerno, UPPER(NAME) AS name,
		CONCAT('(', LEFT(PHONENO, 3), ') ',
				RIGHT(PHONENO, 6)) AS phone,
		CASE SEX
			WHEN 'M' THEN 'Male'
			WHEN 'F' THEN 'Female'
		END AS gender,
		IFNULL(LEAGUENO, 'Not in League') AS LeagueNum
FROM players;