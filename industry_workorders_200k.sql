
-- Drop tables if they exist
IF OBJECT_ID('dbo.WorkOrderMaterials', 'U') IS NOT NULL DROP TABLE dbo.WorkOrderMaterials;
IF OBJECT_ID('dbo.WorkOrderOperations', 'U') IS NOT NULL DROP TABLE dbo.WorkOrderOperations;
IF OBJECT_ID('dbo.WorkOrders', 'U') IS NOT NULL DROP TABLE dbo.WorkOrders;
IF OBJECT_ID('dbo.Materials', 'U') IS NOT NULL DROP TABLE dbo.Materials;
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.ProductionLines', 'U') IS NOT NULL DROP TABLE dbo.ProductionLines;

-- Create tables
CREATE TABLE ProductionLines (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100),
    Location NVARCHAR(100)
);

CREATE TABLE Employees (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100),
    Department NVARCHAR(100)
);

CREATE TABLE Materials (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100),
    Unit NVARCHAR(10)
);

CREATE TABLE WorkOrders (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Code NVARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    LineId INT FOREIGN KEY REFERENCES ProductionLines(Id),
    Status NVARCHAR(50)
);

CREATE TABLE WorkOrderOperations (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    WorkOrderId INT FOREIGN KEY REFERENCES WorkOrders(Id),
    OperationName NVARCHAR(100),
    DurationMinutes INT,
    EmployeeId INT FOREIGN KEY REFERENCES Employees(Id)
);

CREATE TABLE WorkOrderMaterials (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    WorkOrderId INT FOREIGN KEY REFERENCES WorkOrders(Id),
    MaterialId INT FOREIGN KEY REFERENCES Materials(Id),
    Quantity DECIMAL(10,2)
);

-- Seed data
-- ProductionLines: 10
INSERT INTO ProductionLines (Name, Location)
SELECT CONCAT('Line ', n), CONCAT('Plant ', (n % 3) + 1)
FROM (SELECT TOP 10 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM master..spt_values) AS x;

-- Employees: 1000
INSERT INTO Employees (Name, Department)
SELECT CONCAT('Employee_', n),
       CASE n % 4
           WHEN 0 THEN 'Assembly'
           WHEN 1 THEN 'Welding'
           WHEN 2 THEN 'Quality'
           ELSE 'Maintenance'
       END
FROM (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master..spt_values a CROSS JOIN master..spt_values b
) AS x;

-- Materials: 100
INSERT INTO Materials (Name, Unit)
SELECT CONCAT('Material_', n),
       CASE n % 3
           WHEN 0 THEN 'kg'
           WHEN 1 THEN 'pcs'
           ELSE 'm'
       END
FROM (SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM master..spt_values) AS x;

-- WorkOrders: 10000
INSERT INTO WorkOrders (Code, StartDate, EndDate, LineId, Status)
SELECT
    CONCAT('WO-', RIGHT('00000' + CAST(n AS VARCHAR), 5)),
    DATEADD(DAY, -n, GETDATE()),
    DATEADD(DAY, -n + 2, GETDATE()),
    (n % 10) + 1,
    CASE n % 3
        WHEN 0 THEN 'Planned'
        WHEN 1 THEN 'InProgress'
        ELSE 'Completed'
    END
FROM (
    SELECT TOP 10000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master..spt_values a CROSS JOIN master..spt_values b
) AS x;

-- WorkOrderOperations: 150,000 (15 per WorkOrder)
WITH Ops AS (
    SELECT TOP 150000 CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS BIGINT) AS n
    FROM master..spt_values a CROSS JOIN master..spt_values b
)
INSERT INTO WorkOrderOperations (WorkOrderId, OperationName, DurationMinutes, EmployeeId)
SELECT
    ((n - 1) / 20) + 1,
    CONCAT('Operation_', n % 10),
    5 + (n % 55),
    (n % 1000) + 1
FROM Ops
WHERE ((n - 1) / 20) + 1 <= 10000;

-- WorkOrderMaterials: 80,000 (8 per WorkOrder)
WITH Mats AS (
    SELECT TOP 80000 CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS BIGINT) AS n
    FROM master..spt_values a CROSS JOIN master..spt_values b
)
INSERT INTO WorkOrderMaterials (WorkOrderId, MaterialId, Quantity)
SELECT
    ((n - 1) / 12) + 1,
    (n % 100) + 1,
    CAST(RAND(CHECKSUM(NEWID()) + n) * 50 + 1 AS DECIMAL(10,2))
FROM Mats
WHERE ((n - 1) / 12) + 1 <= 10000;
