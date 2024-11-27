CREATE DATABASE BookManagementDW;
USE BookManagementDW;
-- Dimension Tables
CREATE TABLE BookType_Dim (
    BookTypeID INT PRIMARY KEY,
    BookTypeName VARCHAR(255)
);
CREATE TABLE Location_Dim (
    LocationID INT PRIMARY KEY,
    LocationName VARCHAR(255)
);
CREATE TABLE Author_Dim (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(255),
    Age INT,
    Country VARCHAR(255)
);
CREATE TABLE Publication_Dim (
    PublicationID INT PRIMARY KEY,
    PublicationName VARCHAR(255),
    Country VARCHAR(255),
    YearEstablished INT
);
-- Fact Table
CREATE TABLE BookSales_Fact (
    BookID INT PRIMARY KEY,
    BookTypeID INT,
    LocationID INT,
    AuthorID INT,
    PublicationID INT,
    Cost DECIMAL(10,2),
    Quantity INT,
    Profit DECIMAL(10,2),
    FOREIGN KEY (BookTypeID) REFERENCES BookType_Dim(BookTypeID),
    FOREIGN KEY (LocationID) REFERENCES Location_Dim(LocationID),
    FOREIGN KEY (AuthorID) REFERENCES Author_Dim(AuthorID),
    FOREIGN KEY (PublicationID) REFERENCES Publication_Dim(PublicationID)
);
-- Sample data for dimension tables
INSERT INTO BookType_Dim VALUES (1, 'Fiction');
INSERT INTO BookType_Dim VALUES (2, 'Non-Fiction');
INSERT INTO BookType_Dim VALUES (3, 'Science Fiction');
INSERT INTO Location_Dim VALUES (1, 'New York');
INSERT INTO Location_Dim VALUES (2, 'London');
INSERT INTO Location_Dim VALUES (3, 'Paris');
INSERT INTO Author_Dim VALUES (1, 'George Orwell', 46, 'UK');
INSERT INTO Author_Dim VALUES (2, 'Isaac Asimov', 72, 'USA');
INSERT INTO Author_Dim VALUES (3, 'J.K. Rowling', 55, 'UK');
INSERT INTO Publication_Dim VALUES (1, 'Penguin Books', 'UK', 1935);
INSERT INTO Publication_Dim VALUES (2, 'HarperCollins', 'USA', 1989);
INSERT INTO Publication_Dim VALUES (3, 'Hachette Livre', 'France', 1826);
-- Sample data for fact table
INSERT INTO BookSales_Fact VALUES (1, 1, 1, 1, 1, 20.00, 100, 2000.00);
INSERT INTO BookSales_Fact VALUES (2, 2, 2, 2, 2, 25.00, 150, 3750.00);
INSERT INTO BookSales_Fact VALUES (3, 3, 3, 3, 3, 30.00, 200, 6000.00);
INSERT INTO BookSales_Fact VALUES (4, 1, 2, 1, 2, 18.00, 120, 2160.00);
INSERT INTO BookSales_Fact VALUES (5, 2, 3, 2, 3, 22.00, 140, 3080.00);
INSERT INTO BookSales_Fact VALUES (6, 3, 1, 3, 1, 28.00, 160, 4480.00);
INSERT INTO BookSales_Fact VALUES (7, 1, 3, 1, 3, 21.00, 110, 2310.00);
INSERT INTO BookSales_Fact VALUES (8, 2, 1, 2, 1, 26.00, 130, 3380.00);
INSERT INTO BookSales_Fact VALUES (9, 3, 2, 3, 2, 31.00, 180, 5580.00);
INSERT INTO BookSales_Fact VALUES (10, 1, 1, 1, 3, 19.00, 105, 1995.00);









SELECT 
    BT.BookTypeName, 
    L.LocationName, 
    A.AuthorName, 
    P.PublicationName, 
    SUM(BS.Quantity) AS TotalQuantity, 
    SUM(BS.Profit) AS TotalProfit
FROM 
    BookSales_Fact BS
    JOIN BookType_Dim BT ON BS.BookTypeID = BT.BookTypeID
    JOIN Location_Dim L ON BS.LocationID = L.LocationID
    JOIN Author_Dim A ON BS.AuthorID = A.AuthorID
    JOIN Publication_Dim P ON BS.PublicationID = P.PublicationID
GROUP BY 
    BT.BookTypeName, 
    L.LocationName, 
    A.AuthorName, 
    P.PublicationName;

