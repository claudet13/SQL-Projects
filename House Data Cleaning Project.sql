/*

Cleaning data in SQL

*/

SELECT * 
FROM [ATL Portfolio Projects].dbo.NashVilleHousing


------------------------------------------------------------------------------------

--- Standardize Date Formats

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM [ATL Portfolio Projects].dbo.NashVilleHousing

ALTER TABLE [ATL Portfolio Projects].dbo.NashVilleHousing
ADD SaleDateConverted Date

UPDATE [ATL Portfolio Projects].dbo.NashVilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


------------------------------------------------------------------------------------

--- Popuate Property Address Data

SELECT *
FROM [ATL Portfolio Projects].dbo.NashVilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [ATL Portfolio Projects].dbo.NashVilleHousing a
JOIN [ATL Portfolio Projects].dbo.NashVilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [ATL Portfolio Projects].dbo.NashVilleHousing a
JOIN [ATL Portfolio Projects].dbo.NashVilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


------------------------------------------------------------------------------------

--- Breaking out Property Address into Individual Columns (Address, City)

SELECT PropertyAddress
FROM [ATL Portfolio Projects].dbo.NashVilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM [ATL Portfolio Projects].dbo.NashVilleHousing


ALTER TABLE [ATL Portfolio Projects].dbo.NashVilleHousing
ADD PropertySplitAddress NVARCHAR(250)

UPDATE [ATL Portfolio Projects].dbo.NashVilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE [ATL Portfolio Projects].dbo.NashVilleHousing
ADD PropertySplitCity NVARCHAR(250)

UPDATE [ATL Portfolio Projects].dbo.NashVilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


SELECT *
FROM [ATL Portfolio Projects].dbo.NashVilleHousing

--- Breaking out Owner's Address into Individual Columns (Address, City, State) 

SELECT OwnerAddress
FROM [ATL Portfolio Projects].dbo.NashVilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [ATL Portfolio Projects].dbo.NashVilleHousing


ALTER TABLE [ATL Portfolio Projects].dbo.NashVilleHousing
ADD OwnerSplitAddress NVARCHAR(250)

UPDATE [ATL Portfolio Projects].dbo.NashVilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE [ATL Portfolio Projects].dbo.NashVilleHousing
ADD OwnerSplitCity NVARCHAR(250)

UPDATE [ATL Portfolio Projects].dbo.NashVilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE [ATL Portfolio Projects].dbo.NashVilleHousing
ADD OwnerSplitState NVARCHAR(250)

UPDATE [ATL Portfolio Projects].dbo.NashVilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM [ATL Portfolio Projects].dbo.NashVilleHousing


------------------------------------------------------------------------------------

--- Change Y and N to Yes and No in "Sold as Vacant" Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [ATL Portfolio Projects].dbo.NashVilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM [ATL Portfolio Projects].dbo.NashVilleHousing


UPDATE [ATL Portfolio Projects].dbo.NashVilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END


------------------------------------------------------------------------------------

--- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY 
		UniqueID
		) row_num
FROM [ATL Portfolio Projects].dbo.NashVilleHousing
---ORDER BY ParcelID
)

SELECT * 
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress


------------------------------------------------------------------------------------

--- Delete Unused Columns

SELECT *
FROM [ATL Portfolio Projects].dbo.NashVilleHousing

ALTER TABLE [ATL Portfolio Projects].dbo.NashVilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [ATL Portfolio Projects].dbo.NashVilleHousing
DROP COLUMN SaleDate