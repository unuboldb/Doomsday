ALTER DATABASE [DoomsdayPrepDB]
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;

-- Drop the database
DROP DATABASE [DoomsdayPrepDB];

USE [master]
GO

CREATE DATABASE [DoomsdayPrepDB]
GO

USE [DoomsdayPrepDB]
GO
-- Making the Locations Table
CREATE TABLE [dbo].[Locations]
(
    [LocationID] [char](4) NOT NULL UNIQUE,
    [LocationName] [varchar](50) NOT NULL UNIQUE,
    [LocationType] [varchar](255) NOT NULL,
    [LocationSafetyLevel] [varchar](6) NOT NULL,
    [LocationCapacity] [int],
    [LocationPopulation] [int],
    CONSTRAINT PK_LocationID PRIMARY KEY (LocationID),
    CONSTRAINT CHK_LocationID CHECK (LocationID LIKE 'L%')
) ON [PRIMARY]
GO

-- Making the Water Table
CREATE TABLE [dbo].[Water]
(
    [WaterID] [char](4) NOT NULL UNIQUE,
    [WaterSource] [varchar](50) NOT NULL,
    [WaterType] varchar(25) NOT NULL,
    [WaterQuantity] [decimal](10,2),
    CONSTRAINT PK_WaterID PRIMARY KEY (WaterID),
    CONSTRAINT CHK_WaterID CHECK (WaterID LIKE 'W%'),
    CONSTRAINT CHK_WaterType CHECK (WaterType IN ('Clean', 'Dirty', 'Purified', NULL))
) ON [PRIMARY]
GO

--Making the Food Table
CREATE TABLE [dbo].[Food]
(
    [FoodID] [char](4) NOT NULL UNIQUE,
    [FoodName] [varchar](50) NOT NULL,
    [FoodQuantity] [int] NOT NULL,
    -- FoodExpiryDate is nullable as there are things like canned goods etc.
    [FoodExpiryDate] [date],
    CONSTRAINT PK_FoodID PRIMARY KEY (FoodID),
    CONSTRAINT CHK_FoodID CHECK (FoodID LIKE 'F%')
) ON [PRIMARY]
GO

-- Making the Power Table
CREATE TABLE [dbo].[Power]
(
    [PowerID] [char](4) NOT NULL UNIQUE,
    [PowerType][varchar](50) NOT NULL,
    [FuelType][varchar](15) NOT NULL,
    [Capacity][int],
    CONSTRAINT PK_PowerID PRIMARY KEY (PowerID),
    CONSTRAINT CHK_PowerID CHECK (PowerID LIKE 'O%'),
    CONSTRAINT CHK_PowerType CHECK (PowerType IN ('Battery', 'Generator', 'Grid')),
    CONSTRAINT CHK_FuelType CHECK (FuelType IN ('Solar', 'Gas', 'Wind', 'Nuclear', 'Hydro', 'Coal', 'Battery', 'Bio'))
) ON [PRIMARY]
GO

--Making the People Table
CREATE TABLE [dbo].[People]
(
    [PeopleID] [char](4) NOT NULL UNIQUE,
    [PeopleFirstName] [varchar](50) NOT NULL,
    [PeopleLastName][varchar](50) NOT NULL,
    [Age][int] NOT NULL,
    CONSTRAINT PK_PeopleID PRIMARY KEY (PeopleID),
    CONSTRAINT CHK_PeopleID CHECK (PeopleID LIKE 'P%')
) ON [PRIMARY]
GO

--Making the Skill Table
CREATE TABLE [dbo].[Skills]
(
    [SkillsID][char](4) NOT NULL UNIQUE,
    [SkillName][varchar](50) NOT NULL
    CONSTRAINT PK_SkillsID PRIMARY KEY (SkillsID),
    CONSTRAINT CHK_SkillsID CHECK (SkillsID LIKE 'S%')
) ON [PRIMARY]
GO

