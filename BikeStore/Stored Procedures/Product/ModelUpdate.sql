--*************************************************************************************************************************************
--Created By:	Brian Vander Plaats
--Create Date:	10/16/2015
--Description:	Update Model record
--*************************************************************************************************************************************
CREATE PROCEDURE [product].[ModelUpdate]
	@ModelId int,
	@Name nvarchar(100),
	@ManufacturerCode nvarchar(25),
	@CategoryId int,
	@Description nvarchar(max),
	@Features	nvarchar(max),
	@StatusId	int,
	@ManufacturerId int,
	@ListPrice money,
	@ImageCollection nvarchar(max),
	@CategoryCustomData nvarchar(max),
	@ManufacturerCustomData nvarchar(max)
AS

update product.Model
	set Name = @Name,
		ManufacturerCode = @ManufacturerCode,
		CategoryId = @CategoryId,
		[Description] = @Description,
		Features = @Features,
		StatusId = @StatusId,
		ManufacturerId = @ManufacturerId,
		ListPrice = @ListPrice,
		ImageCollection = @ImageCollection,
		CategoryCustomData = @CategoryCustomData,
		ManufacturerCustomData = @ManufacturerCustomData
where ModelID = @ModelID