
/*
1. Show all adults.
*/

SELECT * FROM People WHERE Age >= 18;

/*
2. Show all non-adults.
*/
SELECT * FROM People WHERE Age < 18;

/*
3. Find total number of experts.
*/
SELECT 
    COUNT(*) AS TotalExperts
FROM 
    PersonSkills
WHERE 
    SkillLevel = 'Expert';


/*
4. Find total number of experts in each skills.
*/

SELECT 
    s.SkillName, 
    COUNT(ps.PeopleID) AS TotalExperts
FROM 
    skills s
JOIN 
    PersonSkills ps 
ON 
    s.SkillsID = ps.SkillsID
WHERE 
    ps.SkillLevel = 'Expert'
GROUP BY 
    s.SkillName;


/*
5. Retrieve all locations with a high safety level
*/

SELECT * 
FROM Locations 
WHERE LocationSafetyLevel = 'High';


/*
6. Get the total number of people in each lodging
*/

SELECT LodgingID, SUM(LodgingPopulation) AS TotalPeople 
FROM Lodging 
GROUP BY LodgingID;

/*
7. List all inventory items categorized as "High" value
*/

SELECT * 
FROM Inventory 
WHERE InventoryValue = 'High';


/*
8. Count the number of skills at each level
*/

SELECT SkillLevel, COUNT(*) AS TotalSkills 
FROM PersonSkills 
GROUP BY SkillLevel;


/*
9. Show all allies in locations with "High" safety levels
*/

SELECT a.AllyFirstName, a.AllyLastName, l.LocationName 
FROM Allies a
JOIN Locations l ON a.LocationID = l.LocationID 
WHERE l.LocationSafetyLevel = 'High';

/*
10. Find locations connected to power types "Solar" or "Wind"
*/

SELECT l.LocationName, p.PowerType 
FROM LocationPower lp
JOIN Locations l ON lp.LocationID = l.LocationID
JOIN Power p ON lp.PowerID = p.PowerID
WHERE p.FuelType IN ('Solar', 'Wind');


/*
11. Retrieve all lodgings and their capacity utilization (percentage).
*/
SELECT l.LodgingID, 
       (CAST(l.LodgingPopulation AS FLOAT) / l.Capacity * 100) AS CapacityUtilization 
FROM Lodging l;

/*
12. Retrieve the location with the highest population.
*/

SELECT TOP 1 L.LocationName, SUM(L.LocationPopulation) AS TotalPopulation
FROM Locations L
GROUP BY L.LocationName
ORDER BY TotalPopulation DESC;

/* 
13. List all people with their associated location and lodging.
*/
SELECT P.PeopleFirstName, P.PeopleLastName, L.LocationName, Lodging.LodgingID, Lodging.LodgingPopulation
FROM People P
JOIN PeopleLodging PL ON P.PeopleID = PL.PeopleID
JOIN Lodging Lodging ON PL.LodgingID = Lodging.LodgingID
JOIN Locations L ON Lodging.LocationID = L.LocationID;
