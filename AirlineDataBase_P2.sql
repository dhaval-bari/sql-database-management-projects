-- Create Database
CREATE DATABASE AirlineDB;
USE AirlineDB;

--------------------------------------------------
-- TABLE CREATION
--------------------------------------------------

-- 1. Airlines
CREATE TABLE Airlines (
    AirlineID INT PRIMARY KEY,
    AirlineName VARCHAR(100),
    Country VARCHAR(50)
);

-- 2. Flights
CREATE TABLE Flights (
    FlightID INT PRIMARY KEY,
    AirlineID INT,
    Source VARCHAR(50),
    Destination VARCHAR(50),
    DepartureTime DATETIME,
    ArrivalTime DATETIME,
    Price DECIMAL(10,2),
    FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID)
);

-- 3. Passengers
CREATE TABLE Passengers (
    PassengerID INT PRIMARY KEY,
    Name VARCHAR(100),
    PassportNo VARCHAR(20),
    Nationality VARCHAR(50),
    DOB DATE
);

-- 4. Bookings
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    FlightID INT,
    PassengerID INT,
    BookingDate DATE,
    SeatNo VARCHAR(10),
    Status VARCHAR(50),
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID),
    FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID)
);

-- 5. Payments
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    BookingID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    Method VARCHAR(50),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

--------------------------------------------------
-- INSERT DATA
--------------------------------------------------

-- Airlines
INSERT INTO Airlines VALUES
(1, 'Air India', 'India'),
(2, 'IndiGo', 'India'),
(3, 'Emirates', 'UAE'),
(4, 'Delta Airlines', 'USA'),
(5, 'Qatar Airways', 'Qatar');

-- Flights
INSERT INTO Flights VALUES
(1, 1, 'Delhi', 'Mumbai', '2026-03-18 19:30:00', '2026-03-18 21:30:00', 7000),
(2, 2, 'Delhi', 'Bangalore', '2026-03-18 15:00:00', '2026-03-18 18:00:00', 6000),
(3, 3, 'Mumbai', 'Dubai', '2026-03-18 08:00:00', '2026-03-18 10:00:00', 12000),
(4, 4, 'New York', 'Chicago', '2026-03-18 06:00:00', '2026-03-18 08:00:00', 9000),
(5, 5, 'Doha', 'Delhi', '2026-03-18 09:00:00', '2026-03-18 12:00:00', 11000);

-- Passengers
INSERT INTO Passengers VALUES
(1, 'Amit Sharma', 'M12345', 'India', '1995-05-10'),
(2, 'Sara Khan', 'N56789', 'India', '2001-08-15'),
(3, 'John Doe', 'M98765', 'USA', '1985-02-20'),
(4, 'Ali Hassan', 'Q11111', 'Qatar', '1990-11-25'),
(5, 'Priya Mehta', 'M22222', 'India', '2003-01-01');

-- Bookings
INSERT INTO Bookings VALUES
(1, 1, 1, CURDATE() - INTERVAL 2 DAY, 'A1', 'Confirmed'),
(2, 2, 2, CURDATE() - INTERVAL 10 DAY, 'B2', 'Pending'),
(3, 1, 3, CURDATE() - INTERVAL 1 DAY, 'A2', 'Confirmed'),
(4, 3, 1, CURDATE() - INTERVAL 5 DAY, 'C3', 'Cancelled'),
(5, 4, 4, CURDATE(), 'D4', 'Confirmed'),
(6, 1, 1, CURDATE(), 'A3', 'Confirmed');

-- Payments
INSERT INTO Payments VALUES
(1, 1, 7000, CURDATE() - INTERVAL 2 DAY, 'Card'),
(2, 2, 6000, CURDATE() - INTERVAL 10 DAY, 'UPI'),
(3, 3, 7000, CURDATE() - INTERVAL 1 DAY, 'Card'),
(4, 4, 12000, CURDATE() - INTERVAL 5 DAY, 'NetBanking'),
(5, 5, 9000, CURDATE(), 'UPI');

--------------------------------------------------
-- QUERIES
--------------------------------------------------

-- 1
SELECT * FROM Flights
WHERE Source = 'Delhi' AND Destination = 'Mumbai';

-- 2
SELECT * FROM Flights
WHERE TIME(DepartureTime) > '18:00:00';

-- 3
SELECT * FROM Passengers
WHERE Nationality = 'India';

-- 4
SELECT * FROM Bookings
WHERE Status = 'Confirmed';

-- 5
SELECT B.* FROM Bookings B
JOIN Passengers P ON B.PassengerID = P.PassengerID
WHERE P.Name = 'Amit Sharma';

-- 6
SELECT AirlineID, COUNT(*) AS TotalFlights
FROM Flights
GROUP BY AirlineID;

-- 7
SELECT PassengerID, COUNT(*) AS TotalBookings
FROM Bookings
GROUP BY PassengerID
HAVING COUNT(*) > 3;

-- 8
SELECT * FROM Flights
ORDER BY Price DESC LIMIT 1;

-- 9
SELECT * FROM Airlines
WHERE Country = 'USA';

-- 10
SELECT * FROM Bookings
WHERE BookingDate >= CURDATE() - INTERVAL 7 DAY;

-- 11
SELECT AirlineID, AVG(Price) AS AvgPrice
FROM Flights
GROUP BY AirlineID;

-- 12
SELECT * FROM Passengers
WHERE PassengerID NOT IN (SELECT PassengerID FROM Bookings);

-- 13
SELECT F.* FROM Flights F
LEFT JOIN Bookings B ON F.FlightID = B.FlightID
WHERE B.BookingID IS NULL;

-- 14
SELECT * FROM Passengers
WHERE PassportNo LIKE 'M%';

-- 15
SELECT B.BookingID, P.Name, F.Source, F.Destination
FROM Bookings B
JOIN Passengers P ON B.PassengerID = P.PassengerID
JOIN Flights F ON B.FlightID = F.FlightID;

-- 16
SELECT * FROM Payments
ORDER BY Amount DESC
LIMIT 5;

-- 17
SELECT FlightID, COUNT(PassengerID) AS TotalPassengers
FROM Bookings
GROUP BY FlightID;

-- 18
SELECT * FROM Flights
WHERE TIME(ArrivalTime) < '10:00:00';

-- 19
SELECT F.*, A.AirlineName
FROM Flights F
JOIN Airlines A ON F.AirlineID = A.AirlineID;

-- 20
SELECT PassengerID, BookingDate, COUNT(*) AS CountBookings
FROM Bookings
GROUP BY PassengerID, BookingDate
HAVING COUNT(*) > 1;

-- 21
SELECT Method, SUM(Amount) AS TotalAmount
FROM Payments
GROUP BY Method;

-- 22
SELECT DISTINCT P.*
FROM Passengers P
JOIN Bookings B ON P.PassengerID = B.PassengerID
WHERE B.BookingDate >= CURDATE() - INTERVAL 1 MONTH;

-- 23
SELECT * FROM Flights
WHERE Price BETWEEN 5000 AND 10000;

-- 24
SELECT * FROM Passengers
WHERE DOB > '2000-01-01';

-- 25
SELECT A.*
FROM Airlines A
LEFT JOIN Flights F ON A.AirlineID = F.AirlineID
WHERE F.FlightID IS NULL;