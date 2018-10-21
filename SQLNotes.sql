/*
The key to SQL is understanding statements. A few statements include:
CREATE TABLE is a statement that creates a new table in a database.
DROP TABLE is a statement that removes a table in a database.
SELECT allows you to read data and display it. This is called a query.

In SQL, you can think of a statement as (select all that apply):
A piece of correctly written SQL code.
A way to manipulate data stored in a database.
A sentence.
A way to read data stored in a database.


SELECT is where you tell the query what columns you want back.
FROM is where you tell the query what table you are querying from.
*/

##LIMITS
/*
The LIMIT statement is useful when you want to see just the first few rows of a table. 
This can be much faster for loading than if we load the entire dataset.
*/

SELECT occurred_at,account_id,channel
FROM web_events
LIMIT 15;

##ORDERBY
/*
The ORDER BY statement allows us to order our table by any row. 
If you are familiar with Excel, this is similar to the sorting you can do with filters.
The ORDER BY statement is always after the SELECT and FROM statements, but it is before the LIMIT statement.
*/

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at DESC #Decreasing Order
LIMIT 10;

/*
ORDER BY more than one column at a time.
The statement sorts according to columns listed from left first and those listed on the right after that.
*/
SELECT *
FROM orders
ORDER BY occurred_at , total_amt_usd 
LIMIT 10;

##WHERE
/*
Using the WHERE statement, we can subset out tables based on conditions that must be met. 
Common symbols used within WHERE statements include:

    > (greater than)

    < (less than)

    >= (greater than or equal to)

    <= (less than or equal to)

    = (equal to)

    != (not equal to)
*/
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

/*
WHERE statement can also be used with non-numerical data. We can use the = and != operators here.
ommonly when we are using WHERE with non-numeric data fields, we use the LIKE, NOT, or IN operators. 
*/
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

##ARITHMETIC OPERATIONS
/*Stored in Derived Column
Common operators include:

    * (Multiplication)
    + (Addition)
    - (Subtraction)
    / (Division)
Remember PEMDAS from math class? 
*/
SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

##LOGICAL OPERATORS
/*Introduction to Logical Operators

In the next concepts, you will be learning about Logical Operators. Logical Operators include:

    LIKE
    This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.

    IN
    This allows you to perform operations similar to using WHERE and =, but for more than one condition.

    NOT
    This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.

    AND & BETWEEN
    These allow you to combine operations where all combined conditions must be true.

    OR
    This allow you to combine operations where at least one of the combined conditions must be true.*/

 ##LIKE
 /*The LIKE operator is extremely useful for working with text.
 You will use LIKE within a WHERE clause. The LIKE operator is frequently used with %. 
 The % tells us that we might want any number of characters leading up to a particular set of characters 
 Searching for 'T' is not the same as searching for 't
*/


SELECT name
FROM accounts
WHERE name LIKE 'C%'; #Start with C

SELECT name
FROM accounts
WHERE name LIKE '%C'; #End with C

SELECT name
FROM accounts
WHERE name LIKE '%C%'; #C in b/w

##IN
/*
IN operator is useful for working with both numeric and text columns. 
This operator allows you to use an =, but for more than one item of that particular column.
*/
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

##NOT
/*
NOT operator is an extremely useful operator for working with the previous two operators we introduced: IN and LIKE.
 By specifying NOT LIKE or NOT IN, we can grab all of the rows that do not meet a particular critera
 */

SELECT name
FROM accounts
WHERE name NOT LIKE '%s';

SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

##AND n BETWEEN
/*
AND operator is used within a WHERE statement to consider more than one logical clause at a time.
 Each time you link a new statement with an AND, you will need to specify the column you are interested in looking

 Sometimes we can make a cleaner statement using BETWEEN than we can using AND.
 */
 WHERE column >= 6 AND column <= 10  is same to  WHERE column BETWEEN 6 AND 10

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

##OR
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

/*
Find all the company names that start with a 'C' or 'W',
and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
*/

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') 
           AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')  #Nested Cases
           AND primary_poc NOT LIKE '%eana%');


##Database Normalization
/*
When creating a database, it is really important to think about how data will be stored.
This is known as normalization, and it is a huge part of most SQL classes. If you are in charge of setting up a new database,
is mportant to have a thorough understanding of database normalization.

There are essentially three ideas that are aimed at database normalization:

    Are the tables storing logical groupings of the data?
    Can I make changes in a single location, rather than in many tables for the same information?
    Can I access and manipulate data quickly and efficiently?
*/

##JOINS
/*
goal of JOIN statements is to allow us to pull from more than one table at a time.

Again - JOINs are useful for allowing us to pull data from multiple tables. 
This is both simple and powerful all at the same time.
*/

SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/*
We are able to pull data from two tables:

    orders
    accounts

Above, we are only pulling data from the orders table since in the SELECT statement 
we only reference columns from the orders table

Notice this result is the same as if you switched the tables in the FROM and JOIN.
 Additionally, which side of the = a column is listed doesn't matter.
*/

##KEYS

/*
Keys
Primary Key (PK)

A primary key is a unique column in a particular table. This is the first column in each of our tables. 
Here, those columns are all called id, but that doesn't necessarily have to be the name. 
It is common that the primary key is the first column in our tables in most databases.
Foreign Key (FK)

A foreign key is when we see a primary key in another table. 
We can see these in the previous ERD the foreign keys are provided as:

    region_id
    account_id
    sales_rep_id


    The way we join any two tables is in this way: linking the PK and FK (generally in an ON statement).
*/

SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id #Joining more than 2 tables
JOIN orders
ON accounts.id = orders.account_id

##ALIASES
/*
When we JOIN tables together, it is nice to give each table an alias.
 Frequently an alias is just the first letter of the table name.
 */

Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

QUESTION
##
/*
Provide a table for all the for all web_events associated with account name of Walmart. 
There should be three columns. Be sure to include the primary_poc, time of the event, 
and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen
*/
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';


