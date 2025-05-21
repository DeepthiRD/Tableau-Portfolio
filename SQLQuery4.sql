/*
Cleaning Data Using SQL
*/

Select * from 
[Nashvilla Housing].dbo.NashvilleHousingTbl

--Standardise Date Format

Select SaleDateConverted, Convert(DATE, SaleDate)
from [Nashvilla Housing].dbo.NashvilleHousingTbl


ALTER TABLE [Nashvilla Housing].dbo.NashvilleHousingTbl
ADD SaleDateConverted Date;

Update [Nashvilla Housing].dbo.NashvilleHousingTbl
SET SaleDateConverted = CONVERT(DATE,SaleDate)

--Populate Property Address

Select * from 
[Nashvilla Housing].dbo.NashvilleHousingTbl
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress from 
[Nashvilla Housing].dbo.NashvilleHousingTbl a JOIN
[Nashvilla Housing].dbo.NashvilleHousingTbl b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Nashvilla Housing].dbo.NashvilleHousingTbl a JOIN
[Nashvilla Housing].dbo.NashvilleHousingTbl b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


-----------------------------------------------------------------------

--Breaking Address into Indvidual Columns(Address,City,State)

Select PropertyAddress from 
[Nashvilla Housing].dbo.NashvilleHousingTbl
--where PropertyAddress is null
--order by ParcelID


ALTER TABLE [Nashvilla Housing].dbo.NashvilleHousingTbl
ADD PropertySplitAddress Nvarchar(255);

Update [Nashvilla Housing].dbo.NashvilleHousingTbl
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE [Nashvilla Housing].dbo.NashvilleHousingTbl
ADD PropertySplitCity Nvarchar(255);

Update [Nashvilla Housing].dbo.NashvilleHousingTbl
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
from 
[Nashvilla Housing].dbo.NashvilleHousingTbl

Select OwnerAddress from 
[Nashvilla Housing].dbo.NashvilleHousingTbl
--where PropertyAddress is null
--order by ParcelID

select 
*
from [Nashvilla Housing].dbo.NashvilleHousingTbl

ALTER TABLE [Nashvilla Housing].dbo.NashvilleHousingTbl
ADD OwnerSplitAddress Nvarchar(255);

Update [Nashvilla Housing].dbo.NashvilleHousingTbl
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE [Nashvilla Housing].dbo.NashvilleHousingTbl
ADD OwnerSplitCity Nvarchar(255);

Update [Nashvilla Housing].dbo.NashvilleHousingTbl
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE [Nashvilla Housing].dbo.NashvilleHousingTbl
ADD OwnerSplitState Nvarchar(255);

Update [Nashvilla Housing].dbo.NashvilleHousingTbl
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


---------------------------------------------------------------------
------Change Y and N to Yes and No in "Sold as Vacant" feild

select distinct SoldAsVacant
from [Nashvilla Housing].dbo.NashvilleHousingTbl


select 
case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
ELSE SoldAsVacant
END
from [Nashvilla Housing].dbo.NashvilleHousingTbl

update [Nashvilla Housing].dbo.NashvilleHousingTbl
set SoldAsVacant = case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
ELSE SoldAsVacant
END


------------------------------------------------------------------------
--Remove Duplicates

WITH RownumCte AS
(
select *,
ROW_NUMBER() Over (
Partition By 
        ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		Order by
		    UniqueID
			) row_num
from [Nashvilla Housing].dbo.NashvilleHousingTbl
--order by ParcelID
)
Delete
from RownumCte
where row_num>1


---------------------------------------------------------------------------------------
----Delete Unused Columns

ALTER TABLE [Nashvilla Housing].dbo.NashvilleHousingTbl
Drop Column OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE [Nashvilla Housing].dbo.NashvilleHousingTbl
Drop Column SaleDate



