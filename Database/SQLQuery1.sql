


CREATE PROCEDURE [dbo].[MarkCardAsIssued]
(
	@CardNumber NVARCHAR(64)
)
AS
	UPDATE [dbo].[AvailableCard]
	SET [Issued] = 1
	WHERE [CardNumber] = @CardNumber
