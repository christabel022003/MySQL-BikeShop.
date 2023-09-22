 --1
SELECT cd.CustomerID, CustomerName, [Total Item Variety] = CAST(COUNT(td.BicycleSoldID) AS varchar) + ' Types'
FROM CustomerTable cd 
	JOIN TransactionHeader th 
		ON cd.CustomerID = th.CustomerID 
	JOIN TransactionDetail td 
		ON th.TransactionID = td.TransactionID
WHERE CustomerGender = 'Male' AND CustomerName LIKE 'A%'
GROUP BY cd.CustomerID, CustomerName

--2
SELECT BikeTypeName, tb.TypeBikeID, [BikeCount] = COUNT (bs.BicycleSoldID)
FROM BicycleSold bs JOIN TypeBike  tb ON bs.TypeBikeID = tb.TypeBikeID JOIN GroupSets gs ON tb.TypeBikeID = gs.TypeBikeID 
WHERE GroupSetName LIKE 'Shimano%' AND NumberOfGear BETWEEN 7 AND 12
GROUP BY BikeTypeName, tb.TypeBikeID

--3
SELECT ms.StaffID, StaffName, [Number Of Transactions] = COUNT(td.BicycleSoldID ), 
		CAST(SUM(Quantity) AS varchar) + ' Bikes' AS 'Number Of Bikes Sold'
FROM StaffTable ms
	JOIN TransactionHeader th ON ms.StaffID = th.StaffID 
	JOIN TransactionDetail td ON td.TransactionID = th.TransactionID
WHERE StaffGender = 'Female' AND (LEN(StaffName) BETWEEN 5 AND 10)
GROUP BY ms.StaffID, StaffName

--4
SELECT mgs.GroupSetID, GroupSetName, [Bike Count] = COUNT(bs.BicycleSoldID), [Average Price] = FORMAT (AVG (bs.BikePrice), 'C', 'id-ID')
FROM GroupSets mgs 
	JOIN TypeBike mb ON mgs.TypeBikeID = mb.TypeBikeID
	JOIN Brand mbr ON mb.TypeBikeID = mbr.TypeBikeID JOIN BicycleSold bs ON bs.TypeBikeID = mb.TypeBikeID
WHERE BrandName LIKE 'C%' 
GROUP BY mgs.GroupSetID, GroupSetName,bs.TypeBikeID
HAVING AVG(BikePrice) > 150000000

--5
SELECT th.TransactionID,CustomerName, StaffName, [Transaction Day] = DATENAME(DAY,TransactionDate)
FROM StaffTable ms 
	JOIN TransactionHeader th ON ms.StaffID = th.StaffID
	JOIN CustomerTable mc ON th.CustomerID = mc.CustomerID,
	(
	SELECT [Average] = AVG(SalaryStaff) 
	FROM StaffTable
	) AS X
WHERE ms.SalaryStaff > x.Average AND DATENAME(MONTH, TransactionDate) = 'February'

--6
SELECT ms.StaffName, bs.BikeName, td.TransactionID, [Transaction Month] = MONTH(th.TransactionDate)
FROM StaffTable ms JOIN TransactionHeader th ON ms.StaffID = th.StaffID
JOIN TransactionDetail td ON td.TransactionID = th.TransactionID
JOIN BicycleSold bs ON td.BicycleSoldID = bs.BicycleSoldID,
	(
	SELECT MAX(Quantity) AS Maximum
	FROM TransactionDetail
	) AS x
WHERE td.Quantity < x.Maximum AND DAY(th.TransactionDate) = 12

--7 
SELECT [Average Bikes Sold] = CAST(AVG(td.Quantity) AS varchar) + ' Bikes'
FROM BicycleSold mb 
JOIN TransactionDetail td ON mb.BicycleSoldID = td.BicycleSoldID
JOIN TransactionHeader th ON td.TransactionID = th.TransactionID,
	(
	SELECT BikePrice AS bp
	FROM BicycleSold
	WHERE BikePrice between 100000000 and 150000000
	) x
WHERE DATEDIFF(MONTH , TransactionDate,GETDATE())  < 12 AND BikePrice = x.bp

--8
SELECT [MaxBikesPurchased] = CAST(Max(Quantity) AS varchar) + ' Bikes'
FROM BicycleSold bs JOIN TransactionDetail td ON bs.BicycleSoldID = td.BicycleSoldID JOIN TransactionHeader th ON td.TransactionID=th.TransactionID,  
(
SELECT BikeName AS Bn
FROM BicycleSold
WHERE BikeName LIKE 'S%'
) x
WHERE MONTH(TransactionDate) BETWEEN 7 AND 12 AND BikeName = x.Bn

--9 
GO
CREATE VIEW CustomerView AS
SELECT cd.CustomerName, [Total Transactions] = COUNT(td.BicycleSoldID), [Total Bikes Bought] = SUM (td.Quantity), STUFF(CustomerNumber, 1, 1, '+62') AS [Customer Phone]
FROM CustomerTable cd JOIN TransactionHeader th ON cd.CustomerID=th.CustomerID JOIN TransactionDetail td ON td.TransactionID =  th.TransactionID
GROUP BY cd.CustomerName ,CustomerNumber
HAVING COUNT(th.TransactionID) BETWEEN 2 AND 5 AND SUM(td.Quantity) > 5

SELECT * FROM CustomerView
--10
GO
CREATE VIEW TransactionView AS
SELECT td.TransactionID, [Max Quantity] = MAX(Quantity), [Min Quantity] = MIN(Quantity), [Days Elapsed] = DATEDIFF(DAY,TransactionDate,GETDATE())
FROM StaffTable st JOIN TransactionHeader th ON st.StaffID = th.StaffID JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
WHERE StaffGender = 'male'
GROUP BY td.TransactionID,TransactionDate
HAVING MAX(Quantity) !=MIN(Quantity)

SELECT * FROM TransactionView