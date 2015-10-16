--*************************************************************************************************************************************
--Created By:	Brian Vander Plaats
--Create Date:	10/16/2015
--Description:	Retrieve single Model record for specified key ; Retrieves all model fields needed for update, as
--				well as lookup data for display
--*************************************************************************************************************************************
CREATE PROCEDURE [product].[ModelSelectByKey]
	@ModelId int
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
where md.ModelId = @ModelId