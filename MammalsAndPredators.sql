USE master;
DROP DATABASE IF EXISTS MammalsAndPredators;
CREATE DATABASE MammalsAndPredators;
USE MammalsAndPredators;

CREATE TABLE Animal
(
	id INT IDENTITY NOT NULL PRIMARY KEY,
	name NVARCHAR(20) NOT NULL,
	type NVARCHAR(20) NOT NULL,
	class NVARCHAR(20) NOT NULL
) AS NODE;

CREATE TABLE Habitat
(
	id INT IDENTITY NOT NULL PRIMARY KEY,
	name NVARCHAR(20) NOT NULL
) AS NODE;

CREATE TABLE Class
(
	id INT IDENTITY NOT NULL PRIMARY KEY,
	name NVARCHAR(20) NOT NULL
) AS NODE;

CREATE TABLE IsFoodFor AS EDGE;

CREATE TABLE LocatedIn AS EDGE;

CREATE TABLE InCLass AS EDGE;

ALTER TABLE IsFoodFor ADD CONSTRAINT EC_IsFoodFor CONNECTION (Animal TO Animal);
ALTER TABLE LocatedIn ADD CONSTRAINT EC_LocatedIn CONNECTION (Animal TO Habitat);
ALTER TABLE InClass ADD CONSTRAINT EC_InClass CONNECTION (Animal TO Class);


INSERT INTO Animal (name, type, class)
VALUES 
	(N'Lion', N'Mammal', N'Carnivore'),
	(N'Eagle', N'Bird', N'Bird of Prey'),
	(N'Salmon', N'Fish', N'Anadromous'),
	(N'Python', N'Reptile', N'Constrictor'),
	(N'Frog', N'Amphibian', N'Anura'),
	(N'Butterfly', N'Insect', N'Lepidoptera'),
	(N'Tarantula', N'Arachnid', N'Theraphosidae'),
	(N'Lobster', N'Crustacean', N'Decapoda'),
	(N'Snail', N'Mollusk', 'NGastropod'),
	(N'Sea Star', N'Echinoderm', N'Asteroidea');

INSERT INTO Habitat (name)
VALUES 
	(N'Jungle'),
	(N'Desert'),
	(N'Ocean'),
	(N'Forest'),
	(N'Prairie'),
	(N'Tundra'),
	(N'Mountain'),
	(N'Cave'),
	(N'River'),
	(N'Lake');

INSERT INTO Class (name)
VALUES 
	(N'Mammal'),
	(N'Bird'),
	(N'Fish'),
	(N'Reptile'),
	(N'Amphibian'),
	(N'Insect'),
	(N'Arachnid'),
	(N'Crustacean'),
	(N'Mollusk'),
	(N'Echinoderm');

INSERT INTO IsFoodFor($from_id, $to_id)
VALUES ((SELECT $node_id FROM Animal WHERE name = N'Eagle'), (SELECT $node_id FROM Animal WHERE name = N'Lion')),
		((SELECT $node_id FROM Animal WHERE name = N'Salmon'), (SELECT $node_id FROM Animal WHERE name = N'Lion')),
		((SELECT $node_id FROM Animal WHERE name = N'Salmon'), (SELECT $node_id FROM Animal WHERE name = N'Eagle')),
		((SELECT $node_id FROM Animal WHERE name = N'Python'), (SELECT $node_id FROM Animal WHERE name = N'Eagle')),
		((SELECT $node_id FROM Animal WHERE name = N'Python'), (SELECT $node_id FROM Animal WHERE name = N'Lion')),
		((SELECT $node_id FROM Animal WHERE name = N'Frog'), (SELECT $node_id FROM Animal WHERE name = N'Eagle')),
		((SELECT $node_id FROM Animal WHERE name = N'Frog'), (SELECT $node_id FROM Animal WHERE name = N'Python')),
		((SELECT $node_id FROM Animal WHERE name = N'Frog'), (SELECT $node_id FROM Animal WHERE name = N'Lion')),
		((SELECT $node_id FROM Animal WHERE name = N'Butterfly'), (SELECT $node_id FROM Animal WHERE name = N'Frog')),
		((SELECT $node_id FROM Animal WHERE name = N'Butterfly'), (SELECT $node_id FROM Animal WHERE name = N'Tarantula')),
		((SELECT $node_id FROM Animal WHERE name = N'Tarantula'), (SELECT $node_id FROM Animal WHERE name = N'Frog')),
		((SELECT $node_id FROM Animal WHERE name = N'Lobster'), (SELECT $node_id FROM Animal WHERE name = N'Lobster')),
		((SELECT $node_id FROM Animal WHERE name = N'Snail'), (SELECT $node_id FROM Animal WHERE name = N'Lion'));

