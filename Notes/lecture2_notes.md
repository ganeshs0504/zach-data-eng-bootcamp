
# Data Engineering Notes: Idempotency and Slowly Changing Dimensions

## Vocabulary

### Idempotent
- **Definition**: Denoting an element of a set that is unchanged in value when operated upon.
- **In Data Context**: An operation that produces the same result each time it is performed.

### Idempotent Pipelines (Data Engineering)
- A pipeline is **idempotent** if it produces the same results regardless of when it is run (e.g., day, time, or hour).
- **Why It Matters**: Non-idempotent pipelines are harder to troubleshoot due to silent failures, which can lead to data discrepancies and cascading problems in downstream data sources.

---

## Common Causes of Non-Idempotent Pipelines

### 1. **`INSERT INTO` without `TRUNCATE`**
   - Recommended: Use `MERGE` or `INSERT OVERWRITE` instead.

#### Example: Using `MERGE`
```sql
MERGE INTO target_table AS target
USING source_table AS source
ON target.id = source.id
WHEN MATCHED THEN UPDATE SET
    target.column = source.column
WHEN NOT MATCHED THEN INSERT (id, column)
VALUES (source.id, source.column);
```

#### Example: Using `INSERT OVERWRITE`
```sql
INSERT OVERWRITE TABLE target_table
SELECT * FROM source_table;
```

---

### 2. **Using `start_date >` without a corresponding `end_date <`**
- **Why This Causes Issues**: For instance, if `start_date = yesterday`, each consecutive day adds additional data, leading to duplicates.

---

### 3. **Not Using a Full Set of Partition Sensors**
- Running with partial inputs leads to incomplete data in the pipeline.

---

### 4. **Not Using `depends_on_past` for Cumulative Pipelines**
- **Fix**: Enable sequential processing for cumulative pipelines.  
  Cumulative pipelines involve **Full Outer Join** between previous and current data.

---

### 5. **Relying on the Latest Partition of a Poorly Modeled SCD Table**
- Ensure that dependency tables also follow idempotent pipelines and are properly modeled for Slowly Changing Dimensions (SCD).
- **Exception**: Backfills.

---

## Slowly Changing Dimensions (SCD)

### Overview
- **Definition**: Attributes that might change over time (e.g., age as a dimension).

### Types of SCD Modeling

#### Type 1: Overwrite with Latest Value
- Only keeps the latest value.  
- **Not Recommended**: Makes pipelines non-idempotent.

---

#### Type 2: Historical Tracking (**Gold Standard**)
- Tracks `start_date` and `end_date`.  
- `end_date` can be a future date or `NULL`.  
- **Example**:  
  Favorite food from 2000–2010 might be "Pizza", and from 2011–2020 might be "Sushi".
- **Why Type 2 Is Ideal**: It is purely idempotent.

---

#### Type 3: Limited History
- Retains only two values: **Original Value** and **Current Value**.  
- Does not track intermediate changes or timestamps of changes.

---

### Note
- Only **Type 0 (Unchanging Dimensions)** and **Type 2** are idempotent.

---

### Loading SCD Type 2 Tables

#### 1. **Single Query Method**
- **Advantages**: Nimble and straightforward.  
- **Disadvantages**: Inefficient for large datasets.

#### 2. **Cumulative Method**
- **Advantages**: Efficient for incremental loads.  
- **Disadvantages**: More complex to implement.
