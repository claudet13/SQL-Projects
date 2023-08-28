----------------------------------------------
-------- Formatting the Customer Table

SELECT c.[CustomerKey],
      c.[GeographyKey],
	  g.City AS [Customer City],
      --[CustomerAlternateKey]
      --[Title]
      c.[FirstName] AS [First Name],
      --[MiddleName]
      c.[LastName] AS [Last Name],
	  [FirstName] + ' ' + [LastName] AS [Full Name],
      --[NameStyle]
      c.[BirthDate] AS [Date of Birth],
	  YEAR([BirthDate]) AS [Year of Birth],
      --[MaritalStatus]
      --[Suffix]
	  CASE WHEN c.[Gender] = 'M' THEN 'Male' WHEN c.[Gender] = 'F' THEN 'Female' END AS Gender,
      --[EmailAddress]
      --[YearlyIncome],
      --[TotalChildren]
      --[NumberChildrenAtHome]
      --[EnglishEducation]
      --[SpanishEducation]
      --[FrenchEducation]
      --[EnglishOccupation]
      --[SpanishOccupation]
      --[FrenchOccupation]
      --[HouseOwnerFlag]
      --[NumberCarsOwned]
      --[AddressLine1]
      --[AddressLine2]
      --[Phone],
      [DateFirstPurchase] AS [First Purchase]
      --[CommuteDistance]
FROM [AdventureWorksDW2022].[dbo].[DimCustomer] AS c
LEFT JOIN [AdventureWorksDW2022].dbo.DimGeography AS g
	ON c.GeographyKey = g.GeographyKey
ORDER BY c.CustomerKey