-- ============================================================
-- World War — Snapshot Auto-Init
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
        print(">> [Arcade Mode] Snapshot Created Successfully!")
    else
        print(">> [Arcade Mode] Snapshot Table is ready. (" .. count .. " characters)")
    end

    -- ─── NORMALIZAÇÃO FORÇADA (Executa sempre no Startup) ────────────────
    -- Garante que Cap e Soul nunca fiquem zerados, mesmo que o snapshot ja exista.
    
    -- Level e Exp 250
    db.query("UPDATE `players_snapshot` SET `level` = 250, `experience` = 254237300, `soul` = 200")

    -- Skills 120
    db.query("UPDATE `players_snapshot` SET `maglevel` = 10, `skill_sword` = 120, `skill_axe` = 120, `skill_club` = 120, `skill_shielding` = 100 WHERE `vocation` IN (4, 8)")
    db.query("UPDATE `players_snapshot` SET `maglevel` = 30, `skill_dist` = 120, `skill_shielding` = 80 WHERE `vocation` IN (3, 7)")
    db.query("UPDATE `players_snapshot` SET `maglevel` = 120, `skill_shielding` = 30 WHERE `vocation` IN (1, 2, 5, 6)")

    -- HP/Mana/Cap (Matemática Real para Lvl 250)
    db.query("UPDATE `players_snapshot` SET `health` = 3850, `healthmax` = 3850, `mana` = 1245, `manamax` = 1245, `cap` = 6520 WHERE `vocation` IN (4, 8)")
    db.query("UPDATE `players_snapshot` SET `health` = 2640, `healthmax` = 2640, `mana` = 3665, `manamax` = 3665, `cap` = 5310 WHERE `vocation` IN (3, 7)")
    db.query("UPDATE `players_snapshot` SET `cap` = 6520 WHERE `vocation` IN (9, 10)") -- Monk tem cap de Knight
    db.query("UPDATE `players_snapshot` SET `health` = 2640, `healthmax` = 2640, `mana` = 3665, `manamax` = 3665 WHERE `vocation` IN (9, 10)")
    db.query("UPDATE `players_snapshot` SET `health` = 1430, `healthmax` = 1430, `mana` = 7295, `manamax` = 7295, `cap` = 2890 WHERE `vocation` IN (1, 2, 5, 6)")

    -- Sincroniza a tabela 'players' imediatamente com o snapshot
    db.query([[
        UPDATE `players` p
        INNER JOIN `players_snapshot` ps ON p.`id` = ps.`id`
        SET p.`level` = ps.`level`, p.`experience` = ps.`experience`, p.`maglevel` = ps.`maglevel`,
            p.`skill_fist` = ps.`skill_fist`, p.`skill_club` = ps.`skill_club`, p.`skill_sword` = ps.`skill_sword`,
            p.`skill_axe` = ps.`skill_axe`, p.`skill_dist` = ps.`skill_dist`, p.`skill_shielding` = ps.`skill_shielding`,
            p.`health` = ps.`healthmax`, p.`healthmax` = ps.`healthmax`, p.`mana` = ps.`manamax`, p.`manamax` = ps.`manamax`,
            p.`cap` = ps.`cap`, p.`soul` = ps.`soul`
    ]])

    -- ─── UNIFICAÇÃO DE SPAWN (TEMPLO) ──────────────────────────
    -- Força todos os jogadores a nascerem no Templo (Thais)
    db.query("UPDATE `players` SET `posx` = 1024, `posy` = 633, `posz` = 7, `town_id` = 1")
    db.query("UPDATE `players_snapshot` SET `posx` = 1024, `posy` = 633, `posz` = 7, `town_id` = 1")
    
    print(">> [Arcade Mode] Spawn unification completed! All players set to Temple (1024, 633, 7).")

    return true
end

startupEvent:register()
