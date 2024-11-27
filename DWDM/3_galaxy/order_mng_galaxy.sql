CREATE DATABASE order_galaxy;
USE order_galaxy;


-- Dimension Tables
CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    ShippingAddress VARCHAR(255),
    BillingAddress VARCHAR(255)
);

CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(100),
    Price DECIMAL(10, 2)
);

CREATE TABLE DimPromotion (
    PromotionID INT PRIMARY KEY,
    PromotionName VARCHAR(100),
    Discount DECIMAL(5, 2)
);

CREATE TABLE DimSalesRep (
    SalesRepID INT PRIMARY KEY,
    SalesRepName VARCHAR(100),
    Region VARCHAR(100)
);

CREATE TABLE DimCurrency (
    CurrencyID INT PRIMARY KEY,
    CurrencyName VARCHAR(50)
);



-- FactOrder Table
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

-- FactCurrencyConversion Table
CREATE TABLE FactCurrencyConversion (
    CurrencyID INT,
    ConversionDate DATE,
    ExchangeRateToUSD DECIMAL(10, 4),
    ExchangeRateToEUR DECIMAL(10, 4),
    ExchangeRateToAED DECIMAL(10, 4),
    PRIMARY KEY (CurrencyID, ConversionDate),
    FOREIGN KEY (CurrencyID) REFERENCES DimCurrency(CurrencyID)
);

-- DimCustomer
INSERT INTO DimCustomer VALUES 
(1, 'Alice', '123 Maple St', '123 Maple St'),
(2, 'Bob', '456 Oak St', '456 Oak St'),
(3, 'Charlie', '789 Pine St', '789 Pine St'),
(4, 'Diana', '101 Elm St', '101 Elm St'),
(5, 'Edward', '202 Birch St', '202 Birch St');

-- DimProduct
INSERT INTO DimProduct VALUES 
(1, 'Laptop', 'Electronics', 1000.00),
(2, 'Mouse', 'Accessories', 20.00),
(3, 'Keyboard', 'Accessories', 50.00),
(4, 'Monitor', 'Electronics', 200.00),
(5, 'Printer', 'Electronics', 150.00);

-- DimPromotion
INSERT INTO DimPromotion VALUES 
(1, 'Holiday Sale', 10.00),
(2, 'Clearance', 15.00),
(3, 'New Customer Discount', 5.00),
(4, 'Flash Sale', 20.00),
(5, 'Black Friday', 25.00);

-- DimSalesRep
INSERT INTO DimSalesRep VALUES 
(1, 'John Doe', 'North'),
(2, 'Jane Smith', 'South'),
(3, 'Emily Davis', 'West'),
(4, 'Michael Brown', 'East'),
(5, 'Sarah Wilson', 'Central');

-- DimCurrency
INSERT INTO DimCurrency VALUES 
(1, 'USD'),
(2, 'EUR'),
(3, 'AED'),
(4, 'GBP'),
(5, 'JPY');


-- FactOrder
INSERT INTO FactOrder VALUES 
(1, 1, 1, 1, 1, 1, '2024-01-01', '2024-01-05', 2, 2000.00, 1800.00),
(2, 2, 2, 2, 2, 2, '2024-01-02', '2024-01-06', 5, 100.00, 85.00),
(3, 3, 3, 3, 3, 3, '2024-01-03', '2024-01-07', 10, 500.00, 475.00),
(4, 4, 4, 4, 4, 4, '2024-01-04', '2024-01-08', 1, 200.00, 160.00),
(5, 5, 5, 5, 5, 5, '2024-01-05', '2024-01-09', 3, 450.00, 337.50);

-- FactCurrencyConversion
INSERT INTO FactCurrencyConversion VALUES 
(1, '2024-01-01', 1.0000, 1.1000, 0.2723),
(2, '2024-01-01', 0.9100, 1.0000, 0.2475),
(3, '2024-01-01', 3.6700, 4.0435, 1.0000),
(4, '2024-01-01', 1.2500, 1.3750, 0.3400),
(5, '2024-01-01', 0.0075, 0.0083, 0.0020);


SELECT 
    C.CustomerName,
    P.ProductName,
    PR.PromotionName,
    SR.SalesRepName,
    SUM(F.NetAmount) AS TotalNetAmount
FROM FactOrder F
JOIN DimCustomer C ON F.CustomerID = C.CustomerID
JOIN DimProduct P ON F.ProductID = P.ProductID
JOIN DimPromotion PR ON F.PromotionID = PR.PromotionID
JOIN DimSalesRep SR ON F.SalesRepID = SR.SalesRepID
GROUP BY C.CustomerName, P.ProductName, PR.PromotionName, SR.SalesRepName;