INSERT INTO LocatedIn($from_id, $to_id)
VALUES ((SELECT $node_id FROM Animal WHERE id = 1), (SELECT $node_id FROM Habitat WHERE id = 1)),
		((SELECT $node_id FROM Animal WHERE id = 2), (SELECT $node_id FROM Habitat WHERE id = 2)),
		((SELECT $node_id FROM Animal WHERE id = 3), (SELECT $node_id FROM Habitat WHERE id = 3)),
		((SELECT $node_id FROM Animal WHERE id = 4), (SELECT $node_id FROM Habitat WHERE id = 4)),
		((SELECT $node_id FROM Animal WHERE id = 5), (SELECT $node_id FROM Habitat WHERE id = 5)),
		((SELECT $node_id FROM Animal WHERE id = 6), (SELECT $node_id FROM Habitat WHERE id = 6)),
		((SELECT $node_id FROM Animal WHERE id = 7), (SELECT $node_id FROM Habitat WHERE id = 7)),
		((SELECT $node_id FROM Animal WHERE id = 8), (SELECT $node_id FROM Habitat WHERE id = 8)),
		((SELECT $node_id FROM Animal WHERE id = 9), (SELECT $node_id FROM Habitat WHERE id = 9)),
		((SELECT $node_id FROM Animal WHERE id = 10), (SELECT $node_id FROM Habitat WHERE id = 10));


INSERT INTO InClass($from_id, $to_id)
VALUES ((SELECT $node_id FROM Animal WHERE id = 1), (SELECT $node_id FROM Class WHERE id = 1)),
		((SELECT $node_id FROM Animal WHERE id = 2), (SELECT $node_id FROM Class WHERE id = 2)),
		((SELECT $node_id FROM Animal WHERE id = 3), (SELECT $node_id FROM Class WHERE id = 3)),
		((SELECT $node_id FROM Animal WHERE id = 4), (SELECT $node_id FROM Class WHERE id = 4)),
		((SELECT $node_id FROM Animal WHERE id = 5), (SELECT $node_id FROM Class WHERE id = 5)),
		((SELECT $node_id FROM Animal WHERE id = 6), (SELECT $node_id FROM Class WHERE id = 6)),
		((SELECT $node_id FROM Animal WHERE id = 7), (SELECT $node_id FROM Class WHERE id = 7)),
		((SELECT $node_id FROM Animal WHERE id = 8), (SELECT $node_id FROM Class WHERE id = 8)),
		((SELECT $node_id FROM Animal WHERE id = 9), (SELECT $node_id FROM Class WHERE id = 9)),
		((SELECT $node_id FROM Animal WHERE id = 10), (SELECT $node_id FROM Class WHERE id = 10));

--Кого стоит опасаться Жаба

SELECT Animal1.name AS [Mammal]
	   , Animal2.name AS [Worth afraid]
FROM Animal AS Animal1
	 , IsFoodFor
	 , Animal AS Animal2
WHERE MATCH(Animal1-(IsFoodFor)->Animal2)
	  AND Animal1.name = N'Frog';

--Где живет ЛЯгушка

SELECT Animal.name as [Mammal]
		, Habitat.name AS [Habitat]
FROM Animal
	 , LocatedIn AS lives
	 , Habitat
WHERE MATCH(Animal - (lives)->Habitat)
	  AND Animal.name = N'Frog';

--В каком классе змеюка
SELECT Animal.name as [Mammal]
		, Class.name AS [Class]
FROM Animal
	 , InClass AS InC
	 , Class
WHERE MATCH(Animal - (InC) -> Class)
	  AND Animal.name = N'Python';

--кто хочет убить frog
SELECT Animal1.name as [Killer 1]
		,Animal2.name as [Killer 2]
		,Animal3.name as [victim]
FROM Animal AS Animal1
	,Animal AS Animal2
	,Animal AS Animal3 
	,IsFoodFor AS fo
	,IsFoodFor AS foo
WHERE MATCH(Animal1 <- (fo) - Animal3 - (foo) -> Animal2)
		AND Animal3.name = N'Frog'
		AND Animal1.name != Animal2.name

SELECT Animal1.name,
		STRING_AGG(Animal2.name, '->') WITHIN GROUP (GRAPH PATH) AS Victims
FROM Animal AS Animal1
	,IsFoodFor FOR PATH AS fo
	,Animal FOR PATH AS Animal2
WHERE MATCH(SHORTEST_PATH(Animal1(<-(fo)-Animal2){1,2}))
		AND Animal1.name = N'Lion' 

SELECT Animal1.name,
		STRING_AGG(Animal2.name, '->') WITHIN GROUP (GRAPH PATH) AS Victims
FROM Animal AS Animal1
	,IsFoodFor FOR PATH AS fo
	,Animal FOR PATH AS Animal2
WHERE MATCH(SHORTEST_PATH(Animal1(<-(fo)-Animal2)+))
		AND Animal1.name = N'Lion'