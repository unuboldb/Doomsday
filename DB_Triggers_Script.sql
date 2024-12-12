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



