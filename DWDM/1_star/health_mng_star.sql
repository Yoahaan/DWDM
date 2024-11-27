create database health_fact;
use health_fact;

-- Create Dimension Table: DimPatient
CREATE TABLE DimPatient (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(255),
    Age INT,
    Gender VARCHAR(10),
    MedicalHistory TEXT
);

-- Create Dimension Table: DimDoctor
CREATE TABLE DimDoctor (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(255),
    Specialization VARCHAR(100),
    Qualification VARCHAR(100)
);

-- Create Dimension Table: DimHospital
CREATE TABLE DimHospital (
    HospitalID INT PRIMARY KEY,
    HospitalName VARCHAR(255),
    Location VARCHAR(255),
    HospitalType VARCHAR(100)
);

-- Create Dimension Table: DimTreatment
CREATE TABLE DimTreatment (
    TreatmentID INT PRIMARY KEY,
    TreatmentName VARCHAR(255),
    TreatmentType VARCHAR(100),
    TreatmentCost DECIMAL(10, 2)
);

-- Create Dimension Table: DimTime
CREATE TABLE DimTime (
    TimeID INT PRIMARY KEY,
    Date DATE,
    Month VARCHAR(50),
    Year INT,
    DayOfWeek VARCHAR(50)
);

-- Create Fact Table: FactTreatment
CREATE TABLE FactTreatment (
    FactID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    HospitalID INT,
    TreatmentID INT,
    TimeID INT,
    Cost DECIMAL(10, 2),
    AmountBilled DECIMAL(10, 2),
    FOREIGN KEY (PatientID) REFERENCES DimPatient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES DimDoctor(DoctorID),
    FOREIGN KEY (HospitalID) REFERENCES DimHospital(HospitalID),
    FOREIGN KEY (TreatmentID) REFERENCES DimTreatment(TreatmentID),
    FOREIGN KEY (TimeID) REFERENCES DimTime(TimeID)
);


INSERT INTO DimPatient (PatientID, Name, Age, Gender, MedicalHistory) VALUES
(1, 'John Doe', 30, 'Male', 'None'),
(2, 'Jane Smith', 45, 'Female', 'Diabetes'),
(3, 'Alice Johnson', 60, 'Female', 'Hypertension'),
(4, 'Bob Brown', 55, 'Male', 'Asthma'),
(5, 'Eve Davis', 40, 'Female', 'None');


INSERT INTO DimDoctor (DoctorID, Name, Specialization, Qualification) VALUES
(1, 'Dr. Richard Roe', 'Cardiology', 'MD'),
(2, 'Dr. John Smith', 'Orthopedics', 'MBBS'),
(3, 'Dr. Alice White', 'Neurology', 'MD'),
(4, 'Dr. Bob Brown', 'Pediatrics', 'MBBS'),
(5, 'Dr. Eve Johnson', 'Endocrinology', 'MD');

INSERT INTO DimHospital (HospitalID, HospitalName, Location, HospitalType) VALUES
(1, 'City Hospital', 'New York', 'General'),
(2, 'Westside Medical Center', 'Los Angeles', 'Specialized'),
(3, 'North Bay Health', 'San Francisco', 'General'),
(4, 'Central Clinic', 'Chicago', 'Clinic'),
(5, 'Sunshine Hospital', 'Miami', 'Specialized');


INSERT INTO DimTreatment (TreatmentID, TreatmentName, TreatmentType, TreatmentCost) VALUES
(1, 'Cardiac Bypass Surgery', 'Surgery', 15000.00),
(2, 'Hip Replacement', 'Surgery', 12000.00),
(3, 'Neurology Consultation', 'Consultation', 500.00),
(4, 'Pediatric Vaccination', 'Vaccination', 200.00),
(5, 'Thyroid Treatment', 'Treatment', 1000.00);


INSERT INTO DimTime (TimeID, Date, Month, Year, DayOfWeek) VALUES
(1, '2023-01-01', 'January', 2023, 'Monday'),
(2, '2023-02-15', 'February', 2023, 'Wednesday'),
(3, '2023-03-20', 'March', 2023, 'Monday'),
(4, '2023-04-10', 'April', 2023, 'Monday'),
(5, '2023-05-25', 'May', 2023, 'Thursday');


INSERT INTO FactTreatment (FactID, PatientID, DoctorID, HospitalID, TreatmentID, TimeID, Cost, AmountBilled) VALUES
(1, 1, 1, 1, 1, 1, 15000.00, 16000.00),
(2, 2, 2, 2, 2, 2, 12000.00, 13000.00),
(3, 3, 3, 3, 3, 3, 500.00, 550.00),
(4, 4, 4, 4, 4, 4, 200.00, 250.00),
(5, 5, 5, 5, 5, 5, 1000.00, 1200.00);


SELECT 
    p.Name AS PatientName,
    SUM(f.AmountBilled) AS TotalAmountBilled
FROM 
    FactTreatment f
JOIN 
    DimPatient p ON f.PatientID = p.PatientID
GROUP BY 
    p.Name;
