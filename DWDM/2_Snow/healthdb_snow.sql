CREATE DATABASE HealthDB;
USE HealthDB;
CREATE TABLE DimAddress (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street_address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(10),
    country VARCHAR(50)
);
CREATE TABLE DimInsurance (
    insurance_id INT AUTO_INCREMENT PRIMARY KEY,
    insurance_provider VARCHAR(100),
    insurance_plan VARCHAR(100),
    insurance_expiry DATE
);
CREATE TABLE DimPatient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dob DATE,
    gender CHAR(1),
    address_id INT,
    phone_number VARCHAR(15),
    email VARCHAR(100),
    insurance_id INT,
    FOREIGN KEY (address_id) REFERENCES DimAddress(address_id),
    FOREIGN KEY (insurance_id) REFERENCES DimInsurance(insurance_id)
);
CREATE TABLE DimSpecialization (
    specialization_id INT AUTO_INCREMENT PRIMARY KEY,
    specialization_name VARCHAR(100)
);
CREATE TABLE DimDepartment (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(255),
    phone_number VARCHAR(15)
);
CREATE TABLE DimDoctor (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization_id INT,
    department_id INT,
    phone_number VARCHAR(15),
    email VARCHAR(100),
    FOREIGN KEY (specialization_id) REFERENCES DimSpecialization(specialization_id),
    FOREIGN KEY (department_id) REFERENCES DimDepartment(department_id)
);
CREATE TABLE DimVisitReason (
    visit_reason_id INT AUTO_INCREMENT PRIMARY KEY,
    visit_reason_description VARCHAR(255)
);
CREATE TABLE DimDiagnosis (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    diagnosis_code VARCHAR(20),
    diagnosis_description VARCHAR(255)
);
CREATE TABLE DimTreatment (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    diagnosis_id INT,
    treatment_code VARCHAR(20),
    treatment_description VARCHAR(255),
    cost DECIMAL(10,2),
    FOREIGN KEY (diagnosis_id) REFERENCES DimDiagnosis(diagnosis_id)
);
CREATE TABLE FactPatientAppointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    department_id INT,
    visit_reason_id INT,
    appointment_date DATE,
    appointment_time TIME,
    duration_minutes INT,
    diagnosis_id INT,
    treatment_cost DECIMAL(10,2),
    FOREIGN KEY (patient_id) REFERENCES DimPatient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES DimDoctor(doctor_id),
    FOREIGN KEY (department_id) REFERENCES DimDepartment(department_id),
    FOREIGN KEY (visit_reason_id) REFERENCES DimVisitReason(visit_reason_id),
    FOREIGN KEY (diagnosis_id) REFERENCES DimDiagnosis(diagnosis_id)
);
INSERT INTO DimAddress (street_address, city, state, zip_code, country)
VALUES
('123 MG Road', 'Bengaluru', 'Karnataka', '560001', 'India'),
('456 SV Road', 'Mumbai', 'Maharashtra', '400001', 'India'),
('789 Park Street', 'Kolkata', 'West Bengal', '700016', 'India'),
('101 Anna Salai', 'Chennai', 'Tamil Nadu', '600002', 'India'),
('202 NH Road', 'Delhi', 'Delhi', '110001', 'India');
INSERT INTO DimInsurance (insurance_provider, insurance_plan, insurance_expiry)
VALUES
('HDFC ERGO', 'Health Protect', '2025-06-30'),
('ICICI Lombard', 'Complete Health', '2024-12-31'),
('Bajaj Allianz', 'Family Health Plan', '2026-03-15'),
('Star Health', 'Senior Citizen Plan', '2023-11-30'),
('Max Bupa', 'Individual Health', '2025-09-01');
INSERT INTO DimPatient (first_name, last_name, dob, gender, address_id, phone_number, email, insurance_id)
VALUES
('Amit', 'Sharma', '1985-06-15', 'M', 1, '9876543210', 'amit.sharma@example.com', 1),
('Priya', 'Kumar', '1992-03-22', 'F', 2, '9876543211', 'priya.kumar@example.com', 2),
('Ravi', 'Patel', '1978-11-09', 'M', 3, '9876543212', 'ravi.patel@example.com', 3),
('Sita', 'Iyer', '1983-08-30', 'F', 4, '9876543213', 'sita.iyer@example.com', 4),
('Rajesh', 'Verma', '1990-12-12', 'M', 5, '9876543214', 'rajesh.verma@example.com', 5);
INSERT INTO DimSpecialization (specialization_name)
VALUES
('Cardiology'),
('Orthopedics'),
('Dermatology'),
('Neurology'),
('General Medicine');
INSERT INTO DimDepartment (department_name, location, phone_number)
VALUES
('Cardiology', 'Building A', '011-22334455'),
('Orthopedics', 'Building B', '011-22334456'),
('Dermatology', 'Building C', '011-22334457'),
('Neurology', 'Building D', '011-22334458'),
('General Medicine', 'Building E', '011-22334459');
INSERT INTO DimDoctor (first_name, last_name, specialization_id, department_id, phone_number, email)
VALUES
('Arjun', 'Mehta', 1, 1, '9876543215', 'arjun.mehta@example.com'),
('Sonal', 'Desai', 2, 2, '9876543216', 'sonal.desai@example.com'),
('Rohan', 'Reddy', 3, 3, '9876543217', 'rohan.reddy@example.com'),
('Vikram', 'Singh', 4, 4, '9876543218', 'vikram.singh@example.com'),
('Sneha', 'Gupta', 5, 5, '9876543219', 'sneha.gupta@example.com');
INSERT INTO DimVisitReason (visit_reason_description)
VALUES
('Regular Checkup'),
('Follow-up Visit'),
('New Symptoms'),
('Emergency'),
('Consultation');
INSERT INTO DimDiagnosis (diagnosis_code, diagnosis_description)
VALUES
('D001', 'Common Cold'),
('D002', 'Hypertension'),
('D003', 'Diabetes'),
('D004', 'Migraine'),
('D005', 'Fracture');
INSERT INTO FactPatientAppointments (patient_id, doctor_id, department_id, visit_reason_id, appointment_date, appointment_time, duration_minutes, diagnosis_id, treatment_cost)
VALUES
(1, 1, 1, 1, '2024-09-10', '10:30:00', 30, 1, 500.00),
(2, 2, 2, 2, '2024-09-11', '11:00:00', 45, 2, 1000.00),
(3, 3, 3, 3, '2024-09-12', '12:15:00', 60, 3, 1500.00),
(4, 4, 4, 4, '2024-09-13', '14:00:00', 30, 4, 2000.00),
(5, 5, 5, 5, '2024-09-14', '15:30:00', 45, 5, 2500.00)
