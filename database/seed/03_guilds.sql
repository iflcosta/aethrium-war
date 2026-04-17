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
