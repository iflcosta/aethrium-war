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
