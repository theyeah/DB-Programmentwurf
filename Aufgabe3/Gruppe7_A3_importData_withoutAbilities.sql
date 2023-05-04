-- SET @@GLOBAL.local_infile = 1;	# enable local files for imports on client-side
USE gruppe7;	# refer to correct database

-- the order of importing the data is important with regard to the given FK constraints

# import elements data from "karten.csv"
LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/karten.csv"
INTO TABLE elements
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @Name, @Rarity, @Element, @Cost, @Type, @Subtype, @Quick, @Health, @Abilities)
SET PK_id_char = LEFT(@Element, 1), id_name = @Element;


# import hero data from "hero_campaign.csv" & "hero_random.csv"
LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/hero_campaign.csv"
INTO TABLE hero
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @Name, @Level, @Element1, @Element2, @Health, @Abilities)
SET PK_id = @ID, level = @Level, name = @Name, health = @Health, FK_element1 = nullif(@Element1, "None"), FK_element2 = nullif(@Element2, "None");
-- abilities missing

LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/hero_random.csv"
INTO TABLE hero
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @Name, @Level, @Element1, @Element2, @Health, @Abilities)
SET PK_id = @ID, level = @Level, name = @Name, health = @Health, FK_element1 = nullif(@Element1, "None"), FK_element2 = nullif(@Element2, "None");
-- abilities missing


# import cards data from "karten.csv"
CREATE TABLE IF NOT EXISTS tmp_cards_cardstroop(	# temporary table for distinguishing cards, cards_troop
  `PK_id` varchar(50) PRIMARY KEY,
  `name` varchar(50),
  `rarity` ENUM ("Common", "Exceptional", "Rare", "Forbidden", "Secret", "Uncommon"),
  `type` ENUM ("Action", "Hero", "Troop"),
  `subtype` varchar(50),
  `FK_element` varchar(1),
  `quick` bool,
  `cost` integer,
  `health` integer);

# load cards + cards_troop data to temporary table from "karten.csv"
LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/karten.csv"
INTO TABLE tmp_cards_cardstroop
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @Name, @Rarity, @Element, @Cost, @Type, @Subtype, @Quick, @Health, @Abilities)
SET PK_id = @ID, name = @Name, rarity=@Rarity, type=@Type, subtype=nullif(@Subtype,"None"), FK_element=@Element, quick=if(@Quick="True",1,0), cost=LEFT(@Cost,INSTR(@Cost,"{")), health = @Health;

# move cards data to destination from temporary table
INSERT INTO cards (PK_id, name, rarity, type, subtype, FK_element, quick, cost)
SELECT PK_id, name, rarity, type, subtype, FK_element, quick, cost
FROM tmp_cards_cardstroop;

# move cards_troop data to destination from temporary table
INSERT INTO cards_troop (PK_id, health)
SELECT PK_id, health
FROM tmp_cards_cardstroop
WHERE type = "Troop";

DROP TABLE tmp_cards_cardstroop;	# drop temporary table


# import deck data from "decks_campaign.csv" + "decks_random.csv"
LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/decks_campaign.csv"
INTO TABLE deck
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @CardID, @Amount)
SET PK_id = @ID, PK_FK_card = @CardID, amount = @Amount;

LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/decks_random.csv"
INTO TABLE deck
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @CardID, @Amount)
SET PK_id = @ID, PK_FK_card = @CardID, amount = @Amount;


# import encounter data from "encounter_campaign.csv"
LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/encounter_campaign.csv"
INTO TABLE encounter_campaign
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @ExpFirst, @GoldFirst, @CardReward1, @CardReward2, @DeckID, @HeroID)
SET PK_id = @ID, FK_hero=@HeroID, FK_deck=@DeckID, experience_first = @ExpFirst, gold_first=@GoldFirst, FK_card_reward1=nullif(@CardReward1,"None"), FK_card_reward2=nullif(@CardReward2,"None");

# import encounter data from "encounter_random.csv":
# first the information all encounters have (stored in "encounter_campaign"),
# then the connected information stored in table "encounter_random"
LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/encounter_random.csv"
INTO TABLE encounter_campaign
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @Condition, @ExpFirst, @GoldFirst, @CardReward1, @CardReward2, @ExpRepeat, @GoldRepeat, @DecklistID, @HeroID) -- level missing (hero_x.csv)
SET PK_id = @ID, FK_hero=@HeroID, FK_deck=@DecklistID, experience_first = @ExpFirst, gold_first=@GoldFirst, FK_card_reward1=nullif(@CardReward1,"None"), FK_card_reward2=nullif(@CardReward2,"None"); -- level missing (hero_x.csv)

LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/encounter_random.csv"
INTO TABLE encounter_random
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @Condition, @ExpFirst, @GoldFirst, @CardReward1, @CardReward2, @ExpRepeat, @GoldRepeat, @DecklistID, @HeroID)
SET PK_FK_id = @ID, experience_again = @ExpRepeat, gold_again=@GoldRepeat, FK_condition = nullif(@Condition, "");