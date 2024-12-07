USE [master]
GO

CREATE DATABASE [DoomsdayPrepDB]
GO

-- Making the Locations Table
CREATE TABLE [dbo].[Locations]
(
    [LocationID] [char](4) NOT NULL UNIQUE,
    [LocationName] [varchar](50) NOT NULL UNIQUE,
    [LocationType] [varchar](255) NOT NULL,
    [LocationSafetyLevel] [varchar](6) NOT NULL,
    [LocationCapacity] [int] NOT NULL,
    [LocationPopulation] [int] NOT NULL,
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
    CONSTRAINT PK_WaterID PRIMARY KEY (WaterID),
    CONSTRAINT CHK_WaterID CHECK (WaterID LIKE 'W%'),
    CONSTRAINT CHK_WaterType CHECK (WaterType IN ("Clean", "Dirty", "Purified"))
)

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
)

-- Making the Power Table
CREATE TABLE [dbo].[Power]
(
    [PowerID] [char](4) NOT NULL UNIQUE,
    [PowerType][varchar](10) NOT NULL UNIQUE,
    [FuelType][varchar](15) NOT NULL,
    [Capacity][int],
    CONSTRAINT PK_PowerID PRIMARY KEY (PowerID),
    CONSTRAINT CHK_PowerID CHECK (PowerID LIKE 'O%'),
    CONSTRAINT CHK_PowerType CHECK (PowerType IN ("Battery", "Generator", "Grid")),
    CONSTRAINT CHK_FuelType CHECK (FuelType IN ("Solar", "Gas", "Wind", "Nuclear", "Hydro", "Coal", "Lithium"))
)
