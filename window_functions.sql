/*
Window functions with MySQL
ROW_NUMBER()
RANK()
DENSE_RANK()
*/

create table if not exists sales (
customer_id INT NOT NULL,
sale_amount float );

INSERT INTO sales
VALUES
(11, 201.23),
(12, 201.23),
(13,200.00),
(14, 301.23),
(15,300.00),
(16, 400),
(17, 400),
(18,309),
(19, 399.30);

-- query below will give results of in descending order according to sale_amount 
--  with ROW_NUMBER, RANK, and DENSE_RANK
select 
customer_id, 
sale_amount, 
ROW_NUMBER() OVER (ORDER BY sale_amount DESC) row_numner,
RANK() OVER (ORDER BY sale_amount DESC) sales_rank,
DENSE_RANK() OVER (ORDER BY sale_amount DESC) sales_dense_rank 
from sales;

-- script below gives the same results as the above query
select  
customer_id, 
sale_amount, 
ROW_NUMBER() OVER (ORDER BY sale_amount DESC) row_numner,
RANK() OVER (ORDER BY sale_amount DESC) sales_rank,
DENSE_RANK() OVER (ORDER BY sale_amount DESC) sales_dense_rank
from sales
where sale_amount in ( select distinct  sale_amount  from sales )
order by sale_amount desc;






