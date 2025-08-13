# 🏭 SQL & .NET Challenge: Industrial Production with Work Orders

## 📘 Description

In this challenge, you will work with a realistic data simulation from an industrial production environment. The database includes work orders, operations, materials, production lines, and employees.

The goal of the challenge is to deepen your understanding of:

- **Table joins (JOIN)** between multiple entities,
- **Data aggregation (GROUP BY)** and using **aggregate functions**,
- **Filtering and sorting**,
- And the basics of **data normalization**.

Additional emphasis is placed on **query efficiency** and **performance measurement**.

## 💻 Technological Guidelines for Solution

Implement the application as a **.NET console application** (recommended version: .NET 8 or higher), using:

- **Entity Framework** for database access,
- **LINQ** to execute queries on the data,
- **`Stopwatch`** from `System.Diagnostics` to measure execution time for each query,
- Optionally, use `ILogger` or `Console.WriteLine()` for logging results.

The goal is to measure how quickly queries are executed on large datasets (200,000+ rows) and assess if the queries are appropriately optimized.

### 📌 Example of Application Start in .NET

```csharp
var stopwatch = Stopwatch.StartNew();

using var context = new ProductionDbContext();

// Example of a simple query
var topEmployees = await context.WorkOrderOperations
    .GroupBy(op => op.EmployeeId)
    .Select(g => new {
        EmployeeId = g.Key,
        OperationCount = g.Count()
    })
    .OrderByDescending(x => x.OperationCount)
    .Take(5)
    .ToListAsync();

stopwatch.Stop();
Console.WriteLine($"Execution time: {stopwatch.ElapsedMilliseconds} ms");
```

## 📊 Database Table Structure

| Table               | Purpose                                                              |
|---------------------|----------------------------------------------------------------------|
| `ProductionLines`    | List of all production lines                                          |
| `Employees`          | Employee data                                                         |
| `Materials`          | List of materials                                                     |
| `WorkOrders`         | Work orders with date, status, and link to a production line          |
| `WorkOrderOperations`| Operations linked to work orders and employees                        |
| `WorkOrderMaterials` | Material consumption per work order                                   |

---

## 🔍 Column Descriptions

### `Database Creation`
Use the provided file [`industry_workorders_200k.sql`](industry_workorders_200k.sql):

### `ProductionLines`
| Column   | Meaning                                  |
|----------|------------------------------------------|
| Id       | Primary key                             |
| Name     | Production line name (e.g., 'Line 1')    |
| Location | Line location (e.g., 'Plant A')         |

### `Employees`
| Column    | Meaning                                  |
|-----------|------------------------------------------|
| Id        | Primary key                             |
| Name      | Employee name                           |
| Department| Department (e.g., Assembly, ...)        |

### `Materials`
| Column | Meaning                                 |
|--------|-----------------------------------------|
| Id     | Primary key                            |
| Name   | Material name                          |
| Unit   | Unit of measure (e.g., kg, ...)         |

### `WorkOrders`
| Column   | Meaning                                    |
|----------|--------------------------------------------|
| Id       | Primary key                               |
| Code     | Work order code (e.g., WO-00001)          |
| StartDate| Start date                                |
| EndDate  | End date                                  |
| LineId   | Foreign key to `ProductionLines.Id`       |
| Status   | Status (Planned, InProgress, Completed)   |

### `WorkOrderOperations`
| Column         | Meaning                                 |
|----------------|-----------------------------------------|
| Id             | Primary key                            |
| WorkOrderId    | Foreign key to `WorkOrders.Id`         |
| OperationName  | Operation name                         |
| DurationMinutes| Duration in minutes                    |
| EmployeeId     | Foreign key to `Employees.Id`          |

### `WorkOrderMaterials`
| Column     | Meaning                                |
|------------|----------------------------------------|
| Id         | Primary key                           |
| WorkOrderId| Foreign key to `WorkOrders.Id`        |
| MaterialId | Foreign key to `Materials.Id`         |
| Quantity   | Material quantity consumed            |

---

## 🎯 Challenges

### 1. Find the top 5 lines with the most work orders
> Display `Line Name`, `# of work orders`, sorted in descending order.

### 2. Which employee worked on the most operations?
> Display `Employee Name`, `# of operations`, `Department`.

### 3. Total material consumption by unit
> Display `Unit`, `Total quantity`.

### 4. Average operation duration by work order status
> Join data between `WorkOrders` and `WorkOrderOperations`.

### 5. Top 3 materials by quantity for work orders on "Line 1"
> Use a JOIN between `WorkOrders`, `WorkOrderMaterials`, and `Materials`.

---

## 🛠️ Getting Started

1. Create the database schema in SQL Server.
2. Import the data (approximately 200,000 rows).
3. Start solving the challenges!

---

## 📌 Tips

- Pay attention to **indexes** when optimizing queries (using a local database).
- See if you can solve challenges with a single query.
- Use **CTE** (Common Table Expressions) for better readability of complex queries.

---

## 📦 Authors and Support

This challenge was generated for practicing industrial SQL scenarios and query optimization.  
For issues or errors, feel free to contact the author.
