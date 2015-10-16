CREATE VIEW [product].[ViewPartNumber]
	AS 
	select  md.ModelId, 
			pn.PartNumberId, 
			pn.InventoryPartNumber, 
			pn.ManufacturerPartNumber,
			md.Name as ModelName, 
			md.ManufacturerCode, 
			ct.Name as CategoryName, 
			md.CategoryId,
			md.[Description], 
			md.Features, 
			model_status.name as ModelStatusName, 
			md.StatusId as ModelStatusID,
			md.ManufacturerId,
			mf.Name as ManufacturerName,
			md.ListPrice as ModelListPrice, 
			pn.Name as PartNumberName,
			pn.InvoiceDescription, 
			pn.ListPrice,
			pn.Cost,
			case when pn.Cost is null or pn.Cost = 0.00 then 0.00
				else (pn.ListPrice - pn.Cost) / pn.ListPrice * 100 
			end as PartNumberMarginPercent, 
			pn.UPC,
			md.ImageCollection, 
			md.CategoryCustomData as ModelCategoryCustomData, 
			md.ManufacturerCustomData as ModelManufacturerCustomData,
			pn.CategoryCustomData as PartNumberCategoryCustomData,
			pn.ManufacturerCustomData as PartNumberManufacturerCustomData,
			md.DateModified as ModelDateModified,
			md.DateCreated as ModelDateCreated,
			pn.DateModified as PartNumberDateModified,
			pn.DateCreated as PartNumberDateCreated
from product.PartNumber pn
inner join product.model md
	on pn.ModelId = md.ModelId
left join product.Category ct
	on md.CategoryId = ct.CategoryId
left join product.Manufacturer mf
	on md.ManufacturerId = mf.ManufacturerId
left join product.[Status] model_status
	on md.StatusId = model_status.StatusId
left join product.[Status] partnumber_status
	on pn.StatusId = partnumber_status.StatusId
