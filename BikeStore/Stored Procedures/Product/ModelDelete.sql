--*************************************************************************************************************************************
--Created By:	Brian Vander Plaats
--Create Date:	10/16/2015
--Description:	Delete Model Record
--*************************************************************************************************************************************
CREATE PROCEDURE [product].[ModelDelete]
	@ModelID int
AS
	delete from product.Model where ModelID = @ModelID;
