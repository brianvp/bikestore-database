-- Test Stored procedures
use BikeStore
go

begin tran 
	declare @ModelId int
	declare @CategoryId int
	declare @StatusId int
	declare @ManufacturerId int

	set @CategoryId = (select top 1 CategoryId from product.Category where name = 'Road Bikes')
	set @StatusId = (select top 1 StatusId from product.[Status] where name = 'Active')
	set @ManufacturerId = (select top 1  ManufacturerId from product.Manufacturer where name = 'Trek')

	exec product.ModelInsert @ModelId OUT, 
		 'Domane 4.7', 
		 'DOMANE47',
		 @CategoryId,
		 'Description go here',
		 'Features go here',
		 @StatusId,
		 @ManufacturerId,
		 2800.00,
		 null,
		 null,
		 null

	exec product.ModelSelectByKey @ModelId

	exec product.ModelUpdate
		@ModelId , 
		 'Domane 4.7', 
		 'DOMANE47',
		 @CategoryId,
		 'The 4.7 Series offers top end components at a reasonable price',
		 'Full Ultegra groupset ; Carbon Frame',
		 @StatusId,
		 @ManufacturerId,
		 2800.00,
		 null,
		 null,
		 null
	
	exec product.ModelSelectByKey @ModelId

	exec product.ModelSelectFilter 'Domane', null, null, null,null,null,null,null,null

	exec product.ModelDelete @ModelId

	exec product.ModelSelectByKey @ModelId

rollback