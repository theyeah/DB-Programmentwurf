USE gruppe7;

SELECT	D.PK_id as Deck,
		sum(D.amount) as Kartenzahl_gesamt, sum(IF(E.id_name = "Fire", 1, null)) as Kartenzahl_Fire,
        group_concat(DISTINCT E.id_name) as Elemente

FROM deck D
	JOIN cards C ON D.PK_FK_card = C.PK_ID
    JOIN elements E ON C.FK_element = E.PK_id_char
    
WHERE D.PK_id in (
		SELECT D.PK_id
        FROM deck D LEFT JOIN cards C ON D.PK_FK_card = C.PK_ID
        WHERE C.FK_element = (
			SELECT DISTINCT PK_id_char
			FROM elements
			WHERE id_name = "Fire"
            )
		)

GROUP BY D.PK_id
ORDER BY Kartenzahl_Fire DESC