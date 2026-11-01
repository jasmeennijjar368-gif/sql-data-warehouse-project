/*
=========================================================================================
Script Purpose:
		This stored procedure loads data into the 'bronze' schema from external CSV files.
		It performs the following actions:
		- Truncates the bronze tables before loading data.
		- Uses the 'BULK INSERT' command to load data from csv files to bronze tables.

Parameters:
	None.
	This stored procedure doesn't accept any parameters or return any values.

Usage Example:
	CALL bronze.load_bronze;
=========================================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE 
start_time TIMESTAMP;
		end_time TIMESTAMP;
		batch_start_time TIMESTAMP;
		batch_end_time TIMESTAMP;
BEGIN 
batch_start_time := NOW();
RAISE NOTICE'=======================================';
RAISE NOTICE'Loading Bronze Layer';
RAISE NOTICE'=======================================';

RAISE NOTICE'---------------------------------------';
RAISE NOTICE'Loading CRM Tables';
RAISE NOTICE'---------------------------------------';

start_time := NOW();
RAISE NOTICE'>>Truncating Table: bronze.crm_cust_info';
TRUNCATE TABLE bronze.crm_cust_info;

RAISE NOTICE'>>Inserting data into bronze.crm_cust_info';
\COPY 
bronze.crm_cust_info(cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gender,cst_create_date)
FROM 'C:\Users\acer\Downloads\cust_info.csv'
DELIMITER ','
CSV HEADER;
end_time := NOW();
RAISE NOTICE'Load Duration:%',end_time-start_time;

start_time := NOW();
RAISE NOTICE'>>Truncating Table: bronze.crm_prd_info';
TRUNCATE TABLE bronze.crm_prd_info;

RAISE NOTICE'>>Inserting data into bronze.crm_prd_info';
COPY 
bronze.crm_prd_info(prd_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt)
FROM 'C:\Users\acer\Downloads\prd_info.csv'
DELIMITER ','
CSV HEADER;
end_time := NOW();
RAISE NOTICE'Load Duration:%',end_time-start_time;

start_time := NOW();
RAISE NOTICE'>>Truncating Table: bronze.crm_sales_details';
TRUNCATE TABLE bronze.crm_sales_details;

RAISE NOTICE'>>Inserting data into bronze.crm_sales_details';
COPY 
bronze.crm_sales_details(sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price)
FROM 'C:\Users\acer\Downloads\sales_details.csv'
DELIMITER ','
CSV HEADER;
end_time := NOW();
RAISE NOTICE'Load Duration:%',end_time-start_time;

start_time := NOW();
RAISE NOTICE'>>Truncating Table: bronze.erp_loc_a101';
TRUNCATE TABLE bronze.erp_loc_a101;

RAISE NOTICE'>>Inserting data into bronze.erp_loc_a101';
COPY 
bronze.erp_loc_a101(cid,cntry)
FROM 'C:\Users\acer\Downloads\LOC_A101.csv'
DELIMITER ','
CSV HEADER;
end_time := NOW();
RAISE NOTICE'Load Duration:%',end_time-start_time;

start_time := NOW();
RAISE NOTICE'>>Truncating Table: bronze.erp_cust_az12';
TRUNCATE TABLE bronze.erp_cust_az12;

RAISE NOTICE'>>Inserting data into bronze.erp_cust_az12';
COPY 
bronze.erp_cust_az12(cid,bdate,gen)
FROM 'C:\Users\acer\Downloads\CUST_AZ12.csv'
DELIMITER ','
CSV HEADER;
end_time := NOW();
RAISE NOTICE'Load Duration:%',end_time-start_time;

start_time := NOW();
RAISE NOTICE'>>Truncating Table: bronze.erp_px_cat_g1v2';
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

RAISE NOTICE'>>Inserting data into bronze.erp_px_cat_g1v2';
COPY 
bronze.erp_px_cat_g1v2(id,cat,subcat,maintenance)
FROM 'C:\Users\acer\Downloads\PX_CAT_G1V2.csv'
DELIMITER ','
CSV HEADER;
end_time := NOW();
RAISE NOTICE'Load Duration:%',end_time-start_time;

batch_end_time := NOW();
RAISE NOTICE'Loading Bronze Layer is completed';
RAISE NOTICE'Total duration: %',batch_end_time-batch_start_time;

EXCEPTION 
WHEN OTHERS THEN 
RAISE NOTICE'Error Message: %',SQLERRM;
END;
$$;

--Executing Procedure 
CALL bronze.load_bronze();


SELECT * FROM bronze.crm_cust_info;
SELECT * FROM bronze.crm_prd_info;
SELECT * FROM bronze.crm_sales_details;
SELECT * FROM bronze.erp_cust_az12;
SELECT * FROM bronze.erp_loc_a101;
SELECT * FROM bronze.erp_px_cat_g1v2;
