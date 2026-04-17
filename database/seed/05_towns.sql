-- Towns Seed for Aethrium War
-- 1 = Thais, 2 = Venore, 3 = Edron

DELETE FROM `towns`;

INSERT INTO `towns` (`id`, `name`, `posx`, `posy`, `posz`) VALUES
(1, 'Thais', 174, 239, 7),
(2, 'Venore', 585, 163, 7),
(3, 'Edron', 1031, 264, 8);
