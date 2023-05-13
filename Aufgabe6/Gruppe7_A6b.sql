USE gruppe7;

SELECT E.PK_id as Encounter, "ok" as Erlaubt
FROM encounter_campaign E
WHERE E.FK_deck not in (
	SELECT DISTINCT D.PK_id as Deck
	FROM deck D, cards_banned C
	WHERE D.PK_FK_card = C.PK_FK_card
	GROUP BY Deck
	)
    and E.FK_deck not in (
		SELECT DISTINCT D.PK_id as Deck
        FROM deck D
			JOIN cards C ON D.PK_FK_card = C.PK_id
		WHERE C.rarity != "Common" AND C.rarity != "Uncommon"
        GROUP BY Deck
        )

UNION

SELECT E.PK_id as Encounter, "gebannte Karte im Deck" as Erlaubt
FROM encounter_campaign E
WHERE E.FK_deck in (
	SELECT DISTINCT D.PK_id as Deck
	FROM deck D, cards_banned C
	WHERE D.PK_FK_card = C.PK_FK_card
	GROUP BY Deck
	)
    
UNION

SELECT E.PK_id as Encounter, "Karte von anderem Typ als 'Un-/Common' im Deck" as Erlaubt
	FROM encounter_campaign E
    WHERE E.FK_deck in (
		SELECT DISTINCT D.PK_id as Deck
        FROM deck D
			JOIN cards C ON D.PK_FK_card = C.PK_id
		WHERE C.rarity != "Common" AND C.rarity != "Uncommon"
        GROUP BY Deck
        )

ORDER BY Encounter;