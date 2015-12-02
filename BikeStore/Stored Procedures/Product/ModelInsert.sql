--*************************************************************************************************************************************
--Created By:	Brian Vander Plaats
--Create Date:	10/16/2015
--Description:	Add Model record
-- 11/3/2015 bvp - add select option for extracting ModelId
-- 11/4/2014 bvp - set default value of @ModelId to null - gets around EF Code First mapping issue
--*************************************************************************************************************************************
CREATE PROCEDURE [product].[ModelInsert]
	@ModelId int = null OUTPUT,
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

	select ModelId
	from product.Model
	where @@ROWCOUNT > 0 and ModelId = SCOPE_IDENTITY()