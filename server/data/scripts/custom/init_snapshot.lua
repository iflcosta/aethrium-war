-- ============================================================
-- Aethrium War — Snapshot Auto-Init
-- Executa ao iniciar o servidor para garantir que a tabela Snapshot exista e esteja correta.
-- ============================================================

local startupEvent = GlobalEvent("SnapshotInit")

function startupEvent.onStartup()
    print(">> [Arcade Mode] Verifying players_snapshot table...")

    -- 1. Criar a tabela se não existir
    db.query("CREATE TABLE IF NOT EXISTS `players_snapshot` LIKE `players`")
    
    -- 2. Verificar se está vazia ou desatualizada (Reset Total Ocorrera)
    local resultId = db.storeQuery("SELECT COUNT(*) as count FROM `players_snapshot`")
    local count = result.getNumber(resultId, "count")
    result.free(resultId)

    if count == 0 then
        print(">> [Arcade Mode] Initializing Snapshot Data (235 players)...")
        
        -- Copia os personagens atuais
        db.query("INSERT INTO `players_snapshot` SELECT * FROM `players` WHERE `id` >= 100")

        -- Normaliza para Level 260 (286,246,800 XP)
        db.query("UPDATE `players_snapshot` SET `level` = 260, `experience` = 286246800")

        -- Normaliza Skills 120
        -- Knight (Voc 4, 8)
        db.query("UPDATE `players_snapshot` SET `maglevel` = 10, `skill_sword` = 120, `skill_axe` = 120, `skill_club` = 120, `skill_shielding` = 100 WHERE `vocation` IN (4, 8)")
        -- Paladin (Voc 3, 7)
        db.query("UPDATE `players_snapshot` SET `maglevel` = 30, `skill_dist` = 120, `skill_shielding` = 80 WHERE `vocation` IN (3, 7)")
        -- Mages (Voc 1, 2, 5, 6)
        db.query("UPDATE `players_snapshot` SET `maglevel` = 120, `skill_shielding` = 30 WHERE `vocation` IN (1, 2, 5, 6)")

        -- Normaliza HP/Mana (Base 7.6 para Lvl 260)
        db.query("UPDATE `players_snapshot` SET `health` = 3965, `healthmax` = 3965, `mana` = 1300, `manamax` = 1300 WHERE `vocation` IN (4, 8)")
        db.query("UPDATE `players_snapshot` SET `health` = 2705, `healthmax` = 2705, `mana` = 3890, `manamax` = 3890 WHERE `vocation` IN (3, 7)")
        db.query("UPDATE `players_snapshot` SET `health` = 1445, `healthmax` = 1445, `mana` = 7775, `manamax` = 7775 WHERE `vocation` IN (1, 2, 5, 6)")

        print(">> [Arcade Mode] Snapshot Created Successfully!")
    else
        print(">> [Arcade Mode] Snapshot Table is ready. (" .. count .. " characters)")
    end

    -- Sincroniza a tabela 'players' imediatamente com o snapshot para limpar alterações indevidas passadas
    db.query([[
        UPDATE `players` p
        INNER JOIN `players_snapshot` ps ON p.`id` = ps.`id`
        SET p.`level` = ps.`level`, p.`experience` = ps.`experience`, p.`maglevel` = ps.`maglevel`,
            p.`skill_fist` = ps.`skill_fist`, p.`skill_club` = ps.`skill_club`, p.`skill_sword` = ps.`skill_sword`,
            p.`skill_axe` = ps.`skill_axe`, p.`skill_dist` = ps.`skill_dist`, p.`skill_shielding` = ps.`skill_shielding`,
            p.`health` = ps.`healthmax`, p.`healthmax` = ps.`healthmax`, p.`mana` = ps.`manamax`, p.`manamax` = ps.`manamax`
    ]])
    print(">> [Arcade Mode] All live players synchronized with Snapshot!")

    return true
end

startupEvent:register()
