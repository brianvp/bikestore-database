CREATE TABLE [product].[PartNumber]
(
	[PartNumberId] INT identity(10000,1) NOT NULL PRIMARY KEY,
	Name nvarchar(100),
	InvoiceDescription nvarchar(50),
	ModelId int
		constraint PartNumberModelForeignKey foreign key (ModelId)
			references product.Model (ModelId),
	StatusId int
		constraint PartNumberStatusForeignKey foreign key (StatusId)
			references product.Status (StatusId),
	InventoryPartNumber nvarchar(25),
	ManufacturerPartNumber nvarchar(25),
	CategoryCustomData nvarchar(max),
	ManufacturerCustomData nvarchar(max),
	ListPrice	money,
	Cost		money,
	UPC			nchar(12),
	DateModified datetime2,
	DateCreated datetime2 default getdate() 
)
