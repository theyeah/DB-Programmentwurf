USE gruppe7;

SELECT C.*

FROM hero H
	JOIN encounter_campaign E ON E.FK_hero = H.PK_id
    JOIN deck D on E.FK_deck = D.PK_id
    JOIN cards C on D.PK_FK_card = C.PK_id

WHERE C.PK_id not in (
	SELECT C.PK_id
    FROM hero H
		JOIN encounter_campaign E ON E.FK_hero = H.PK_id
		JOIN deck D on E.FK_deck = D.PK_id
		JOIN cards C on D.PK_FK_card = C.PK_id
    WHERE level > 24
    GROUP BY C.PK_id
    )

GROUP BY C.PK_id