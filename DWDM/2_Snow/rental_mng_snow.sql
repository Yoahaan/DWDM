create database health_snow;
use health_snow;


-- Create Dimension Table: DimPropertyType
CREATE TABLE DimPropertyType (
    PropertyTypeID INT PRIMARY KEY,
    PropertyTypeName VARCHAR(255)
);

-- Create Dimension Table: DimProperty
CREATE TABLE DimProperty (
    PropertyID INT PRIMARY KEY,
    Address VARCHAR(255),
    Size DECIMAL(10, 2),
    PropertyTypeID INT,
    FOREIGN KEY (PropertyTypeID) REFERENCES DimPropertyType(PropertyTypeID)
);

-- Create Dimension Table: DimTenantContact
CREATE TABLE DimTenantContact (
    ContactID INT PRIMARY KEY,
    TenantID INT,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    FOREIGN KEY (TenantID) REFERENCES DimTenant(TenantID)
);

-- Create Dimension Table: DimTenant
CREATE TABLE DimTenant (
    TenantID INT PRIMARY KEY,
    Name VARCHAR(255),
    Age INT,
    Gender VARCHAR(10)
);

-- Create Dimension Table: DimCity
CREATE TABLE DimCity (
    CityID INT PRIMARY KEY,
    CityName VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100)
);

-- Create Dimension Table: DimLocation
CREATE TABLE DimLocation (
    LocationID INT PRIMARY KEY,
    CityID INT,
    Address VARCHAR(255),
    FOREIGN KEY (CityID) REFERENCES DimCity(CityID)
);

-- Create Dimension Table: DimTime
CREATE TABLE DimTime (
    TimeID INT PRIMARY KEY,
    Date DATE,
    Month VARCHAR(50),
    Year INT
);


-- Create Fact Table: FactRental
CREATE TABLE FactRental (
    FactID INT PRIMARY KEY,
    PropertyID INT,
    TenantID INT,
    LocationID INT,
    TimeID INT,
    RentAmount DECIMAL(10, 2),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (PropertyID) REFERENCES DimProperty(PropertyID),
    FOREIGN KEY (TenantID) REFERENCES DimTenant(TenantID),
    FOREIGN KEY (LocationID) REFERENCES DimLocation(LocationID),
    FOREIGN KEY (TimeID) REFERENCES DimTime(TimeID)
);


INSERT INTO DimPropertyType (PropertyTypeID, PropertyTypeName) VALUES
(1, 'Apartment'),
(2, 'House'),
(3, 'Condo');


INSERT INTO DimProperty (PropertyID, Address, Size, PropertyTypeID) VALUES
(1, '123 Main St', 1200.00, 1),
(2, '456 Elm St', 1500.00, 2),
(3, '789 Oak St', 900.00, 3);


INSERT INTO DimTenant (TenantID, Name, Age, Gender) VALUES
(1, 'John Doe', 30, 'Male'),
(2, 'Jane Smith', 28, 'Female'),
(3, 'Alice Johnson', 35, 'Female');


INSERT INTO DimTenantContact (ContactID, TenantID, Phone, Email) VALUES
(1, 1, '555-1234', 'johndoe@email.com'),
(2, 2, '555-5678', 'janesmith@email.com'),
(3, 3, '555-9876', 'alicejohnson@email.com');


INSERT INTO DimCity (CityID, CityName, State, Country) VALUES
(1, 'New York', 'New York', 'USA'),
(2, 'Los Angeles', 'California', 'USA'),
(3, 'Chicago', 'Illinois', 'USA');


INSERT INTO DimLocation (LocationID, CityID, Address) VALUES
(1, 1, '123 Main St, New York'),
(2, 2, '456 Elm St, Los Angeles'),
(3, 3, '789 Oak St, Chicago');


INSERT INTO DimTime (TimeID, Date, Month, Year) VALUES
(1, '2023-01-01', 'January', 2023),
(2, '2023-02-01', 'February', 2023),
(3, '2023-03-01', 'March', 2023);


INSERT INTO FactRental (FactID, PropertyID, TenantID, LocationID, TimeID, RentAmount, StartDate, EndDate) VALUES
(1, 1, 1, 1, 1, 1500.00, '2023-01-01', '2023-12-31'),
(2, 2, 2, 2, 2, 1800.00, '2023-02-01', '2023-11-30'),
(3, 3, 3, 3, 3, 1200.00, '2023-03-01', '2023-09-30');


SELECT
    p.PropertyTypeName,
    SUM(f.RentAmount) AS TotalRentAmount
FROM
    FactRental f
JOIN
    DimProperty dp ON f.PropertyID = dp.PropertyID
JOIN
    DimPropertyType p ON dp.PropertyTypeID = p.PropertyTypeID
GROUP BY
    p.PropertyTypeName;
