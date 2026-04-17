-- Towns Seed for Aethrium War (Mapa Unificado aethrium-war.otbm)
--
-- IMPORTANTE: O startup.lua do TFS 1.8 trunca e reinsere esta tabela
-- automaticamente com getTemplePosition() de cada Town do OTBM.
-- Este seed serve como fallback e referência documental.
--
-- As coordenadas abaixo representam os templos das 3 arenas:
--   Town 1 (Thais)  — área central, spawn padrão dos heróis
--   Town 2 (Venore) — arena norte do mapa
--   Town 3 (Edron)  — arena sul do mapa
--
-- Os jogadores migrados (04_players_all.sql) têm town_id=1 e
-- posições individuais de spawn (posx/posy/posz) definidas pela
-- sua guilda no mapa original do 7.6.

DELETE FROM `towns`;

INSERT INTO `towns` (`id`, `name`, `posx`, `posy`, `posz`) VALUES
(1, 'Thais',  1024, 633, 7),
(2, 'Venore', 1063, 607, 7),
(3, 'Edron',  1004, 574, 6);
