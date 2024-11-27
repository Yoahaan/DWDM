CREATE DATABASE order_snow;
USE order_snow;


-- Dimension Tables
CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE CustomerShippingAddress (
    CustomerID INT PRIMARY KEY,
    ShippingAddress VARCHAR(255),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID)
);

CREATE TABLE CustomerBillingAddress (
    CustomerID INT PRIMARY KEY,
    BillingAddress VARCHAR(255),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID)
);

CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100)
);

CREATE TABLE ProductCategory (
    ProductID INT PRIMARY KEY,
    CategoryName VARCHAR(100),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID)
);

CREATE TABLE DimPromotion (
    PromotionID INT PRIMARY KEY,
    PromotionName VARCHAR(100)
);

CREATE TABLE PromotionDiscount (
    PromotionID INT PRIMARY KEY,
    DiscountPercentage DECIMAL(5, 2),
    FOREIGN KEY (PromotionID) REFERENCES DimPromotion(PromotionID)
);

CREATE TABLE DimSalesRep (
    SalesRepID INT PRIMARY KEY,
    SalesRepName VARCHAR(100)
);

CREATE TABLE SalesRepRegion (
    SalesRepID INT PRIMARY KEY,
    RegionName VARCHAR(100),
    FOREIGN KEY (SalesRepID) REFERENCES DimSalesRep(SalesRepID)
);

CREATE TABLE DimCurrency (
    CurrencyID INT PRIMARY KEY,
    CurrencyName VARCHAR(50)
);

CREATE TABLE ExchangeRate (
    CurrencyID INT PRIMARY KEY,
    ExchangeRateToUSD DECIMAL(10, 4),
    FOREIGN KEY (CurrencyID) REFERENCES DimCurrency(CurrencyID)
);

-- Fact Table
CREATE TABLE FactOrder (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    PromotionID INT,
    SalesRepID INT,
    CurrencyID INT,
    OrderDate DATE,
    RequestedShipDate DATE,
    Quantity INT,
    GrossAmount DECIMAL(10, 2),
    NetAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
    FOREIGN KEY (PromotionID) REFERENCES DimPromotion(PromotionID),
    FOREIGN KEY (SalesRepID) REFERENCES DimSalesRep(SalesRepID),
    FOREIGN KEY (CurrencyID) REFERENCES DimCurrency(CurrencyID)
);

-- Insert Sample Data for Dimensions
INSERT INTO DimCustomer VALUES 
(1, 'Alice'), 
(2, 'Bob'), 
(3, 'Charlie');

INSERT INTO CustomerShippingAddress VALUES 
(1, '123 Maple St'), 
(2, '456 Oak St'), 
(3, '789 Pine St');

INSERT INTO CustomerBillingAddress VALUES 
(1, '123 Maple St'), 
(2, '456 Oak St'), 
(3, '789 Pine St');

INSERT INTO DimProduct VALUES 
(1, 'Laptop'), 
(2, 'Mouse'), 
(3, 'Keyboard');

INSERT INTO ProductCategory VALUES 
(1, 'Electronics'), 
(2, 'Accessories'), 
(3, 'Accessories');

INSERT INTO DimPromotion VALUES 
(1, 'Holiday Sale'), 
(2, 'Clearance'), 
(3, 'New Customer Discount');

INSERT INTO PromotionDiscount VALUES 
(1, 10.00), 
(2, 15.00), 
(3, 5.00);

INSERT INTO DimSalesRep VALUES 
(1, 'John Doe'), 
(2, 'Jane Smith'), 
(3, 'Emily Davis');

INSERT INTO SalesRepRegion VALUES 
(1, 'North'), 
(2, 'South'), 
(3, 'West');

INSERT INTO DimCurrency VALUES 
(1, 'USD'), 
(2, 'EUR'), 
(3, 'AED');

INSERT INTO ExchangeRate VALUES 
(1, 1.0000), 
(2, 1.1000), 
(3, 0.2723);

-- Insert Sample Data for Fact Table
INSERT INTO FactOrder VALUES 
(1, 1, 1, 1, 1, 1, '2024-01-01', '2024-01-05', 2, 2000.00, 1800.00),
(2, 2, 2, 2, 2, 2, '2024-01-02', '2024-01-06', 5, 100.00, 85.00),
(3, 3, 3, 3, 3, 3, '2024-01-03', '2024-01-07', 10, 500.00, 475.00);



SELECT 
    C.CustomerName,
    P.ProductName,
    PR.PromotionName,
    S.SalesRepName,
    SUM(F.NetAmount) AS TotalNetAmount
FROM FactOrder F
JOIN DimCustomer C ON F.CustomerID = C.CustomerID
JOIN DimProduct P ON F.ProductID = P.ProductID
JOIN DimPromotion PR ON F.PromotionID = PR.PromotionID
JOIN DimSalesRep S ON F.SalesRepID = S.SalesRepID
GROUP BY C.CustomerName, P.ProductName, PR.PromotionName, S.SalesRepName;

