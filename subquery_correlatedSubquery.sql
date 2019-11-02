-- Subquery and Correlated Subquery examples with SQL Server

/* Subquery

A subquery (nested query, or inner query) is a query in the WHERE clause.
SubQuery is executed before the main query is executed. A maximum of 32 levels of subqueries are allowed.

Operators in WHERE clause:  use "=" when subquery returns a single value (single column)
            use "IN" when subquery returns multiple values (single column)
            use "EXISTS()" when subquery returns multiple values (multiple columns)
            EXISTS() is a boolean function, which returns TRUE when there exists at least one row
*/


-- Question: who has the max balance and what is the amount?
-- approach: (1) what is the max balance? (2) who has it?

-- What is the max balance
select max(BALANCE) 
from [dbo].[ACCOUNT]


-- Who has highest balance?
select name
from ACCOUNT
where BALANCE = (select max(BALANCE) 
                 from [dbo].[ACCOUNT]
                )


-- Who has the second highest balance?
select name
from ACCOUNT
where BALANCE = (select max(BALANCE) 
                 from [dbo].[ACCOUNT]
                 where BALANCE < (select max(BALANCE) 
                                  from [dbo].[ACCOUNT]
                                  )
                )


-- Who has the second highest balance? a different and more general way to do
-- first find out the 2nd highest disctinct balance
select min(BALANCE)
from ACCOUNT
where BALANCE in (select distinct top 2 BALANCE 
                  from [dbo].[ACCOUNT]
                  order by BALANCE desc
                 )

-- find out all the names of the persons that have the 2nd highest disctinct balance
select name
from ACCOUNT
where BALANCE = (select min(BALANCE)
                 from ACCOUNT
                 where BALANCE in (select distinct top 2 BALANCE 
                                   from [dbo].[ACCOUNT]
                                   order by BALANCE desc
                                   )
                )


-- similarly, find out all the names of the persons that have the 15th highest disctince balance
select name
from ACCOUNT
where BALANCE = (select min(BALANCE)
                 from ACCOUNT
                 where BALANCE in (select distinct top 15 BALANCE 
                                   from [dbo].[ACCOUNT]
                                   order by BALANCE desc
                                   )
                )


-- Correlated Subquery
/* A correlated subquery (or synchronized subquery) uses values from the outer query as a looped program. 
Inner query needs a value from outer query, so outer query is executed first, and the subquery (inner query) is 
evaluated once for each row processed by the outer query (and hence correlated subquery can be slow).

*/

-- A typical correlated query sample
SELECT employee_id, name
FROM employees employee_id
WHERE salary > (
                SELECT AVG(salary)
                FROM employees
                WHERE department = emp.department
               )


-- Question: Who have (has) the 2nd highest disctinct balance?
select name
from ACCOUNT 
where BALANCE = (select disticnt BALANCE
                 from ACCOUNT a     -- table 'a' is outer, for every row in 'a' will be compared with ecery row in table 'b'
                 where 2 = (select count(distinct BALANCE) 
                                   from ACCOUNT b
                                   where a.BALANCE <= b.BANLANCE
                            )
                )

-- Question: list the ACID and the NAME where the account has done any transactions.
SELECT ACID, NAME 
FROM ACCT_MASTER AS AM 
WHERE EXISTS(SELECT *
             FROM TXN_MASTER AS TM
             WHERE AM.ACID = TM.ACID
            )

-- Question: list the ACID and the NAME where the account holder has done more than 3 transactions for the month of November 2011.
SELECT ACID, NAME 
FROM ACCT_MASTER AS AM 
WHERE 3 = (SELECT COUNT(ACID)
             FROM TXN_MASTER AS TM
             WHERE AM.ACID = TM.ACID
          )
