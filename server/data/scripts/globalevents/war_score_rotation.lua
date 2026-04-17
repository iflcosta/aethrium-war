-- ============================================================
--  Aethrium War — Seamless Map Rotation (Unified Map)
--  Arquivo: server/data/scripts/globalevents/war_score_rotation.lua
--  
--  Lógica:
--    A cada 10 segundos, verifica se algum time atingiu a meta.
--    Em vez de reiniciar, teletransporta todos para a próxima cidade.
-- ============================================================

local WAR_FRAG_GOAL  = 100    -- Frags para vencer o round
local WAR_CHECK_SECS = 10     -- Intervalo de verificação
local WAR_COUNTDOWN  = 15     -- Segundos antes do teleporte

-- Definição das Arenas (Cidades no Mapa Unificado)
local ARENAS = {
    { id = 1, name = "Thais",  pos = Position(174, 239, 7) },
    { id = 2, name = "Venore", pos = Position(585, 163, 7) },
    { id = 3, name = "Edron",  pos = Position(1031, 264, 8) }
}

local currentArenaIndex = 1
local isRotating = false

-- ─── Funções Auxiliares ─────────────────────────────────────

local function getGuildName(guildId, callback)
    db.asyncQuery(
        string.format("SELECT `name` FROM `guilds` WHERE `id` = %d", guildId),
        function(rows)
            local name = (rows and rows[1]) and rows[1].name or ("Time " .. guildId)
            callback(name)
        end
    )
end

local function resetAllWarScores()
    db.asyncQuery("DELETE FROM `war_scores`")
end

local function applySeamlessRotation()
    currentArenaIndex = (currentArenaIndex % #ARENAS) + 1
    local arena = ARENAS[currentArenaIndex]
    
    -- 1. Atualiza Town ID globalmente no DB para jogadores offline
    db.asyncQuery(string.format("UPDATE `players` SET `town_id` = %d", arena.id))
    
    -- 2. Teletransporta jogadores online e atualiza seu respawn
    local players = Game.getPlayers()
    for _, player in ipairs(players) do
        -- Reset de status (Cura total)
        player:addHealth(player:getMaxHealth())
        player:addMana(player:getMaxMana())
        player:removeConditions(CONDITION_INFIGHT)
        
        -- Atualiza respawn
        player:setTown(arena.id)
        
        -- Teleporte
        player:teleportTo(arena.pos)
        arena.pos:sendMagicEffect(CONST_ME_TELEPORT)
    end
    
    Game.broadcastMessage(
        string.format("⚔ [ARENA ATIVA] ⚔  Bem-vindos a %s! Que a guerra recomece!", arena.name),
        MESSAGE_STATUS_WARNING
    )
    
    isRotating = false
end

local function startRotationCountdown(winnerName, frags)
    isRotating = true
    local msg = string.format("⚔ [ROUND FINALIZADO] ⚔ %s venceu com %d frags!", winnerName, frags)
    Game.broadcastMessage(msg, MESSAGE_STATUS_WARNING)

    local countdown = WAR_COUNTDOWN
    for i = 0, countdown do
        addEvent(function()
            if countdown > 0 then
                if countdown <= 5 or countdown % 5 == 0 then
                    Game.broadcastMessage(
                        string.format("[Aethrium War] Próxima arena em %d segundos...", countdown),
                        MESSAGE_STATUS_DEFAULT
                    )
                end
                countdown = countdown - 1
            else
                resetAllWarScores()
                applySeamlessRotation()
            end
        end, i * 1000)
    end
end

-- ─── GlobalEvent: Monitor de Placar ────────────────────────

local warScoreMonitor = GlobalEvent("WarScoreMonitor")

function warScoreMonitor.onThink(interval)
    if isRotating then return true end

    db.asyncQuery(
        "SELECT `guild_id`, SUM(`frags`) AS total_frags FROM `war_scores` "..
        "GROUP BY `guild_id` HAVING total_frags >= " .. WAR_FRAG_GOAL ..
        " ORDER BY total_frags DESC LIMIT 1",
        function(rows)
            if not rows or #rows == 0 then return end
            local winner = rows[1]
            getGuildName(tonumber(winner.guild_id), function(name)
                startRotationCountdown(name, tonumber(winner.total_frags))
            end)
        end
    )
    return true
end

warScoreMonitor:interval(WAR_CHECK_SECS * 1000)
warScoreMonitor:register()

-- ─── Comando !frags (Mantido) ──────────────────────────────

local fragsCommand = TalkAction("!frags")
function fragsCommand.onSay(player, words, param)
    db.asyncQuery(
        "SELECT g.`name`, SUM(ws.`frags`) AS total "..
        "FROM `war_scores` ws JOIN `guilds` g ON g.`id` = ws.`guild_id` "..
        "GROUP BY ws.`guild_id` ORDER BY total DESC",
        function(rows)
            local lines = { "[=== Placar da Guerra ===]" }
            if rows and #rows > 0 then
                for i, row in ipairs(rows) do
                    table.insert(lines, string.format("%d. %s — %d frags", i, row.name, tonumber(row.total)))
                end
            else
                table.insert(lines, "Nenhum combate registrado ainda.")
            end
            table.insert(lines, string.format("[Próxima Arena: %s]", ARENAS[(currentArenaIndex % #ARENAS) + 1].name))
            table.insert(lines, string.format("[Meta: %d frags]", WAR_FRAG_GOAL))
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, table.concat(lines, "\n"))
        end
    )
    return false
end
fragsCommand:register()
