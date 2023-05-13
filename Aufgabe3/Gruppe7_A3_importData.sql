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
  `health` integer
  );

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

# remove datasets where DeckID and/or CardID is missing
DELETE FROM deck
WHERE PK_id = "";


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


# import abilities from "karten.csv" and hero_x.csv":
# first import all abilites of cards to temporary table with card id
# split single abilities field to n rows
# move data to abilities table with autoID and unique abilities.content
# connect cardID with abilities in card_abilities table via info from temporary table
# do similar steps for heros

CREATE TABLE IF NOT EXISTS tmp_cards_abilities(	# temporary table for distinguishing abilities
  `card_id` varchar(50) PRIMARY KEY,
  `abilities` varchar(1000)
  );

LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/karten.csv"
INTO TABLE tmp_cards_abilities
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @Name, @Rarity, @Element, @Cost, @Type, @Subtype, @Quick, @Health, @Abilities)
SET card_id = @ID, abilities = trim(@Abilities);

SET SQL_SAFE_UPDATES = 0;

DELETE  FROM tmp_cards_abilities
WHERE length(abilities) < 5;

CREATE TABLE IF NOT EXISTS tmp_cards_singleability(	# temporary table for distinguishing abilities
  `card_id` varchar(50),
  `ability` varchar(500),
  `abilities` varchar (1000),
   PRIMARY KEY (`card_id`, `ability`)
  );

INSERT INTO tmp_cards_singleability (card_id, ability, abilities)
SELECT	card_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        ELSE trim(abilities) END,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, position('|' in abilities) + 1))
		ELSE null END
FROM   tmp_cards_abilities;


-- "loop" start = "iteration" 0

CREATE TABLE IF NOT EXISTS tmp_cards_singleability2(	# temporary table for distinguishing abilities
  `card_id` varchar(50),
  `ability` varchar(500),
  `abilities` varchar (1000),
   PRIMARY KEY (`card_id`, `ability`)
  );

INSERT INTO tmp_cards_singleability2 (card_id, ability)
SELECT card_id, ability
FROM tmp_cards_singleability;

INSERT INTO tmp_cards_singleability2 (card_id, ability, abilities)
SELECT	card_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        ELSE abilities END,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, position('|' in abilities) + 1))
		ELSE null END
FROM   tmp_cards_singleability
WHERE length(abilities) > 5;


-- "iteration 1"
CREATE TABLE IF NOT EXISTS tmp_cards_singleability3(	# temporary table for distinguishing abilities
  `card_id` varchar(50),
  `ability` varchar(500),
  `abilities` varchar (1000),
   PRIMARY KEY (`card_id`, `ability`)
  );

INSERT INTO tmp_cards_singleability3 (card_id, ability)
SELECT card_id, ability
FROM tmp_cards_singleability2;

INSERT INTO tmp_cards_singleability3 (card_id, ability, abilities)
SELECT	card_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        WHEN length(abilities) > 3 THEN abilities
        ELSE "1" END,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, position('|' in abilities) + 1))
		ELSE null END
FROM   tmp_cards_singleability2
WHERE length(abilities) > 5;


-- "iteration 2"
CREATE TABLE IF NOT EXISTS tmp_cards_singleability4(	# temporary table for distinguishing abilities
  `card_id` varchar(50),
  `ability` varchar(500),
  `abilities` varchar (1000),
   PRIMARY KEY (`card_id`, `ability`)
  );

INSERT INTO tmp_cards_singleability4 (card_id, ability)
SELECT card_id, ability
FROM tmp_cards_singleability3;

INSERT INTO tmp_cards_singleability4 (card_id, ability, abilities)
SELECT	card_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        ELSE abilities END,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, position('|' in abilities) + 1))
		ELSE null END
FROM   tmp_cards_singleability3
WHERE length(abilities) > 5;

-- "iteration 3"
CREATE TABLE IF NOT EXISTS tmp_cards_singleability5(	# temporary table for distinguishing abilities
  `card_id` varchar(50),
  `ability` varchar(500),
  `abilities` varchar (1000),
   PRIMARY KEY (`card_id`, `ability`)
  );

INSERT INTO tmp_cards_singleability5 (card_id, ability)
SELECT card_id, ability
FROM tmp_cards_singleability4;

