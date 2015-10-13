/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/


-- For loading CSV files
declare @ImportPath nvarchar(200)
declare @command nvarchar(max)
set @ImportPath = '<path to \BikeStore\SampleDataScripts\>'


declare @ManufacturerData table
(
	Name nvarchar(50)
)

insert into @ManufacturerData (Name) 
	values
	('Park Tool'),
	('Trek'),
	('Bontrager'),
	('Garmin'),
	('Felt'),
	('Pinarello')


merge into product.Manufacturer dest
using @ManufacturerData src
	on dest.Name = src.Name
when matched then
	update
		set dest.Name = src.Name
when not matched then
	insert (Name)
	values (Name) ;


declare @CategoryData table
(
	Name nvarchar(50),
	CustomDataFields nvarchar(max)
)

insert into @CategoryData (Name,CustomDataFields) 
	values
	('Road Bikes', '{"Frame":"","Fork":"","Size":"","Fit":"","Wheels":"","Tires":"","Groupset":"","Derailleur":"","Front Sprocket":""}'),
	('Wheels - Carbon',''),
	('Wheels - Tubeless',''),
	('Tires - Road Bike Clincher',''),
	('Saddles - Road Bike',''),
	('Handlebars - Road',''),
	('Bike Computer',''),
	('Bar Tape','')


merge into product.Category dest
using @CategoryData src
	on dest.Name = src.Name
when matched then
	update
		set dest.Name = src.Name,
			dest.CustomDataFields = src.CustomDataFields
when not matched then
	insert (Name, CustomDataFields)
	values (Name, CustomDataFields) ;


declare @StatusData table
(
	Name nvarchar(50)
)

insert into @StatusData (Name) 
	values
	('Announced'),
	('Active'),
	('Inactive'),
	('Discontinued')


merge into product.Status dest
using @StatusData src
	on dest.Name = src.Name
when matched then
	update
		set dest.Name = src.Name
when not matched then
	insert (Name)
	values (Name) ;

-- import Model Data

if object_id('tempdb..#ModelStaging', 'U') is not null
	drop table #ModelStaging

create table #ModelStaging 
(
	Name nvarchar(100),
	ManufacturerCode nvarchar(25),
	CategoryName varchar(25),
	[Description] nvarchar(max),
	[Features] nvarchar(max),
	StatusName nvarchar(25),
	ManufacturerName varchar(25),
	ListPrice	money,
	ImageCollection nvarchar(max),
	CategoryCustomData nvarchar(max),
	ManufacturerCustomData nvarchar(max)
);



set @command = 
'bulk insert #ModelStaging
from '+char(39) + @ImportPath + 'ModelData.txt' + char(39) + '
with
(	FirstRow=2,
	fieldterminator =''\t'',
	rowterminator = ''\n''
)'

exec (@command)


declare @ModelData table
(
	Name nvarchar(100),
	ManufacturerCode nvarchar(25),
	CategoryId int,
	[Description] nvarchar(max),
	[Features] nvarchar(max),
	StatusId int,
	ManufacturerId int,
	ListPrice	money,
	ImageCollection nvarchar(max),
	CategoryCustomData nvarchar(max),
	ManufacturerCustomData nvarchar(max)
);

insert into @ModelData
values 
	('Domane 6.2', '', (select CategoryId from product.Category where Name = 'Road Bikes'), '','', (select StatusId from product.Status where name = 'Active'), (Select ManufacturerID from product.Manufacturer where Name = 'Trek'), 0.00,'','','')
	
insert into @ModelData
select ms.name, ms.ManufacturerCode, cat.CategoryId, ms.[Description],ms.Features, sts.StatusId, mfg.ManufacturerId, ms.ListPrice, ms.ImageCollection, ms.CategoryCustomData, ms.ManufacturerCustomData
from #ModelStaging ms
left join product.Category cat
	on ms.CategoryName = cat.Name
left join product.Status sts
	on ms.StatusName = sts.Name
left join product.Manufacturer mfg
	on ms.ManufacturerName = mfg.Name



merge into product.Model dest
using @ModelData src
	on dest.Name = src.Name
when matched then
	update
		set dest.Name = src.Name,
			dest.ManufacturerCode = src.ManufacturerCode,
			dest.CategoryId = src.CategoryId,
			dest.[Description] = src.[Description],
			dest.Features = src.Features,
			dest.StatusID = src.StatusId,
			dest.ManufacturerId = src.ManufacturerId,
			dest.ListPrice = src.ListPrice,
			dest.ImageCollection = src.ImageCollection,
			dest.CategoryCustomData = src.CategoryCustomData,
			dest.ManufacturerCustomData = src.ManufacturerCustomData
