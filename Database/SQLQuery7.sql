USE [Fundi]
GO
/****** Object:  StoredProcedure [dbo].[AddCard]    Script Date: 2019/03/25 09:27:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[AddCard]
(
 @ContactId INT,
 @CardNumber NVARCHAR(64),
 @Pin NVARCHAR(64)
)
AS

DECLARE @CardRecord TABLE ([CardId] INT)

INSERT INTO [dbo].[Card] (ContactId,CardNumber,Pin)
OUTPUT [inserted].[CardId]
VALUES (@ContactId,@CardNumber, @Pin)

SELECT [CardId] FROM @CardRecord



select * from [AvailableCard]

select * from [Card]
select * from [Transaction]