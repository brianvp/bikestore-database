--*************************************************************************************************************************************
--Created By:	Brian Vander Plaats
--Create Date:	10/16/2015
--Description:	Retrieves a list of models based on a combination of filter fields
--*************************************************************************************************************************************
CREATE PROCEDURE [product].[ModelSelectFilter]
	@Name nvarchar(100),
	@ManufacturerCode nvarchar(25),
	@CategoryName nvarchar(50),
	@Description nvarchar(max),
	@Features	nvarchar(max),
	@MinListPrice money,
	@MaxListPrice money,
	@StatusName nvarchar(50),
	@ManufacturerName nvarchar(100)
AS

set nocount on;

select  md.ModelId, 
		md.Name, 
		md.ManufacturerCode, 
		md.CategoryId,
		ct.Name as CategoryName,
		md.[Description], 
		md.Features, 
		model_status.name as StatusName, 
		md.StatusId,
		md.ManufacturerId,
		mf.Name as ManufacturerName,
		md.ListPrice,
		md.ImageCollection,
		md.CategoryCustomData, 
		md.ManufacturerCustomData,
		md.DateModified,
		md.DateCreated
from product.model md
left join product.Category ct
	on md.CategoryId = ct.CategoryId
left join product.Manufacturer mf
	on md.ManufacturerId = mf.ManufacturerId
left join product.[Status] model_status
	on md.StatusId = model_status.StatusId
where ( md.name like '%' + @Name + '%' or @name is null ) AND
	  ( md.ManufacturerCode like '%' + @ManufacturerCode + '%' or @ManufacturerCode is null ) AND
	  ( ct.name like '%' + @CategoryName + '%' or @CategoryName is null ) AND
	  ( md.[Description] like '%' + @Description + '%' or @Description is null ) AND
	  ( md.Features like '%' + @Features + '%' or @Features is null) AND
	  ( md.ListPrice > @MinListPrice or @MinListPrice is null) AND
	  ( md.ListPrice < @MaxListPrice or @MaxListPrice is null ) AND
	  ( model_status.Name like '%' + @StatusName + '%' or @StatusName is null ) AND
	  ( mf.Name like '%' + @ManufacturerName + '%' or @ManufacturerName is null )