CREATE DATABASE FinalProjectDB
GO
USE FinalProjectDB
GO
CREATE TABLE StaffTable(
StaffID VARCHAR(5) PRIMARY KEY CHECK(StaffID LIKE 'ST[0-9][0-9][0-9]'),
StaffName VARCHAR(34) NOT NULL,
StaffEmail VARCHAR(24) NOT NULL ,
StaffPhone VARCHAR(24) NOT NULL,
StaffGender VARCHAR(9) NOT NULL ,
SalaryStaff INT,
CONSTRAINT staffnames_check CHECK (LEN(StaffName) > 4),
CONSTRAINT staffemail_check CHECK (StaffEmail LIKE '%@rocalink.com'),
CONSTRAINT staffphone_check CHECK ((StaffPhone LIKE '08%')),
CONSTRAINT staffgender_check CHECK ((StaffGender LIKE 'Female') OR (StaffGender LIKE 'Male'))
)

CREATE TABLE TypeBike(
TypeBikeID	VARCHAR(5) NOT NULL PRIMARY KEY CHECK (TypeBikeID LIKE 'BT[0-9][0-9][0-9]'),
BikeTypeName VARCHAR(24) NOT NULL
)

CREATE TABLE BicycleSold(
BicycleSoldID VARCHAR(5) NOT NULL PRIMARY KEY,
BikeName       VARCHAR(24) NOT NULL ,
TypeBikeID VARCHAR(5) NOT NULL FOREIGN KEY REFERENCES TypeBike(TypeBikeID),
BikePrice	   INT NOT NULL,
CONSTRAINT BikeSeries_check CHECK (BicycleSoldID LIKE 'BK[0-9][0-9][0-9]'),
CONSTRAINT pricebike_check CHECK (BikePrice > 0)
)
CREATE TABLE Brand(
BrandID VARCHAR(5) PRIMARY KEY CHECK(BrandID LIKE 'BR[0-9][0-9][0-9]'),
TypeBikeID VARCHAR(5) NOT NULL FOREIGN KEY REFERENCES TypeBike(TypeBikeID),
BrandName VARCHAR(24) NOT NULL,
Descriptions VARCHAR(255) NOT NULL,
Website VARCHAR(64) NOT NULL CHECK(Website LIKE 'www%'),
Nationality VARCHAR(24) NOT NULL,
)

CREATE TABLE CustomerTable(
CustomerID VARCHAR(5) PRIMARY KEY CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]'),
CustomerName    VARCHAR(24) NOT NULL,
CustomerNumber	VARCHAR(24) NOT NULL,
CustomerGender VARCHAR(7) NOT NULL ,
CustomerEmail VARCHAR(24) NOT NULL ,
CONSTRAINT CustomerNameS_check CHECK (LEN(CustomerName) > 4),
CONSTRAINT CustomerGenders_check CHECK ((CustomerGender LIKE 'Female') OR (CustomerGender LIKE 'Male')),
CONSTRAINT custsemail_check CHECK (CustomerEmail LIKE '%@gmail.com'),
CONSTRAINT custnumbers_check CHECK ((CustomerNumber LIKE '08%'))
)

CREATE TABLE GroupSets(
GroupSetID	VARCHAR(5) NOT NULL PRIMARY KEY CHECK (GroupSetID LIKE 'GR[0-9][0-9][0-9]'),
TypeBikeID VARCHAR(5) NOT NULL FOREIGN KEY REFERENCES TypeBike(TypeBikeID),
GroupSetName		VARCHAR(24) NOT NULL,
NumberOfGear		INT NOT NULL,
GearWirelessCapability VARCHAR(24) NOT NULL,
CONSTRAINT NumberOfGear_CHECK CHECK (NumberOfGear BETWEEN 4 AND 12),
CONSTRAINT GearWirelessCapability CHECK ((GearWirelessCapability LIKE 'True') OR (GearWirelessCapability LIKE 'False')),
)

CREATE TABLE TransactionHeader(
TransactionID VARCHAR(5) PRIMARY KEY CHECK(TransactionID LIKE 'TR[0-9][0-9][0-9]'),
StaffID VARCHAR(5) NOT NULL FOREIGN KEY REFERENCES StaffTable(StaffID),
CustomerID VARCHAR(5) NOT NULL FOREIGN KEY REFERENCES CustomerTable(CustomerID),
TransactionDate DATE NOT NULL,
BikesPurchased VARCHAR (24) NOT NULL,
CONSTRAINT checkdate_check CHECK (DATEPART(DAY, TransactionDate) <= GETDATE())
)
CREATE TABLE TransactionDetail(
TransactionID VARCHAR(5) NOT NULL FOREIGN KEY REFERENCES TransactionHeader(TransactionID),
BicycleSoldID VARCHAR(5) NOT NULL FOREIGN KEY REFERENCES BicycleSold(BicycleSoldID),
Quantity INT NOT NULL,
CONSTRAINT qtybike_check CHECK (Quantity > 0)
)