--Creating Lodging Table
CREATE TABLE [dbo].[Lodging]
(
    [LodgingID] [char](4) NOT NULL UNIQUE,
    [LocationID] [char](4) NOT NULL,
    [LodgingPopulation][int] NOT NULL,
    [Capacity][int] NOT NULL,
    CONSTRAINT PK_LodgingID PRIMARY KEY (LodgingID),
    CONSTRAINT CHK_LodgingID CHECK (LodgingID LIKE 'D%'),
    CONSTRAINT FK_LocationID1 FOREIGN KEY (LocationID) REFERENCES [Locations](LocationID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ON [PRIMARY]
GO

-- Making the Allies Table
CREATE TABLE [dbo].[Allies]
(
    [AllyID][char](4) NOT NULL UNIQUE,
    [LocationID][char](4) NOT NULL,
    [AllyFirstName][varchar](50) NOT NULL,
    [AllyLastName][varchar](50) NOT NULL,
    [TrustLevel][varchar](6) NOT NULL,
    CONSTRAINT PK_AllyID PRIMARY KEY (AllyID),
    CONSTRAINT CHK_AllyID CHECK (AllyID LIKE 'A%'),
    CONSTRAINT FK_LocationID2 FOREIGN KEY (LocationID) REFERENCES [Locations](LocationID),
    CONSTRAINT CHK_TrustLevel CHECK (TrustLevel IN ('High', 'Medium', 'Low'))
) ON [PRIMARY]
GO

-- Making the Adversaries Table
CREATE TABLE [dbo].[Adversaries]
(
    [AdversaryID][char](4) NOT NULL UNIQUE,
    [LocationID][char](4) NOT NULL,
    [ThreatName][varchar](25) NOT NULL,
    [ThreatLevel][varchar](25) NOT NULL,
    [LastEncountered][date] NOT NULL,
    CONSTRAINT PK_AdversaryID PRIMARY KEY (AdversaryID),
    CONSTRAINT FK_LocationID3 FOREIGN KEY (LocationID) REFERENCES [Locations](LocationID),
    CONSTRAINT CHK_AdversaryID CHECK (AdversaryID LIKE 'V%'),
    CONSTRAINT CHK_ThreatLevel CHECK (ThreatLevel IN ('High', 'Medium', 'Low'))
) ON [PRIMARY]
GO

-- Making the Currency Table
CREATE TABLE [dbo].[Currency]
(
    [CurrencyID][char](4) NOT NULL UNIQUE,
    [CurrencyType][varchar](10) NOT NULL
    CONSTRAINT PK_CurrencyID PRIMARY KEY (CurrencyID),
    CONSTRAINT CHK_CurrencyID CHECK (CurrencyID LIKE 'C%')
) ON [PRIMARY]
GO

-- Making the Inventory Table
CREATE TABLE [dbo].[Inventory]
(
    [InventoryID][char](4) NOT NULL UNIQUE,
    [CurrencyID][char](4) NOT NULL,
    [Category][varchar](255) NOT NULL,
    [Quantity][int] NOT NULL,
    [InventoryValue][varchar](6) NOT NULL,
    [Measurement][varchar](15) NOT NULL,
    CONSTRAINT PK_InventoryID PRIMARY KEY (InventoryID),
    CONSTRAINT CHK_InventoryID CHECK (InventoryID Like 'I%'),
    CONSTRAINT CHK_Value CHECK (InventoryValue IN ('High', 'Medium', 'Low')),
) ON [PRIMARY]
GO

--  LINKING TABLES START

-- Person / Skills Linking Table
CREATE TABLE [dbo].[PersonSkills]
(
    [PeopleID][char](4) NOT NULL,
    [SkillsID][char](4) NOT NULL,
    [SkillLevel][varchar](50) NOT NULL,
    CONSTRAINT PK_People_Skills PRIMARY KEY (PeopleID, SkillsID),
    CONSTRAINT FK_PeopleID1 FOREIGN KEY (PeopleID) REFERENCES [People](PeopleID),
    CONSTRAINT FK_SkillsID FOREIGN KEY (SkillsID) REFERENCES [Skills](SkillsID),
    CONSTRAINT CHK_SkillsLevel CHECK (SkillLevel IN ('Beginner', 'Advanced', 'Expert'))
) ON [PRIMARY]
GO

-- Location / Inventory Linking Table
CREATE TABLE [dbo].[LocationInventory]
(
    [LocationID][char](4) NOT NULL,
    [InventoryID][char](4) NOT NULL,
    CONSTRAINT PK_Location_Inventory PRIMARY KEY (LocationID, InventoryID),
    CONSTRAINT FK_LocationID4 FOREIGN KEY (LocationID) REFERENCES [Locations](LocationID),
    CONSTRAINT FK_InventoryID1 FOREIGN KEY (InventoryID) REFERENCES [Inventory](InventoryID)
) ON [PRIMARY]
GO

-- People / Lodging Linking Table
CREATE TABLE [dbo].[PeopleLodging]
(
    [PeopleID][char](4) NOT NULL,
    [LodgingID][char](4) NOT NULL,
    CONSTRAINT PK_People_Lodging PRIMARY KEY (PeopleID, LodgingID),
    CONSTRAINT FK_PeopleID2 FOREIGN KEY (PeopleID) REFERENCES [People](PeopleID),
    CONSTRAINT FK_LodgingID FOREIGN KEY (LodgingID) REFERENCES [Lodging](LodgingID)
) ON [PRIMARY]
GO

-- Inventory / Food Linking Table
CREATE TABLE [dbo].[InventoryFood]
(
    [InventoryID][char](4) NOT NULL,
    [FoodID][char](4) NOT NULL,
    CONSTRAINT PK_Food_Inventory PRIMARY KEY (InventoryID, FoodID),
    CONSTRAINT FK_InventoryID2 FOREIGN KEY (InventoryID) REFERENCES [Inventory](InventoryID),
    CONSTRAINT FK_FoodID FOREIGN KEY (FoodID) REFERENCES [Food](FoodID)
) ON [PRIMARY]
GO

-- Location / Water Linking Table
CREATE TABLE [dbo].[LocationWater]
(
    [LocationID][char](4) NOT NULL,
    [WaterID][char](4) NOT NULL, 
    CONSTRAINT PK_Location_Water PRIMARY KEY (LocationID, WaterID),
    CONSTRAINT FK_LocationID5 FOREIGN KEY (LocationID) REFERENCES [Locations](LocationID),
    CONSTRAINT FK_WaterID FOREIGN KEY (WaterID) REFERENCES [Water](WaterID)
) ON [PRIMARY]
GO

-- Location / Power Linking Table
CREATE TABLE [dbo].[LocationPower]
(
    [LocationID][char](4) NOT NULL,
    [PowerID][char](4) NOT NULL,
    CONSTRAINT PK_Location_Power PRIMARY KEY (LocationID, PowerID),
    CONSTRAINT FK_LocationID6 FOREIGN KEY (LocationID) REFERENCES [Locations](LocationID),
    CONSTRAINT FK_PowerID FOREIGN KEY (PowerID) REFERENCES [Power](PowerID)
) ON [PRIMARY]
GO

USE [master]
GO
ALTER DATABASE [DoomsdayPrepDB] SET READ_WRITE
GO