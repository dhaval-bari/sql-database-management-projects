CREATE DATABASE UniversityDB;
USE UniversityDB;

CREATE TABLE DEPARTMENT (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(100),
    Location VARCHAR(100),
    ManagerEmpID INT
);

CREATE TABLE INSTRUCTOR (
    EmpID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Title VARCHAR(50),
    Salary DECIMAL(10,2),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES DEPARTMENT(DeptID)
);

CREATE TABLE COURSE (
    CourseCode VARCHAR(10) PRIMARY KEY,
    Title VARCHAR(100),
    Credits INT,
    Description TEXT,
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES DEPARTMENT(DeptID)
);

CREATE TABLE SECTION (
    CourseCode VARCHAR(10),
    SectionNo INT,
    Semester VARCHAR(20),
    Year INT,
    Time VARCHAR(20),
    Room VARCHAR(20),
    EmpID INT,
    PRIMARY KEY (CourseCode, SectionNo),
    FOREIGN KEY (CourseCode) REFERENCES COURSE(CourseCode),
    FOREIGN KEY (EmpID) REFERENCES INSTRUCTOR(EmpID)
);

CREATE TABLE STUDENT (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    Gender VARCHAR(10),
    GPA DECIMAL(3,2)
);

CREATE TABLE STUDENT_EMAIL (
    StudentID INT,
    Email VARCHAR(100),
    PRIMARY KEY (StudentID, Email),
    FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID)
);

CREATE TABLE INSTRUCTOR_PHONE (
    EmpID INT,
    PhoneNo VARCHAR(15),
    PRIMARY KEY (EmpID, PhoneNo),
    FOREIGN KEY (EmpID) REFERENCES INSTRUCTOR(EmpID)
);

CREATE TABLE ENROLLMENT (
    StudentID INT,
    CourseCode VARCHAR(10),
    SectionNo INT,
    Grade VARCHAR(5),
    PRIMARY KEY (StudentID, CourseCode, SectionNo),
    FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID),
    FOREIGN KEY (CourseCode, SectionNo) REFERENCES SECTION(CourseCode, SectionNo)
);

SHOW TABLES;