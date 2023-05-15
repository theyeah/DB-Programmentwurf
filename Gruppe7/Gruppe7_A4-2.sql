USE gruppe7;


SELECT type, subtype, count(PK_id) as Karten_Anzahl

FROM cards C

GROUP BY Type, Subtype
ORDER BY Karten_Anzahl DESC