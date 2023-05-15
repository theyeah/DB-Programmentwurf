USE gruppe7;


SELECT C.*, COUNT(D.PK_id) AS Anzahl_Decks, COUNT(DISTINCT CA.PK_FK_ability) AS Anzahl_Abilities

FROM cards C
	LEFT JOIN deck D ON D.PK_FK_card = C.PK_id
    LEFT JOIN card_abilities CA ON C.PK_id = CA.PK_FK_card

GROUP BY C.PK_id
ORDER BY Anzahl_Decks DESC;