/*
SQL Server PIVOT operator rotates a table-valued expression. It turns the unique values in one column 
into multiple columns in the output and performs aggregations on any remaining column values

This example shows how to use the SQL Server PIVOT operator to convert rows to columns. (Here rows is actually
 the same as one column, as in this example, the many category_names under the category column in 
 the production_categories table become rows after a query is performed)

Two tables are used in this exampe: production.products and production.categories.

production.products
    *product_id
     product_name
     brand_id
     category_id
     model_year
     list_price

production.categories
    *category_id
     category_name

*/

-- Find the number of products for each product category: 

SELECT 
    category_name, 
    COUNT(product_id) product_count
FROM 
    production.products p
    INNER JOIN production.categories c 
        ON c.category_id = p.category_id
GROUP BY 
    category_name;

/* Query results:

category_name             product_count
Children Bicycles           45
Comfort Bicycles            43
Cruisers Bicycles           34
Cyclocross Bicycles         23
Electric Bikes              24
Montain Bikes               20
Road Biles                  124

*/

/* 
The goals are first to turn the category names from the first column of the above output into multiple columns
 and count the number of products for each category name; 
 next, show the product_count for each of the category by model year.

Children Bicycles   Comfort Bicycles   Cruisers Bicycles  ....
  45                     43               34

model_year  Children Bicycles   Comfort Bicycles   Cruisers Bicycles  ....
    2011        3                       2                   3
    2012        6                       7                   2
    2013        4                       1                   4
    ...             ...                         ...

In order to achieve the first goal, three steps are required:

    Step_1, select a base dataset for pivoting
    Step_2, create a temporary result by using a derived table or common table expression (CTE)
    Step_3, apply the PIVOT operator
*/


--Step_1: select a base dataset for pivoting
SELECT 
    category_name, 
    product_id
FROM 
    production.products p
    INNER JOIN production.categories c 
        ON c.category_id = p.category_id


--Step_2, create a temporary result by using a derived table or common table expression (CTE)
SELECT * FROM (
    SELECT 
        category_name, 
        product_id
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t


--Step_3, apply the PIVOT operator
SELECT * FROM   
(
    SELECT 
        category_name, 
        product_id
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN (
        [Children Bicycles], 
        [Comfort Bicycles], 
        [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;


/*
 This query would generates the following output:

 Children Bicycles   Comfort Bicycles   Cruisers Bicycles  ....
  45                     43               34

*/

/*
Mow try to achieve the second goal.
 Any additional column that is added to the select list of the query that returns the base data will 
 automatically form row groups in the pivot table. Here, the model year column is added to the above query:
*/
SELECT * FROM   
(
    SELECT 
        category_name, 
        product_id,
        model_year
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN (
        [Children Bicycles], 
        [Comfort Bicycles], 
        [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;

/* Now, the output of this query would be something like this:

model_year  Children Bicycles   Comfort Bicycles   Cruisers Bicycles  ....
    2011        3                       2                   3
    2012        6                       7                   2
    2013        4                       1                   4
    ...             ...                         ...
*/

