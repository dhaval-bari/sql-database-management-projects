-- Create Database
CREATE DATABASE OnlineBookStore2;
USE OnlineBookstore2;

-- 1. Authors Table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    Name VARCHAR(100),
    Country VARCHAR(50),
    DOB DATE
);

-- 2. Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100)
);

-- 3. Books Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(150),
    AuthorID INT,
    CategoryID INT,
    Price DECIMAL(10,2),
    Stock INT,
    PublishedYear INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- 4. Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(150)
);

-- 5. Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Extra Table (for sales calculation)
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    BookID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

--------------------------------------------------
-- INSERT DATA
--------------------------------------------------

-- Authors
INSERT INTO Authors VALUES
(1, 'Chetan Bhagat', 'India', '1974-04-22'),
(2, 'J.K. Rowling', 'UK', '1965-07-31'),
(3, 'Dan Brown', 'USA', '1964-06-22'),
(4, 'Arundhati Roy', 'India', '1961-11-24'),
(5, 'Paulo Coelho', 'Brazil', '1947-08-24');

-- Categories
INSERT INTO Categories VALUES
(1, 'Fiction'),
(2, 'Mystery'),
(3, 'Fantasy'),
(4, 'Romance'),
(5, 'Self-help');

-- Books
INSERT INTO Books VALUES
(1, 'Half Girlfriend', 1, 4, 350, 20, 2014),
(2, 'Harry Potter Guide', 2, 3, 800, 5, 2016),
(3, 'Da Vinci Code', 3, 2, 550, 8, 2003),
(4, 'The Alchemist', 5, 5, 450, 12, 1988),
(5, 'God of Small Things', 4, 1, 650, 3, 1997),
(6, 'Advanced SQL Guide', 3, 5, 900, 6, 2020);

-- Customers
INSERT INTO Customers VALUES
(1, 'Rahul Sharma', 'rahul@gmail.com', '9876543210', 'Mumbai'),
(2, 'Priya Mehta', 'priya@gmail.com', '9123456780', 'Delhi'),
(3, 'Amit Verma', 'amit@gmail.com', '9988776655', 'Mumbai'),
(4, 'Neha Singh', 'neha@gmail.com', '9090909090', 'Pune'),
(5, 'Karan Patel', 'karan@gmail.com', '8888888888', 'Ahmedabad');

-- Orders
INSERT INTO Orders VALUES
(1, 1, CURDATE() - INTERVAL 10 DAY, 'Completed'),
(2, 2, CURDATE() - INTERVAL 5 DAY, 'Pending'),
(3, 1, CURDATE() - INTERVAL 40 DAY, 'Completed'),
(4, 3, CURDATE() - INTERVAL 2 DAY, 'Pending'),
(5, 4, CURDATE() - INTERVAL 1 DAY, 'Completed');

-- OrderDetails
INSERT INTO OrderDetails VALUES
(1, 1, 2, 1),
(2, 1, 3, 2),
(3, 2, 1, 1),
(4, 3, 4, 3),
(5, 4, 5, 1),
(6, 5, 6, 2);

--------------------------------------------------
-- QUERIES
--------------------------------------------------

-- 1
SELECT * FROM Books WHERE Price > 500;

-- 2
SELECT * FROM Books WHERE PublishedYear > 2015;

-- 3
SELECT * FROM Customers WHERE Address = 'Mumbai';

-- 4
SELECT B.* FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID
WHERE A.Name = 'Dan Brown';

-- 5
SELECT * FROM Books ORDER BY Price DESC LIMIT 3;

-- 6
SELECT C.CategoryName, COUNT(B.BookID) AS TotalBooks
FROM Categories C
LEFT JOIN Books B ON C.CategoryID = B.CategoryID
GROUP BY C.CategoryName;

-- 7
SELECT * FROM Orders
WHERE OrderDate >= CURDATE() - INTERVAL 30 DAY;

-- 8
SELECT C.Name, COUNT(O.OrderID) AS TotalOrders
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.Name;

-- 9
SELECT * FROM Books WHERE Stock < 10;

-- 10
SELECT AuthorID, COUNT(BookID) AS TotalBooks
FROM Books
GROUP BY AuthorID
HAVING COUNT(BookID) > 5;

-- 11
SELECT B.Title, C.CategoryName
FROM Books B
JOIN Categories C ON B.CategoryID = C.CategoryID;

-- 12
SELECT O.OrderID, SUM(B.Price * OD.Quantity) AS TotalSales
FROM Orders O
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Books B ON OD.BookID = B.BookID
GROUP BY O.OrderID;

-- 13
SELECT * FROM Orders WHERE Status = 'Pending';

-- 14
SELECT * FROM Authors WHERE Country = 'India';

-- 15
SELECT * FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);

-- 16
SELECT CategoryID, AVG(Price) AS AvgPrice
FROM Books
GROUP BY CategoryID;

-- 17
SELECT * FROM Books ORDER BY PublishedYear DESC;

-- 18
SELECT CustomerID, MAX(OrderDate) AS RecentOrder
FROM Orders
GROUP BY CustomerID;

-- 19
SELECT C.CategoryName
FROM Categories C
LEFT JOIN Books B ON C.CategoryID = B.CategoryID
WHERE B.BookID IS NULL;

-- 20
SELECT DISTINCT Address FROM Customers;

-- 21
SELECT COUNT(*) AS TotalCustomers FROM Customers;

-- 22
SELECT O.OrderID, C.Name, O.OrderDate
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID;

-- 23
SELECT CategoryID, MIN(Price) AS CheapestBook
FROM Books
GROUP BY CategoryID;

-- 24
SELECT DISTINCT C.Name
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Books B ON OD.BookID = B.BookID
JOIN Authors A ON B.AuthorID = A.AuthorID
WHERE A.Name = 'Dan Brown';

-- 25
SELECT * FROM Books WHERE Title LIKE '%Guide%';