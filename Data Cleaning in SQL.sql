-- Cleaning Data in SQL Queries

select * from NashwilleHousing

--1 Standardize Date Format

select SaleDateConverted, Convert(Date, SaleDate)
from NashwilleHousing

update NashwilleHousing
set SaleDate= CONVERT(date, SaleDate)

alter table NashwilleHousing
add SaleDateConverted date  

update NashwilleHousing
set SaleDateConverted= CONVERT(date, SaleDate)



--2populate property  adress data

select  *
from NashwilleHousing
order by ParcelID


select  a.ParcelID, a.PropertyAddress, b.ParcelID, B.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashwilleHousing  a 
join NashwilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashwilleHousing  a 
join NashwilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


--3breaking out adress into individual columns (address, city, status)


select  PropertyAddress
from NashwilleHousing


select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,  LEN(PropertyAddress)) as Address
from NashwilleHousing

alter table NashwilleHousing
add PropertySplitAddresss nvarchar(255);

update NashwilleHousing
set PropertySplitAddresss= SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

alter table NashwilleHousing
add PropertySplitCity nvarchar(255)

update NashwilleHousing
set PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,  LEN(PropertyAddress))

select * from NashwilleHousing




select OwnerAddress
from NashwilleHousing

select PARSENAME(Replace(OwnerAddress,',','.'),3) as addresss
,PARSENAME(Replace(OwnerAddress,',','.'),2) as city
,PARSENAME(Replace(OwnerAddress,',','.'),1)as state
from NashwilleHousing


alter table NashwilleHousing
add OwnerSplitAddress nvarchar(255)

update NashwilleHousing
set OwnerSplitAddress= PARSENAME(Replace(OwnerAddress,',','.'),3) 

alter table NashwilleHousing
add OwnerSplitState nvarchar(255);

update NashwilleHousing
set OwnerSplitState= PARSENAME(Replace(OwnerAddress,',','.'),1)

alter table NashwilleHousing
add OwnerSplitCity nvarchar(255)

update NashwilleHousing
set OwnerSplitCity= PARSENAME(Replace(OwnerAddress,',','.'),2) 

select *
from NashwilleHousing


--4Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from NashwilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N'then 'No'
else SoldAsVacant
end
from NashwilleHousing

update NashwilleHousing
set SoldAsVacant=case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N'then 'No'
else SoldAsVacant
end 


--5Remove Duplicates
with RownNumCTE as(

select  *,
ROW_NUMBER() over (
partition by ParcelID, 
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order  by UniqueID
			 ) row_num
from NashwilleHousing

)
select *
from RownNumCTE
where row_num>1
order by PropertyAddress


--6delete unused columns
select * 
from NashwilleHousing

ALTER TABLE NashwilleHousing
drop column PropertyAddress, TaxDistrict, OwnerAddress

ALTER TABLE NashwilleHousing
drop column SaleDate