when not matched then
	insert (Name, ManufacturerCode, CategoryId, [Description], Features, StatusId, ManufacturerId, ListPrice, ImageCollection, CategoryCustomData, ManufacturerCustomData)
	values (Name, ManufacturerCode, CategoryId, [Description], Features, StatusId, ManufacturerId, ListPrice, ImageCollection, CategoryCustomData, ManufacturerCustomData) ;



-- Import PartNumber data

if object_id('tempdb..#PartNumberStaging', 'U') is not null
	drop table #PartNumberStaging

create table #PartNumberStaging 
(
	Name nvarchar(100),
	InvoiceDescription nvarchar(50),
	ModelName nvarchar(100),
	StatusName nvarchar(25),
	InventoryPartNumber nvarchar(25),
	ManufacturerPartNumber nvarchar(25),
	CategoryCustomData nvarchar(max),
	ManufacturerCustomData nvarchar(max),
	ListPrice	money,
	Cost		money,
	UPC			nchar(12)
);



set @command = 
'bulk insert #PartNumberStaging
from '+char(39) + @ImportPath + 'PartNumberData.txt' + char(39) + '
with
(	FirstRow=2,
	fieldterminator =''\t'',
	rowterminator = ''\n''
)'

exec (@command)

declare @PartNumberData table
(
	Name nvarchar(100),
	InvoiceDescription nvarchar(50),
	ModelId int,
	StatusId int,
	InventoryPartNumber nvarchar(25),
	ManufacturerPartNumber nvarchar(25),
	CategoryCustomData nvarchar(max),
	ManufacturerCustomData nvarchar(max),
	ListPrice	money,
	Cost		money,
	UPC			nchar(12)
);

insert into @PartNumberData
	values ('56 CM', 'Domane 6.2 56 CM', (select ModelId from product.Model where Name = 'Domane 6.2'), (select StatusId from product.Status where Name = 'Active'), '13400', 'DOMANE6256','','',0.00, 0.00,''),
		   ('58 CM', 'Domane 6.2 58 CM', (select ModelId from product.Model where Name = 'Domane 6.2'), (select StatusId from product.Status where Name = 'Active'), '13401', 'DOMANE6258','','',0.00, 0.00,''),
		   ('52 CM', 'Domane 6.2 52 CM', (select ModelId from product.Model where Name = 'Domane 6.2'), (select StatusId from product.Status where Name = 'Active'), '13402', 'DOMANE6252','','',0.00, 0.00,''),
		   ('55 CM', 'Domane 6.2 55 CM', (select ModelId from product.Model where Name = 'Domane 6.2'), (select StatusId from product.Status where Name = 'Active'), '13403', 'DOMANE6255','','',0.00, 0.00,'')

insert into @PartNumberData
select pns.name, pns.InvoiceDescription, mdl.ModelId, sts.StatusId, pns.InventoryPartNumber, pns.ManufacturerPartNumber, pns.CategoryCustomData, pns.ManufacturerCustomData, pns.ListPrice, pns.Cost, pns.UPC
from #PartNumberStaging pns
left join product.Model mdl
	on pns.ModelName = mdl.Name
left join product.Status sts
	on pns.StatusName = sts.Name


merge into product.PartNumber dest
using @PartNumberData src
	on dest.InventoryPartNumber = src.InventoryPartNumber
when matched then
	update
		set dest.Name = src.Name,
			dest.InvoiceDescription = src.InvoiceDescription,
			dest.ModelId = src.ModelId,
			dest.StatusID = src.StatusId,
			dest.InventoryPartNumber = src.InventoryPartNumber,
			dest.ManufacturerPartNumber = src.ManufacturerPartNumber,
			dest.CategoryCustomData = src.CategoryCustomData,
			dest.ManufacturerCustomData = src.ManufacturerCustomData,
			dest.ListPrice = src.ListPrice,
			dest.Cost = src.Cost,
			dest.UPC = src.UPC		
when not matched then
	insert (Name, InvoiceDescription, ModelId, StatusId, InventoryPartNumber, ManufacturerPartNumber, CategoryCustomData, ManufacturerCustomData, ListPrice, Cost, UPC)
	values (Name, InvoiceDescription, ModelId, StatusId, InventoryPartNumber, ManufacturerPartNumber, CategoryCustomData, ManufacturerCustomData, ListPrice, Cost, UPC) ;
