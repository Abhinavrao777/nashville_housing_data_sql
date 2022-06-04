select * 
from 
	portfolio_1..nashvillehousing;



-- date format

select SaleDate,
	convert(date,saleDate) 
from 
	portfolio_1..nashvillehousing;


alter table portfolio_1..nashvillehousing
Add saledateconverted date

update  portfolio_1..nashvillehousing
set saledateconverted = convert(date,SaleDate)

select * 
from
	portfolio_1..nashvillehousing


---Populate Property Address data
-- null values


Select *
From 
	portfolio_1..nashvillehousing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From portfolio_1..nashvillehousing as  a
JOIN portfolio_1..nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From portfolio_1..nashvillehousing a
JOIN portfolio_1..nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


select count(*)
from
	portfolio_1..nashvillehousing
where 
	PropertyAddress is null   -- null values


--- breaking out  Address into Individual columns (address, city) --propertyaddress

select PropertyAddress 
from 
	portfolio_1..nashvillehousing

select 
substring(PropertyAddress ,1, CHARINDEX(',',PropertyAddress)-1) as  address,
substring(PropertyAddress ,1, CHARINDEX(',',PropertyAddress)-1) as  address
--substring(PropertyAddress ,CHARINDEX(',',PropertyAddress+1),len( PropertyAddress)) as address_city
from 
	portfolio_1..nashvillehousing

select 
substring(PropertyAddress ,1, CHARINDEX(',',PropertyAddress) - 1) as  address,
substring(PropertyAddress ,CHARINDEX(',',PropertyAddress)+ 1,len(PropertyAddress)) as  city

from
	portfolio_1..nashvillehousing

select 
charindex(',',PropertyAddress)
from
	portfolio_1..nashvillehousing



-- creating 2 new column (address and city) propertyaddress



alter table portfolio_1..nashvillehousing
add propertysplitaddress nvarchar (255)

update  portfolio_1..nashvillehousing set
propertysplitaddress=substring(PropertyAddress ,1, CHARINDEX(',',PropertyAddress) - 1)


alter table portfolio_1..nashvillehousing
add propertysplitcity nvarchar (255)

update  portfolio_1..nashvillehousing set
propertysplitcity=substring(PropertyAddress ,1, CHARINDEX(',',PropertyAddress) - 1)


select * 
from 
	portfolio_1..nashvillehousing


--- breaking out  Address into Individual columns (address, city , state) --OwnerAddress

--using function parsename


select OwnerAddress 
from 
	portfolio_1..nashvillehousing


select 
	Parsename(replace(OwnerAddress, ',','.'),3),
	Parsename(replace(OwnerAddress, ',','.'),2),
	Parsename(replace(OwnerAddress, ',','.'),1)
from 
	portfolio_1..nashvillehousing

alter table portfolio_1..nashvillehousing
add ownersplitaddress nvarchar(255)

update portfolio_1..nashvillehousing set
ownersplitaddress=Parsename(replace(OwnerAddress, ',','.'),3)

alter table portfolio_1..nashvillehousing
add ownersplitcity nvarchar(255)

update portfolio_1..nashvillehousing set
ownersplitcity=Parsename(replace(OwnerAddress, ',','.'),2)

alter table portfolio_1..nashvillehousing
add ownersplitstate nvarchar(255)

update portfolio_1..nashvillehousing set
ownersplitstate=Parsename(replace(OwnerAddress, ',','.'),1)



select * 

from 
	portfolio_1..nashvillehousing


--- changing Yes  and No for y and n

select distinct soldasvacant,count(soldasvacant)
from 
		portfolio_1..nashvillehousing
group by 
	soldasvacant

update  portfolio_1..nashvillehousing set
soldasvacant= case
		WHEN soldasvacant='y' then 'yes'
		WHEN soldasvacant='N' then 'no'
		else soldasvacant
		end

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From portfolio_1..NashvilleHousing

)
delete 
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


select *
from 
	portfolio_1..NashvilleHousing


 Select *
From portfolio_1..NashvilleHousing


ALTER TABLE Portfolio_1..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


Select *
From 
	portfolio_1..NashvilleHousing




			





