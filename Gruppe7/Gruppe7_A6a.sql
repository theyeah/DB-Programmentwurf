USE gruppe7;


CREATE TABLE IF NOT EXISTS `Cards_banned` (
  `PK_FK_card` varchar(50) PRIMARY KEY,
  `Reason` varchar(50),
  `BanningDate` date
);
ALTER TABLE `Cards_banned` ADD FOREIGN KEY (`PK_FK_card`) REFERENCES `Cards` (`PK_id`);


insert into cards_banned
	values	("M3B103", "Karte veraltet",now()),
			("M3B106", "Karte nicht nutzbar", "2023-02-20"),
			("M3B2", "Karte kaputt", "2022-12-12"),
			("M3B5", "Copyright abgelaufen", "2021-10-05"),
			("M3C224", "Karte veraltet", "2021-10-05"),
			("M3C293", "Karte veraltet", "2021-09-05"),
			("M3R1312", "Karte overpowered", "2019-10-04"),
			("M3R3141", "Karte overpowered", "2021-10-17"),
			("M3R3306", "Copyright abgelaufen", "2015-08-08"),
			("M3R3403", "Karte nicht nutzbar", "2017-10-02");


SELECT D.PK_id as Deck, group_concat(concat(D.PK_FK_card,": ",C.reason)) as Karte_Begründung
FROM deck D, cards_banned C
WHERE D.PK_FK_card = C.PK_FK_card
GROUP BY Deck