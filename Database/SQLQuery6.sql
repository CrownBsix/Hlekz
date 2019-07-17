USE [Fundi]
GO
/****** Object:  StoredProcedure [dbo].[AddTransaction]    Script Date: 2019/03/25 09:18:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[AddTransaction]
(
 @CardId INT,
 @Amount Decimal(18,2),
 @Reference NVARCHAR(64),
 @TransactionDate DATETIME
)
AS

INSERT INTO [dbo].[Transaction] ([CardId],[Amount],[Reference],[TransactionDate])
VALUES (@CardId,@Amount,@Reference,@TransactionDate)

