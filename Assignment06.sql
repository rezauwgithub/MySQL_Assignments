/* 
1)	(15 Pts.) Write statements that implement the following design in a database named my_web_db (create those 3 tables):
In the Downloads table, the user_id and product_id columns are the foreign keys.
Include a statement to drop the database if it already exists.
Include statements to create and select the database.
Include any indexes that you think are necessary.
Specify the utf8 character set for all tables.
*/

/*
NOTE: 	I set the SESSION sql_mode to STRICT_ALL_TABLES because
		MySQL Workbench 6.0 and 5.2.47 (did not test 6.1 yet...) was allowing NULL to be assigned
		to NOT NULL columns when using the UPDATE clause. (It was not allowed with the INSERT clause.)
		http://bugs.mysql.com/bug.php?id=33699

		NOW, with this setting, the UPDATE clause also produces the expected error to occur on 
*/
SET SESSION sql_mode = 'STRICT_ALL_TABLES';

DROP DATABASE IF EXISTS my_web_db;
CREATE DATABASE my_web_db;

USE my_web_db;

ALTER DATABASE my_web_db CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE users
(
	user_id 		INT 			PRIMARY KEY		AUTO_INCREMENT, 
	email_address	VARCHAR(100)	UNIQUE,
	first_name		VARCHAR(45),
	last_name		VARCHAR(45)
);

CREATE TABLE products
(
	product_id		INT				PRIMARY KEY		AUTO_INCREMENT,
	product_name	VARCHAR(45)		UNIQUE
);

CREATE TABLE downloads
(
	download_id		INT				PRIMARY KEY		AUTO_INCREMENT,
	user_id			INT,
	download_date	DATETIME,
	filename		VARCHAR(50),
	product_id		INT
);

CREATE INDEX downloads_download_date_ix
	ON downloads (download_date DESC);

/* 
2.	(15 Pts.) Write a script that adds rows to the database that you created in exercise 1:
Add two rows to the Users and Products tables.
Add three rows to the Downloads table: one row for user 1 and product 2; one row for user 2 and product 1; and one row for user 2 and product 2. Use the NOW function to insert the current date and time into the download_date column.
Write a SELECT statement that joins the three tables and retrieves the data from these tables like this:
 
Sort the results by the email address in descending sequence and the product name in ascending sequence.
*/
INSERT INTO users VALUES
(DEFAULT, 'rezanemail@gmail.com', 'Reza', 'Naeemi'),
(DEFAULT, 'billgates@microsoft.com', 'Bill', 'Gates');

INSERT INTO products VALUES
(DEFAULT, 'Windows 7 Professional'),
(DEFAULT, 'Windows 8 Professional');

INSERT INTO downloads VALUES
(DEFAULT, 1, NOW(), 'Win8Pro.iso', 2),
(DEFAULT, 2, NOW(), 'Win7Pro.iso', 1),
(DEFAULT, 2, NOW(), 'Win8Pro.iso', 2);

SELECT email_address, first_name, last_name, 
		download_date, filename, product_name
FROM users u JOIN downloads d
	USING (user_id)
			JOIN products p
	USING (product_id)
ORDER BY email_address DESC, product_name;


/*
3)	(10 Pts.) Write an ALTER TABLE statement that adds two new columns to the Products table created in exercise 1.
Add one column for product price that provides for three digits to the left of the decimal point and two to the right. This column should have a default value of 9.99.
Add one column for the date and time that the product was added to the database.
*/
ALTER TABLE products
ADD product_price DECIMAL(3,2) DEFAULT 9.99,
ADD date_time DATETIME DEFAULT NOW();


/*
4)	(10 Pts.) Write an ALTER TABLE statement that modifies the Users table created in exercise 1 so the first_name column cannot store NULL values and can store a maximum of 20 characters.
Code an UPDATE statement that attempts to insert a NULL value into this column. It should fail due to the NOT NULL constraint.
Code another UPDATE statement that attempts to insert a first name that’s longer than 20 characters. It should fail due to the length of the column.
*/
ALTER TABLE users
MODIFY first_name VARCHAR(20) NOT NULL;


-- NOTE: "Continue on SQL script error" should be enabled in the Preferences, since the following two statements will produce errors.
UPDATE users
SET first_name = NULL
WHERE user_id = 1;

UPDATE users
SET first_name = 'Keihanaikukauakahihuliheekahaunaele'
WHERE user_id = 1;