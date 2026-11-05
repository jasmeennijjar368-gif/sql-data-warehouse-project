/*
=====================================================================================================================
Quality Checks
=====================================================================================================================
Script Purpose:
	This script performs various quality checks for data consistency, accuracy,
	and standardization across the 'silver' schema. It includes checks for:
	- Null or duplicate primary keys.
	- Unwanted spaces in string fields.
	- Data standardization and consistency.
	- Invalid date ranges and orders.
	- Data consistency between related fields.

Usage Notes:
	- Run these checks after data loading Silver Layer.
	- Investigate and resolve any discrepancies found during the checks.
=======================================================================================================================
*/ 

-- crm_cust_info
--cst_id,cst_key
--Check for nulls or duplicates in primary key
--Expectation: No Result 
SELECT cst_id,
COUNT(*) 
FROM bronze.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*)>1 OR cst_id IS NULL;
--need to remove null and duplicates

--Check for unwanted spaces in string values
--Expectation: No Result 
SELECT cst_firstname
FROM bronze.crm_cust_info 
WHERE cst_firstname != TRIM(cst_firstname);
--need to clear unwanted spaces

SELECT cst_lastname
FROM bronze.crm_cust_info 
WHERE cst_lastname != TRIM(cst_lastname);
--need to clear unwanted spaces

SELECT cst_key
FROM bronze.crm_cust_info 
WHERE cst_key != TRIM(cst_key);
--It's right

--Data Standardization & Consistency 
SELECT DISTINCT cst_gender
FROM bronze.crm_cust_info;
--It's M and F, rather than using abbreviation use male and female and n/a for null

--crm_prd_info
--check for nulls or duplicates in primary key 
--Expectation : No Result 

SELECT prd_id,
COUNT(*) 
FROM bronze.crm_prd_info
GROUP BY prd_id 
HAVING COUNT(*)>1 OR prd_id IS NULL;
--Result is right. no need to change 

--prd_key
SELECT * FROM bronze.crm_prd_info;
SELECT * FROM bronze.erp_px_cat_g1v2;
SELECT * FROM bronze.crm_sales_details;
--prd_key is connected to two tables crm_sales_details and erp_px_cat_g1v2
-- so we have to divide prd_key into two categories : cat_id and prd_key 

--prd_nm
--check for unwanted spaces
--Expectation Result : no results 
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);
--Result is right so no change

--prd_cost 
--check for nulls or negative numbers 
--Expectation: No results
SELECT prd_cost 
FROM bronze.crm_prd_info
WHERE prd_cost<0 OR prd_cost IS NULL;
--we have null so use is null in query

--prd_line 
--Data Standardization and Consistency 
SELECT DISTINCT prd_line 
FROM bronze.crm_prd_info;

--crm_sales_details 
--sls_ord_num 
--check unwanted spaces
SELECT * 
FROM bronze.crm_sales_details 
WHERE sls_ord_num != TRIM(sls_ord_num);

--prd_key and cst_id should be in prd_info and cust_info table 
--check 
SELECT *
FROM bronze.crm_sales_details 
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);
--Result is fine 

SELECT *
FROM bronze.crm_sales_details 
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);
--Result is fine 

--dates 
--check for invalid dates 
SELECT 
NULLIF(sls_order_dt,0) AS sls_order_dt 
FROM bronze.crm_sales_details 
WHERE sls_order_dt<=0
OR LENGTH(sls_order_dt::TEXT)!=8
OR sls_order_dt>20500101
OR sls_order_dt<19000101;
--here we have null values and invalid dates o use case 

SELECT 
NULLIF(sls_ship_dt,0) AS sls_ship_dt 
FROM bronze.crm_sales_details 
WHERE sls_ship_dt<=0
OR LENGTH(sls_ship_dt::TEXT)!=8
OR sls_ship_dt>20500101
OR sls_ship_dt<19000101;
--result is fine but still use case if there will be problem in future adding data 

SELECT 
NULLIF(sls_due_dt,0) AS sls_ship_dt 
FROM bronze.crm_sales_details 
WHERE sls_due_dt<=0
OR LENGTH(sls_due_dt::TEXT)!=8
OR sls_due_dt>20500101
OR sls_due_dt<19000101;
--result is fine but still use case if there will be problem in future adding data 

SELECT * FROM bronze.crm_sales_details 
WHERE sls_order_dt> sls_ship_dt
 OR sls_order_dt> sls_due_dt;
-- Result is right 

--check data consistency: between sales,quantity and price 
-- sales = quantity*price 
-- values can't be null , zero or negative
SELECT DISTINCT 
sls_sales,
sls_quantity,
sls_price 
FROM bronze.crm_sales_details 
WHERE sls_sales != sls_quantity*sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales<=0 OR sls_quantity<=0 OR sls_price<=0;

/* 
Observation:
if sales is negative, zero or null and sales!= quantity*price , derive it using quantity and price 
if price is 0 or null, calculate it using sales and quantity 
if price is negative , convert it to positive value 
*/

--erp_cust_az12
--cid
SELECT * FROM bronze.erp_cust_az12;
SELECT * FROM bronze.crm_cust_info;
--nas is extra in cid. so remove it 

--bdate
--identify out of range dates
SELECT DISTINCT 
bdate
FROM bronze.erp_cust_az12
WHERE bdate<'1924-01-01' OR bdate>CURRENT_DATE;
--clean it 

--gen 
--data standardization & consistency 
SELECT DISTINCT gen 
FROM bronze.erp_cust_az12;
--we get null, blank space , male , female. fix it

--erp_loc_a101
--cid 
SELECT * FROM bronze.erp_loc_a101;
SELECT * FROM silver.crm_cust_info;
--In silver cust info there is no hyphen in cst key so remove in cid 

--data standardization & consistency 
SELECT DISTINCT cntry 
FROM bronze.erp_loc_a101
ORDER BY cntry;
--here is null and blank spaces in sresult, so use case

--erp_px_cat_g1v2
--id
SELECT * FROM bronze.erp_px_cat_g1v2;
SELECT * FROM silver.crm_prd_info;
--result is right

--cat 
--check for unwanted spaces 
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat!=TRIM(cat) OR subcat!=TRIM(subcat);

-- Data standardization and consistency 
SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2;
--result is right 
SELECT DISTINCT subcat
FROM bronze.erp_px_cat_g1v2;
--result is right 
SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2;
--result is right
--so no change 
