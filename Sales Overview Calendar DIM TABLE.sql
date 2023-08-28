----------------------------------------------------------------
---- Formatting the Date table

SELECT [DateKey],
      [FullDateAlternateKey] AS Date,
      --[DayNumberOfWeek]
      [EnglishDayNameOfWeek] AS Day,
      --[SpanishDayNameOfWeek]
      --[FrenchDayNameOfWeek]
      [DayNumberOfMonth],
      --[DayNumberOfYear]
      --[WeekNumberOfYear]
      [EnglishMonthName] AS Month,
	  LEFT([EnglishMonthName], 3) AS [Month Short],
      --[SpanishMonthName]
      --[FrenchMonthName]
      [MonthNumberOfYear] AS [Month Number],
      [CalendarQuarter] AS Quarter,
      [CalendarYear] AS Year
      --[CalendarSemester]
      --[FiscalQuarter]
      --[FiscalYear]
      --[FiscalSemester]
  FROM [AdventureWorksDW2022].[dbo].[DimDate]
  WHERE [CalendarYear] > 2021