# Data Engineering Notes

## Data Dimensions

### Overview
- **Dimensions** are attributes of an entity, similar to columns in a database.
- Includes an **identifier dimension** (e.g., Primary Key) that uniquely identifies each record.

### Types of Dimensions
1. **Slowly Changing Dimensions (SCD)**  
   - Values might change over time.  
   - Examples: Customer address, product price.  
   - Often used in tracking changes for historical analysis.
2. **Fixed Dimensions (Static)**  
   - Values remain constant and do not change.  
   - Examples: Country codes, product categories.

> **Why It Matters**: Understanding the type of dimension is crucial for designing data models that align with business requirements and support efficient querying.

---

## Data Modeling

### Key Consideration: Identify the Consumer
The first step in modeling data is to understand the target audience or use case for the data. This determines how the data should be structured.

#### Types of Consumers
1. **Data Analysts / Data Scientists**  
   - Prioritize ease of use and minimal complexity in data types.  
   - Aim for intuitive structures that support tools like SQL and BI dashboards.

2. **Other Data Engineers**  
   - Can handle compact and more complex data models.  
   - Nested data types (e.g., arrays, maps, structs) are acceptable.

3. **Machine Learning Models**  
   - Understand the requirements of the training process.  
   - Ensure features are in the right format and aligned with ML needs.

4. **Customers / End Users**  
   - Data must be easily interpretable and presented in a user-friendly format, such as charts or summaries.

---

## Cumulative Table Design

### Purpose
- Designed to **retain historical data** over time.
- Helps in tracking changes or trends on a day-to-day basis.

### Methodology
1. Maintain two datasets: `TODAY` and `YESTERDAY`.
2. Perform a **Full Outer Join** to combine both datasets and retain all data.
3. Use **COALESCE** to merge columns and ensure historical continuity.

#### Example Use Case
- Tracking user activity across daily intervals to understand behavior patterns.

---

## Compactness vs. Usability Trade-Off

### Definitions
- **Usability**:  
  - Data is easy to query and analyze.  
  - Avoid complex data types for ease of filtering (e.g., `WHERE`) and aggregations (e.g., `GROUP BY`).

- **Compactness**:  
  - Data is stored in a compressed, efficient format.  
  - Typically harder for humans to read or query directly.

### Middle Ground
- Utilize complex data types like `ARRAY`, `MAP`, and `STRUCT` to balance between compactness and usability.

> **Best Practice**: Choose the right balance based on the expected consumer and their needs.

---

## Run-Length Encoding

### What is Run-Length Encoding?
- A **compression technique** that reduces storage by eliminating duplicate values in contiguous rows.

### How It Works
1. The column to be compressed must be **sorted** first.
2. Consecutive duplicate values are "nullified" (not stored redundantly).

### Benefits
- Efficient storage of repetitive data.
- Improves query performance by reducing the size of datasets.

#### Example
Given the following sorted data:
Date User Activity 2024-11-15 Logged In 2024-11-15 Logged In 2024-11-16 Logged Out

Run-length encoding would store:
Date User Activity 2024-11-15 Logged In 2024-11-16 Logged Out


---

> **Pro Tip**: Always assess the trade-offs between compression techniques and query performance. Compression saves storage but may increase the complexity of data retrieval.