INSERT INTO tmp_cards_singleability5 (card_id, ability, abilities)
SELECT	card_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        ELSE abilities END,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, position('|' in abilities) + 1))
		ELSE null END
FROM   tmp_cards_singleability4
WHERE length(abilities) > 5;

-- "iteration 4"
CREATE TABLE IF NOT EXISTS tmp_cards_singleability6(	# temporary table for distinguishing abilities
  `card_id` varchar(50),
  `ability` varchar(500),
  `abilities` varchar (1000),
   PRIMARY KEY (`card_id`, `ability`)
  );

INSERT INTO tmp_cards_singleability6 (card_id, ability)
SELECT card_id, ability
FROM tmp_cards_singleability5;

INSERT INTO tmp_cards_singleability6 (card_id, ability, abilities)
SELECT	card_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        ELSE abilities END,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, position('|' in abilities) + 1))
		ELSE null END
FROM   tmp_cards_singleability5
WHERE length(abilities) > 5;

-- "iteration 5"
CREATE TABLE IF NOT EXISTS tmp_cards_singleability7(	# temporary table for distinguishing abilities
  `card_id` varchar(50),
  `ability` varchar(500),
  `abilities` varchar (1000),
   PRIMARY KEY (`card_id`, `ability`)
  );

INSERT INTO tmp_cards_singleability7 (card_id, ability)
SELECT card_id, ability
FROM tmp_cards_singleability6;

INSERT INTO tmp_cards_singleability7 (card_id, ability, abilities)
SELECT	card_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        ELSE abilities END,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, position('|' in abilities) + 1))
		ELSE null END
FROM   tmp_cards_singleability6
WHERE length(abilities) > 5;

-- "iteration 6"
CREATE TABLE IF NOT EXISTS tmp_cards_singleability8(	# temporary table for distinguishing abilities
  `card_id` varchar(50),
  `ability` varchar(500),
   PRIMARY KEY (`card_id`, `ability`)
  );

INSERT INTO tmp_cards_singleability8 (card_id, ability)
SELECT card_id, ability
FROM tmp_cards_singleability7;

INSERT INTO tmp_cards_singleability8 (card_id, ability)
SELECT	card_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        ELSE abilities END
FROM   tmp_cards_singleability7
WHERE length(abilities) > 5;

-- "loop" end

INSERT INTO abilities (content)
SELECT distinct ability
FROM tmp_cards_singleability;




CREATE TABLE IF NOT EXISTS tmp_heroes_abilities(	# temporary table for distinguishing abilities
  `hero_id` varchar(50) PRIMARY KEY,
  `abilities` varchar(1000)
  );

LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/hero_random.csv"
INTO TABLE tmp_heroes_abilities
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @Name, @Level, @Element1, @Element2, @Health, @Abilities)
SET hero_id = @ID, abilities = trim(@Abilities);

LOAD DATA LOCAL INFILE "C:/Users/hofmannfl/source/repos/DH-Studium/Sem4_Datenbanken/Aufgabenstellung/hero_campaign.csv"
INTO TABLE tmp_heroes_abilities
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 2 LINES
(@ID, @Name, @Level, @Element1, @Element2, @Health, @Abilities)
SET hero_id = @ID, abilities = trim(@Abilities);

DELETE  FROM tmp_heroes_abilities
WHERE length(abilities) < 5;

CREATE TABLE IF NOT EXISTS tmp_heroes_singleability(	# temporary table for distinguishing abilities
  `hero_id` varchar(50),
  `ability` varchar(500),
  `abilities` varchar (1000),
   PRIMARY KEY (`hero_id`, `ability`)
  );

INSERT INTO tmp_heroes_singleability (hero_id, ability, abilities)
SELECT	hero_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        ELSE trim(abilities) END,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, position('|' in abilities) + 1))
		ELSE null END
FROM   tmp_heroes_abilities;


-- "loop" start = "iteration" 0

CREATE TABLE IF NOT EXISTS tmp_heroes_singleability2(	# temporary table for distinguishing abilities
  `hero_id` varchar(50),
  `ability` varchar(500),
  `abilities` varchar (1000),
   PRIMARY KEY (`hero_id`, `ability`)
  );

INSERT INTO tmp_heroes_singleability2 (hero_id, ability)
SELECT hero_id, ability
FROM tmp_heroes_singleability;

