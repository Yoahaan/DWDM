CREATE DATABASE OrderManagementDW;
USE OrderManagementDW;
-- Dimension Tables
CREATE TABLE Customer_Dim (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    BillingAddress VARCHAR(255),
    ShippingAddress VARCHAR(255)
);
CREATE TABLE Product_Dim (
    ProductID INT PRIMARY KEY,	
    ProductName VARCHAR(255),
    Category VARCHAR(255)
);
CREATE TABLE Promotion_Dim (
    PromotionID INT PRIMARY KEY,
    PromotionDescription VARCHAR(255),
    DiscountPercent DECIMAL(5,2)
);
CREATE TABLE SalesRep_Dim (
    SalesRepID INT PRIMARY KEY,
    SalesRepName VARCHAR(255)
);
CREATE TABLE Currency_Dim (
    CurrencyID INT PRIMARY KEY,
    CurrencyName VARCHAR(50),
    ExchangeRateToUSD DECIMAL(10,4)
);
-- Fact Table with Generated Column for NetOrderAmount
CREATE TABLE Order_Fact (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    PromotionID INT,
    SalesRepID INT,
    CurrencyID INT,
    GrossOrderAmount DECIMAL(10,2),
    DiscountAmount DECIMAL(10,2),
    NetOrderAmount DECIMAL(10,2) GENERATED ALWAYS AS (GrossOrderAmount - DiscountAmount) STORED,
    OrderQuantity INT,
    RequestedShipDate DATE,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customer_Dim(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Product_Dim(ProductID),
    FOREIGN KEY (PromotionID) REFERENCES Promotion_Dim(PromotionID),
    FOREIGN KEY (SalesRepID) REFERENCES SalesRep_Dim(SalesRepID),
    FOREIGN KEY (CurrencyID) REFERENCES Currency_Dim(CurrencyID)
);


-- Insert data into dimension tables
INSERT INTO Customer_Dim VALUES (1, 'John Doe', '123 Main St', '456 Oak St');
INSERT INTO Customer_Dim VALUES (2, 'Jane Smith', '789 Pine St', '101 Maple St');

INSERT INTO Product_Dim VALUES (1, 'Laptop', 'Electronics');
INSERT INTO Product_Dim VALUES (2, 'Smartphone', 'Electronics');

INSERT INTO Promotion_Dim VALUES (1, 'Holiday Sale', 10.00);
INSERT INTO Promotion_Dim VALUES (2, 'Clearance', 20.00);

INSERT INTO SalesRep_Dim VALUES (1, 'Alice Johnson');
INSERT INTO SalesRep_Dim VALUES (2, 'Bob Brown');

INSERT INTO Currency_Dim VALUES (1, 'USD', 1.00);
INSERT INTO Currency_Dim VALUES (2, 'Euro', 1.10);
INSERT INTO Currency_Dim VALUES (3, 'Dirham', 3.67);

-- Insert data into fact table
INSERT INTO Order_Fact (OrderID, CustomerID, ProductID, PromotionID, SalesRepID, CurrencyID, GrossOrderAmount, DiscountAmount, OrderQuantity, RequestedShipDate, OrderDate) 
VALUES (1, 1, 1, 1, 1, 1, 1000.00, 100.00, 1, '2024-08-10', '2024-08-01');

INSERT INTO Order_Fact (OrderID, CustomerID, ProductID, PromotionID, SalesRepID, CurrencyID, GrossOrderAmount, DiscountAmount, OrderQuantity, RequestedShipDate, OrderDate) 
VALUES (2, 1, 2, 2, 2, 2, 500.00, 50.00, 1, '2024-08-15', '2024-08-05');

INSERT INTO Order_Fact (OrderID, CustomerID, ProductID, PromotionID, SalesRepID, CurrencyID, GrossOrderAmount, DiscountAmount, OrderQuantity, RequestedShipDate, OrderDate) 
VALUES (3, 2, 1, 1, 1, 3, 1200.00, 120.00, 2, '2024-08-12', '2024-08-02');

INSERT INTO Order_Fact (OrderID, CustomerID, ProductID, PromotionID, SalesRepID, CurrencyID, GrossOrderAmount, DiscountAmount, OrderQuantity, RequestedShipDate, OrderDate) 
VALUES (4, 2, 2, 2, 2, 1, 800.00, 80.00, 1, '2024-08-18', '2024-08-07');

INSERT INTO Order_Fact (OrderID, CustomerID, ProductID, PromotionID, SalesRepID, CurrencyID, GrossOrderAmount, DiscountAmount, OrderQuantity, RequestedShipDate, OrderDate) 
VALUES (5, 1, 1, 1, 1, 2, 950.00, 95.00, 2, '2024-08-20', '2024-08-09');

INSERT INTO Order_Fact (OrderID, CustomerID, ProductID, PromotionID, SalesRepID, CurrencyID, GrossOrderAmount, DiscountAmount, OrderQuantity, RequestedShipDate, OrderDate) 
VALUES (6, 2, 2, 2, 2, 3, 700.00, 70.00, 1, '2024-08-22', '2024-08-10');
INSERT INTO Order_Fact (OrderID, CustomerID, ProductID, PromotionID, SalesRepID, CurrencyID, GrossOrderAmount, DiscountAmount, OrderQuantity, RequestedShipDate, OrderDate) 
VALUES (7, 1, 1, 1, 1, 1, 1100.00, 110.00, 1, '2024-08-24', '2024-08-12');
INSERT INTO Order_Fact (OrderID, CustomerID, ProductID, PromotionID, SalesRepID, CurrencyID, GrossOrderAmount, DiscountAmount, OrderQuantity, RequestedShipDate, OrderDate) 
VALUES (8, 2, 2, 2, 2, 2, 650.00, 65.00, 1, '2024-08-26', '2024-08-15');
INSERT INTO Order_Fact (OrderID, CustomerID, ProductID, PromotionID, SalesRepID, CurrencyID, GrossOrderAmount, DiscountAmount, OrderQuantity, RequestedShipDate, OrderDate) 
VALUES (9, 1, 1, 1, 1, 3, 1050.00, 105.00, 1, '2024-08-28', '2024-08-17');

INSERT INTO Order_Fact (OrderID, CustomerID, ProductID, PromotionID, SalesRepID, CurrencyID, GrossOrderAmount, DiscountAmount, OrderQuantity, RequestedShipDate, OrderDate) 
VALUES (10, 2, 2, 2, 2, 1, 550.00, 55.00, 1, '2024-08-30', '2024-08-19');

SELECT 
    C.CustomerName, 
    P.ProductName, 
    PR.PromotionDescription, 
    S.SalesRepName, 
    O.GrossOrderAmount, 
    O.DiscountAmount, 
    (O.NetOrderAmount * CU.ExchangeRateToUSD) AS NetOrderAmountInUSD
FROM 
    Order_Fact O
    JOIN Customer_Dim C ON O.CustomerID = C.CustomerID
    JOIN Product_Dim P ON O.ProductID = P.ProductID
    JOIN Promotion_Dim PR ON O.PromotionID = PR.PromotionID
    JOIN SalesRep_Dim S ON O.SalesRepID = S.SalesRepID
    JOIN Currency_Dim CU ON O.CurrencyID = CU.CurrencyID;
