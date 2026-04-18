-- ============================================================
-- Aethrium War — Snapshot Initialization Tool
-- Este script deve ser carregado ou executado uma vez para configurar o Snapshot.
-- ============================================================

local function setupArcadeSnapshot()
    print(">> [Arcade Setup] Initializing players_snapshot...")

    -- 1. Criar a tabela de snapshot se não existir
    db.query("CREATE TABLE IF NOT EXISTS `players_snapshot` LIKE `players`")
    
    -- 2. Limpar snapshot antigo (para garantir nova carga limpa)
    db.query("TRUNCATE TABLE `players_snapshot`")
    
    -- 3. Copiar todos os personagens migrados (ID >= 100)
    db.query("INSERT INTO `players_snapshot` SELECT * FROM `players` WHERE `id` >= 100")

    -- 4. Normalizar Stats (Level 260 + Experience)
    -- Level 260 = 286,246,800 XP
    db.query("UPDATE `players_snapshot` SET `level` = 260, `experience` = 286246800")

    -- 5. Normalizar Skills 120 (Knight: Sword/Axe/Club | Paladin: Dist | Mage: ML)
    -- Knight (Vocation 4 e 8)
    db.query("UPDATE `players_snapshot` SET `skill_sword` = 120, `skill_axe` = 120, `skill_club` = 120, `skill_shielding` = 100 WHERE `vocation` IN (4, 8)")
    
    -- Paladin (Vocation 3 e 7)
    db.query("UPDATE `players_snapshot` SET `skill_dist` = 120, `skill_shielding` = 80 WHERE `vocation` IN (3, 7)")
    
    -- Mages (Vocation 1, 2, 5, 6)
    db.query("UPDATE `players_snapshot` SET `maglevel` = 120, `skill_shielding` = 30 WHERE `vocation` IN (1, 2, 5, 6)")

    -- 6. Garantir Health e Mana máximos para Level 260 (Base 7.6)
    -- Sorcerer/Druid: HP 1445, Mana 7775
    db.query("UPDATE `players_snapshot` SET `health` = 1445, `healthmax` = 1445, `mana` = 7775, `manamax` = 7775 WHERE `vocation` IN (1, 2, 5, 6)")
    -- Paladin: HP 2705, Mana 3890
    db.query("UPDATE `players_snapshot` SET `health` = 2705, `healthmax` = 2705, `mana` = 3890, `manamax` = 3890 WHERE `vocation` IN (3, 7)")
    -- Knight: HP 3965, Mana 1300
    db.query("UPDATE `players_snapshot` SET `health` = 3965, `healthmax` = 3965, `mana` = 1300, `manamax` = 1300 WHERE `vocation` IN (4, 8)")

    print(">> [Arcade Setup] Snapshot completed! 235 characters normalized to LVL 260 / SKILL 120.")
end

-- Executar a função
setupArcadeSnapshot()
