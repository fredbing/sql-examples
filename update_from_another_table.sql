/*
Methods for updating a table with info from another table.
This could add one or more new columns to the taget table, 
 or replace/update the existing column with the info from the source table
*/


-- SQL Sever
UPDATE        targetTable
SET           targetTable.targetColumn = s.sourceColumn
FROM          targetTable t
INNER JOIN    sourceTable s
ON            t.matchingColumn = s.matchingColumn


-- MySQL
UPDATE    targetTable t,
          sourceTable s
SET       targetTable.targetColumn = sourceTable.sourceColumn
WHERE     t.matchingColumn = s.matchingColumn



