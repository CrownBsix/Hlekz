USE FundiPay
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
 --INSERT INTO [dbo].[AvailableCard] VALUES('256958746','0'),('697512569','0'),('125698753','0'),('253649853','0'),('125698756','0'),('175698236','0'),('475698236','0'),('987632519','0'),('014567289','0'),('903652891','0'),('305698458','0'),('198659852','0'),('50642398','0'),('304586972','0'),('256498642','0'),('013654986','0'),('102365489','0'),('906354698','0'),('806954698','0'),('32369587','0'),('697458690','0'),('456985698','0'),('032546894','0'),('685469523','0'),('987569246','0'),('695874586','0')
 
 GO
 
 CREATE PROCEDURE [dbo].[MarkCardAsIssued]
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

CREATE TABLE [dbo].[Person]
(
[PersonId] INT IDENTITY(1,1) NOT NULL,
[FirstName] NVARCHAR(60) NOT NULL,
[Surname] NVARCHAR(60) NOT NULL,
[Date_Of_Birth] DATETIME NOT NULL,
[Age] INT NOT NULL,
CONSTRAINT[PK_Person_PersonId] PRIMARY KEY([PersonId]),
CONSTRAINT[CK_Person_FirstName] CHECK(LEN([FirstName])<>(0)),
CONSTRAINT[CK_Person_Surname] CHECK(LEN([Surname])<>(0))
)
 
CREATE PROCEDURE [dbo].[Get_Persons]
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
		  ,Age
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
		  ,Age
      FROM [dbo].[Person]
)
   
  SELECT * 
  FROM Persons
 WHERE RowNumber BETWEEN (@PageNumber - 1) * @PageSize + 1 AND @PageNumber * @PageSize 
 ORDER BY FirstName

END
END
GO

--INSERT INTO [dbo].[Person] VALUES ('Crown','Ndlala',getdate(),30),('Sakhile','baloyi',getdate(),30),('Madodo','Bvuma',getdate(),30),('Hlekani','Sabela',getdate(),30),('Akhisizwa','Sidodi',getdate(),30),('Precious','Lolwane',getdate(),30),('Mamphala','Kgatla',getdate(),30),('Kgomotso','Mkharhi',getdate(),30),('Wilson','Ndlala',getdate(),30),('Excellent','Nkomo',getdate(),30),('Sipho','Ngobeni',getdate(),30),('Julius','Siwape',getdate(),30),('Sharon','Mabunda',getdate(),30),('Terry','Ngobeni',getdate(),30),('Success','Ndobeni',getdate(),30),('Leon','Nkuna',getdate(),30),('Fourie','Bvuma',getdate(),30),('Clive','Baloyi',getdate(),30),('Madala','Mahlawule',getdate(),30),('Region','Mkansi',getdate(),30),('Sonnyboy','makhubele',getdate(),30),('Raymond','Mdaka',getdate(),30)
                                 -- ,('Hlekz','Ndlala',getdate(),30),('Nyiko','Khosa',getdate(),30),('Nnana','Ramoshaba',getdate(),30),('Mavona','Nkuna',getdate(),30),('Gladness','Mabunda',getdate(),30),('Precious','Mathebula',getdate(),30),('Ralph','Kgatla',getdate(),30),('Ndzhaka','Mkharhi',getdate(),30),('Madala','Mnkasi',getdate(),30),('Ntiyislani','Manyama',getdate(),30),('Dzunani','Mathebula',getdate(),30),('Julius','Baloyi',getdate(),30),('Shanane','Rikhotso',getdate(),30),('Gladness','Ngobeni',getdate(),30),('Success','Ndobeni',getdate(),30),('Leon','Nkuna',getdate(),30),('Clive','Bvuma',getdate(),30),('Clive','Baloyi',getdate(),30),('Madala','Mahlawule',getdate(),30),('Region','Mkansi',getdate(),30),('Sonnyboy','makhubele',getdate(),30),('Madoda','Bvuma',getdate(),30)
								  --,('Imes','Baloyi',getdate(),30),('Tinyiko','baloyi',getdate(),30),('Mmphala','Bvuma',getdate(),30),('Mumsy','Mathebula',getdate(),30),('rejoice','Sidodi',getdate(),30),('Akani','Lolwane',getdate(),30),('Masingita','Kgatla',getdate(),30),('Kgomotso','Mhlarhi',getdate(),30),('Nicolous','Mnkasi',getdate(),30),('Excellent','Nkomo',getdate(),30),('Jerry','Mashele',getdate(),30),('Julius','Siwape',getdate(),30),('Charmaine','Mabunda',getdate(),30),('Ntsako','Ngobeni',getdate(),30),('Success','Bvuma',getdate(),30),('Leon','Nkuna',getdate(),30),('Sheldah','Bvuma',getdate(),30),('Clive','Baloyi',getdate(),30),('Madala','Mahlawule',getdate(),30),('Region','Mkansi',getdate(),30),('Sonnyboy','makhubele',getdate(),30),('Raymond','Mdaka',getdate(),30)
								  --,('Brigton','Ndlala',getdate(),30),('Ruel','Mongwe',getdate(),30),('Risuna','Sabela',getdate(),30),('Devine','Sabela',getdate(),30),('Joyce','Mabunda',getdate(),30),('Precious','Bvuma',getdate(),30),('Lukan','Kgatla',getdate(),30),('Mpfumelani','Mkharhi',getdate(),30),('Imes','Mnkasi',getdate(),30),('Joel','Nkomo',getdate(),30),('Jerry','Mathebula',getdate(),30),('George','Siwape',getdate(),30),('Sharon','Manyama',getdate(),30),('Terry','Ngobeni',getdate(),30),('Success','Ndobeni',getdate(),30),('Leon','Nkuna',getdate(),30),('Fourie','Bvuma',getdate(),30),('Clive','Mnkasi',getdate(),30),('Madala','Mahlawule',getdate(),30),('Region','Mkansi',getdate(),30),('Sonnyboy','makhubele',getdate(),30),('Raymond','Mdaka',getdate(),30)
								  --,('Madala','Mnkasi',getdate(),30),('Luyanda','baloyi',getdate(),30),('Hundzukani','Bvuma',getdate(),30),('Tshiketani','Mkasi',getdate(),30),('Glen','Sidodi',getdate(),30),('Wilson','Lolwane',getdate(),30),('Kenny','Kgatla',getdate(),30),('Loraine','Mkhrrhi',getdate(),30),('July','Mnkasi',getdate(),30),('Given','Nkomo',getdate(),30),('Jerry','Nkonwana',getdate(),30),('Organ','Siwape',getdate(),30),('Nsovo','Nhlambathi',getdate(),30),('Terry','Ngobeni',getdate(),30),('Success','Ndlala',getdate(),30),('Leon','Nkuna',getdate(),30),('Fourie','Bvuma',getdate(),30),('Clive','Baloyi',getdate(),30),('Madala','Mahlawule',getdate(),30),('Region','Mkansi',getdate(),30),('Sonnyboy','makhubele',getdate(),30),('Raymond','Mdaka',getdate(),30)


