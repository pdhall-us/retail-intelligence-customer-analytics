-- Creating Database name 'retail'
create database if not exists retail;

-- Using database retail
use retail;

-- Validating total number of rows
select count(*) as total_rows from retailcombined; # It matches with the original DataFrame 1067371 rows

-- Check the datatype
describe retailcombined;

/*
Based on analysis convert the following columns datatypes:-
1. InvoiceDate: Text --> datetime
2. CustomerID: double --> bigint
*/
-- Changing Datatype
-- Step-1: Update the column according to the MySQL datetime formatting before changing the datatype.

update retailcombined
set invoicedate = str_to_date(invoicedate, '%m/%d/%Y %H:%i'); # str_to_date(col, 'fomat_from_text') will convert to MySQL DateTime pattern

-- Step-2: Update the Datatypes of target columns.
alter table retailcombined
modify column invoicedate datetime,
modify column customerid bigint;

select * from retailcombined
limit 5;

-- Fetch total number of duplicate records
select count(*) - (select count(*) from (select distinct * from retailcombined) as t1) as Duplicate_rows from retailcombined;

-- Create new table without those duplicate rows
create table RetailCleaned as select distinct * from retailcombined;

-- Validate number of rows
select count(*) as count from retailcleaned;

-- Removing Records with null customer_id
delete from retailcleaned
where customerid is null;

-- Removing Records with negative quantity
delete from retailcleaned
where quantity<1;