
##LEFT n RIGHT
three new functions:

    LEFT
    RIGHT
    LENGTH

LEFT pulls a specified number of characters for each row in a specified column starting at the beginning (or from the left). As you saw here, you can pull the first three digits of a phone number using LEFT(phone_number, 3).

RIGHT pulls a specified number of characters for each row in a specified column starting at the end (or from the right). As you saw here, you can pull the last eight digits of a phone number using RIGHT(phone_number, 8).

LENGTH provides the number of characters for each row of a specified column. 
Here, you saw that we could use this to get the length of each phone number as LENGTH(phone_number).

SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

##POSITION

POSITION takes a character and a column, and provides the index where that character is for each row. 
The index of the first position is 1 in SQL. If you come from another programming language, many begin indexing at 0. 
Here, you saw that you can pull the index of a comma as POSITION(',' IN city_state).

STRPOS provides the same result as POSITION, but the syntax for achieving those results is a bit different as shown here:
 STRPOS(city_state, ',')

 SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;

##CONCAT


    CONCAT
    Piping ||

Each of these will allow you to combine columns together across rows. In this video, you saw how first
 and last names stored in separate columns could be combined together to create a full name: CONCAT(first_name, ' ', last_name) 
 or with piping as first_name || ' ' || last_name.


WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com'), LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;

##CAST

SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2)) new_date
FROM sf_crime_data;

SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;

##COALESCE

In general, COALESCE returns the first non-NULL value passed for each row.  

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;