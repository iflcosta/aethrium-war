-- ============================================================
--  Aethrium War — Rotação de Mapa por Tempo (20 minutos)
--  Mapa: aethrium-war.otbm (Thais + Venore + Edron unificados)
-- ============================================================

local WAR_ROUND_MINUTES  = 20
local WAR_COUNTDOWN_SECS = 15

-- Stub de compatibilidade — war_arcade_reset.lua referencia WarRotation.checkScores
WarRotation = { checkScores = function() end }

WAR_CURRENT_MAP = 1  -- índice ativo em WAR_MAPS (definido em war_spawn.lua)

local isRotating = false

-- ─── Avisos de countdown ─────────────────────────────────────

local function scheduleCountdownWarnings()
    local interval = WAR_ROUND_MINUTES * 60
    addEvent(function()
        Game.broadcastMessage("[ Aethrium War ] Novo mapa em 5 minutos!", MESSAGE_STATUS_WARNING)
    end, (interval - 5 * 60) * 1000)
    addEvent(function()
        Game.broadcastMessage("[ Aethrium War ] Novo mapa em 1 minuto!", MESSAGE_STATUS_WARNING)
    end, (interval - 60) * 1000)
end

-- ─── Reset + teleporte de todos os players ───────────────────

local function resetAndSpawnAll()
    local players = Game.getPlayers()
    for _, player in ipairs(players) do
        if player:getGroup():getId() < 4 then
            if resetPlayerToArcadeState then
                resetPlayerToArcadeState(player)
            end
            -- Stagger para não criar pico no servidor
            addEvent(function(cid)
                local p = Player(cid)
                if not p then return end
                local pos = WarGetBestSpawnPoint and WarGetBestSpawnPoint(p)
                    or Position(1024, 633, 7)
                p:teleportTo(pos)
                pos:sendMagicEffect(CONST_ME_TELEPORT)
                if applySpawnProtection then applySpawnProtection(p) end
            end, math.random(500, 3000), player:getId())
        end
    end
end

-- ─── Execução da rotação ─────────────────────────────────────

local function getMapCount()
    if not WAR_MAPS then return 1 end
    local count = 0
    for _ in pairs(WAR_MAPS) do count = count + 1 end
    return count
end

local function findMVP(winnerTeamId)
    if not WarPlayerKills or not winnerTeamId then return nil, 0 end
    local mvpName, mvpKills = nil, 0
    for _, data in pairs(WarPlayerKills) do
        if data.teamId == winnerTeamId and data.kills > mvpKills then
            mvpName  = data.name
            mvpKills = data.kills
        end
    end
    return mvpName, mvpKills
end

local function executeRotation()
    if isRotating then return end
    isRotating = true

    -- 1. Busca time vencedor do round pelo placar atual
    db.asyncStoreQuery(
        "SELECT g.`id`, g.`name`, IFNULL(SUM(ws.`frags`), 0) AS total " ..
        "FROM `guilds` g " ..
        "LEFT JOIN `war_scores` ws ON ws.`guild_id` = g.`id` " ..
        "WHERE g.`id` BETWEEN 1 AND 7 " ..
        "GROUP BY g.`id` ORDER BY total DESC LIMIT 1",
        function(resultId)
            local winnerTeamId   = nil
            local winnerTeamName = nil
            local winnerFrags    = 0

            if resultId ~= false then
                winnerTeamId   = result.getNumber(resultId, "id")
                winnerTeamName = result.getString(resultId, "name")
                winnerFrags    = result.getNumber(resultId, "total")
                result.free(resultId)
            end

            -- 2. Monta anúncio com time vencedor + MVP
            local lines = { "[ FIM DO ROUND ]" }
            if winnerTeamName and winnerFrags > 0 then
                lines[#lines + 1] = string.format(
                    "Time vencedor: %s com %d frags!", winnerTeamName, winnerFrags)
                local mvpName, mvpKills = findMVP(winnerTeamId)
                if mvpName then
                    lines[#lines + 1] = string.format(
                        "MVP: %s (%d kills)", mvpName, mvpKills)
                end
            else
                lines[#lines + 1] = "Nenhum frag registrado neste round."
            end
            lines[#lines + 1] = string.format(
                "Novo mapa em %d segundos...", WAR_COUNTDOWN_SECS)

            Game.broadcastMessage(table.concat(lines, " | "), MESSAGE_STATUS_WARNING)

            -- 3. Reseta placar e tracking de kills
            db.asyncQuery("UPDATE `war_scores` SET `frags` = 0 WHERE `round_id` = 1")
            WarPlayerKills = {}

            -- 4. Após o countdown: avança mapa + reseta todos
            addEvent(function()
                local mapCount = getMapCount()
                WAR_CURRENT_MAP = (WAR_CURRENT_MAP % mapCount) + 1

                local mapName = WAR_MAPS and WAR_MAPS[WAR_CURRENT_MAP]
                    and WAR_MAPS[WAR_CURRENT_MAP].name or ("Mapa " .. WAR_CURRENT_MAP)

                Game.broadcastMessage(
                    string.format("[ NOVO MAPA: %s ] Que a guerra recomece!", mapName),
                    MESSAGE_STATUS_WARNING)

                resetAndSpawnAll()
                isRotating = false
            end, WAR_COUNTDOWN_SECS * 1000)
        end
    )
end

-- ─── GlobalEvent: a cada 20 minutos ──────────────────────────

local rotEvent = GlobalEvent("WarMapRotation")
function rotEvent.onThink(interval)
    executeRotation()
    scheduleCountdownWarnings()  -- agenda avisos para o próximo ciclo
    return true
end
rotEvent:interval(WAR_ROUND_MINUTES * 60 * 1000)
rotEvent:register()

-- ─── Startup: anuncia arena inicial e agenda avisos ──────────

local startupEvent = GlobalEvent("WarRotationStartup")
function startupEvent.onStartup()
    scheduleCountdownWarnings()
    addEvent(function()
        local mapName = WAR_MAPS and WAR_MAPS[WAR_CURRENT_MAP]
            and WAR_MAPS[WAR_CURRENT_MAP].name or "Arena"
        Game.broadcastMessage(
            string.format("[ Aethrium War ] Arena: %s | Rotacao em %d minutos.",
                mapName, WAR_ROUND_MINUTES),
            MESSAGE_STATUS_DEFAULT)
    end, 3000)  -- delay para os outros scripts terminarem de carregar
    return true
end
startupEvent:type("startup")
startupEvent:register()
