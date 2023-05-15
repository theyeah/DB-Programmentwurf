USE gruppe7;


CREATE VIEW hero_view AS
SELECT	Hero, Deck, Level,
		sum(Kartenzahl) as Kartenanzahl, format(avg(Kosten), 2) as Kartenkostendurchschnitt,
        count(IF(Kartentyp = "Common", 1, Null)) as Common, count(IF(Element = "Uncommon", 1, Null)) as Uncommon,
        count(IF(Kartentyp = "Rare", 1, Null)) as Rare,
        count(IF(Kartentyp = "Exceptional", 1, Null)) as Exceptional,
        count(IF(Kartentyp = "Secret", 1, Null)) as Secret,
        count(IF(Kartentyp = "Forbidden", 1, Null)) as Forbidden,
        GROUP_CONCAT(DISTINCT Element SEPARATOR ', ') as Elemente,
        GROUP_CONCAT(DISTINCT Encounter SEPARATOR ', ') as Encounters
        
FROM (
	SELECT H.PK_id as Hero, D.PK_id as Deck, H.level as Level, D.amount as Kartenzahl, C.cost as Kosten, C.rarity as Kartentyp, El.id_name as Element, E.PK_id as Encounter

	FROM deck D
		JOIN encounter_campaign E ON D.PK_id = e.FK_deck
		JOIN hero H ON e.FK_hero = H.PK_id
		JOIN cards C ON D.PK_FK_card = C.PK_id
		JOIN elements El ON C.FK_element = El.PK_Id_char
	) as subSelect
    
GROUP BY Hero, Deck;

SELECT * FROM hero_view