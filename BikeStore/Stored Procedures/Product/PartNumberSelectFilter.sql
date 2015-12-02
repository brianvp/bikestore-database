--*************************************************************************************************************************************
--Created By:	Brian Vander Plaats
--Create Date:	11/3/2015
--Description:	Retrieves a list of Part Numbers based on a combination of filter fields
--*************************************************************************************************************************************
CREATE PROCEDURE [product].[PartNumberSelectFilter]
	@ModelName nvarchar(100),
	@PartNumberName nvarchar(100),
	@ManufacturerCode nvarchar(25),
	@InventoryPartNumber nvarchar(25),
	@ManufacturerPartNumber nvarchar(25),
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
		md.Name as ModelName, 
		pn.Name as PartNumberName,
		md.ManufacturerCode, 
		pn.PartNumberId,
		pn.InventoryPartNumber,
		pn.ManufacturerPartNumber,
		pn.InvoiceDescription,
		pn.UPC,
		md.CategoryId,
		ct.Name as CategoryName,
		md.[Description], 
		md.Features, 
		model_status.name as ModelStatusName, 
		md.StatusId,
		md.ManufacturerId,
		mf.Name as ManufacturerName,
		pn.ListPrice,
		pn.Cost,
		md.ImageCollection,
		md.CategoryCustomData, 
		md.ManufacturerCustomData,
		md.DateModified,
		md.DateCreated
from product.model md
left join product.PartNumber pn
	on md.ModelId = pn.ModelId
left join product.Category ct
	on md.CategoryId = ct.CategoryId
left join product.Manufacturer mf
	on md.ManufacturerId = mf.ManufacturerId
left join product.[Status] model_status
	on md.StatusId = model_status.StatusId
where ( md.name like '%' + @ModelName + '%' or @ModelName is null ) AND
	  ( pn.name like '%' + @PartNumberName + '%' or @PartNumberName is null ) AND
	  ( md.ManufacturerCode like '%' + @ManufacturerCode + '%' or @ManufacturerCode is null ) AND
	  ( pn.InventoryPartNumber like '%' + @InventoryPartNumber + '%' or @InventoryPartNumber is null ) AND
	  ( pn.ManufacturerPartNumber like '%' + @ManufacturerPartNumber + '%' or @ManufacturerPartNumber is null ) AND
	  ( ct.name like '%' + @CategoryName + '%' or @CategoryName is null ) AND
	  ( md.[Description] like '%' + @Description + '%' or @Description is null ) AND
	  ( md.Features like '%' + @Features + '%' or @Features is null) AND
	  ( pn.ListPrice > @MinListPrice or @MinListPrice is null) AND
	  ( pn.ListPrice < @MaxListPrice or @MaxListPrice is null ) AND
	  ( model_status.Name like '%' + @StatusName + '%' or @StatusName is null ) AND
	  ( mf.Name like '%' + @ManufacturerName + '%' or @ManufacturerName is null )