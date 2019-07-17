USE [Fundi]
GO
/****** Object:  StoredProcedure [dbo].[AddCard]    Script Date: 2019/03/25 08:42:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[AddCard]
(
 @CardNumber NVARCHAR(64),
 @Pin NVARCHAR(64)
)
AS

DECLARE @CardRecord TABLE ([CardId] INT)

INSERT INTO [dbo].[Card] (CardNumber,Pin)
OUTPUT [inserted].[CardId]
VALUES (@CardNumber, @Pin)

SELECT [CardId] FROM @CardRecord



