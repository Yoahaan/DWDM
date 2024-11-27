-- Create Database
CREATE DATABASE RentalManagement;

-- Use the newly created database
USE RentalManagement;

-- Create Dim_Property Table
CREATE TABLE Dim_Property (
    PropertyID INT PRIMARY KEY,
    Type VARCHAR(50),
    Location VARCHAR(100),
    Size INT,
    Amenities TEXT
);

-- Create Dim_Tenant Table
CREATE TABLE Dim_Tenant (
    TenantID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    Occupation VARCHAR(50)
);

-- Create Dim_Lease Table
CREATE TABLE Dim_Lease (
    LeaseID INT PRIMARY KEY,
    LeaseTerm VARCHAR(50),
    StartDate DATE,
    EndDate DATE
);

-- Create Dim_Time Table
CREATE TABLE Dim_Time (
    TimeID INT PRIMARY KEY,
    Year INT,
    Quarter INT,
    Month INT,
    Day INT
);

-- Create Dim_Agent Table
CREATE TABLE Dim_Agent (
    AgentID INT PRIMARY KEY,
    AgentName VARCHAR(100),
    ContactNumber VARCHAR(20),
    Email VARCHAR(100)
);

-- Create Fact_RentalTransactions Table
CREATE TABLE Fact_RentalTransactions (
    RentalTransactionID INT PRIMARY KEY,
    PropertyID INT,
    TenantID INT,
    LeaseID INT,
    Amount DECIMAL(10, 2),
    PaymentDate DATE,
    PaymentMethod VARCHAR(50),
    TimeID INT,
    AgentID INT,
    FOREIGN KEY (PropertyID) REFERENCES Dim_Property(PropertyID),
    FOREIGN KEY (TenantID) REFERENCES Dim_Tenant(TenantID),
    FOREIGN KEY (LeaseID) REFERENCES Dim_Lease(LeaseID),
    FOREIGN KEY (TimeID) REFERENCES Dim_Time(TimeID),
    FOREIGN KEY (AgentID) REFERENCES Dim_Agent(AgentID)
);

-- Insert Data into Dim_Property
INSERT INTO Dim_Property (PropertyID, Type, Location, Size, Amenities) VALUES
(1, 'Apartment', 'Mumbai', 850, 'Gym, Swimming Pool, Parking'),
(2, 'Villa', 'Bangalore', 2500, 'Garden, Home Theater, Pool'),
(3, 'Studio', 'Delhi', 450, 'WiFi, Gym, Rooftop'),
(4, 'Flat', 'Chennai', 1200, 'Balcony, Parking, Security'),
(5, 'Row House', 'Pune', 1800, 'Garden, Parking, Clubhouse');

-- Insert Data into Dim_Tenant
INSERT INTO Dim_Tenant (TenantID, Name, Age, Gender, Occupation) VALUES
(1, 'Aditi Sharma', 28, 'Female', 'Software Developer'),
(2, 'Rahul Verma', 35, 'Male', 'Bank Manager'),
(3, 'Sneha Rao', 30, 'Female', 'Teacher'),
(4, 'Vikram Singh', 40, 'Male', 'Consultant'),
(5, 'Priya Patel', 27, 'Female', 'Graphic Designer');

-- Insert Data into Dim_Lease
INSERT INTO Dim_Lease (LeaseID, LeaseTerm, StartDate, EndDate) VALUES
(1, '12 Months', '2024-01-01', '2024-12-31'),
(2, '6 Months', '2024-02-01', '2024-07-31'),
(3, '24 Months', '2024-03-01', '2026-02-28'),
(4, '12 Months', '2024-04-01', '2025-03-31'),
(5, '18 Months', '2024-05-01', '2025-10-31');

-- Insert Data into Dim_Time
INSERT INTO Dim_Time (TimeID, Year, Quarter, Month, Day) VALUES
(1, 2024, 1, 1, 1),
(2, 2024, 1, 1, 15),
(3, 2024, 1, 2, 1),
(4, 2024, 2, 4, 15),
(5, 2024, 3, 6, 1);

-- Insert Data into Dim_Agent
INSERT INTO Dim_Agent (AgentID, AgentName, ContactNumber, Email) VALUES
(1, 'Ravi Mehta', '98765-43210', 'ravi.mehta@agency.com'),
(2, 'Anita Desai', '98765-54321', 'anita.desai@agency.com'),
(3, 'Karan Joshi', '98765-65432', 'karan.joshi@agency.com'),
(4, 'Neha Gupta', '98765-76543', 'neha.gupta@agency.com'),
(5, 'Vikram Khanna', '98765-87654', 'vikram.khanna@agency.com');

-- Insert Data into Fact_RentalTransactions
INSERT INTO Fact_RentalTransactions (RentalTransactionID, PropertyID, TenantID, LeaseID, Amount, PaymentDate, PaymentMethod, TimeID, AgentID) VALUES
(1, 1, 1, 1, 30000.00, '2024-01-01', 'Credit Card', 1, 1),
(2, 2, 2, 2, 50000.00, '2024-02-01', 'Bank Transfer', 2, 2),
(3, 3, 3, 3, 25000.00, '2024-03-01', 'Debit Card', 3, 3),
(4, 4, 4, 4, 40000.00, '2024-04-01', 'Cash', 4, 4),
(5, 5, 5, 5, 35000.00, '2024-05-01', 'Online Transfer', 5, 5);

