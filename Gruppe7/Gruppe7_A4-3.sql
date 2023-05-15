SELECT a.*, COUNT(ha.PK_FK_ability) + COUNT(ca.PK_FK_ability) as Vorkommen_gesamt

FROM abilities a
	LEFT JOIN hero_abilities ha on a.PK_ID = ha.PK_FK_ability
	LEFT JOIN card_abilities ca on a.PK_ID = ca.PK_FK_ability

GROUP BY a.PK_ID
HAVING Vorkommen_gesamt > 1
ORDER BY Vorkommen_gesamt DESC;