-- ============================================================
--  Aethrium War — Reinicialização de Times no Startup
--  Garante que todos os players voltem para o time original (Account ID)
-- ============================================================

local warStartup = GlobalEvent("WarTeamReset")

function warStartup.onStartup()
    -- Sincroniza a guilda com o ID da conta para os times 1-7
    -- Isso reverte qualquer uso do !joinlow feito na sessão anterior
    local query = [[
        UPDATE `guild_membership` gm 
        JOIN `players` p ON gm.`player_id` = p.`id` 
        SET gm.`guild_id` = p.`account_id` 
        WHERE p.`account_id` BETWEEN 1 AND 7;
    ]]
    
    if db.query(query) then
        print(">> [Aethrium War] Times reinicializados com sucesso baseados no ID da conta.")
    else
        print(">> [Aethrium War] Erro ao reinicializar times no startup.")
    end

    -- Limpa o placar de frags para um novo recomeço do servidor?
    -- Opcional: descomente se quiser que todo restart limpe o placar global
    -- db.query("DELETE FROM `war_scores`;")
    
    return true
end

warStartup:register()
