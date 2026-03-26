-- Create Database
CREATE DATABASE InventoryDB;
USE InventoryDB;

--------------------------------------------------
-- TABLE CREATION
--------------------------------------------------

-- 1. Categories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100)
);

-- 2. Suppliers
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    Contact VARCHAR(15),
    City VARCHAR(50)
);

-- 3. Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    CategoryID INT,
    SupplierID INT,
    Price DECIMAL(10,2),
    Stock INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- 4. Purchases
CREATE TABLE Purchases (
    PurchaseID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    PurchaseDate DATE,
    SupplierID INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- 5. Sales
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    CustomerName VARCHAR(100),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

--------------------------------------------------
-- INSERT DATA
--------------------------------------------------

-- Categories
INSERT INTO Categories VALUES
(1, 'Electronics'),
(2, 'Furniture'),
(3, 'Clothing'),
(4, 'Groceries'),
(5, 'Stationery');

-- Suppliers
INSERT INTO Suppliers VALUES
(1, 'ABC Traders', '9876543210', 'Delhi'),
(2, 'XYZ Supplies', '9123456780', 'Mumbai'),
(3, 'Global Mart', '9988776655', 'Delhi'),
(4, 'Prime Distributors', '9090909090', 'Pune'),
(5, 'Retail Hub', '8888888888', 'Ahmedabad');

-- Products
INSERT INTO Products VALUES
(1, 'Laptop', 1, 1, 70000, 5),
(2, 'Chair', 2, 2, 3000, 20),
(3, 'T-Shirt', 3, 3, 800, 50),
(4, 'Rice Bag', 4, 4, 2000, 8),
(5, 'Notebook', 5, 5, 100, 100),
(6, 'Smartphone', 1, 1, 50000, 3);

-- Purchases
INSERT INTO Purchases VALUES
(1, 1, 10, CURDATE() - INTERVAL 10 DAY, 1),
(2, 2, 15, CURDATE() - INTERVAL 20 DAY, 2),
(3, 3, 30, CURDATE() - INTERVAL 5 DAY, 3),
(4, 4, 25, CURDATE() - INTERVAL 15 DAY, 4),
(5, 5, 50, CURDATE() - INTERVAL 2 DAY, 5);

-- Sales
INSERT INTO Sales VALUES
(1, 1, 2, CURDATE() - INTERVAL 1 DAY, 'Rahul'),
(2, 2, 5, CURDATE() - INTERVAL 3 DAY, 'Priya'),
(3, 3, 20, CURDATE() - INTERVAL 2 DAY, 'Amit'),
(4, 1, 1, CURDATE() - INTERVAL 6 DAY, 'Neha'),
(5, 4, 3, CURDATE() - INTERVAL 1 DAY, 'Karan');

--------------------------------------------------
-- QUERIES
--------------------------------------------------

-- 1
SELECT * FROM Products WHERE Stock < 10;

-- 2
SELECT * FROM Products ORDER BY Price DESC LIMIT 5;

-- 3
SELECT * FROM Suppliers WHERE City = 'Delhi';

-- 4
SELECT * FROM Products WHERE SupplierID = 1;

-- 5
SELECT CategoryID, COUNT(*) AS TotalProducts
FROM Products
GROUP BY CategoryID;

-- 6
SELECT ProductID, SUM(Quantity) AS TotalPurchased
FROM Purchases
WHERE ProductID = 1
GROUP BY ProductID;

-- 7
SELECT P.*
FROM Products P
LEFT JOIN Sales S ON P.ProductID = S.ProductID
WHERE S.SaleID IS NULL;

-- 8
SELECT * FROM Sales
WHERE SaleDate >= CURDATE() - INTERVAL 7 DAY;

-- 9
SELECT ProductID, SUM(Quantity) AS TotalSold
FROM Sales
GROUP BY ProductID
HAVING SUM(Quantity) > 50;

-- 10
SELECT SupplierID, COUNT(ProductID) AS TotalProducts
FROM Products
GROUP BY SupplierID
HAVING COUNT(ProductID) > 5;

-- 11
SELECT CategoryID, AVG(Price) AS AvgPrice
FROM Products
GROUP BY CategoryID;

-- 12
SELECT ProductID, SUM(Quantity) AS TotalSold
FROM Sales
GROUP BY ProductID
ORDER BY TotalSold DESC
LIMIT 1;

-- 13
SELECT C.*
FROM Categories C
LEFT JOIN Products P ON C.CategoryID = P.CategoryID
WHERE P.ProductID IS NULL;

-- 14
SELECT S.SaleID, P.ProductName, S.CustomerName
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID;

-- 15
SELECT PU.PurchaseID, S.SupplierName
FROM Purchases PU
JOIN Suppliers S ON PU.SupplierID = S.SupplierID;

-- 16
SELECT S.*
FROM Suppliers S
LEFT JOIN Purchases P ON S.SupplierID = P.SupplierID
WHERE P.PurchaseID IS NULL;

-- 17
SELECT ProductID, MAX(PurchaseDate) AS RecentPurchase
FROM Purchases
GROUP BY ProductID;

-- 18
SELECT CustomerName, COUNT(*) AS Purchases
FROM Sales
GROUP BY CustomerName
HAVING COUNT(*) > 3;

-- 19
SELECT SUM(Price * Stock) AS TotalStockValue FROM Products;

-- 20
SELECT * FROM Products
ORDER BY Stock DESC LIMIT 1;

-- 21
SELECT CustomerName, SUM(Quantity) AS TotalBought
FROM Sales
GROUP BY CustomerName;

-- 22
SELECT CustomerName, SUM(Quantity * P.Price) AS TotalValue
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY CustomerName
ORDER BY TotalValue DESC
LIMIT 3;

-- 23
SELECT MONTH(SaleDate) AS Month, SUM(Quantity) AS TotalSales
FROM Sales
GROUP BY MONTH(SaleDate);

-- 24
SELECT P.*
FROM Products P
JOIN Purchases PU ON P.ProductID = PU.ProductID
LEFT JOIN Sales S ON P.ProductID = S.ProductID
WHERE S.SaleID IS NULL;

-- 25
SELECT SupplierID, COUNT(DISTINCT CategoryID) AS CategoryCount
FROM Products
GROUP BY SupplierID
HAVING COUNT(DISTINCT CategoryID) > 1;