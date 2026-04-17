-- ============================================================
--  Aethrium War — Score Monitor & Map Rotation
--  Arquivo: server/data/scripts/globalevents/war_score_rotation.lua
--
--  Lógica:
--    A cada 10 segundos, verifica o placar na tabela war_scores.
--    Se algum time atingir WAR_FRAG_GOAL frags, ele é anunciado
--    como vencedor, o placar é resetado e o próximo mapa é
--    carregado (servidor faz shutdown/restart com novo mapa).
-- ============================================================

local WAR_FRAG_GOAL  = 100    -- Frags para vencer o round
local WAR_CHECK_SECS = 10     -- Intervalo de verificação (segundos)
local WAR_ROUND_ID   = 1      -- Round atual (incrementado a cada rotação)

-- Sequência de mapas (Phase 5 adicionará os arquivos OTBM)
local MAP_ROTATION = { "thais", "venore", "edron" }
local currentMapIndex = 1

-- Cache de nomes de guilds (evita queries repetidas)
local guildNameCache = {}

local function getGuildName(guildId, callback)
    if guildNameCache[guildId] then
        callback(guildNameCache[guildId])
        return
    end
    db.asyncQuery(
        string.format("SELECT `name` FROM `guilds` WHERE `id` = %d", guildId),
        function(rows)
            local name = (rows and rows[1]) and rows[1].name or ("Time " .. guildId)
            guildNameCache[guildId] = name
            callback(name)
        end
    )
end

local function resetWarScores()
    WAR_ROUND_ID = WAR_ROUND_ID + 1
    db.asyncQuery("DELETE FROM `war_scores`")
end

local function rotateMap()
    currentMapIndex = (currentMapIndex % #MAP_ROTATION) + 1
    local nextMap   = MAP_ROTATION[currentMapIndex]

    -- Anuncia mudança de mapa
    Game.broadcastMessage(
        string.format("[Aethrium War] Próximo round começa no mapa: %s!", nextMap),
        MESSAGE_STATUS_WARNING
    )

    -- Agenda shutdown para troca de mapa em 15 segundos
    addEvent(function()
        Game.broadcastMessage(
            "[Aethrium War] Reiniciando servidor para carregar novo mapa...",
            MESSAGE_STATUS_WARNING
        )
        addEvent(function()
            -- Salva e reinicia (o startup script lê o mapa da config)
            Game.setStorageValue(12345, currentMapIndex) -- persiste índice
            Game.saveGameState()
            os.exit(0)
        end, 5000)
    end, 10000)
end

local function announceWinner(guildId, frags)
    getGuildName(guildId, function(guildName)
        local msg = string.format(
            "⚔ [ROUND ENCERRADO] ⚔  %s venceu com %d frags! Parabéns guerreiros!",
            guildName, frags
        )
        -- Triple broadcast para garantir visibilidade
        Game.broadcastMessage(msg, MESSAGE_STATUS_WARNING)
        addEvent(function() Game.broadcastMessage(msg, MESSAGE_STATUS_WARNING) end, 500)
        addEvent(function() Game.broadcastMessage(msg, MESSAGE_STATUS_WARNING) end, 1000)

        -- Contar down e rotar
        local countdown = 15
        for i = 1, countdown do
            addEvent(function()
                if countdown > 0 then
                    Game.broadcastMessage(
                        string.format("[Aethrium War] Novo round em %d segundos...", countdown),
                        MESSAGE_STATUS_DEFAULT
                    )
                    countdown = countdown - 1
                end
            end, i * 1000)
        end

        addEvent(function()
            resetWarScores()
            rotateMap()
        end, (countdown + 1) * 1000)
    end)
end

-- ─── GlobalEvent: Monitor de Placar ────────────────────────

local warScoreMonitor = GlobalEvent("WarScoreMonitor")

function warScoreMonitor.onThink(interval)
    db.asyncQuery(
        "SELECT `guild_id`, SUM(`frags`) AS total_frags FROM `war_scores` "..
        "GROUP BY `guild_id` HAVING total_frags >= " .. WAR_FRAG_GOAL ..
        " ORDER BY total_frags DESC LIMIT 1",
        function(rows)
            if not rows or #rows == 0 then return end
            local winner = rows[1]
            announceWinner(tonumber(winner.guild_id), tonumber(winner.total_frags))
        end
    )
    return true
end

warScoreMonitor:interval(WAR_CHECK_SECS * 1000)
warScoreMonitor:register()

-- ─── Comando: Ver Placar Atual (!frags) ────────────────────

local fragsCommand = TalkAction("!frags")

function fragsCommand.onSay(player, words, param)
    db.asyncQuery(
        "SELECT g.`name`, SUM(ws.`frags`) AS total "..
        "FROM `war_scores` ws JOIN `guilds` g ON g.`id` = ws.`guild_id` "..
        "GROUP BY ws.`guild_id` ORDER BY total DESC",
        function(rows)
            if not rows or #rows == 0 then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
                    "[War] Nenhum frag registrado ainda neste round.")
                return
            end
            local lines = { "[=== Placar do Round ===]" }
            for i, row in ipairs(rows) do
                table.insert(lines, string.format(
                    "%d. %s — %d frags", i, row.name, tonumber(row.total)
                ))
            end
            table.insert(lines, string.format("[Meta: %d frags para vencer]", WAR_FRAG_GOAL))
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, table.concat(lines, "\n"))
        end
    )
    return false
end
fragsCommand:register()
