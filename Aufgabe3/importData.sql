SET @@GLOBAL.local_infile = 1;

USE gruppe7;

# Datei einlesen und Werte valiedieren
LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/csv/encounter_campaign.csv"
INTO TABLE encounter_campaign
CHARACTER SET 'latin1'
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@PK_id, @experience_first, @gold_first, @FK_card_reward1, @FK_card_reward2, @FK_deck, @FK_hero);