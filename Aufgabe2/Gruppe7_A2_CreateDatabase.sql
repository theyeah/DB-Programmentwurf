DROP DATABASE IF EXISTS gruppe7;
CREATE DATABASE Gruppe7;
USE Gruppe7;

CREATE TABLE IF NOT EXISTS `Encounter_Campaign` (
  `PK_id` varchar(50) PRIMARY KEY,
  `FK_hero` varchar(50),
  `FK_deck` varchar(50),
  `level` integer,
  `experience_first` integer,
  `gold_first` integer,
  `FK_card_reward1` varchar(50),
  `FK_card_reward2` varchar(50),
  INDEX idx_FK_hero (FK_hero),
  INDEX idx_FK_deck (FK_deck)
);

CREATE TABLE IF NOT EXISTS `Encounter_Random` (
  `PK_FK_id` varchar(50) PRIMARY KEY,
  `experience_again` integer,
  `gold_again` integer,
  `FK_condition` varchar(50)
);

CREATE TABLE IF NOT EXISTS `Hero` (
  `PK_id` varchar(50) PRIMARY KEY,
  `level` integer,
  `name` varchar(75),
  `health` integer,
  `FK_element1` varchar(75),
  `FK_element2` varchar(75)
);

CREATE TABLE IF NOT EXISTS `Abilities` (
  `PK_id` integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `content` varchar(255) UNIQUE
);

CREATE TABLE IF NOT EXISTS `Hero_Abilities` (
  `PK_FK_hero` varchar(50),
  `PK_FK_ability` integer,
  PRIMARY KEY (`PK_FK_hero`, `PK_FK_ability`),
  INDEX idx_PK_FK_ability (PK_FK_ability)
);

CREATE TABLE IF NOT EXISTS `Elements` (
  `PK_id_char` varchar(1) PRIMARY KEY,
  `id_name` varchar(75) UNIQUE
);

CREATE TABLE IF NOT EXISTS `Cards` (
  `PK_id` varchar(50) PRIMARY KEY,
  `name` varchar(50),
  `rarity` ENUM ("Common", "Exceptional", "Rare", "Forbidden", "Secret", "Uncommon"),
  `type` ENUM ("Action", "Hero", "Troop"),
  `subtype` varchar(50),
  `FK_element` varchar(1),
  `quick` bool,
  `cost` integer
);

CREATE TABLE IF NOT EXISTS `Card_Abilities` (
  `PK_FK_card` varchar(50),
  `PK_FK_ability` integer,
  PRIMARY KEY (`PK_FK_card`, `PK_FK_ability`),
  INDEX idx_PK_FK_ability (PK_FK_ability)
);

CREATE TABLE IF NOT EXISTS `Cards_Troop` (
  `PK_id` varchar(50) PRIMARY KEY,
  `health` integer
);

CREATE TABLE IF NOT EXISTS `Deck` (
  `PK_id` varchar(50),
  `PK_FK_card` varchar(50),
  `amount` integer,
  PRIMARY KEY (`PK_id`, `PK_FK_card`),
  INDEX idx_PK_FK_card (PK_FK_card)
);

ALTER TABLE `Encounter_Campaign` ADD FOREIGN KEY (`FK_hero`) REFERENCES `Hero` (`PK_id`);
ALTER TABLE `Encounter_Campaign` ADD FOREIGN KEY (`FK_deck`) REFERENCES `Deck` (`PK_id`);
ALTER TABLE `Encounter_Campaign` ADD FOREIGN KEY (`FK_card_reward1`) REFERENCES `Cards` (`PK_id`);
ALTER TABLE `Encounter_Campaign` ADD FOREIGN KEY (`FK_card_reward2`) REFERENCES `Cards` (`PK_id`);

ALTER TABLE `Encounter_Random` ADD FOREIGN KEY (`PK_FK_id`) REFERENCES `Encounter_Campaign` (`PK_id`);
ALTER TABLE `Encounter_Random` ADD FOREIGN KEY (`FK_condition`) REFERENCES `Encounter_Campaign` (`PK_id`);

ALTER TABLE `Hero` ADD FOREIGN KEY (`FK_element1`) REFERENCES `Elements` (`id_name`);
ALTER TABLE `Hero` ADD FOREIGN KEY (`FK_element2`) REFERENCES `Elements` (`id_name`);

ALTER TABLE `Hero_Abilities` ADD FOREIGN KEY (`PK_FK_hero`) REFERENCES `Hero` (`PK_id`);
ALTER TABLE `Hero_Abilities` ADD FOREIGN KEY (`PK_FK_ability`) REFERENCES `Abilities` (`PK_id`);

ALTER TABLE `Cards` ADD FOREIGN KEY (`FK_element`) REFERENCES `Elements` (`PK_id_char`);

ALTER TABLE `Card_Abilities` ADD FOREIGN KEY (`PK_FK_card`) REFERENCES `Cards` (`PK_id`);
ALTER TABLE `Card_Abilities` ADD FOREIGN KEY (`PK_FK_ability`) REFERENCES `Abilities` (`PK_id`);

ALTER TABLE `Cards_Troop` ADD FOREIGN KEY (`PK_id`) REFERENCES `Cards` (`PK_id`);

ALTER TABLE `Deck` ADD FOREIGN KEY (`PK_FK_card`) REFERENCES `Cards` (`PK_id`);