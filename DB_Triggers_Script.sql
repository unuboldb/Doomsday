-- Triggers Script

-- Updates LocationSafetyLevel based on current LocationPopulation
CREATE TRIGGER LocationSafetyLevel
ON [DoomsdayPrepDB].[dbo].[Locations]
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE L
    SET 
        LocationPopulation = I.LocationPopulation, 
        LocationSafetyLevel = 
            CASE 
                WHEN I.LocationPopulation >= 10 THEN 'High'
                WHEN I.LocationPopulation BETWEEN 5 AND 9 THEN 'Medium'
                ELSE 'Low'
            END
    FROM [DoomsdayPrepDB].[dbo].[Locations] L
    INNER JOIN INSERTED I
        ON L.LocationID = I.LocationID;
END;

-- Updated Inventory when a new Low ThreatLevel Adversary is added
CREATE TRIGGER NewAdversaryLow
ON [DoomsdayPrepDB].[dbo].[Adversaries]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted WHERE ThreatLevel = 'Low')
    BEGIN
        UPDATE Inventory
        SET Quantity = CASE
            WHEN Category = 'Clothes' THEN Quantity - 4
            WHEN Category = 'Food' THEN Quantity - 40
            WHEN Category = 'Water' THEN Quantity - 40
            ELSE Quantity
        END
        WHERE Category IN ('Clothes', 'Food', 'Water');
    END
END;

-- Updated Inventory when a new Medium ThreatLevel Adversary is added
CREATE TRIGGER NewAdversaryMedium
ON [DoomsdayPrepDB].[dbo].[Adversaries]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted WHERE ThreatLevel = 'Medium')
    BEGIN
        UPDATE Inventory
        SET Quantity = CASE
            WHEN Category = 'Clothes' THEN Quantity - 15
            WHEN Category = 'Food' THEN Quantity - 90
            WHEN Category = 'Water' THEN Quantity - 80
            WHEN Category = 'Fuel' THEN Quantity - 15
            WHEN Category = 'Tools' THEN Quantity - 3
            ELSE Quantity
        END
        WHERE Category IN ('Clothes', 'Food', 'Water', 'Fuel', 'Tools');
    END
END;

-- Updated Inventory when a new High ThreatLevel Adversary is added
CREATE TRIGGER NewAdversaryHigh
ON [DoomsdayPrepDB].[dbo].[Adversaries]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted WHERE ThreatLevel = 'High')
    BEGIN
        UPDATE Inventory
        SET Quantity = CASE
            WHEN Category = 'Clothes' THEN Quantity - 30
            WHEN Category = 'Food' THEN Quantity - 125
            WHEN Category = 'Water' THEN Quantity - 115
            WHEN Category = 'Ammo' THEN Quantity - 35
            WHEN Category = 'Fuel' THEN Quantity - 30
            WHEN Category = 'Tools' THEN Quantity - 10
            ELSE Quantity
        END
        WHERE Category IN ('Clothes', 'Food', 'Water', 'Ammo', 'Fuel', 'Tools');
    END
END;
