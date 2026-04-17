CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `password` char(40) NOT NULL,
  `secret` char(16) DEFAULT NULL,
  `type` int NOT NULL DEFAULT '1',
  `premium_ends_at` int unsigned NOT NULL DEFAULT '0',
  `email` varchar(255) NOT NULL DEFAULT '',
  `creation` int NOT NULL DEFAULT '0',
  `tibia_coins` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

INSERT INTO `accounts` (`id`, `name`, `password`, `secret`, `type`, `premium_ends_at`, `email`, `creation`, `tibia_coins`) VALUES
(1, '1', '356a192b7913b04c54574d18c28d46e6395428ab', NULL, 1, 0, '', 0, 0);

CREATE TABLE IF NOT EXISTS `players` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `group_id` int NOT NULL DEFAULT '1',
  `account_id` int NOT NULL DEFAULT '0',
  `level` int NOT NULL DEFAULT '1',
  `reset` int(11) NOT NULL DEFAULT 0,
  `vocation` int NOT NULL DEFAULT '0',
  `health` int NOT NULL DEFAULT '150',
  `healthmax` int NOT NULL DEFAULT '150',
  `experience` bigint unsigned NOT NULL DEFAULT '0',
  `lookbody` int NOT NULL DEFAULT '0',
  `lookfeet` int NOT NULL DEFAULT '0',
  `lookhead` int NOT NULL DEFAULT '0',
  `looklegs` int NOT NULL DEFAULT '0',
  `looktype` int NOT NULL DEFAULT '136',
  `lookaddons` int NOT NULL DEFAULT '0',
  `lookmount` smallint UNSIGNED NOT NULL DEFAULT '0',
  `currentmount` smallint UNSIGNED NOT NULL DEFAULT '0',
  `randomizemount` tinyint NOT NULL DEFAULT '0',
  `direction` tinyint unsigned NOT NULL DEFAULT '2',
  `maglevel` int NOT NULL DEFAULT '0',
  `mana` int NOT NULL DEFAULT '0',
  `manamax` int NOT NULL DEFAULT '0',
  `manaspent` bigint unsigned NOT NULL DEFAULT '0',
  `soul` int unsigned NOT NULL DEFAULT '0',
  `town_id` int NOT NULL DEFAULT '1',
  `posx` int NOT NULL DEFAULT '0',
  `posy` int NOT NULL DEFAULT '0',
  `posz` int NOT NULL DEFAULT '0',
  `conditions` blob DEFAULT NULL,
  `cap` int NOT NULL DEFAULT '400',
  `sex` int NOT NULL DEFAULT '0',
  `lastlogin` bigint unsigned NOT NULL DEFAULT '0',
  `lastip` int unsigned NOT NULL DEFAULT '0',
  `save` tinyint NOT NULL DEFAULT '1',
  `skull` tinyint NOT NULL DEFAULT '0',
  `skulltime` bigint NOT NULL DEFAULT '0',
  `lastlogout` bigint unsigned NOT NULL DEFAULT '0',
  `blessings` tinyint NOT NULL DEFAULT '0',
  `onlinetime` bigint NOT NULL DEFAULT '0',
  `deletion` bigint NOT NULL DEFAULT '0',
  `balance` bigint unsigned NOT NULL DEFAULT '0',
  `protection_time` bigint unsigned NOT NULL DEFAULT '0',
  `offlinetraining_time` smallint unsigned NOT NULL DEFAULT '43200',
  `offlinetraining_skill` int NOT NULL DEFAULT '-1',
  `stamina` smallint unsigned NOT NULL DEFAULT '2520',
  `skill_fist` int unsigned NOT NULL DEFAULT 10,
  `skill_fist_tries` bigint unsigned NOT NULL DEFAULT 0,
  `skill_club` int unsigned NOT NULL DEFAULT 10,
  `skill_club_tries` bigint unsigned NOT NULL DEFAULT 0,
  `skill_sword` int unsigned NOT NULL DEFAULT 10,
  `skill_sword_tries` bigint unsigned NOT NULL DEFAULT 0,
  `skill_axe` int unsigned NOT NULL DEFAULT 10,
  `skill_axe_tries` bigint unsigned NOT NULL DEFAULT 0,
  `skill_dist` int unsigned NOT NULL DEFAULT 10,
  `skill_dist_tries` bigint unsigned NOT NULL DEFAULT 0,
  `skill_shielding` int unsigned NOT NULL DEFAULT 10,
  `skill_shielding_tries` bigint unsigned NOT NULL DEFAULT 0,
  `skill_fishing` int unsigned NOT NULL DEFAULT 10,
  `skill_fishing_tries` bigint unsigned NOT NULL DEFAULT 0,
  `token_protected` tinyint NOT NULL DEFAULT '0',
  `token_hash` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  KEY `vocation` (`vocation`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

INSERT INTO `players` (`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`, `currentmount`, `randomizemount`, `direction`, `maglevel`, `mana`, `manamax`, `manaspent`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, `lastlogin`, `lastip`, `save`, `skull`, `skulltime`, `lastlogout`, `blessings`, `onlinetime`, `deletion`, `balance`, `offlinetraining_time`, `offlinetraining_skill`, `stamina`, `skill_fist`, `skill_fist_tries`, `skill_club`, `skill_club_tries`, `skill_sword`, `skill_sword_tries`, `skill_axe`, `skill_axe_tries`, `skill_dist`, `skill_dist_tries`, `skill_shielding`, `skill_shielding_tries`, `skill_fishing`, `skill_fishing_tries`) VALUES
(1, 'Account Manager', 1, 1, 1, 0, 150, 150, 0, 0, 0, 0, 0, 110, 0, 0, 0, 2, 0, 0, 0, 0, 0, 1, 50, 50, 7, NULL, 400, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0);

CREATE TABLE IF NOT EXISTS `player_autolootconfig` (
  `player_id` int(11) NOT NULL,
  `config` blob NOT NULL,
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `account_bans` (
  `account_id` int NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint NOT NULL,
  `expires_at` bigint NOT NULL,
  `banned_by` int NOT NULL,
  PRIMARY KEY (`account_id`),
  FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `account_ban_history` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint NOT NULL,
  `expired_at` bigint NOT NULL,
  `banned_by` int NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `account_storage` (
  `account_id` int NOT NULL,
  `key` int unsigned NOT NULL,
  `value` int NOT NULL,
  PRIMARY KEY (`account_id`, `key`),
  FOREIGN KEY (`account_id`) REFERENCES `accounts`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `ip_bans` (
  `ip` int unsigned NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint NOT NULL,
  `expires_at` bigint NOT NULL,
  `banned_by` int NOT NULL,
  PRIMARY KEY (`ip`),
  FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `player_namelocks` (
  `player_id` int NOT NULL,
  `reason` varchar(255) NOT NULL,
  `namelocked_at` bigint NOT NULL,
  `namelocked_by` int NOT NULL,
  PRIMARY KEY (`player_id`),
  FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`namelocked_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `account_viplist` (
  `account_id` int NOT NULL COMMENT 'id of account whose viplist entry it is',
  `player_id` int NOT NULL COMMENT 'id of target player of viplist entry',
  `description` varchar(128) NOT NULL DEFAULT '',
  UNIQUE KEY `account_player_index` (`account_id`,`player_id`),
  FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `game_storage` (
  `key` int UNSIGNED NOT NULL DEFAULT '0',
  `value` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `guilds` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `ownerid` int NOT NULL,
  `creationdata` int NOT NULL,
  `motd` varchar(255) NOT NULL DEFAULT '',
  `balance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY (`name`),
  UNIQUE KEY (`ownerid`),
  FOREIGN KEY (`ownerid`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `guild_invites` (
  `player_id` int NOT NULL DEFAULT '0',
  `guild_id` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`player_id`,`guild_id`),
  FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `guild_ranks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `guild_id` int NOT NULL COMMENT 'guild',
  `name` varchar(255) NOT NULL COMMENT 'rank name',
  `level` int NOT NULL COMMENT 'rank level - leader, vice, member, maybe something else',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `guild_membership` (
  `player_id` int NOT NULL,
  `guild_id` int NOT NULL,
  `rank_id` int NOT NULL,
  `nick` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`player_id`),
  FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`rank_id`) REFERENCES `guild_ranks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `guild_wars` (
  `id` int NOT NULL AUTO_INCREMENT,
  `guild1` int NOT NULL DEFAULT '0',
  `guild2` int NOT NULL DEFAULT '0',
  `name1` varchar(255) NOT NULL,
  `name2` varchar(255) NOT NULL,
  `status` tinyint NOT NULL DEFAULT '0',
  `started` bigint NOT NULL DEFAULT '0',
  `ended` bigint NOT NULL DEFAULT '0',
  `fraglimit` int NOT NULL DEFAULT '0',
  `payment` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `guild1` (`guild1`),
  KEY `guild2` (`guild2`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `guild_war_kills` (
  `id` int NOT NULL AUTO_INCREMENT,
  `war_id` int NOT NULL,
  `killer_guild` int NOT NULL,
  `killer` int NOT NULL,
  `victim` int NOT NULL,
  `time` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `war_id` (`war_id`),
  KEY `killer_guild` (`killer_guild`),
  FOREIGN KEY (`war_id`) REFERENCES `guild_wars` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `houses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `owner` int NOT NULL,
  `type` varchar(32) NOT NULL DEFAULT 'House',
  `paid` int unsigned NOT NULL DEFAULT '0',
  `warnings` int NOT NULL DEFAULT '0',
  `is_protected` tinyint NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `rent` int NOT NULL DEFAULT '0',
  `town_id` int NOT NULL DEFAULT '0',
  `bid` int NOT NULL DEFAULT '0',
  `bid_end` int NOT NULL DEFAULT '0',
  `last_bid` int NOT NULL DEFAULT '0',
  `highest_bidder` int NOT NULL DEFAULT '0',
  `size` int NOT NULL DEFAULT '0',
  `beds` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `town_id` (`town_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `house_lists` (
  `house_id` int NOT NULL,
  `listid` int NOT NULL,
  `list` text NOT NULL,
  FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `house_guests` (
  `house_id` int NOT NULL,
  `player_id` int NOT NULL,
  PRIMARY KEY (`house_id`, `player_id`),
  FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `market_history` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `sale` tinyint NOT NULL DEFAULT '0',
  `itemtype` smallint unsigned NOT NULL,
  `amount` smallint unsigned NOT NULL,
  `price` int unsigned NOT NULL DEFAULT '0',
  `expires_at` bigint unsigned NOT NULL,
  `inserted` bigint unsigned NOT NULL,
  `state` tinyint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`, `sale`),
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `market_offers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `sale` tinyint NOT NULL DEFAULT '0',
  `itemtype` smallint unsigned NOT NULL,
  `amount` smallint unsigned NOT NULL,
  `created` bigint unsigned NOT NULL,
  `anonymous` tinyint NOT NULL DEFAULT '0',
  `price` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sale` (`sale`,`itemtype`),
  KEY `created` (`created`),
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `players_online` (
 `player_id` int(11) NOT NULL,
  `broadcasting` tinyint(1) NOT NULL DEFAULT '0',
  `password` varchar(40) NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  `spectators` int(11) NOT NULL DEFAULT '0',
  `protocol_version` int(4) NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `player_deaths` (
  `player_id` int NOT NULL,
  `time` bigint unsigned NOT NULL DEFAULT '0',
  `level` int NOT NULL DEFAULT '1',
  `killed_by` varchar(255) NOT NULL,
  `is_player` tinyint NOT NULL DEFAULT '1',
  `mostdamage_by` varchar(100) NOT NULL,
  `mostdamage_is_player` tinyint NOT NULL DEFAULT '0',
  `unjustified` tinyint NOT NULL DEFAULT '0',
  `mostdamage_unjustified` tinyint NOT NULL DEFAULT '0',
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE,
  KEY `killed_by` (`killed_by`),
  KEY `mostdamage_by` (`mostdamage_by`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `player_inboxitems` (
  `player_id` int NOT NULL,
  `sid` int NOT NULL,
  `pid` int NOT NULL DEFAULT '0',
  `itemtype` smallint unsigned NOT NULL,
  `count` smallint NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL,
  UNIQUE KEY `player_id_2` (`player_id`, `sid`),
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `player_storeinboxitems` (
  `player_id` int NOT NULL,
  `sid` int NOT NULL,
  `pid` int NOT NULL DEFAULT '0',
  `itemtype` smallint unsigned NOT NULL,
  `count` smallint NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL,
  UNIQUE KEY `player_id_2` (`player_id`, `sid`),
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `player_depotlockeritems` (
  `player_id` int NOT NULL,
  `sid` int NOT NULL COMMENT 'any given range eg 0-100 will be reserved for depot lockers and all > 100 will be then normal items inside depots',
  `pid` int NOT NULL DEFAULT '0',
  `itemtype` smallint NOT NULL,
  `count` smallint NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL,
  UNIQUE KEY `player_id_2` (`player_id`, `sid`),
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `player_depotitems` (
  `player_id` int NOT NULL,
  `sid` int NOT NULL COMMENT 'any given range eg 0-100 will be reserved for depot lockers and all > 100 will be then normal items inside depots',
  `pid` int NOT NULL DEFAULT '0',
  `itemtype` smallint unsigned NOT NULL,
  `count` smallint NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL,
  UNIQUE KEY `player_id_2` (`player_id`, `sid`),
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `player_items` (
  `player_id` int NOT NULL DEFAULT '0',
  `pid` int NOT NULL DEFAULT '0',
  `sid` int NOT NULL DEFAULT '0',
  `itemtype` smallint unsigned NOT NULL,
  `count` smallint NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL,
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE,
  KEY `sid` (`sid`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `player_mounts` (
  `player_id` int NOT NULL DEFAULT '0',
  `mount_id` smallint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`player_id`, `mount_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `player_spells` (
  `player_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `player_storage` (
  `player_id` int NOT NULL DEFAULT '0',
  `key` int unsigned NOT NULL DEFAULT '0',
  `value` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`player_id`,`key`),
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `player_outfits` (
  `player_id` int NOT NULL DEFAULT '0',
  `outfit_id` smallint unsigned NOT NULL DEFAULT '0',
  `addons` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`player_id`,`outfit_id`),
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `player_debugasserts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `assert_line` varchar(255) NOT NULL,
  `date` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`),
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `server_config` (
  `config` varchar(50) NOT NULL,
  `value` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY `config` (`config`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `tile_store` (
  `house_id` int NOT NULL,
  `data` longblob NOT NULL,
  FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS `towns` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `posx` int NOT NULL DEFAULT '0',
  `posy` int NOT NULL DEFAULT '0',
  `posz` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

INSERT INTO `server_config` (`config`, `value`) VALUES ('db_version', '29'), ('motd_hash', ''), ('motd_num', '0'), ('players_record', '0');

DROP TRIGGER IF EXISTS `ondelete_players`;
DROP TRIGGER IF EXISTS `oncreate_guilds`;

DELIMITER //
CREATE TRIGGER `ondelete_players` BEFORE DELETE ON `players`
 FOR EACH ROW BEGIN
    UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id`;
END
//
CREATE TRIGGER `oncreate_guilds` AFTER INSERT ON `guilds`
 FOR EACH ROW BEGIN
    INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('the Leader', 3, NEW.`id`);
    INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('a Vice-Leader', 2, NEW.`id`);
    INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('a Member', 1, NEW.`id`);
END
//

CREATE TABLE IF NOT EXISTS `guild_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guild_id` int(11) NOT NULL,
  `guild_associated` int(11) DEFAULT NULL,
  `player_associated` int(11) DEFAULT NULL,
  `type` ENUM('DEPOSIT', 'WITHDRAW') NOT NULL,
  `category` ENUM ('OTHER', 'RENT', 'MATERIAL', 'SERVICES', 'REVENUE', 'CONTRIBUTION') NOT NULL DEFAULT 'OTHER',
  `balance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `time` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`guild_id`) REFERENCES `guilds`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`guild_associated`) REFERENCES `guilds`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`player_associated`) REFERENCES `players`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;
DELIMITER ;

-- Custom Aethrium War Scoreboard Table
-- UNIQUE KEY (guild_id, round_id) Ã© obrigatÃ³rio para o
-- ON DUPLICATE KEY UPDATE frags + 1 funcionar no Lua.
CREATE TABLE IF NOT EXISTS `war_scores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `guild_id` int NOT NULL,
  `frags` int NOT NULL DEFAULT '0',
  `round_id` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `guild_round` (`guild_id`, `round_id`),
  FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;
-- Seed for Accounts 1-7
-- Passwords are SHA1(N) where N is the account number
INSERT INTO `accounts` (`id`, `name`, `password`, `type`) VALUES
(1, '1', '356a192b7913b04c54574d18c28d46e6395428ab', 1),
(2, '2', 'da4b9237bacccdf19c0760cab7aec4a8359010b0', 1),
(3, '3', '77de68daecd823babbb58edb1c8e14d7106e83bb', 1),
(4, '4', '1b6453892473a467d07372d45eb05abc2031647a', 1),
(5, '5', 'ac3478d69a3c81fa62e60f5c3696165a4e5e6ac4', 1),
(6, '6', 'c1dfd96eea8cc2b62785275bca38ac261256e278', 1),
(7, '7', '902ba3cda1883801594b6e1b452790cc53948fda', 1)
ON DUPLICATE KEY UPDATE `password` = VALUES(`password`);
-- Seed for the 7 Team Leaders
-- Required for guild ownership constraints
INSERT INTO `players` (`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `looktype`, `maglevel`, `mana`, `manamax`, `town_id`, `posx`, `posy`, `posz`) VALUES
(2, 'Bubble', 1, 1, 221, 4, 3000, 3000, 150000000, 128, 10, 500, 500, 1, 1024, 633, 7),
(3, 'Undead Slayer', 1, 2, 222, 4, 3000, 3000, 150000000, 128, 10, 500, 500, 1, 1024, 633, 7),
(4, 'Irie D', 1, 3, 185, 4, 2500, 2500, 80000000, 128, 9, 400, 400, 1, 1024, 633, 7),
(5, 'Eternal Oblivion', 1, 4, 292, 4, 4500, 4500, 340000000, 128, 11, 800, 800, 1, 1024, 633, 7),
(6, 'Cachero', 1, 5, 222, 1, 1200, 1200, 150000000, 130, 85, 6000, 6000, 1, 1024, 633, 7),
(7, 'Seromontis', 1, 6, 223, 4, 3100, 3100, 155000000, 128, 10, 550, 550, 1, 1024, 633, 7),
(8, 'Mateusz Dragon Wielki', 1, 7, 241, 2, 1350, 1350, 227000000, 130, 55, 7000, 7000, 1, 1024, 633, 7)
ON DUPLICATE KEY UPDATE `level` = VALUES(`level`);
-- Seed for the 7 Official Teams
INSERT INTO `guilds` (`id`, `name`, `ownerid`, `creationdata`) VALUES
(1, 'Antica Team', 2, UNIX_TIMESTAMP()),
(2, 'Nova Team', 3, UNIX_TIMESTAMP()),
(3, 'Secura Team', 4, UNIX_TIMESTAMP()),
(4, 'Amera Team', 5, UNIX_TIMESTAMP()),
(5, 'Calmera Team', 6, UNIX_TIMESTAMP()),
(6, 'Hiberna Team', 7, UNIX_TIMESTAMP()),
(7, 'Harmonia Team', 8, UNIX_TIMESTAMP())
ON DUPLICATE KEY UPDATE `ownerid` = VALUES(`ownerid`);

-- Member assignment for Leaders
-- Note: Requires guild_ranks to exist (created by trigger)
INSERT INTO `guild_membership` (`player_id`, `guild_id`, `rank_id`)
SELECT 2, 1, id FROM `guild_ranks` WHERE `guild_id` = 1 AND `level` = 3
UNION ALL
SELECT 3, 2, id FROM `guild_ranks` WHERE `guild_id` = 2 AND `level` = 3
UNION ALL
SELECT 4, 3, id FROM `guild_ranks` WHERE `guild_id` = 3 AND `level` = 3
UNION ALL
SELECT 5, 4, id FROM `guild_ranks` WHERE `guild_id` = 4 AND `level` = 3
UNION ALL
SELECT 6, 5, id FROM `guild_ranks` WHERE `guild_id` = 5 AND `level` = 3
UNION ALL
SELECT 7, 6, id FROM `guild_ranks` WHERE `guild_id` = 6 AND `level` = 3
UNION ALL
SELECT 8, 7, id FROM `guild_ranks` WHERE `guild_id` = 7 AND `level` = 3
ON DUPLICATE KEY UPDATE `guild_id` = VALUES(`guild_id`);
-- Phase 3: Character Migration
INSERT INTO `players` (`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`, `currentmount`, `randomizemount`, `direction`, `maglevel`, `mana`, `manamax`, `manaspent`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, `lastlogin`, `lastip`, `save`, `skull`, `skulltime`, `lastlogout`, `blessings`, `onlinetime`, `deletion`, `balance`, `offlinetraining_time`, `offlinetraining_skill`, `stamina`, `skill_fist`, `skill_fist_tries`, `skill_club`, `skill_club_tries`, `skill_sword`, `skill_sword_tries`, `skill_axe`, `skill_axe_tries`, `skill_dist`, `skill_dist_tries`, `skill_shielding`, `skill_shielding_tries`, `skill_fishing`, `skill_fishing_tries`) VALUES
(9, 'Aaron Soulbringer', 1, 6, 156, 2, 925, 925, 60884000, 0, 94, 116, 94, 130, 0, 0, 0, 2, 55, 4475, 4475, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(10, 'Adric', 1, 1, 174, 4, 2675, 2675, 84821900, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 865, 865, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(11, 'Aerwyn Angelsdaughter', 1, 4, 139, 3, 1495, 1495, 43074019, 132, 125, 78, 114, 129, 0, 0, 0, 2, 25, 2000, 2000, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(12, 'Alex The Dark Knight', 1, 5, 169, 4, 2600, 2600, 78772784, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 840, 840, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(13, 'Alfa Aguia Dani', 1, 7, 153, 3, 1635, 1635, 57395200, 114, 63, 116, 63, 129, 0, 0, 0, 2, 25, 2210, 2210, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(14, 'Alfonzo', 1, 3, 197, 1, 1130, 1130, 124460889, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 5705, 5705, 0, 100, 1, 1030, 566, 7, NULL, 0, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(15, 'Alianius Eterion', 1, 6, 156, 4, 2405, 2405, 60884000, 0, 94, 116, 94, 134, 0, 0, 0, 2, 8, 775, 775, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(16, 'Ancient of demon', 1, 7, 150, 4, 2315, 2315, 54042300, 114, 63, 116, 63, 134, 0, 0, 0, 2, 8, 745, 745, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(17, 'Andinho', 1, 4, 158, 3, 1675, 1675, 63286700, 132, 125, 78, 114, 129, 0, 0, 0, 2, 25, 2270, 2270, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(18, 'Anodax', 1, 7, 150, 4, 2315, 2315, 54042300, 114, 63, 116, 63, 134, 0, 0, 0, 2, 8, 745, 745, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(19, 'Apocalipsis', 1, 1, 195, 4, 2990, 2990, 119833800, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 970, 970, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(20, 'Aragami', 1, 1, 280, 3, 2905, 2905, 358105800, 114, 114, 116, 76, 129, 0, 0, 0, 2, 25, 4115, 4115, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(21, 'Arozonic Bow Master', 1, 7, 167, 2, 980, 980, 74882600, 114, 63, 116, 63, 130, 0, 0, 0, 2, 55, 4805, 4805, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(22, 'Balor De Nur', 1, 6, 148, 3, 1585, 1585, 51881200, 0, 94, 116, 94, 129, 0, 0, 0, 2, 25, 2135, 2135, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(23, 'Band', 1, 4, 176, 1, 1025, 1025, 87868625, 132, 125, 78, 114, 130, 0, 0, 0, 2, 55, 5075, 5075, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(24, 'Barba Destroyer', 1, 4, 148, 3, 1595, 1595, 52486915, 132, 125, 78, 114, 129, 0, 0, 0, 2, 25, 2150, 2150, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(25, 'Bartek-Butek', 1, 6, 146, 4, 2255, 2255, 49778500, 0, 94, 116, 94, 134, 0, 0, 0, 2, 8, 725, 725, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(26, 'Benosa of Darkness', 1, 6, 146, 4, 2255, 2255, 49778500, 0, 94, 116, 94, 134, 0, 0, 0, 2, 8, 725, 725, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(27, 'Blinx', 1, 2, 183, 1, 1060, 1060, 98844200, 114, 57, 116, 126, 130, 0, 0, 0, 2, 55, 5285, 5285, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(28, 'Bravo Hugo', 1, 5, 168, 3, 1785, 1785, 78772784, 0, 50, 116, 126, 129, 0, 0, 0, 2, 25, 2435, 2435, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(29, 'Burt Simpson', 1, 3, 210, 4, 3215, 3215, 151429981, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 1045, 1045, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(30, 'Butcher Man', 1, 4, 145, 2, 870, 870, 49499104, 132, 125, 78, 114, 130, 0, 0, 0, 2, 55, 4145, 4145, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(31, 'Bysiu', 1, 3, 160, 4, 2465, 2465, 66441714, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 795, 795, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(32, 'Cafum', 1, 5, 153, 4, 2360, 2360, 57395200, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 760, 760, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(33, 'Calax', 1, 4, 188, 4, 2885, 2885, 107263200, 132, 125, 78, 114, 134, 0, 0, 0, 2, 8, 935, 935, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(34, 'Carchii', 1, 2, 180, 4, 2765, 2765, 94010800, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 895, 895, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(35, 'Carsomyr', 1, 5, 176, 1, 1025, 1025, 87868501, 0, 50, 116, 126, 130, 0, 0, 0, 2, 55, 5075, 5075, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(36, 'Cassius Excalibur', 1, 6, 153, 1, 910, 910, 57395200, 0, 94, 116, 94, 130, 0, 0, 0, 2, 55, 4385, 4385, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(37, 'Cerepton', 1, 6, 152, 4, 2345, 2345, 56262600, 0, 94, 116, 94, 134, 0, 0, 0, 2, 8, 755, 755, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(38, 'Cham paly', 1, 1, 165, 3, 1755, 1755, 72192800, 114, 114, 116, 76, 129, 0, 0, 0, 2, 25, 2390, 2390, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(39, 'Cromosomax', 1, 2, 151, 4, 2330, 2330, 55145000, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 750, 750, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(40, 'Dagor Dragontooth', 1, 1, 199, 4, 3050, 3050, 127439400, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 990, 990, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(41, 'Dan Jagiello', 1, 7, 146, 4, 2255, 2255, 49778500, 114, 63, 116, 63, 134, 0, 0, 0, 2, 8, 725, 725, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(42, 'Danger II', 1, 1, 300, 3, 3105, 3105, 441084800, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 4415, 4415, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(43, 'Danger III', 1, 1, 288, 4, 4385, 4385, 390366775, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 1435, 1435, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(44, 'Danger IV', 1, 1, 300, 1, 1645, 1645, 444460825, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 8795, 8795, 0, 100, 1, 1029, 566, 7, NULL, 1330, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(45, 'Danger Sorc', 1, 1, 1, 1, 2000, 2000, 100, 114, 57, 116, 126, 130, 0, 0, 0, 2, 40, 2500, 2500, 0, 100, 1, 1299, 571, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(46, 'Dark Daniel', 1, 1, 160, 4, 2465, 2465, 65751800, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 795, 795, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(47, 'Dark Demension', 1, 3, 165, 1, 970, 970, 73236128, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 4745, 4745, 0, 100, 1, 1029, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(48, 'Dark Nimbus Man', 1, 5, 151, 4, 2330, 2330, 55145000, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 750, 750, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(49, 'Darth Sithius', 1, 4, 174, 3, 1845, 1845, 84821900, 132, 125, 78, 114, 129, 0, 0, 0, 2, 25, 2525, 2525, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(50, 'Deamon', 1, 1, 280, 3, 2195, 2195, 358105800, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 3050, 3050, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(51, 'Deba Master', 1, 6, 150, 3, 1605, 1605, 54042300, 0, 94, 116, 94, 129, 0, 0, 0, 2, 25, 2165, 2165, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(52, 'Denis Tacador De Runa', 1, 5, 159, 2, 940, 940, 64511400, 0, 50, 116, 126, 130, 0, 0, 0, 2, 55, 4565, 4565, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(53, 'Desew', 1, 1, 167, 4, 2570, 2570, 74882600, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 830, 830, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(54, 'Didukun', 1, 5, 162, 4, 2495, 2495, 69210780, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 805, 805, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(55, 'Distarus', 1, 1, 280, 1, 1545, 1545, 358105800, 114, 114, 116, 76, 130, 0, 0, 0, 2, 60, 8195, 8195, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(56, 'Dolmet', 1, 6, 173, 3, 1835, 1835, 83351200, 0, 94, 116, 94, 129, 0, 0, 0, 2, 25, 2510, 2510, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(57, 'Domelus', 1, 7, 160, 3, 1705, 1705, 65751800, 114, 63, 116, 63, 129, 0, 0, 0, 2, 25, 2315, 2315, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(58, 'Dratini angel', 1, 7, 140, 4, 2165, 2165, 43812800, 114, 63, 116, 63, 134, 0, 0, 0, 2, 8, 695, 695, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(59, 'Drazharm', 1, 1, 250, 3, 2605, 2605, 254237300, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 3665, 3665, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(60, 'Dritia', 1, 7, 173, 2, 1010, 1010, 83351200, 114, 63, 116, 63, 130, 0, 0, 0, 2, 55, 4985, 4985, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(61, 'Eduzin Knight', 1, 5, 181, 4, 2780, 2780, 96259793, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 900, 900, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(62, 'El Margaro', 1, 5, 151, 4, 2330, 2330, 55145000, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 750, 750, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(63, 'Eldeus', 1, 3, 156, 3, 1665, 1665, 61816915, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 2255, 2255, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(64, 'Eohar', 1, 3, 176, 1, 1025, 1025, 87967622, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 5075, 5075, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(65, 'Epicranio', 1, 7, 159, 1, 940, 940, 64511400, 114, 63, 116, 63, 130, 0, 0, 0, 2, 55, 4565, 4565, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(66, 'Erox', 1, 1, 300, 3, 3105, 3105, 441084800, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 4415, 4415, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(67, 'Euroty Hyypes', 1, 3, 152, 3, 1625, 1625, 56597693, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 2195, 2195, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(68, 'Eusaro', 1, 6, 146, 4, 2255, 2255, 49778500, 0, 94, 116, 94, 134, 0, 0, 0, 2, 8, 725, 725, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(69, 'Evu', 1, 1, 280, 3, 2195, 2195, 358105800, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 3050, 3050, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(70, 'Exequter', 1, 2, 212, 1, 1205, 1205, 154367600, 114, 57, 116, 126, 130, 0, 0, 0, 2, 55, 6155, 6155, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(71, 'Fandr', 1, 5, 166, 3, 1765, 1765, 74444206, 0, 50, 116, 126, 129, 0, 0, 0, 2, 25, 2405, 2405, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(72, 'Faraonek', 1, 2, 157, 4, 2420, 2420, 62077600, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 780, 780, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(73, 'Farlo Beat', 1, 3, 170, 4, 2600, 2600, 79041300, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 840, 840, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(74, 'Figueingy', 1, 5, 173, 4, 2660, 2660, 83655603, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 860, 860, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(75, 'Filho da Nomuxe', 1, 5, 171, 1, 1000, 1000, 81404637, 0, 50, 116, 126, 130, 0, 0, 0, 2, 55, 4925, 4925, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(76, 'Frewa', 1, 3, 160, 4, 2465, 2465, 65752594, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 795, 795, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(77, 'Garganfunker', 1, 6, 158, 3, 1685, 1685, 63286700, 0, 94, 116, 94, 129, 0, 0, 0, 2, 25, 2285, 2285, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(78, 'Ghael', 1, 5, 199, 4, 3050, 3050, 128195018, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 990, 990, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(79, 'Goblinsworder', 1, 2, 195, 4, 2990, 2990, 119833800, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 970, 970, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(80, 'God Danger', 1, 1, 222222, 5, 3255, 3255, 4340325221, 94, 7, 3, 94, 130, 0, 0, 0, 2, 9999999, 18455, 18455, 0, 100, 1, 1087, 575, 7, NULL, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 13, 0, 15, 0, 10, 0, 10, 0, 13, 0, 10, 0, 10, 0),
(81, 'God Xupy', 1, 1, 613, 1, 3210, 3210, 3818314994, 109, 0, 20, 109, 130, 0, 0, 0, 2, 9999999, 18185, 18185, 0, 100, 1, 1055, 608, 7, NULL, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 12, 0, 15, 0, 12, 0, 10, 0, 11, 0, 10, 0, 10, 0),
(82, 'Gohigoge', 1, 4, 138, 4, 2135, 2135, 42108110, 132, 125, 78, 114, 134, 0, 0, 0, 2, 8, 685, 685, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(83, 'Gorasuls', 1, 3, 162, 3, 1725, 1725, 68280100, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 2345, 2345, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(84, 'Graeme grinder', 1, 7, 144, 4, 2225, 2225, 47733400, 114, 63, 116, 63, 134, 0, 0, 0, 2, 8, 715, 715, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(85, 'Guardian Alien', 1, 1, 206, 3, 2165, 2165, 141511500, 114, 114, 116, 76, 129, 0, 0, 0, 2, 25, 3005, 3005, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(86, 'Gugo', 1, 4, 209, 3, 2195, 2195, 148487150, 132, 125, 78, 114, 129, 0, 0, 0, 2, 25, 3050, 3050, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(87, 'Halfhigh', 1, 1, 152, 4, 2345, 2345, 56262600, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 755, 755, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(88, 'Halge', 1, 1, 161, 4, 2480, 2480, 67008000, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 800, 800, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(89, 'Herganon', 1, 7, 204, 3, 2145, 2145, 137390400, 114, 63, 116, 63, 129, 0, 0, 0, 2, 25, 2975, 2975, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(90, 'Hesperides', 1, 1, 206, 2, 1175, 1175, 141511500, 114, 114, 116, 76, 130, 0, 0, 0, 2, 55, 5975, 5975, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(91, 'Hydecka', 1, 6, 143, 4, 2210, 2210, 46732200, 0, 94, 116, 94, 134, 0, 0, 0, 2, 8, 710, 710, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(92, 'Ingek', 1, 5, 215, 1, 1220, 1220, 161391823, 0, 50, 116, 126, 130, 0, 0, 0, 2, 55, 6245, 6245, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(93, 'Jacke-Ekblom', 1, 1, 146, 4, 2255, 2255, 49778500, 114, 57, 126, 126, 134, 0, 0, 0, 2, 8, 725, 725, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(94, 'James Dark', 1, 2, 160, 3, 1705, 1705, 65751800, 114, 57, 116, 126, 129, 0, 0, 0, 2, 25, 2315, 2315, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(95, 'Jane the pal', 1, 1, 146, 3, 1565, 1565, 49778500, 114, 57, 126, 126, 129, 0, 0, 0, 2, 25, 2105, 2105, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(96, 'Jareknes', 1, 4, 158, 4, 2420, 2420, 62612225, 132, 125, 78, 114, 134, 0, 0, 0, 2, 8, 780, 780, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(97, 'Jetob The Knight', 1, 1, 144, 4, 2225, 2225, 47733400, 114, 57, 126, 126, 134, 0, 0, 0, 2, 8, 715, 715, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(98, 'Jynx', 1, 1, 270, 2, 1495, 1495, 320836300, 114, 63, 116, 63, 130, 0, 0, 0, 2, 55, 7895, 7895, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(99, 'Kaktus Hunter', 1, 3, 165, 1, 970, 970, 73005246, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 4745, 4745, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(100, 'Kalili', 1, 7, 146, 4, 2255, 2255, 49778500, 114, 63, 116, 63, 134, 0, 0, 0, 2, 8, 725, 725, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(101, 'Kaori Sato', 1, 6, 141, 4, 2180, 2180, 44772000, 0, 94, 116, 94, 134, 0, 0, 0, 2, 8, 700, 700, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(102, 'Kawaa', 1, 4, 149, 1, 890, 890, 53309481, 132, 125, 78, 114, 130, 0, 0, 0, 2, 55, 4265, 4265, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(103, 'Kazu Neu', 1, 5, 151, 4, 2330, 2330, 55145000, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 750, 750, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(104, 'Keppi', 1, 2, 156, 1, 925, 925, 60884000, 114, 57, 116, 126, 130, 0, 0, 0, 2, 55, 4475, 4475, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(105, 'Kimn Knight', 1, 6, 150, 4, 2315, 2315, 54042300, 0, 94, 116, 94, 134, 0, 0, 0, 2, 8, 745, 745, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(106, 'Kiryh', 1, 7, 208, 1, 1185, 1185, 145714200, 114, 63, 116, 63, 130, 0, 0, 0, 2, 55, 6035, 6035, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(107, 'Carchii', 1, 2, 180, 1, 1045, 1045, 94010800, 114, 57, 116, 126, 130, 0, 0, 0, 2, 55, 5195, 5195, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(108, 'Naraku', 1, 1, 350, 3, 3605, 3605, 702432300, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 5165, 5165, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(109, 'Paladin2', 1, 1, 2, 3, 125, 125, 100, 114, 57, 116, 126, 129, 0, 0, 0, 2, 15, 240, 240, 0, 100, 1, 1299, 571, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(110, 'Kry to', 1, 1, 180, 4, 2765, 2765, 94010800, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 895, 895, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(111, 'Kuwuten', 1, 1, 157, 4, 2420, 2420, 62077600, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 780, 780, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(112, 'Lady Martunia', 1, 7, 153, 1, 910, 910, 57395200, 114, 63, 116, 63, 130, 0, 0, 0, 2, 55, 4385, 4385, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(113, 'Lawebuz', 1, 1, 161, 4, 2480, 2480, 67008000, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 800, 800, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(114, 'Lifely Sorcerer', 1, 6, 148, 1, 885, 885, 51881200, 0, 94, 116, 94, 130, 0, 0, 0, 2, 55, 4235, 4235, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(115, 'Liromir', 1, 7, 178, 1, 1035, 1035, 90877700, 114, 63, 116, 63, 130, 0, 0, 0, 2, 55, 5135, 5135, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(116, 'Lobello', 1, 1, 167, 2, 980, 980, 74882600, 114, 114, 116, 76, 130, 0, 0, 0, 2, 55, 4805, 4805, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(117, 'Logen Miles', 1, 1, 300, 3, 3105, 3105, 441084800, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 4415, 4415, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(118, 'Lord Lobek', 1, 5, 156, 3, 1665, 1665, 60884000, 0, 50, 116, 126, 129, 0, 0, 0, 2, 25, 2255, 2255, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(119, 'Lord Strutt', 1, 6, 141, 4, 2180, 2180, 44772000, 0, 94, 116, 94, 134, 0, 0, 0, 2, 8, 700, 700, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(120, 'Lord Xavy', 1, 1, 171, 3, 1815, 1815, 80461000, 114, 114, 116, 76, 129, 0, 0, 0, 2, 25, 2480, 2480, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(121, 'Luisingy', 1, 5, 217, 4, 3320, 3320, 166134348, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 1080, 1080, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(122, 'Luthien Frostmourne', 1, 6, 202, 4, 3095, 3095, 133350100, 0, 94, 116, 94, 134, 0, 0, 0, 2, 8, 1005, 1005, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(123, 'Marshall', 1, 3, 170, 3, 1805, 1805, 79378594, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 2465, 2465, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(124, 'Martin Langbogen', 1, 1, 160, 3, 1705, 1705, 65751800, 114, 114, 116, 76, 129, 0, 0, 0, 2, 25, 2315, 2315, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(125, 'Master Morla', 1, 6, 143, 1, 860, 860, 46732200, 0, 94, 116, 94, 130, 0, 0, 0, 2, 55, 4085, 4085, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(126, 'Mastro Daro', 1, 2, 184, 1, 1065, 1065, 100491400, 114, 57, 116, 126, 130, 0, 0, 0, 2, 55, 5315, 5315, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(127, 'Meroti', 1, 2, 153, 4, 2360, 2360, 57395200, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 760, 760, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(128, 'Miller', 1, 2, 178, 1, 1035, 1035, 90877700, 114, 57, 116, 126, 130, 0, 0, 0, 2, 55, 5135, 5135, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(129, 'Mliows', 1, 5, 154, 2, 915, 915, 58542900, 0, 50, 116, 126, 130, 0, 0, 0, 2, 55, 4415, 4415, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(130, 'Mountain Elf', 1, 4, 160, 4, 2465, 2465, 66844309, 132, 125, 78, 114, 134, 0, 0, 0, 2, 8, 795, 795, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(131, 'Muncher', 1, 4, 152, 4, 2345, 2345, 56681410, 132, 125, 78, 114, 134, 0, 0, 0, 2, 8, 755, 755, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(132, 'Naraku', 1, 1, 300, 3, 3105, 3105, 441084800, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 4415, 4415, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(133, 'Narcosis', 1, 4, 142, 1, 855, 855, 46066289, 132, 125, 78, 114, 130, 0, 0, 0, 2, 55, 4055, 4055, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(134, 'Nervine', 1, 4, 146, 1, 875, 875, 50275086, 132, 125, 78, 114, 130, 0, 0, 0, 2, 55, 4175, 4175, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(135, 'Nezogogi', 1, 3, 184, 2, 1065, 1065, 101092570, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 5315, 5315, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(136, 'Nidhoog', 1, 2, 150, 3, 1605, 1605, 54042300, 114, 57, 116, 126, 129, 0, 0, 0, 2, 25, 2165, 2165, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(137, 'Nuvemem', 1, 7, 151, 4, 2330, 2330, 55145000, 114, 63, 116, 63, 134, 0, 0, 0, 2, 8, 750, 750, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(138, 'Olo Bulge', 1, 3, 153, 1, 910, 910, 58000002, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 4385, 4385, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(139, 'Orzel', 1, 3, 175, 2, 1020, 1020, 86621538, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 5045, 5045, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(140, 'Oten', 1, 2, 163, 4, 2510, 2510, 69568200, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 810, 810, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(141, 'Oura', 1, 3, 160, 1, 945, 945, 66876009, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 4595, 4595, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(142, 'Painful hands', 1, 6, 153, 3, 1635, 1635, 57395200, 0, 94, 116, 94, 129, 0, 0, 0, 2, 25, 2210, 2210, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(143, 'Pancras Dragonheart', 1, 7, 200, 3, 2105, 2105, 129389800, 114, 63, 116, 63, 129, 0, 0, 0, 2, 25, 2915, 2915, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(144, 'Pavlo', 1, 1, 300, 3, 3105, 3105, 441084800, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 4415, 4415, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(145, 'Penancea', 1, 7, 201, 4, 3080, 3080, 131360000, 114, 63, 116, 63, 134, 0, 0, 0, 2, 8, 1000, 1000, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(146, 'Pepelu', 1, 1, 165, 3, 1755, 1755, 72192800, 114, 114, 116, 76, 129, 0, 0, 0, 2, 25, 2390, 2390, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(147, 'Phoenix del fenix', 1, 5, 163, 1, 960, 960, 69829852, 0, 50, 116, 126, 130, 0, 0, 0, 2, 55, 4685, 4685, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(148, 'Pibby', 1, 6, 153, 3, 1635, 1635, 57395200, 0, 94, 116, 94, 129, 0, 0, 0, 2, 25, 2210, 2210, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(149, 'Pieszczochh-pila', 1, 3, 167, 4, 2570, 2570, 75460282, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 830, 830, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(150, 'Pker', 1, 1, 250, 1, 950, 950, 254237300, 114, 57, 116, 126, 130, 0, 0, 0, 2, 55, 4625, 4625, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(151, 'Pogromczyni Swiatla', 1, 7, 172, 2, 1005, 1005, 81897600, 114, 63, 116, 63, 130, 0, 0, 0, 2, 55, 4955, 4955, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(152, 'Purerior', 1, 2, 185, 1, 1070, 1070, 102156800, 114, 57, 116, 126, 130, 0, 0, 0, 2, 55, 5345, 5345, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(153, 'Quatre Sandrock', 1, 4, 146, 4, 2255, 2255, 49988031, 132, 125, 78, 114, 134, 0, 0, 0, 2, 8, 725, 725, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(154, 'Raafaell', 1, 7, 156, 1, 925, 925, 60884000, 114, 63, 116, 63, 130, 0, 0, 0, 2, 55, 4475, 4475, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(155, 'Raffio', 1, 2, 200, 4, 3065, 3065, 129389800, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 995, 995, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(156, 'Refedebo', 1, 4, 152, 4, 2345, 2345, 56681410, 132, 125, 78, 114, 134, 0, 0, 0, 2, 8, 755, 755, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(157, 'Rhapsody', 1, 2, 169, 4, 2600, 2600, 77638400, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 840, 840, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(158, 'Rheakith', 1, 4, 166, 4, 2555, 2555, 74043926, 132, 125, 78, 114, 134, 0, 0, 0, 2, 8, 825, 825, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(159, 'Rockarou', 1, 6, 162, 4, 2495, 2495, 68280100, 0, 94, 116, 94, 134, 0, 0, 0, 2, 8, 805, 805, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(160, 'Routi', 1, 7, 140, 1, 845, 845, 43812800, 114, 63, 116, 63, 130, 0, 0, 0, 2, 55, 3995, 3995, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(161, 'Salve Knight', 1, 1, 200, 3, 2105, 2105, 129389800, 114, 114, 116, 76, 129, 0, 0, 0, 2, 25, 2915, 2915, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(162, 'Sashra', 1, 1, 181, 4, 2780, 2780, 95604000, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 900, 900, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(163, 'Savage Funkstar', 1, 6, 175, 4, 2690, 2690, 86309800, 0, 94, 116, 94, 134, 0, 0, 0, 2, 8, 870, 870, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(164, 'Selphie', 1, 5, 162, 4, 2495, 2495, 69210780, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 805, 805, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(165, 'Semiramida', 1, 3, 173, 4, 2660, 2660, 83576159, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 860, 860, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(166, 'Sephirothe', 1, 1, 170, 3, 1805, 1805, 79041300, 114, 114, 116, 76, 129, 0, 0, 0, 2, 25, 2465, 2465, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(167, 'Shawe', 1, 4, 144, 4, 2225, 2225, 47910063, 132, 125, 78, 114, 134, 0, 0, 0, 2, 8, 715, 715, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(168, 'Sir Baxter', 1, 1, 143, 4, 2210, 2210, 46732200, 114, 57, 126, 126, 134, 0, 0, 0, 2, 8, 710, 710, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(169, 'Sir Seamus of Halo', 1, 5, 153, 4, 2360, 2360, 57395200, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 760, 760, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(170, 'Socha', 1, 4, 169, 4, 2600, 2600, 78233420, 132, 125, 78, 114, 134, 0, 0, 0, 2, 8, 840, 840, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(171, 'Sorcerer of the dark age', 1, 7, 156, 1, 925, 925, 60884000, 114, 63, 116, 63, 130, 0, 0, 0, 2, 55, 4475, 4475, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(172, 'Sorrrrc', 1, 1, 170, 1, 995, 995, 79041300, 114, 57, 116, 126, 130, 0, 0, 0, 2, 55, 1655, 4895, 0, 100, 1, 1087, 579, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(173, 'Squidy', 1, 4, 195, 4, 2990, 2990, 119974060, 132, 125, 78, 114, 134, 0, 0, 0, 2, 8, 970, 970, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(174, 'Steffl', 1, 1, 181, 4, 2780, 2780, 95604000, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 900, 900, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(175, 'Stonehurst', 1, 3, 156, 4, 2405, 2405, 60932161, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 775, 775, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(176, 'Strike-Dziadzia', 1, 7, 141, 3, 1515, 1515, 44772000, 114, 63, 116, 63, 129, 0, 0, 0, 2, 25, 2030, 2030, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(177, 'Striker Hero', 1, 5, 147, 4, 2270, 2270, 50822600, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 730, 730, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(178, 'Strinnity', 1, 1, 184, 1, 1065, 1065, 100491400, 114, 114, 116, 76, 130, 0, 0, 0, 2, 55, 5315, 5315, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(179, 'Suprido', 1, 1, 181, 1, 1050, 1050, 95604000, 114, 114, 116, 76, 130, 0, 0, 0, 2, 55, 5225, 5225, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(180, 'Surufon', 1, 3, 195, 2, 1120, 1120, 121330227, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 5645, 5645, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(181, 'Suzey II', 1, 1, 300, 1, 1645, 1645, 441084800, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 8795, 8795, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(182, 'Tai Fei', 1, 2, 181, 4, 2780, 2780, 95604000, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 900, 900, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(183, 'Taikioku', 1, 2, 161, 4, 2480, 2480, 67008000, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 800, 800, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(184, 'Takhissis', 1, 6, 143, 2, 860, 860, 46732200, 0, 94, 116, 94, 130, 0, 0, 0, 2, 55, 4085, 4085, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(185, 'Tearuos', 1, 4, 152, 1, 930, 930, 56723865, 132, 125, 78, 114, 130, 0, 0, 0, 2, 55, 4505, 4505, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(186, 'Tedunio', 1, 7, 182, 4, 2795, 2795, 97215100, 114, 63, 116, 63, 134, 0, 0, 0, 2, 8, 905, 905, 0, 100, 1, 1024, 633, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(187, 'Templier', 1, 3, 153, 4, 2360, 2360, 58314166, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 760, 760, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(188, 'Timon', 1, 1, 166, 4, 2555, 2555, 73529500, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 825, 825, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(189, 'Tobei', 1, 2, 150, 4, 2315, 2315, 54042300, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 745, 745, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(190, 'Todihoru', 1, 3, 155, 4, 2390, 2390, 60554842, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 770, 770, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(191, 'Tonnyy', 1, 2, 161, 4, 2480, 2480, 67008000, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 800, 800, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(192, 'Typhoonia', 1, 1, 250, 3, 2605, 2605, 254237300, 114, 114, 116, 76, 129, 0, 0, 0, 2, 25, 3665, 3665, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(193, 'Ufuk Sahin II', 1, 1, 300, 3, 3105, 3105, 441084800, 132, 125, 78, 114, 129, 0, 0, 0, 2, 25, 4415, 4415, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(194, 'Ufuk Sahin', 1, 1, 300, 3, 3105, 3105, 441084800, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 4415, 4415, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(195, 'Uncle Barry', 1, 3, 172, 4, 2645, 2645, 82617920, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 855, 855, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(196, 'Veldoor', 1, 1, 171, 1, 1000, 1000, 80461000, 114, 114, 116, 76, 130, 0, 0, 0, 2, 55, 4925, 4925, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(197, 'Vetius', 1, 3, 159, 4, 2450, 2450, 64560598, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 790, 790, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(198, 'Villo', 1, 1, 300, 1, 1645, 1645, 441084800, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 8795, 8795, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(199, 'Vossione', 1, 2, 150, 3, 1605, 1605, 54042300, 114, 57, 116, 126, 129, 0, 0, 0, 2, 25, 2165, 2165, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(200, 'Widomaker', 1, 6, 163, 1, 960, 960, 69568200, 0, 94, 116, 94, 130, 0, 0, 0, 2, 55, 4685, 4685, 0, 100, 1, 1105, 539, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(201, 'Wiejski Chlopak', 1, 1, 270, 3, 2805, 2805, 320836300, 114, 114, 116, 76, 129, 0, 0, 0, 2, 25, 3965, 3965, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(202, 'Wigoholi', 1, 5, 157, 2, 930, 930, 62077600, 0, 50, 116, 126, 130, 0, 0, 0, 2, 55, 4505, 4505, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(203, 'Will Hunting', 1, 4, 187, 1, 1080, 1080, 105764511, 132, 125, 78, 114, 130, 0, 0, 0, 2, 55, 5405, 5405, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(204, 'Willmyster', 1, 4, 137, 4, 2120, 2120, 41354471, 132, 125, 78, 114, 134, 0, 0, 0, 2, 8, 680, 680, 0, 100, 1, 1004, 574, 6, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(205, 'Wojtasson', 1, 1, 160, 4, 2465, 2465, 65751800, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 795, 795, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(206, 'Wolek', 1, 2, 162, 4, 2495, 2495, 68280100, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 805, 805, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(207, 'Wurzel', 1, 1, 214, 4, 3275, 3275, 158819900, 114, 114, 116, 76, 134, 0, 0, 0, 2, 8, 1065, 1065, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(208, 'Xamox', 1, 1, 145, 4, 2240, 2240, 48748800, 114, 57, 126, 126, 134, 0, 0, 0, 2, 8, 720, 720, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(209, 'Xanadu', 1, 1, 206, 3, 2165, 2165, 141511500, 114, 114, 116, 76, 129, 0, 0, 0, 2, 25, 3005, 3005, 0, 100, 1, 1063, 607, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(210, 'Xupy II', 1, 1, 300, 1, 1645, 1645, 441084800, 132, 118, 114, 132, 130, 0, 0, 0, 2, 55, 8795, 8795, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0),
(211, 'Xupy IV', 1, 1, 300, 3, 3105, 3105, 441084800, 132, 118, 114, 132, 129, 0, 0, 0, 2, 25, 4415, 4415, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(212, 'Zambo', 1, 2, 169, 4, 2600, 2600, 77638400, 114, 57, 116, 126, 134, 0, 0, 0, 2, 8, 840, 840, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(213, 'Zanetgotsuken', 1, 2, 155, 3, 1655, 1655, 59705800, 114, 57, 116, 126, 129, 0, 0, 0, 2, 25, 2240, 2240, 0, 100, 1, 1039, 586, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 100, 0, 50, 0, 10, 0),
(214, 'Zephim', 1, 5, 153, 4, 2360, 2360, 57395200, 0, 50, 116, 126, 134, 0, 0, 0, 2, 8, 760, 760, 0, 100, 1, 1087, 572, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(215, 'Ziober', 1, 3, 152, 4, 2345, 2345, 56444335, 132, 118, 114, 132, 134, 0, 0, 0, 2, 8, 755, 755, 0, 100, 1, 1030, 566, 7, NULL, 300, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 100, 0, 100, 0, 100, 0, 10, 0, 100, 0, 10, 0),
(216, 'Zu', 1, 1, 339, 1, 1840, 1840, 642942097, 114, 114, 116, 76, 130, 0, 0, 0, 2, 56, 9965, 9965, 0, 100, 1, 1063, 607, 7, NULL, 690, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 13, 0, 10, 0, 10, 0)
ON DUPLICATE KEY UPDATE `level` = VALUES(`level`);
-- Towns Seed for Aethrium War (Mapa Unificado aethrium-war.otbm)
--
-- IMPORTANTE: O startup.lua do TFS 1.8 trunca e reinsere esta tabela
-- automaticamente com getTemplePosition() de cada Town do OTBM.
-- Este seed serve como fallback e referÃªncia documental.
--
-- As coordenadas abaixo representam os templos das 3 arenas:
--   Town 1 (Thais)  â€” Ã¡rea central, spawn padrÃ£o dos herÃ³is
--   Town 2 (Venore) â€” arena norte do mapa
--   Town 3 (Edron)  â€” arena sul do mapa
--
-- Os jogadores migrados (04_players_all.sql) tÃªm town_id=1 e
-- posiÃ§Ãµes individuais de spawn (posx/posy/posz) definidas pela
-- sua guilda no mapa original do 7.6.

DELETE FROM `towns`;

INSERT INTO `towns` (`id`, `name`, `posx`, `posy`, `posz`) VALUES
(1, 'Thais',  1024, 633, 7),
(2, 'Venore', 1063, 607, 7),
(3, 'Edron',  1004, 574, 6);