INSERT INTO tmp_heroes_singleability2 (hero_id, ability, abilities)
SELECT	hero_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        ELSE abilities END,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, position('|' in abilities) + 1))
		ELSE null END
FROM   tmp_heroes_singleability
WHERE length(abilities) > 5;


-- "iteration 1"
CREATE TABLE IF NOT EXISTS tmp_heroes_singleability3(	# temporary table for distinguishing abilities
  `hero_id` varchar(50),
  `ability` varchar(500),
  `abilities` varchar (1000),
   PRIMARY KEY (`hero_id`, `ability`)
  );

INSERT INTO tmp_heroes_singleability3 (hero_id, ability)
SELECT hero_id, ability
FROM tmp_heroes_singleability2;

INSERT INTO tmp_heroes_singleability3 (hero_id, ability, abilities)
SELECT	hero_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        WHEN length(abilities) > 3 THEN abilities
        ELSE "1" END,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, position('|' in abilities) + 1))
		ELSE null END
FROM   tmp_heroes_singleability2
WHERE length(abilities) > 5;


-- "iteration 2"
CREATE TABLE IF NOT EXISTS tmp_heroes_singleability4(	# temporary table for distinguishing abilities
  `hero_id` varchar(50),
  `ability` varchar(500),
  `abilities` varchar (1000),
   PRIMARY KEY (`hero_id`, `ability`)
  );

INSERT INTO tmp_heroes_singleability4 (hero_id, ability)
SELECT hero_id, ability
FROM tmp_heroes_singleability3;

INSERT INTO tmp_heroes_singleability4 (hero_id, ability, abilities)
SELECT	hero_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        ELSE abilities END,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, position('|' in abilities) + 1))
		ELSE null END
FROM   tmp_heroes_singleability3
WHERE length(abilities) > 5;

-- "iteration 3"
CREATE TABLE IF NOT EXISTS tmp_heroes_singleability5(	# temporary table for distinguishing abilities
  `hero_id` varchar(50),
  `ability` varchar(500),
  `abilities` varchar (1000),
   PRIMARY KEY (`hero_id`, `ability`)
  );

INSERT INTO tmp_heroes_singleability5 (hero_id, ability)
SELECT hero_id, ability
FROM tmp_heroes_singleability4;

INSERT INTO tmp_heroes_singleability5 (hero_id, ability, abilities)
SELECT	hero_id,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, 1, position('|' in abilities) - 1))
        ELSE abilities END,
	CASE
		WHEN instr(abilities, '|') > 0 THEN trim(substring(abilities, position('|' in abilities) + 1))
		ELSE null END
FROM   tmp_heroes_singleability4
WHERE length(abilities) > 5;

-- "loop" end

INSERT IGNORE INTO abilities (content)	#ignore duplicate entries
SELECT distinct ability
FROM tmp_heroes_singleability5;



# assign abilities to cards & heros
INSERT INTO card_abilities
SELECT card_id, PK_id
FROM tmp_cards_singleability8 TMP JOIN abilities A on TMP.ability = A.content;

INSERT INTO hero_abilities
SELECT hero_id, PK_id
FROM tmp_heroes_singleability5 TMP JOIN abilities A on TMP.ability = A.content;



DROP TABLE tmp_cards_abilities;	# drop temporary table
DROP TABLE tmp_cards_singleability;	# drop temporary table
DROP TABLE tmp_cards_singleability2;	# drop temporary table
DROP TABLE tmp_cards_singleability3;	# drop temporary table
DROP TABLE tmp_cards_singleability4;	# drop temporary table
DROP TABLE tmp_cards_singleability5;	# drop temporary table
DROP TABLE tmp_cards_singleability6;	# drop temporary table
DROP TABLE tmp_cards_singleability7;	# drop temporary table
DROP TABLE tmp_cards_singleability8;	# drop temporary table

DROP TABLE tmp_heroes_abilities;	# drop temporary table
DROP TABLE tmp_heroes_singleability;	# drop temporary table
DROP TABLE tmp_heroes_singleability2;	# drop temporary table
DROP TABLE tmp_heroes_singleability3;	# drop temporary table
DROP TABLE tmp_heroes_singleability4;	# drop temporary table
DROP TABLE tmp_heroes_singleability5;	# drop temporary table