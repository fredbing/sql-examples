
-- HiveQL snippets 


/* Create tables
*/

-- Use SerDe to handle csv files with fields containing comma or other special symbols
ALTER TABLE table_csv SET SERDE 'com.bizo.hive.serde.csv.CSVSerde'


-- Partitioning tables
create table sales (RowID smallint, OrderID int, OrderDate date, Quote float, CustomerName string)
partitioned by (yr int)
row format serde 'com.bizo.hive.serde.csv.CSVSerde'
stored as textfile;

-- Add aprtitions after the table sales created
alter table sales
add partition (yr =2001)
location '2001/';

alter table sales
add partition (yr =2002)
location '2002/';

alter table sales
add partition (yr =2003)
location '2003/';


/*
Query tables
Hive data types: 
ARRAY- array(1,2,3): SELECT col[0] FROM
MAP- map('a', 1, 'b',2): SELECT col.a FROM
STRUCT- struct('a', 1, 1.3): use the EXPLODE() UDF to flatten data
*/

-- Get access to struct using dot '.'
-- Below is an example of nested data structure where both preference and categories are struct data type
SELECT
    c.id,
    c.name,
    c.preference.categories.surveys
FROM customers c;


-- Get access to the map structure
-- Here 'addresses' is a map structure type in which the key is 'shipping'
SELECT
    c.id,
    c.name
FROM customers c
WHERE c.addresses['shipping'].zip_code = '55447';

-- Get access to the array structure
-- Here 'orders' is an array structure type
SELECT
    c.id,
    c.name,
    orders[0]
FROM customers c;


-- EXPLODE() can also be used for flattening and parsing data
-- get customers and all of their Order IDs
SELECT
    c.id as ID,
    c.name as Name,
    ords.order_id AS order_id
FROM
    customer c
LATERAL VIEW EXPLODE(c.orders) o AS ords

-- get total of each order for these customers
SELECT 
    c.id AS CustomerID,
    c.name AS CustomerName,
    ords.order_id AS OrderID,
    order_items.price * order_items.qty as TotalAmount
FROM 
    customer c
LATERAL VIEW EXPLODE(c.orders) o AS ords
LATERAL VIEW EXPLODE(orders.items) i AS order_items
limit 1000;


/* Aggregations with grouping sets, CUBE and ROLLUP

*/

-- Grouping sets: individuals
SELECT
    ordermonth,
    category 
FROM
    ....
WHERE
    ....
group by
    ordermonth,
    category
grouping sets
    (ordermonth, category)  -- same as union of two queries with group by each one separately

-- Grouping sets: individuals and combination
SELECT
    ordermonth,
    category
    GROUPING__ID
FROM
    ....
WHERE
    ....
group by
    ordermonth,
    category
grouping sets
    ((ordermonth, category), ordermonth, category)


-- Grouping sets: CUBE for all aggregation combinations
SELECT
    ordermonth,
    category
    GROUPING__ID
FROM
    ....
WHERE
    ....
group by
    ordermonth,
    category
with cube


-- Grouping sets: ROLLUP for hierarchical aggregation combinations
SELECT
    ordermonth,
    category
    GROUPING__ID
FROM
    ....
WHERE
    ....
group by
    ordermonth,
    category
with ROLLUP



-- 'SEMI JOIN' is equivalent to 'EXIST'
SELECT *
FROM a
WHERE EXISTS (
    SELECT *
    FROM b
    WHERE a.name = b.name
)

-- is equivalent to:
SELECT *
FROM a
LEFT SEMI JOIN b
    ON a.name = b.name

