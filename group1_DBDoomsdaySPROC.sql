-- Stored Procedure Script files
CREATE PROCEDURE DeleteAdversary
    @AdversaryID CHAR(4)
AS
BEGIN
    DELETE FROM Adversaries
    WHERE AdversaryID = @AdversaryID;
END;
GO

CREATE PROCEDURE UpdateInventoryQuantity
    @InventoryID CHAR(4),
    @NewQuantity INT
AS
BEGIN
    UPDATE Inventory
    SET Quantity = @NewQuantity
    WHERE InventoryID = @InventoryID;
END;
GO

CREATE PROCEDURE AddNewAlly
    @AllyID CHAR(4),
    @LocationID CHAR(4),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @TrustLevel NVARCHAR(6)
AS
BEGIN
    INSERT INTO Allies (AllyID, LocationID, AllyFirstName, AllyLastName, TrustLevel)
    VALUES (@AllyID, @LocationID, @FirstName, @LastName, @TrustLevel);
END;
GO

CREATE PROCEDURE GetPeopleByLodging
    @LodgingID CHAR(4)
AS
BEGIN
    SELECT P.PeopleID, P.PeopleFirstName, P.PeopleLastName, P.Age
    FROM People P
    INNER JOIN PeopleLodging PL ON P.PeopleID = PL.PeopleID
    WHERE PL.LodgingID = @LodgingID;
END;
GO