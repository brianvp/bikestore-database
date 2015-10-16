CREATE VIEW [product].[ViewModel]
	AS 
	select  md.ModelId, 
			md.Name as ModelName,
			md.ManufacturerCode,  
			md.CategoryId,
			md.[Description], 
			md.Features, 
			model_status.name as ModelStatusName, 
			md.StatusId as ModelStatusID,
			md.ManufacturerId,
			mf.Name as ManufacturerName,
			md.ListPrice as ModelListPrice,
			md.ImageCollection,
			md.CategoryCustomData as ModelCategoryCustomData, 
			md.ManufacturerCustomData as ModelManufacturerCustomData,
			md.DateModified,
			md.DateCreated
from product.model md
left join product.Category ct
	on md.CategoryId = ct.CategoryId
left join product.Manufacturer mf
	on md.ManufacturerId = mf.ManufacturerId
left join product.[Status] model_status
	on md.StatusId = model_status.StatusId

