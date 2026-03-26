-- Create Database
CREATE DATABASE FoodDeliveryDB;
USE FoodDeliveryDB;

--------------------------------------------------
-- TABLE CREATION
--------------------------------------------------

-- 1. Restaurants
CREATE TABLE Restaurants (
    RestaurantID INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(50),
    Rating DECIMAL(2,1)
);

-- 2. MenuItems
CREATE TABLE MenuItems (
    MenuItemID INT PRIMARY KEY,
    RestaurantID INT,
    ItemName VARCHAR(100),
    Price DECIMAL(10,2),
    Category VARCHAR(50),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- 3. Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(100)
);

-- 4. DeliveryAgents
CREATE TABLE DeliveryAgents (
    AgentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Phone VARCHAR(15),
    VehicleNo VARCHAR(20)
);

-- 5. Orders (Extended with AgentID for query needs)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    RestaurantID INT,
    AgentID INT,
    OrderDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID),
    FOREIGN KEY (AgentID) REFERENCES DeliveryAgents(AgentID)
);

-- EXTRA TABLE (Needed for item-level queries)
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT,
    MenuItemID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (MenuItemID) REFERENCES MenuItems(MenuItemID)
);

--------------------------------------------------
-- INSERT DATA
--------------------------------------------------

-- Restaurants
INSERT INTO Restaurants VALUES
(1, 'Dominos', 'Bangalore', 4.5),
(2, 'Pizza Hut', 'Mumbai', 4.2),
(3, 'Burger King', 'Bangalore', 4.0),
(4, 'KFC', 'Delhi', 3.9),
(5, 'Subway', 'Bangalore', 4.3);

-- MenuItems
INSERT INTO MenuItems VALUES
(1, 1, 'Veg Pizza', 350, 'Pizza'),
(2, 1, 'Cheese Burst Pizza', 500, 'Pizza'),
(3, 2, 'Chicken Pizza', 450, 'Pizza'),
(4, 3, 'Veg Burger', 150, 'Burger'),
(5, 4, 'Fried Chicken', 400, 'Fast Food'),
(6, 5, 'Choco Lava Cake', 200, 'Dessert');

-- Customers
INSERT INTO Customers VALUES
(1, 'Rahul', '9876543210', 'Bangalore'),
(2, 'Priya', '9123456780', 'Mumbai'),
(3, 'Amit', '9988776655', 'Delhi'),
(4, 'Neha', '9090909090', 'Bangalore'),
(5, 'Karan', '8888888888', 'Pune');

-- DeliveryAgents
INSERT INTO DeliveryAgents VALUES
(1, 'Agent A', '9000000001', 'KA01'),
(2, 'Agent B', '9000000002', 'KA02'),
(3, 'Agent C', '9000000003', 'MH01'),
(4, 'Agent D', '9000000004', 'DL01'),
(5, 'Agent E', '9000000005', 'KA03');

-- Orders
INSERT INTO Orders VALUES
(1, 1, 1, 1, CURDATE() - INTERVAL 1 DAY, 'Delivered'),
(2, 2, 2, 2, CURDATE() - INTERVAL 5 DAY, 'Cancelled'),
(3, 1, 3, 1, CURDATE() - INTERVAL 2 DAY, 'Delivered'),
(4, 3, 4, 3, CURDATE(), 'Delivered'),
(5, 4, 5, 4, CURDATE() - INTERVAL 3 DAY, 'Pending');

-- OrderItems
INSERT INTO OrderItems VALUES
(1, 1, 1, 2),
(2, 1, 2, 1),
(3, 2, 3, 1),
(4, 3, 4, 3),
(5, 4, 5, 2),
(6, 5, 6, 1);

--------------------------------------------------
-- QUERIES
--------------------------------------------------

-- 1
SELECT * FROM Restaurants WHERE City = 'Bangalore';

-- 2
SELECT * FROM MenuItems WHERE Price > 300;

-- 3
SELECT * FROM Orders
WHERE OrderDate >= CURDATE() - INTERVAL 7 DAY;

-- 4
SELECT * FROM Restaurants ORDER BY Rating DESC LIMIT 5;

-- 5
SELECT * FROM Customers WHERE Address = 'Bangalore';

-- 6
SELECT * FROM Orders WHERE Status = 'Delivered';

-- 7
SELECT RestaurantID, COUNT(*) AS TotalItems
FROM MenuItems
GROUP BY RestaurantID;

-- 8
SELECT CustomerID, COUNT(DISTINCT RestaurantID) AS RestaurantsVisited
FROM Orders
GROUP BY CustomerID
HAVING COUNT(DISTINCT RestaurantID) > 3;

-- 9
SELECT RestaurantID, MAX(Price) AS MostExpensive
FROM MenuItems
GROUP BY RestaurantID;

-- 10
SELECT AgentID, COUNT(*) AS Deliveries
FROM Orders
GROUP BY AgentID
HAVING COUNT(*) > 10;

-- 11
SELECT R.*
FROM Restaurants R
LEFT JOIN Orders O ON R.RestaurantID = O.RestaurantID
WHERE O.OrderID IS NULL;

-- 12
SELECT Category, AVG(Price) AS AvgPrice
FROM MenuItems
GROUP BY Category;

-- 13
SELECT O.OrderID, C.Name, R.Name
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN Restaurants R ON O.RestaurantID = R.RestaurantID;

-- 14
SELECT C.Name, MI.ItemName, COUNT(*) AS TimesOrdered
FROM OrderItems OI
JOIN Orders O ON OI.OrderID = O.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN MenuItems MI ON OI.MenuItemID = MI.MenuItemID
GROUP BY C.Name, MI.ItemName
HAVING COUNT(*) > 1;

-- 15
SELECT AgentID, COUNT(*) AS TotalOrders
FROM Orders
GROUP BY AgentID
ORDER BY TotalOrders DESC
LIMIT 1;

-- 16
SELECT * FROM Orders WHERE Status = 'Cancelled';

-- 17
SELECT DISTINCT R.*
FROM Restaurants R
JOIN MenuItems M ON R.RestaurantID = M.RestaurantID
WHERE M.Category = 'Pizza';

-- 18
SELECT MenuItemID, SUM(Quantity) AS TotalSold
FROM OrderItems
GROUP BY MenuItemID
ORDER BY TotalSold DESC
LIMIT 1;

-- 19
SELECT C.Name, SUM(MI.Price * OI.Quantity) AS TotalSpent
FROM OrderItems OI
JOIN Orders O ON OI.OrderID = O.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN MenuItems MI ON OI.MenuItemID = MI.MenuItemID
GROUP BY C.Name
ORDER BY TotalSpent DESC
LIMIT 3;

-- 20
SELECT * FROM Orders ORDER BY OrderDate;

-- 21
SELECT * FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);

-- 22
SELECT * FROM MenuItems WHERE Category = 'Dessert';

-- 23
SELECT * FROM Orders WHERE AgentID = 1;

-- 24
SELECT OrderDate, COUNT(*) AS TotalOrders
FROM Orders
GROUP BY OrderDate;

-- 25
SELECT RestaurantID, COUNT(DISTINCT Category) AS CategoryCount
FROM MenuItems
GROUP BY RestaurantID
HAVING COUNT(DISTINCT Category) > 1;