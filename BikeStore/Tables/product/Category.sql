CREATE TABLE [product].[Category]
(
	[CategoryId] INT identity(100,1) NOT NULL PRIMARY KEY,
	Name nvarchar(50),
	CustomDataFields nvarchar(max),
	DateModified datetime2,
	DateCreated datetime2 default getdate()
)
