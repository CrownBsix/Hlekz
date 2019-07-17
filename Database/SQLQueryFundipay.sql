USE FundiPAy
GO

CREATE TABLE [dbo].[Contact]
(
 [ContactId] INT IDENTITY (1,1) NOT NULL,
 [MobileNumber] NVARCHAR(64) NOT NULL,
 [Email] NVARCHAR(64) NULL,
 CONSTRAINT [PK_Contacts_ContactId] PRIMARY KEY([ContactId]),
 CONSTRAINT [CK_Contacts_MobileNumber] CHECK(LEN([MobileNumber])<>(0)),
)

GO

CREATE PROCEDURE [dbo].[CreateContact]
(
 @MobileNumber NVARCHAR(64),
 @Email NVARCHAR(64)=NULL
  )
AS
 BEGIN
 DECLARE @ContactRecord TABLE ([ContactId] INT);

 INSERT INTO [dbo].[Contact]([MobileNumber],[Email])
 OUTPUT [INSERTED].[ContactId]
 VALUES(@MobileNumber,@Email)

 SELECT [ContactId] FROM @ContactRecord
 END;
 GO

 CREATE TABLE [dbo].[Card]
 (

  CardId INT IDENTITY(1,1) NOT NULL,
  ContactId INT NOT NULL,
  CardNumber NVARCHAR(64) NOT NULL,
  Pin NVARCHAR(64) NOT NULL,
  CONSTRAINT [PK_Card_CardId] PRIMARY KEY ([CardId]),
  CONSTRAINT [FK_Card_Contact_ContactId] FOREIGN KEY ([ContactId]) REFERENCES [dbo].[Contact] ([ContactId]),

 )
 GO

 CREATE PROCEDURE [dbo].[CreateCard]
 (
  @ContactId INT,
  @CardNumber NVARCHAR(64),
  @Pin NVARCHAR(64)
 )
 AS
 BEGIN

 DECLARE @CreateCardRecord TABLE ([CardId] INT);
 
 INSERT INTO [dbo].[CreateCard]([ContactId],[CardNumber],[Pin])
 OUTPUT [INSERTED].[CardId]
 VALUES(@ContactId,@CardNumber,@Pin)

 SELECT [CardId] FROM @CreateCardRecord
 

 END
 GO

 CREATE TABLE [dbo].[Transaction]
 (
  TransactionId INT IDENTITY(1,1) NOT NULL,
  CardId INT NOT NULL,
  Amount DECIMAL(19,2) NOT NULL,
  Reference NVARCHAR(64) NOT NULL,
  TransactionDate DATETIME NOT NULL,
  CONSTRAINT[PK_Transaction_TransactionId] PRIMARY KEY([TransactionId]),
  CONSTRAINT [FK_Transaction_Card_CardId] FOREIGN KEY([CardId]) REFERENCES [dbo].[Card] ([CardId]),
  CONSTRAINT [CK_Transaction_Amount] CHECK (LEN([Amount])<>(0)),
  CONSTRAINT [CK_Transaction_Reference] CHECK (LEN([Reference])<>(0)),

 )
 GO

CREATE PROCEDURE [dbo].[CreateTransaction]
 (
  @CardId INT ,
  @Amount NVARCHAR(64),
  @Reference DECIMAL(18,2),
  @TransactionDate DATETIME
 )
 AS
 
 INSERT INTO [dbo].[CreateTransaction] ([CardId],[Amount],[Reference],[TransactionDate])
 VALUES (@CardId,@amount,@Reference,@TransactionDate)

 GO

CREATE TABLE [dbo].[AvailableCard]
( 
  AvailableCardId INT IDENTITY(1,1) NOT NULL,
  CardNumber NVARCHAR(64) NOT NULL,
  Issued INT NOT NULL,
  CONSTRAINT [PK_AvailableCard_AvailableCardId] PRIMARY KEY([AvailableCardId]),
  CONSTRAINT [CK_AvailableCard_CardNumber] CHECK (LEN([CardNumber])<>(0)),

 )

 
 GO
 
 ALTER PROCEDURE [dbo].[MarkCardAsIssued]
 (
  @CardNumber NVARCHAR(64)

 )
 AS
 
 UPDATE [dbo].[AvailableCard]
 SET [Issued] = 1
 WHERE [CardNumber] =@CardNumber
 
 GO

 CREATE PROCEDURE [dbo].[RetrieveAvailableCard]
 
 AS
 SELECT [AvailableCardId],[CardNumber]
 FROM [dbo].[AvailableCard]
 WHERE [Issued]=0

 DECLARE	@return_value int

EXEC	@return_value = [dbo].[RetrieveAvailableCard]

SELECT	'Return Value' = @return_value
 
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
INSERT INTO [dbo].[Transaction] ([CardId],[Amount],[Reference],[TransactionDate])
VALUES (@CardId,@Amount,@Reference,@TransactionDate)

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

CREATE PROCEDURE [dbo].[MarkCardAsIssued]
(
	@CardNumber NVARCHAR(64)
)
AS
	UPDATE [dbo].[AvailableCard]
	SET [Issued] = 1
	WHERE [CardNumber] = @CardNumber

	CREATE TABLE [dbo].[Person]
(
[PersonId] INT IDENTITY(1,1) NOT NULL,
[FirstName] NVARCHAR(60) NOT NULL,
[Surname] NVARCHAR(60) NOT NULL,
[DateOfBirth] DATETIME NOT NULL,
[Age] INT NOT NULL,
CONSTRAINT[PK_Person_PersonId] PRIMARY KEY([PersonId]),
CONSTRAINT[CK_Person_FirstName] CHECK(LEN([FirstName])<>(0)),
CONSTRAINT[CK_Person_Surname] CHECK(LEN([Surname])<>(0))
)

