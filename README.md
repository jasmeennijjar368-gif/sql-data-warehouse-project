# SQL Data Warehouse and Analytics Project

The materials of the data warehouse project: the source files, every script from the videos, and the docs.

## Project Overview

This project involves building a data warehouse using PostgreSQL.

The project integrates data from two source systems:

- CRM (Customer Relationship Management)
- ERP (Enterprise Resource Planning)

The objective is to clean, transform, and integrate raw data 
into a structured data warehouse for analytical reporting.

```text
sql-data-warehouse-project/             
├── 01_datasets/            the six source files the project loads
│   ├── source_crm/         three files from the CRM system
│   └── source_erp/         three files from the ERP system
├── 02_docs/                the requirements, the diagrams and the notes
├── 03_scripts/             the project scripts, in the order of the videos
│   ├── init_database.sql   creates the database: run it first
│   ├── bronze/             loads the raw files
│   ├── silver/             cleans and prepares the data
│   └── gold/               builds the tables for analysis
└── 04_tests/               checks the quality of the silver and gold data
```

## Data Architecture

The project follows the Medallion Architecture:

- Bronze Layer: Stores raw data.
- Silver Layer: Cleans and transforms data.
- Gold Layer: Contains analytical tables ready for reporting.
  <img width="672" height="703" alt="Data Architecture" src="https://github.com/user-attachments/assets/6f9e5fb6-3043-4ca9-90a6-c31be8d816ea" />

   
## Project Overview
In this project, I:

- Design the architecture: a modern data warehouse with three layers, bronze, silver and gold.
- Build the ETL pipelines: load the source files and move the data through the layers.
- Model the data: facts and dimensions, ready for reports.
- Analyze it: answer business questions with PostgreSQL.

## 🛠️ Important Links & Tools
- PostgreSQL and pgAdmin
- Git: a GitHub account, to save and share your project.
- draw.io: to draw the architecture and the data model.
- Notion template: the project plan, ready to copy.
- Notion project steps: every phase and task of the project.

## 🚀 Project Requirements
Building the Data Warehouse (Data Engineering).
Objective:
Develop a modern data warehouse using PostgreSQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

## Specifications
- Data Sources: Import data from two source systems (ERP and CRM) provided as CSV files.
- Data Quality: Cleanse and resolve data quality issues prior to analysis.
- Integration: Combine both sources into a single, user-friendly data model designed for analytical queries.
- Scope: Focus on the latest dataset only; historization of data is not required.
- Documentation: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

## BI: Analytics & Reporting (Data Analysis)
Objective:
Develop SQL-based analytics to deliver detailed insights into:

- Customer Behavior
- Product Performance
- Sales Trends
- These insights empower stakeholders with key business metrics, enabling strategic decision-making.
