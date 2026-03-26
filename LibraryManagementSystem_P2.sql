-- Create Database
CREATE DATABASE LibraryDB;
USE LibraryDB;

--------------------------------------------------
-- TABLE CREATION
--------------------------------------------------

-- 1. Authors
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    Name VARCHAR(100),
    Nationality VARCHAR(50)
);

-- 2. Books
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(150),
    AuthorID INT,
    Category VARCHAR(100),
    Price DECIMAL(10,2),
    Stock INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- 3. Members
CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(100)
);

-- 4. Loans
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    IssueDate DATE,
    ReturnDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- 5. Fines
CREATE TABLE Fines (
    FineID INT PRIMARY KEY,
    LoanID INT,
    Amount DECIMAL(10,2),
    PaymentStatus VARCHAR(50),
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

--------------------------------------------------
-- INSERT DATA
--------------------------------------------------

-- Authors
INSERT INTO Authors