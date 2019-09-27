/*
Methods for finding and deleting duplicate rows
the snippets below are mainly SQL Server based
*/

/* 
Identifying duplicate rows
*/

SELECT col_name, COUNT(col_name) FROM table_name
GROUP BY col_name
HAVING COUNT(col_name) > 1;

/*
Deleting duplicate rows
*/

-- Method 1: use SELECT DISTINCT INTO statement
SELECT DISTINCT * INTO tmp_table FROM table_ori
DELETE FROM table_ori
INSERT INTO table_ori
SELECT * FROM tmp_table DROP TABLE tmp_table


-- Method 2: set ROWCOUNT (for tables having no primary key)
-- need to find the duplicate rows first by using SELECT, then delete the duplicate row(s)
SET ROWCOUNT 1 
DELETE FROM table_ori WHERE name = "duplcated name" 
SET ROWCOUNT 0;
               
-- Method 3: use ROWID, the pseudocolumn that uniquely defines a single row in a database table.
DELETE FROM table_ori alias_a 
WHERE ROWID > (SELECT MIN (ROWID) FROM table_ori alias_b 
               WHERE alias_b.name = alias_a.name);
-- In case there are rows with same name but different other attribute such as age, then:
DELETE FROM table_ori alias_a 
WHERE ROWID > (SELECT MIN (ROWID) FROM table_ori alias_b 
               WHERE alias_b.name = alias_a.name
               AND alias_a.age = alias_b.age);




