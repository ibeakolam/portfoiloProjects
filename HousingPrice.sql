/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [portfolioProject].[dbo].[Sheet1$]

  --Cleaning data in SQL
  
  select *
  from portfolioproject.dbo.sheet1$


  --Standardizen Date Format
  
  select saleDate, CONVERT(date,saleDate)
  from portfolioproject.dbo.sheet1$

  update portfolioproject.dbo.sheet1$
  set saleDateConverted = CONVERT(date,saleDate)

  alter table portfolioproject.dbo.sheet1$
  add saleDateConverted Date;


   select saleDateConverted, CONVERT(date,saleDate)
  from portfolioproject.dbo.sheet1$


  --Populate property Address date

    select* 
  from portfolioproject.dbo.sheet1$
  --where propertyaddress is null
  order by parcelID

  select a.parcelID, a.propertyaddress, b.parcelID, b.propertyaddress, isnull (a.propertyaddress,b.propertyaddress)
  from portfolioproject.dbo.sheet1$ a
  join portfolioProject.dbo.Sheet1$ b
  on a.parcelID = b.parcelID
  and a.[uniqueID] <> b.[uniqueID]
where a.propertyaddress is null



update a

  set propertyaddress = isnull (a.propertyaddress,b.propertyaddress)
  from portfolioproject.dbo.sheet1$ a
  join portfolioProject.dbo.Sheet1$ b
  on a.parcelID = b.parcelID
  and a.[uniqueID] <> b.[uniqueID]
  where a.propertyaddress is null





  
    select a.parcelID, a.propertyaddress, b.parcelID, b.propertyaddress 
  from portfolioproject.dbo.sheet1$ a
  join portfolioproject.dbo.sheet1$ b
  on a.parcelID = b.parcelID
  where propertyaddress is null


  select 
  SUBSTRING(propertyAddress, 1, charindex(',', propertyaddress)-1) as address
  ,SUBSTRING(propertyAddress,  charindex(',', propertyaddress) +1, len(PROPERTYADDRESS)) as address
 
  from portfolioproject.dbo.sheet1$



  update portfolioproject.dbo.sheet1$
  set owenersplitaddress = SUBSTRING(propertyAddress,  charindex(',', propertyaddress) +1, len(PROPERTYADDRESS))
 

  alter table portfolioproject.dbo.sheet1$
  add propertysplitaddress nvarchar(255);


  update portfolioproject.dbo.sheet1$
  set propertysplitcity =SUBSTRING(propertyAddress,  charindex(',', propertyaddress) +1, len(PROPERTYADDRESS))
 

  alter table portfolioproject.dbo.sheet1$
  add propertysplitcity  nvarchar(255)


  select *
  from portfolioproject.dbo.sheet1$
 

 select owneraddress
  from portfolioproject.dbo.sheet1$
 


 select
 parsename(replace(owneraddress, '.', '.'),1)
 ,parsename(replace(owneraddress, '.', '.'),2)
 ,parsename(replace(owneraddress, '.', '.'),1)
 from portfolioproject.dbo.sheet1$



 
  update portfolioproject.dbo.sheet1$
  set ownersplitaddress = parsename(replace(owneraddress, '.', '.'),1)

  alter table portfolioproject.dbo.sheet1$
  add ownersplitaddress nvarchar(255);


  update portfolioproject.dbo.sheet1$
  set ownersplitcity =parsename(replace(owneraddress, '.', '.'),2)

  alter table portfolioproject.dbo.sheet1$
  add ownersplitcity  nvarchar(255)


  update portfolioproject.dbo.sheet1$
  set ownersplitstate =parsename(replace(owneraddress, '.', '.'),1)

  alter table portfolioproject.dbo.sheet1$
  add ownersplitstate  nvarchar(255)

  select *
  from portfolioproject.dbo.sheet1$


  select distinct (soldasvacant), count(soldasvacant)
  from portfolioproject.dbo.sheet1$
  group by soldasvacant
  order by 2



  --removing duplicates

with row_numCTE as(
  select *,
  row_number() over(
  partition by parcelID,
   propertyaddress,
   saleprice,
   saleDate,
   legalReference
   order by 
   uniqueID
   ) row_num
  from portfolioproject.dbo.sheet1$
  --order by parcelID
  )
  select*
  from row_numCTE
  where row_num >1
  order by propertyaddress

  SELECT*
  from portfolioproject.dbo.sheet1$
  

  --delete unused columns

  alter table portfolioproject.dbo.sheet1$
  drop column Owneraddress,taxDistrict,propertyaddress

  alter table portfolioproject.dbo.sheet1$
  drop column saleDate




select soldasvacant
,case when soldasvacant = 'y' then 'yes'
     when soldasvacant = 'n' then 'no'
	 else soldasvacant
	 end
from portfolioproject.dbo.sheet1$


update portfolioproject.dbo.sheet1$
set soldasvacant = case when soldasvacant = 'y' then 'yes'
     when soldasvacant = 'n' then 'no'
	 else soldasvacant
	 end