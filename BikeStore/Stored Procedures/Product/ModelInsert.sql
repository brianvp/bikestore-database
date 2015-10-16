--*************************************************************************************************************************************
--Created By:	Brian Vander Plaats
--Create Date:	10/16/2015
--Description:	Add Model record
--*************************************************************************************************************************************
CREATE PROCEDURE [product].[ModelInsert]
	@ModelID int OUTPUT,
	@Name nvarchar(100),
	@ManufacturerCode nvarchar(25),
	@CategoryID int,
	@Description nvarchar(max),
	@Features	nvarchar(max),
	@StatusId	int,
	@ManufacturerId int,
	@ListPrice money,
	@ImageCollection nvarchar(max),
	@CategoryCustomData nvarchar(max),
	@ManufacturerCustomData nvarchar(max)
AS

insert into product.Model 
	(Name,
	ManufacturerCode,
	CategoryId,
	[Description],
	Features,
	StatusId,
	ManufacturerId,
	ListPrice,
	ImageCollection,
	CategoryCustomData,
	ManufacturerCustomData
	)
	values
	( @Name,
		@ManufacturerCode,
		@CategoryID,
		@Description,
		@Features,
		@StatusId,
		@ManufacturerId,
		@ListPrice,
		@ImageCollection,
		@CategoryCustomData,
		@ManufacturerCustomData
	);

	set @ModelID = SCOPE_IDENTITY();