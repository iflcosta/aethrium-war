-- Guilds/Teams Seed for Aethrium War
-- Each account ID (1-7) maps to a specific legendary guild.

DELETE FROM `guilds`;

INSERT INTO `guilds` (`id`, `name`, `ownerid`, `creationdata`, `motd`) VALUES
(1, 'Antica Team', 1, 1000000000, 'Welcome to Antica Team! (Account 1)'),
(2, 'Nova Team', 2, 1000000000, 'Welcome to Nova Team! (Account 2)'),
(3, 'Secura Team', 3, 1000000000, 'Welcome to Secura Team! (Account 3)'),
(4, 'Amera Team', 4, 1000000000, 'Welcome to Amera Team! (Account 4)'),
(5, 'Calmera Team', 5, 1000000000, 'Welcome to Calmera Team! (Account 5)'),
(6, 'Hiberna Team', 6, 1000000000, 'Welcome to Hiberna Team! (Account 6)'),
(7, 'Harmonia Team', 7, 1000000000, 'Welcome to Harmonia Team! (Account 7)');
