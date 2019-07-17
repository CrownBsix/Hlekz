CREATE PROCEDURE [dbo].[Persons]
(
@PageNumber  INT = 1,
@PageSize INT = 10
)
AS 
BEGIN

IF @PageNumber = 1 
  BEGIN 
        WITH Persons AS
(
    SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) AS RowNumber
          ,PersonId
          ,FirstName
          ,Surname
          ,Date_Of_Birth 
      FROM [dbo].[Person]
)
   
      SELECT * 
  FROM Persons
 WHERE RowNumber BETWEEN (@PageNumber - 1) * @PageSize AND @PageNumber * @PageSize 
 ORDER BY FirstName
 
  END 
ELSE 
  BEGIN 
      
        WITH Persons AS
(
    SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) AS RowNumber
          ,PersonId
          ,FirstName
          ,Surname
          ,Date_Of_Birth 
      FROM [dbo].[Person]
)
   
  SELECT * 
  FROM Persons
 WHERE RowNumber BETWEEN (@PageNumber - 1) * @PageSize + 1 AND @PageNumber * @PageSize 
 ORDER BY FirstName

END
END
GO

