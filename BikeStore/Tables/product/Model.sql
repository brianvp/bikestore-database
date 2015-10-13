CREATE TABLE [product].[Model]
(
	[ModelId] INT identity(10000,1) NOT NULL PRIMARY KEY,
	Name nvarchar(100),
	ManufacturerCode nvarchar(25),
	CategoryId int,
	[Description] nvarchar(max),
	[Features] nvarchar(max),
	StatusId int
		constraint ModelStatusForeignKey foreign key (StatusId)
			references product.Status (StatusId),
	ManufacturerId int,
	ListPrice	money,
	ImageCollection nvarchar(max),
	CategoryCustomData nvarchar(max),
	ManufacturerCustomData nvarchar(max),
	DateModified datetime2,
	DateCreated datetime2 default getdate(), 
    CONSTRAINT [ModelManufacturerForeignKey] FOREIGN KEY (ManufacturerId) REFERENCES product.Manufacturer(ManufacturerId),
	constraint [ModelCategoryForeignKey] foreign key (CategoryId) references product.Category (CategoryId)

)