INSERT INTO [dbo].[Person] VALUES ('Crown','Ndlala',getdate(),30),('Sakhile','baloyi',getdate(),30),('Madodo','Bvuma',getdate(),30),('Hlekani','Sabela',getdate(),30),('Akhisizwa','Sidodi',getdate(),30),('Precious','Lolwane',getdate(),30),('Mamphala','Kgatla',getdate(),30),('Kgomotso','Mkharrhi',getdate(),30),('Wilson','Mnkasi',getdate(),30),('Excellent','Nkomo',getdate(),30),('Jerry','Mathebula',getdate(),30),('Julius','Siwape',getdate(),30),('Sharon','Mabunda',getdate(),30),('Terry','Ngobeni',getdate(),30),('Success','Ndobeni',getdate(),30),('Leon','Nkuna',getdate(),30),('Fourie','Bvuma',getdate(),30),('Clive','Baloyi',getdate(),30),('Madala','Mahlawule',getdate(),30),('Region','Mkansi',getdate(),30),('Sonnyboy','makhubele',getdate(),30),('Raymond','Mdaka',getdate(),30)

---Works in SQL 2017 for paging,Filtering and sorting
CREATE PROCEDURE [dbo].[Person]
(
	@SearchValue NVARCHAR(50) = NULL,
	@PageNumber INT = 1,
	@PageSize INT = 10,
	@SortColumn NVARCHAR(20) = 'FirstName',
	@SortOrder NVARCHAR(20) = 'ASC'
)
 AS BEGIN
 SET NOCOUNT ON;

 SET @SearchValue = LTRIM(RTRIM(@SearchValue))

 ;WITH CTE_Results AS 
(
    SELECT PersonId, FirstName, Surname,DateOfBirth,Age FROM [dbo].[Person] 
	WHERE (@SearchValue IS NULL OR FirstName LIKE '%' + @SearchValue + '%') 
	 	    ORDER BY
   	 CASE WHEN (@SortColumn = 'FirstName' AND @SortOrder='ASC')
                    THEN FirstName
        END ASC,
        CASE WHEN (@SortColumn = 'FirstName' AND @SortOrder='DESC')
                   THEN FirstName
		END DESC,
	 CASE WHEN (@SortColumn = 'Surname' AND @SortOrder='ASC')
                    THEN Surname
        END ASC,
        CASE WHEN (@SortColumn = 'Surname' AND @SortOrder='DESC')
                   THEN Surname
				   END DESC,
	 CASE WHEN (@SortColumn = 'DateOfBirth' AND @SortOrder='ASC')
                    THEN DateOfBirth
        END ASC,
        CASE WHEN (@SortColumn = 'DateOfBirth' AND @SortOrder='DESC')
                   THEN DateOfBirth
				   			   END DESC,
	 CASE WHEN (@SortColumn = 'Age' AND @SortOrder='ASC')
                    THEN Age
        END ASC,
        CASE WHEN (@SortColumn = 'Age' AND @SortOrder='DESC')
                   THEN Age
		END DESC 
      OFFSET @PageSize * (@PageNo - 1) ROWS
      FETCH NEXT @PageSize ROWS ONLY
	),
CTE_TotalRows AS 
(
 SELECT COUNT(PersonId) AS MaxRows FROM [dbo].[Person] WHERE (@SearchValue IS NULL OR FirstName LIKE '%' + @SearchValue + '%')
)
   SELECT MaxRows, t.PersonId, t.FirstName,t.Surname t.DateOfBirth,t.Age FROM [dbo].[Person] AS t, CTE_TotalRows 
   WHERE EXISTS (SELECT 1 FROM CTE_Results WHERE CTE_Results.PersonId = t.PersonId)
   OPTION (RECOMPILE)
   END
GO
---Works in SQL 2017

SELECT [PersonId],[FirstName],[Surname],[DateOfBirth],[Age] FROM [dbo].[Person]
ORDER BY [FirstName]
OFFSET 5 ROWS
FETCH NEXT 10 ROWS ONLY

---Works in SQL 2017

SELECT
  PersonId,FirstName,Surname,Age 
FROM [dbo].[Person]
 ORDER BY PersonId
  OFFSET (@PageNo - 1) * @RowCountPerPage ROWS
  FETCH NEXT @RowCountPerPage ROWS ONLY


  ----WORKING IN SQL LESS 2012
  

DECLARE @PageNum AS INT;
DECLARE @PageSize AS INT;
SET @PageNum = 8;
SET @PageSize = 10;

IF @PageNum = 1 
  BEGIN 
        WITH Persons AS
(
    SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) AS RowNum
          ,PersonId
          ,FirstName
          ,Surname
          ,DateOfBirth 
      FROM [dbo].[Person]
)
   
      SELECT * 
  FROM Persons
 WHERE RowNum BETWEEN (@PageNum - 1) * @PageSize AND @PageNum * @PageSize 
 ORDER BY FirstName
 
  END 
ELSE 
  BEGIN 
      
        WITH Persons AS
(
    SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) AS RowNum
          ,PersonId
          ,FirstName
          ,Surname
          ,DateOfBirth 
      FROM [dbo].[Person]
)
   
  SELECT * 
  FROM Persons
 WHERE RowNum BETWEEN (@PageNum - 1) * @PageSize + 1 AND @PageNum * @PageSize 
 ORDER BY FirstName

END
GO
WITH Persons AS
(
    SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) AS RowNum
          ,PersonId
          ,FirstName
          ,Surname
          ,DateOfBirth 
      FROM [dbo].[Person]
)
  SELECT * 
  FROM Persons
 WHERE RowNum BETWEEN (@PageNum - 1) * @PageSize + 1 AND @PageNum * @PageSize 
 ORDER BY FirstName
  
