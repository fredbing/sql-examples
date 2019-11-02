/*
Self JOIN is useful for (1) querying hierarchical data and (2) comparing rows within the same table

*/

-- Querying hierarchical data
/* 
Question: the employee table with 3 attributes: emplyee_id, employee_name, manager_id, 
In this table, every row(every employee) has a manager_id, employee_id is NOT NULL, while manager_id can be NULL.
The id of the employee's manager is the same as the empoyee_id of the manager.
Objective: print out 4 attributes: including the 3 attributes in the table plus managers' name.
This problem can be solved using SELF JOIN as below:
*/


SELECT a.employee_name as employee_name, a.employee_id as e_id, a.manager_id as m_id, b.employee_name as manager_name
FROM employee a
LEFT JOIN employee b ON a.manager_id = b.employee_id
ORDER BY manager_name;


-- Comparing rows within the table
/* use table customers as example, which has following attributes: 
customer_id (PK), customer_name, phone, email, city
Objective: find the customers who locate in the same city
The following statement will solve this problem
*/

SELECT c1.city, c1.customer_name customer_1, c2.customer_name customer_2
FROM customers c1
INNER JOIN customers c2 ON c1.customer_id > c2.customer_id
AND c1.city = c2.city
ORDER BY city, customer_1, customer_2

-- condition c1.customer_id > c2.customer_id is to make sure it doesn't compare the same customer






