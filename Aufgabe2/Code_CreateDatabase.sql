CREATE DATABASE IF NOT EXISTS Gruppe7;
USE Gruppe7;

CREATE TABLE IF NOT EXISTS `Encounter_Campaign` (
  `PK_id` integer PRIMARY KEY,
  `FK_hero` integer,
  `FK_deck` integer,
  `type` ENUM ('enc_type_1', 'enc_type_2', 'enc_type_3'),
  `level` integer,
  `experience_first` integer,
  `gold_first` integer,
  `FK_card_reward1` integer,
  `FK_card_reward2` integer,
  INDEX idx_FK_hero (FK_hero),
  INDEX idx_FK_deck (FK_deck)
);

CREATE TABLE IF NOT EXISTS `Encounter_Random` (
  `PK_FK_id` integer PRIMARY KEY,
  `experience_again` integer,
  `gold_again` integer,
  `FK_condition` integer
);

CREATE TABLE IF NOT EXISTS `Hero` (
  `PK_id` integer PRIMARY KEY,
  `level` integer,
  `name` varchar(50),
  `health` integer,
  `FK_element1` varchar(50),
  `FK_element2` varchar(50),
  FOREIGN KEY (`PK_id`) REFERENCES `Encounter_Campaign` (`FK_hero`)
);

CREATE TABLE IF NOT EXISTS `Abilities` (
  `PK_id` integer PRIMARY KEY,
  `content` varchar(255)
);

CREATE TABLE IF NOT EXISTS `Hero_Abilities` (
  `PK_FK_hero` integer,
  `PK_FK_ability` integer,
  PRIMARY KEY (`PK_FK_hero`, `PK_FK_ability`),
  INDEX idx_PK_FK_ability (PK_FK_ability)
);

CREATE TABLE IF NOT EXISTS `Elements` (
  `PK_id_char` varchar(1) PRIMARY KEY,
  `id_name` varchar(50) UNIQUE
);

CREATE TABLE IF NOT EXISTS `Cards` (
  `PK_id` integer PRIMARY KEY,
  `name` varchar(50),
  `rarity` ENUM ('rarity_1', 'rarity_2', 'rarity_3'),
  `type` ENUM ('card_type_1', 'card_type_2', 'card_type_3'),
  `subtype` ENUM ('card_type_1', 'card_type_2', 'card_type_3'),
  `FK_element` varchar(1),
  `quick` bool,
  `cost` integer
);

CREATE TABLE IF NOT EXISTS `Card_Abilities` (
  `PK_FK_card` integer,
  `PK_FK_ability` integer,
  PRIMARY KEY (`PK_FK_card`, `PK_FK_ability`),
  INDEX idx_PK_FK_ability (PK_FK_ability)
);

CREATE TABLE IF NOT EXISTS `Cards_Troop` (
  `PK_id` integer PRIMARY KEY,
  `health` integer
);

CREATE TABLE IF NOT EXISTS `Deck` (
  `PK_id` integer,
  `PK_FK_hero` integer,
  `PK_FK_card` integer,
  `amount` integer,
  PRIMARY KEY (`PK_id`, `PK_FK_hero`, `PK_FK_card`),
  FOREIGN KEY (`PK_FK_card`) REFERENCES `Cards` (`PK_id`),
  INDEX idx_PK_FK_card (PK_FK_card)
);

ALTER TABLE `Encounter_Campaign` ADD FOREIGN KEY (`FK_card_reward1`) REFERENCES `Cards` (`PK_id`);

ALTER TABLE `Encounter_Campaign` ADD FOREIGN KEY (`FK_card_reward2`) REFERENCES `Cards` (`PK_id`);

ALTER TABLE `Encounter_Random` ADD FOREIGN KEY (`PK_FK_id`) REFERENCES `Encounter_Campaign` (`PK_id`);

ALTER TABLE `Encounter_Random` ADD FOREIGN KEY (`FK_condition`) REFERENCES `Encounter_Campaign` (`PK_id`);

ALTER TABLE `Hero` ADD FOREIGN KEY (`PK_id`) REFERENCES `Encounter_Campaign` (`FK_hero`);

ALTER TABLE `Hero` ADD FOREIGN KEY (`FK_element1`) REFERENCES `Elements` (`id_name`);

ALTER TABLE `Hero` ADD FOREIGN KEY (`FK_element2`) REFERENCES `Elements` (`id_name`);

ALTER TABLE `Hero` ADD FOREIGN KEY (`PK_id`) REFERENCES `Hero_Abilities` (`PK_FK_hero`);

ALTER TABLE `Abilities` ADD FOREIGN KEY (`PK_id`) REFERENCES `Hero_Abilities` (`PK_FK_ability`);

ALTER TABLE `Cards` ADD FOREIGN KEY (`FK_element`) REFERENCES `Elements` (`PK_id_char`);

ALTER TABLE `Cards` ADD FOREIGN KEY (`PK_id`) REFERENCES `Card_Abilities` (`PK_FK_card`);

ALTER TABLE `Abilities` ADD FOREIGN KEY (`PK_id`) REFERENCES `Card_Abilities` (`PK_FK_ability`);

ALTER TABLE `Cards` ADD FOREIGN KEY (`PK_id`) REFERENCES `Cards_Troop` (`PK_id`);

ALTER TABLE `Deck` ADD FOREIGN KEY (`PK_id`) REFERENCES `Encounter_Campaign` (`FK_deck`);

ALTER TABLE `Deck` ADD FOREIGN KEY (`PK_FK_hero`) REFERENCES `Hero` (`PK_id`);