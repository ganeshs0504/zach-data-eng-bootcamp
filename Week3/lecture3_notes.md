
# Data Engineering Notes: Dimensions, ENUMs, and Graph Data Modeling

## Additive and Non-Additive Dimensions

### Additive Dimensions
- Refer to metrics that can be **aggregated** or summed up across different categories.  
- **Example**:  
  - Age is additive.  
    - Total population = Sum of individuals aged 1, 2, 3, ..., 150.

### Non-Additive Dimensions
- Metrics that **cannot** be summed across categories due to overlaps or dependencies.  
- **Example**:  
  - Active users are non-additive:  
    - Total active users ≠ Web users + Android users + iOS users (as some users may use multiple platforms).

### Additivity Rule
- A dimension is additive over a specific window of time if and only if the **grain of data** within that window can have only one value at any given time.

---

## ENUMs (Enumerations)

### Overview
- ENUMs are suitable for **low-to-medium cardinality** datasets.  
  - **Example**: Countries, statuses, or categories.

### Best Practices
- Limit usage to datasets with fewer than **50 unique values** (a good rule of thumb).

### Benefits of ENUMs
1. **Built-in Data Quality**: Ensures values conform to predefined categories.
2. **Static Fields**: Provide consistency across datasets.
3. **Built-in Documentation**: Acts as a self-documenting data type.
4. **Partitioning**: Effective for **sub-partitions** in large datasets, helping break down big data problems into manageable chunks.

---

## Graph Data Modeling

### Relationship-Focused Approach
- Unlike traditional modeling, graph data modeling focuses on **relationships**, not just entities.

### Basic Structure
- Most graphs can be represented with three key attributes:  
  - `identifier` (String)  
  - `type` (String)  
  - `properties` (Map<String, String>)

#### Example
| **Field**        | **Type**           | **Description**                     |
|-------------------|--------------------|-------------------------------------|
| `identifier`      | String             | Unique ID for the node.             |
| `type`            | String             | Category or type of the node.       |
| `properties`      | Map<String,String> | Key-value pairs for additional info.|

---

### Advanced Relationship Model
A more detailed model includes both nodes and their relationships:  

#### Structure
| **Field**             | **Type**        | **Description**                     |
|------------------------|-----------------|-------------------------------------|
| `subject_identifier`   | String          | Unique ID of the source node.       |
| `subject_type`         | VERTEX_TYPE     | Type/category of the source node.   |
| `object_identifier`    | String          | Unique ID of the target node.       |
| `object_type`          | VERTEX_TYPE     | Type/category of the target node.   |
| `edge_type`            | EDGE_TYPE       | Type/category of the relationship.  |
| `properties`           | Map<String,String> | Key-value pairs for relationship metadata. |

---

> **Pro Tip**: Use graph models for scenarios with complex relationships, such as social networks, recommendation systems, or supply chain modeling.
