-- Create Database
CREATE DATABASE CinemaDB;
USE CinemaDB;

--------------------------------------------------
-- TABLE CREATION
--------------------------------------------------

-- 1. Movies
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    Title VARCHAR(100),
    Genre VARCHAR(50),
    Language VARCHAR(50),
    Duration INT, -- in minutes
    ReleaseDate DATE
);

-- 2. Screens
CREATE TABLE Screens (
    ScreenID INT PRIMARY KEY,
    ScreenName VARCHAR(50),
    Capacity INT
);

-- 3. Showtimes
CREATE TABLE Showtimes (
    ShowID INT PRIMARY KEY,
    MovieID INT,
    ScreenID INT,
    ShowDate DATE,
    ShowTime TIME,
    Price DECIMAL(10,2),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (ScreenID) REFERENCES Screens(ScreenID)
);

-- 4. Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

-- 5. Tickets
CREATE TABLE Tickets (
    TicketID INT PRIMARY KEY,
    ShowID INT,
    CustomerID INT,
    SeatNo VARCHAR(10),
    BookingDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (ShowID) REFERENCES Showtimes(ShowID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

--------------------------------------------------
-- INSERT DATA
--------------------------------------------------

-- Movies
INSERT INTO Movies VALUES
(1, 'War', 'Action', 'Hindi', 150, '2019-10-02'),
(2, 'Pathaan', 'Action', 'Hindi', 145, '2023-01-25'),
(3, 'Avengers', 'Action', 'English', 180, '2018-04-27'),
(4, '3 Idiots', 'Drama', 'Hindi', 170, '2009-12-25'),
(5, 'Inception', 'Sci-Fi', 'English', 160, '2010-07-16');

-- Screens
INSERT INTO Screens VALUES
(1, 'Screen 1', 100),
(2, 'Screen 2', 80),
(3, 'Screen 3', 120),
(4, 'Screen 4', 60),
(5, 'Screen 5', 90);

-- Showtimes
INSERT INTO Showtimes VALUES
(1, 1, 1, CURDATE(), '18:00:00', 300),
(2, 2, 2, CURDATE(), '20:00:00', 400),
(3, 3, 3, CURDATE() + INTERVAL 1 DAY, '15:00:00', 500),
(4, 4, 4, CURDATE() + INTERVAL 2 DAY, '12:00:00', 250),
(5, 5, 5, CURDATE() - INTERVAL 1 DAY, '21:00:00', 450);

-- Customers
INSERT INTO Customers VALUES
(1, 'Rahul', 'rahul@gmail.com', '9876543210'),
(2, 'Priya', 'priya@gmail.com', '9123456780'),
(3, 'Amit', 'amit@gmail.com', '9988776655'),
(4, 'Neha', 'neha@gmail.com', '9090909090'),
(5, 'Karan', 'karan@gmail.com', '8888888888');

-- Tickets
INSERT INTO Tickets VALUES
(1, 1, 1, 'A1', CURDATE(), 'Booked'),
(2, 1, 2, 'A2', CURDATE(), 'Booked'),
(3, 2, 3, 'B1', CURDATE(), 'Cancelled'),
(4, 3, 1, 'C1', CURDATE(), 'Booked'),
(5, 4, 4, 'D1', CURDATE(), 'Booked'),
(6, 1, 1, 'A3', CURDATE(), 'Booked');

--------------------------------------------------
-- QUERIES
--------------------------------------------------

-- 1
SELECT * FROM Movies WHERE Genre = 'Action';

-- 2
SELECT * FROM Movies WHERE ReleaseDate > '2020-01-01';

-- 3
SELECT * FROM Showtimes WHERE ShowDate = CURDATE();

-- 4
SELECT * FROM Showtimes ORDER BY Price DESC LIMIT 3;

-- 5
SELECT ShowID, COUNT(*) AS TicketsSold
FROM Tickets
GROUP BY ShowID;

-- 6
SELECT CustomerID, COUNT(*) AS TicketsBooked
FROM Tickets
GROUP BY CustomerID
HAVING COUNT(*) > 5;

-- 7
SELECT S.ShowID, (SC.Capacity - COUNT(T.TicketID)) AS AvailableSeats
FROM Showtimes S
JOIN Screens SC ON S.ScreenID = SC.ScreenID
LEFT JOIN Tickets T ON S.ShowID = T.ShowID
GROUP BY S.ShowID, SC.Capacity;

-- 8
SELECT DISTINCT C.*
FROM Customers C
JOIN Tickets T ON C.CustomerID = T.CustomerID
JOIN Showtimes S ON T.ShowID = S.ShowID
WHERE S.MovieID = 1;

-- 9
SELECT M.*
FROM Movies M
LEFT JOIN Showtimes S ON M.MovieID = S.MovieID
WHERE S.ShowID IS NULL;

-- 10
SELECT T.TicketID, C.Name, M.Title
FROM Tickets T
JOIN Customers C ON T.CustomerID = C.CustomerID
JOIN Showtimes S ON T.ShowID = S.ShowID
JOIN Movies M ON S.MovieID = M.MovieID;

-- 11
SELECT * FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Tickets);

-- 12
SELECT BookingDate, COUNT(*) AS TotalTickets
FROM Tickets
GROUP BY BookingDate;

-- 13
SELECT * FROM Movies WHERE Duration > 120;

-- 14
SELECT M.Title, COUNT(T.TicketID) AS Popularity
FROM Movies M
JOIN Showtimes S ON M.MovieID = S.MovieID
JOIN Tickets T ON S.ShowID = T.ShowID
GROUP BY M.Title
ORDER BY Popularity DESC
LIMIT 1;

-- 15
SELECT CustomerID, COUNT(*) AS TotalTickets
FROM Tickets
GROUP BY CustomerID
ORDER BY TotalTickets DESC
LIMIT 5;

-- 16
SELECT * FROM Tickets WHERE Status = 'Cancelled';

-- 17
SELECT * FROM Showtimes WHERE ScreenID = 1;

-- 18
SELECT M.Genre, AVG(S.Price) AS AvgPrice
FROM Movies M
JOIN Showtimes S ON M.MovieID = S.MovieID
GROUP BY M.Genre;

-- 19
SELECT * FROM Movies WHERE Language = 'Hindi';

-- 20
SELECT * FROM Showtimes
WHERE ShowDate BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY;

-- 21
SELECT CustomerID, COUNT(DISTINCT S.MovieID) AS MoviesWatched
FROM Tickets T
JOIN Showtimes S ON T.ShowID = S.ShowID
GROUP BY CustomerID
HAVING COUNT(DISTINCT S.MovieID) > 1;

-- 22
SELECT MovieID, MIN(ShowTime) AS EarliestShow
FROM Showtimes
GROUP BY MovieID;

-- 23
SELECT MovieID, COUNT(DISTINCT ScreenID) AS ScreensUsed
FROM Showtimes
GROUP BY MovieID
HAVING COUNT(DISTINCT ScreenID) > 1;

-- 24
SELECT MONTH(BookingDate) AS Month, COUNT(*) AS Tickets
FROM Tickets
GROUP BY MONTH(BookingDate);

-- 25
SELECT MovieID, COUNT(*) AS ShowCount
FROM Showtimes
GROUP BY MovieID
HAVING COUNT(*) > 10;