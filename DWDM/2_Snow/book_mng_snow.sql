CREATE DATABASE book_snow;
USE book_snow;


CREATE TABLE DimBookType (
    BookTypeID INT PRIMARY KEY,
    BookTypeName VARCHAR(100)
);

CREATE TABLE DimLocation (
    LocationID INT PRIMARY KEY,
    CityID INT,
    RegionID INT,
    FOREIGN KEY (CityID) REFERENCES DimCity(CityID),
    FOREIGN KEY (RegionID) REFERENCES DimRegion(RegionID)
);

CREATE TABLE DimAuthor (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(100),
    Age INT,
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES DimCountry(CountryID)
);

CREATE TABLE DimPublication (
    PublicationID INT PRIMARY KEY,
    PublisherID INT,
    CountryID INT,
    EstablishedYear INT,
    FOREIGN KEY (PublisherID) REFERENCES DimPublisher(PublisherID),
    FOREIGN KEY (CountryID) REFERENCES DimCountry(CountryID)
);

CREATE TABLE DimTime (
    TimeID INT PRIMARY KEY,
    Year INT,
    Quarter INT,
    Month INT,
    Day INT
);


CREATE TABLE DimCity (
    CityID INT PRIMARY KEY,
    CityName VARCHAR(100),
    StateID INT,
    FOREIGN KEY (StateID) REFERENCES DimState(StateID)
);

CREATE TABLE DimState (
    StateID INT PRIMARY KEY,
    StateName VARCHAR(100),
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES DimCountry(CountryID)
);

CREATE TABLE DimRegion (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(100)
);

CREATE TABLE DimCountry (
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(100)
);

CREATE TABLE DimPublisher (
    PublisherID INT PRIMARY KEY,
    PublisherName VARCHAR(100)
);



CREATE TABLE FactBook (
    BookID INT PRIMARY KEY,
    BookTypeID INT,
    LocationID INT,
    AuthorID INT,
    PublicationID INT,
    TimeID INT,
    Quantity INT,
    Profit DECIMAL(10, 2),
    FOREIGN KEY (BookTypeID) REFERENCES DimBookType(BookTypeID),
    FOREIGN KEY (LocationID) REFERENCES DimLocation(LocationID),
    FOREIGN KEY (AuthorID) REFERENCES DimAuthor(AuthorID),
    FOREIGN KEY (PublicationID) REFERENCES DimPublication(PublicationID),
    FOREIGN KEY (TimeID) REFERENCES DimTime(TimeID)
);



INSERT INTO DimCity VALUES (1, 'New York', 1), (2, 'London', 2), (3, 'Delhi', 3), (4, 'Tokyo', 4), (5, 'Sydney', 5);

INSERT INTO DimState VALUES (1, 'New York State', 1), (2, 'England', 2), (3, 'Delhi State', 3), (4, 'Tokyo Prefecture', 4), (5, 'NSW', 5);

INSERT INTO DimRegion VALUES (1, 'North America'), (2, 'Europe'), (3, 'Asia'), (4, 'Asia-Pacific'), (5, 'Australia');

INSERT INTO DimCountry VALUES (1, 'USA'), (2, 'UK'), (3, 'India'), (4, 'Japan'), (5, 'Australia');

INSERT INTO DimPublisher VALUES (1, 'Penguin Random House'), (2, 'HarperCollins'), (3, 'Rupa Publications'), (4, 'Kodansha'), (5, 'Pan Macmillan');



INSERT INTO DimBookType VALUES (1, 'Fiction'), (2, 'Science'), (3, 'History'), (4, 'Biography'), (5, 'Technology');

INSERT INTO DimLocation VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 5);

INSERT INTO DimAuthor VALUES 
(1, 'Author A', 45, 1), 
(2, 'Author B', 50, 2), 
(3, 'Author C', 60, 3), 
(4, 'Author D', 40, 4), 
(5, 'Author E', 55, 5);

INSERT INTO DimPublication VALUES 
(1, 1, 1, 1980), 
(2, 2, 2, 1990), 
(3, 3, 3, 2000), 
(4, 4, 4, 2010), 
(5, 5, 5, 2020);

INSERT INTO DimTime VALUES (1, 2024, 4, 11, 27), (2, 2024, 4, 12, 1), (3, 2024, 3, 10, 15), (4, 2024, 2, 8, 1), (5, 2024, 1, 1, 10);





INSERT INTO FactBook VALUES 
(1, 1, 1, 1, 1, 1, 300, 1500.00),
(2, 2, 2, 2, 2, 2, 500, 2500.00),
(3, 3, 3, 3, 3, 3, 400, 2000.00),
(4, 4, 4, 4, 4, 4, 200, 1000.00),
(5, 5, 5, 5, 5, 5, 600, 3000.00);



SELECT 
    BT.BookTypeName,
    C.CityName AS City,
    S.StateName AS State,
    R.RegionName AS Region,
    A.AuthorName,
    P.PublisherName,
    T.Year,
    SUM(F.Quantity) AS TotalQuantity,
    SUM(F.Profit) AS TotalProfit
FROM FactBook F
JOIN DimBookType BT ON F.BookTypeID = BT.BookTypeID
JOIN DimLocation L ON F.LocationID = L.LocationID
JOIN DimCity C ON L.CityID = C.CityID
JOIN DimState S ON C.StateID = S.StateID
JOIN DimRegion R ON L.RegionID = R.RegionID
JOIN DimAuthor A ON F.AuthorID = A.AuthorID
JOIN DimPublication P ON F.PublicationID = P.PublicationID
JOIN DimTime T ON F.TimeID = T.TimeID
GROUP BY BT.BookTypeName, C.CityName, S.StateName, R.RegionName, A.AuthorName, P.PublisherName, T.Year;
