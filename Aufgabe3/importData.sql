-- SET @@GLOBAL.local_infile = 1;

USE gruppe7;

LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/karten.csv"
INTO TABLE elements
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @Name, @Rarity, @Element, @Cost, @Type, @Subtype, @Quick, @Health, @Abilities)
SET PK_id_char = LEFT(@Element, 1), id_name = @Element;


LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/karten.csv"
INTO TABLE cards
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @Name, @Rarity, @Element, @Cost, @Type, @Subtype, @Quick, @Health, @Abilities)
SET PK_id = @ID, name = @Name, rarity=@Rarity, type=@Type, subtype=nullif(@Subtype,"None"), FK_element=@Element, quick=if(@Quick="True",1,0), cost=LEFT(@Cost,INSTR(@Cost,"{"));

/*LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/encounter_campaign.csv"
INTO TABLE encounter_campaign
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @ExpFirst, @GoldFirst, @CardReward1, @CardReward2, @DeckID, @HeroID)
SET PK_id = @ID, experience_first = @ExpFirst, gold_first=@GoldFirst, FK_card_reward1=@CardReward1, FK_card_reward2=@CardReward2, FK_deck=@DeckID, FK_hero=@HeroID;
*/