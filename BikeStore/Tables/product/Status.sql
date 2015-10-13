CREATE TABLE [product].[Status]
(
	[StatusId] INT identity(100,1) NOT NULL PRIMARY KEY,
	Name nvarchar(50),
	DateModified datetime2,
	DateCreated datetime2 default getdate()

)
