USE [Fundi]
GO
/****** Object:  StoredProcedure [dbo].[CreateContact]    Script Date: 2019/03/25 08:55:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CreateContact]
(
	@CellPhone NVARCHAR(64),
	@Email NVARCHAR(64) = NULL
)

AS

	DECLARE @ContactRecord TABLE ([ContactId] INT)

	INSERT INTO [dbo].[Contact] (CellPhone,Email) 
	OUTPUT [inserted].[ContactId]
	VALUES(@CellPhone,@Email)


	SELECT [ContactId] FROM @ContactRecord



	alter table [dbo].[Transaction]
	add Amount decimal(18,2)