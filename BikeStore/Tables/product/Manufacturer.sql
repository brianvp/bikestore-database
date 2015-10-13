CREATE TABLE [product].[Manufacturer]
(
	[ManufacturerId] INT identity(100,1) NOT NULL PRIMARY KEY,
	Name nvarchar(100),
	CustomDataFields nvarchar(max),
	DateModified datetime2,
	DateCreated datetime2 default getdate()
)
