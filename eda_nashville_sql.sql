
Select *
From 
	portfolio_1..NashvilleHousing

select * 
From 
	portfolio_1..NashvilleHousing 
where 
	Bedrooms>5;

select avg(saleprice)
from 
	portfolio_1..NashvilleHousing

select distinct(uniqueID)
from
	portfolio_1..NashvilleHousing


--eg1
-- how many distinct landuse are there 

select count(distinct(landuse))
from 
	portfolio_1..NashvilleHousing
-- there are 39 distinct landuse 

-- eg2
-- Distinct landuse and  their respective avg  sale price

select distinct(landuse),
	avg(saleprice) as avg_saleprice
from 
	portfolio_1..NashvilleHousing
group by
	landuse
order by 
	avg(saleprice) desc

--VACANT COMMERCIAL LAND has higest avg_saleprice
--VACANT ZONED MULTI FAMILY has lowest avg_saleprice

-- eg3


select distinct(SoldAsVacant),
	avg(saleprice) as avg_saleprice
from 
	portfolio_1..NashvilleHousing
group by 
	SoldAsVacant 

-- eg4

Select *
From 
	portfolio_1..NashvilleHousing
order by
	Acreage desc

--max acreage is 160.06


-- eg5

select distinct(yearbuilt),
	count(UniqueID) as nu_of_nashville_housing
from
	portfolio_1..NashvilleHousing
where  
	yearbuilt is not null
group by
	YearBuilt
order by 
	count(UniqueID) desc 
	



-- eg6

select distinct(ownersplitcity) as city,
	count(UniqueID) as nu_of_nashville_housing
from 
	portfolio_1..NashvilleHousing
where
	ownersplitcity is not null 
group by 
	ownersplitcity


-- eg7

select distinct(ownersplitcity) as city,
	avg(saleprice) as avg_saleprice,
	avg(landvalue) as avg_landvalue
from 
	portfolio_1..NashvilleHousing
where
	ownersplitcity is not null 
group by 
	ownersplitcity

-- eg8

select 
	distinct(Month(saledateconverted)) as month,
 
	avg(saleprice) as avg_saleprice,
	avg(landvalue) as avg_landvalue

from 
	portfolio_1..NashvilleHousing
 
group by 
	Month(saledateconverted)
-

-- eg9

select 

	distinct(Month(saledateconverted)) as month,
	count(UniqueID) as nu_of_nashville_housing

from 
	portfolio_1..NashvilleHousing
where 
	YearBuilt > 2000
group by 
	Month(saledateconverted)


--   WINDOW FUNCTIONS

-- eg10

select 
	distinct(Month(saledateconverted)) as month,
    ownersplitcity as city,
	avg(saleprice) over() as avg_saleprice,
	avg(saleprice)  over(partition by  ownersplitcity) as avg_saleprice_city

from 
	portfolio_1..NashvilleHousing
where 
	 ownersplitcity is not null
order by 
	month

-- eg11


select 
	distinct(Month(saledateconverted)) as month,
    ownersplitcity as city,
	count(UniqueID) over() as  nu_of_nashville_housing,
	Count(UniqueID )  over(partition by  ownersplitcity) as nu_of_nashville_housing_city

from 
	portfolio_1..NashvilleHousing
where 
	 ownersplitcity is not null
order by 
	month


-- row_number() , rank() , dense_rank()

--eg12

select 

	distinct(Month(saledateconverted)) as month,
	count(UniqueID) as  nu_of_nashville_housing,

	row_number()  over(order by count(UniqueID)) as "row_number",
	rank()  over(order by count(UniqueID)) as "rank",
	dense_rank() over(order by count(UniqueID)) as "dense_rank"

from 
	portfolio_1..NashvilleHousing
where 
	 ownersplitcity is not null
group by
	Month(saledateconverted)

-- eg13

select 

	ownersplitcity as city,
	count(UniqueID) as  nu_of_nashville_housing,

	row_number()  over(order by count(UniqueID)) as "row_number",
	rank()  over(order by count(UniqueID)) as "rank",
	dense_rank() over(order by count(UniqueID)) as "dense_rank"

from 
	portfolio_1..NashvilleHousing
where 
	 ownersplitcity is not null
group by
	ownersplitcity



-- stored procedures

-- eg14

Create  procedure nashville_data
As
begin
select * 
from
	portfolio_1..NashvilleHousing
end

EXEC nashville_data;
 

-- eg15

Create  procedure nashville_rank_data
As
begin
select 

	ownersplitcity as city,
	count(UniqueID) as  nu_of_nashville_housing,

	row_number()  over(order by count(UniqueID)) as "row_number",
	rank()  over(order by count(UniqueID)) as "rank",
	dense_rank() over(order by count(UniqueID)) as "dense_rank"

from 
	portfolio_1..NashvilleHousing
where 
	 ownersplitcity is not null
group by
	ownersplitcity

end

EXEC nashville_rank_data;


-- eg16


Create  procedure count_nashville
@n int
As
begin
select  

	distinct(Month(saledateconverted)) as month,
	count(UniqueID) as  nu_of_nashville_housing

from 
	portfolio_1..NashvilleHousing
where 
	 ownersplitcity is not null and  Month(saledateconverted)>=@n
group by
	Month(saledateconverted)
end

EXEC count_nashville 10
	

--- PIVOT TABLE CONCEPT

--- eg17

Select 
	Month(saledateconverted) as month ,
	count(case when SoldAsvacant='yes' then UniqueID else null end ) as yes_nasville_houses,
	count(case when SoldAsvacant='no' then UniqueID else null end ) as no_nasville_houses
from
	portfolio_1..NashvilleHousing
group by
	Month(saledateconverted)
order by 
	Month(saledateconverted)

-- eg18

Select 
	Month(saledateconverted) as month ,
	sum(case when SoldAsvacant='yes' then SalePrice else null end ) as yes_avg_saleprice,
	sum(case when SoldAsvacant='no' then SalePrice else null end ) as no_avg_saleprice
from
	portfolio_1..NashvilleHousing
group by
	Month(saledateconverted)
order by 
	Month(saledateconverted)

-- eg20

Select 
	ownersplitcity as city ,
	sum(case when SoldAsvacant='yes' then SalePrice else null end ) as yes_avg_saleprice,
	sum(case when SoldAsvacant='no' then SalePrice else null end ) as no_avg_saleprice
from
	portfolio_1..NashvilleHousing
group by
	ownersplitcity
order by 
	ownersplitcity

-- eg21

Select 
	ownersplitcity as city ,
	sum(case when SoldAsvacant='yes' then bedrooms else null end ) as yes_bedroom_count,
	sum(case when SoldAsvacant='no' then bedrooms else null end ) as no_bedroom_count
from
	portfolio_1..NashvilleHousing
group by
	ownersplitcity
order by 
	ownersplitcity
