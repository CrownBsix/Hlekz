USE FundiPay
GO

CREATE PROCEDURE [dbo].[GetPeople]
(
@DisplayLegth int,
@DisplayStart int,
@SortCol int,
@SortDir  nvarchar(10),
@Search nvarchar(255) = NULL
)
AS
BEGIN
DECLARE
@FirstRec int,
@LastRec int
SET
@FirstRec=@DisplayStart;
@LastRec = @DisplayStart + @DisplayLegth

;WITH CTE_GetPeople as
(
 SELECT ROW_NUMBER() OVER (ORDER BY 
      CASE WHEN @SortCol = 'FirstName' AND @SortDir='ASC'  
           THEN FirstName  
      END ASC,  
      CASE WHEN @SortCol = 'FirstName' AND @SortDir='DESC'  
           THEN FirstName  
      END DESC,  
      CASE WHEN @SortCol = 'Surname' AND @SortDir='ASC'  
           THEN Surname
      END ASC,  
      CASE WHEN @SortCol = 'Surname' AND @SortDir='DESC'  
           THEN Surname  
      END DESC, 
	  CASE WHEN @SortCol = 'Date_Of_Birth' AND @SortDir='ASC'  
           THEN Date_Of_Birth  
      END ASC,  
      CASE WHEN @SortCol = 'Date_Of_Birth' AND @SortDir='DESC'  
           THEN Date_Of_Birth  
      END DESC,  
      CASE WHEN @SortCol = 'Age' AND @SortDir='ASC'  
           THEN Surname
      END ASC,  
      CASE WHEN @SortCol = 'Age' AND @SortOrder='DESC'  
           THEN Age  
      END DESC  
	  )
	  As
	  RowNum,
	  Count(*) over() as TotalCount,
	   PersonId,
        [FirstName],
        [Surname]
		,[Date_Of_Birth]
		,[Age]
		From [dbo].[Person]
		  WHERE (@Search IS NULL OR [FirstName] LIKE '%' + @Search + '%')  
   OR (@Search IS NULL OR PersonId LIKE '%' + @Search + '%'))

)
SELECT  
   TotalCount,  
   RowNum,  
       [FirstName],
        [Surname]
		,[Date_Of_Birth]
		,[Age]  
 FROM CTE_Results AS Result  
 WHERE RowNum > @FirstRec AND RowNum <= @LastRec  
 ORDER BY RowNum ASC 

END
	  