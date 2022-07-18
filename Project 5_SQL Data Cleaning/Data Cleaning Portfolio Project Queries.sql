/*

CLEANING DATA USING SQL 

*/

USE PortfolioProject
GO

-----------------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM  dbo.NashvilleHousing
GO
-----------------------------------------------------------------------------------------------------------------------------------

-- Standadize SaleDate format --

SELECT SaleDate, CONVERT(DATE, SaleDate)
FROM dbo.NashvilleHousing 
GO

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)
GO

ALTER TABLE NashvilleHousing
ADD NewSaleDate Date
GO

UPDATE NashvilleHousing
SET NewSaleDate = CONVERT(Date, SaleDate) 
GO

SELECT *
FROM NashvilleHousing
GO
----------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address Data --

SELECT FT.ParcelID, ST.ParcelID, FT.[UniqueID ], ST.[UniqueID ], FT.PropertyAddress, ST.PropertyAddress, ISNULL(FT.PropertyAddress, ST.PropertyAddress)
FROM NashvilleHousing FT
INNER JOIN NashvilleHousing ST
 ON FT.ParcelID = ST.ParcelID AND FT.[UniqueID ] <> ST.[UniqueID ]
WHERE FT.PropertyAddress IS NULL 
GO

UPDATE FT
SET FT.PropertyAddress = ISNULL(FT.PropertyAddress, ST.PropertyAddress)
FROM NashvilleHousing FT
INNER JOIN NashvilleHousing ST
 ON FT.ParcelID = ST.ParcelID AND FT.[UniqueID ] <> ST.[UniqueID ]
GO

SELECT *
FROM NashvilleHousing
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out address into individual columns (Address, City State) --

SELECT PropertyAddress, SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress) - 1)
       ,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))
FROM NashvilleHousing
GO

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(250)
GO

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(250)
GO
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress) - 1)
   ,PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))
GO

SELECT *
FROM NashvilleHousing
GO
------

SELECT OwnerAddress, PARSENAME(REPLACE(OwnerAddress, ',','.'), 3), PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)
                    ,PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
FROM NashvilleHousing
GO

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(250)
GO

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(250)
GO

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(250)
GO

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)
   ,OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)
   ,OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
GO

SELECT *
FROM dbo.NashvilleHousing
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in the 'SoldAsVacant' column --

SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2
GO

SELECT SoldAsVacant
,CASE
     WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
 END
FROM NashvilleHousing
GO

UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE
     WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
END
GO

SELECT *
FROM dbo.NashvilleHousing
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Removing Duplicates --

WITH ROWNUM_CTE AS
(
SELECT *, ROW_NUMBER()  OVER (

          PARTITION BY ParcelID
		              ,PropertyAddress
					  ,SalePrice
					  ,SaleDate
					  ,LegalReference
					   ORDER BY UniqueID
					 ) RowNumber 
FROM NashvilleHousing
)
DELETE
FROM ROWNUM_CTE
WHERE RowNumber > 1
GO

SELECT * 
FROM NashvilleHousing
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Deleting Unused Columns --

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate, TaxDistrict
GO

SELECT *
FROM NashvilleHousing
-----------------------------------------------------------------------------------------------------------------------------------------------------------



