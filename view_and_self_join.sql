/*
VIEW, Self JOIN
*/

/* 
Descrition of query question: the employee table with 3 attributes: emplyee_id, employee_name, manager_id, 
it needs to print out 4 attributes: including the 3 attributes in the table plus managers' name.
In the employee table, every row(every employee) has a manager_id, employee_id is NOT NULL, while manager_id can be NUL.
The id of the employee's manager is the same as the empoyee_id of the manager
*/


-- Method 1: create a view, and use the original table to join the view

/*
-- find the names and id's of all managers
SELECT DISTINCT employee_name as manager_name, employee_id
FROM employee
WHERE employee_id IN 
	(SELECT manager_id 
	 FROM employee);
*/

-- Create a view
CREATE VIEW manager AS
SELECT DISTINCT employee_name, employee_id
FROM employee
WHERE employee_id IN 
	(SELECT manager_id 
	 FROM employee);

-- print out 4 attributes: employee_name, employee_id, manager_id, manager_name
SELECT a.employee_name as employee_name, a.employee_id as e_id, a.manager_id as m_id, b.employee_name as manager_name
FROM employee a
LEFT JOIN manager b ON a.manager_id = b.employee_id;


-- Method 2: use Self Join, which is a simpler method than Method 1
-- Self Join is useful for querying hierarchical data. 
-- In the query below, a and b are some tables of different alias 

SELECT a.employee_name as employee_name, a.employee_id as e_id, a.manager_id as m_id, b.employee_name as manager_name
FROM employee a
LEFT JOIN employee b ON a.manager_id = b.employee_id;







