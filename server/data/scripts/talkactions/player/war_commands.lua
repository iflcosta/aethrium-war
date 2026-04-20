-- ============================================================
--  Aethrium War — Comandos de Guerra
--  Arquivo: server/data/scripts/talkactions/player/war_commands.lua
--
--  Comandos disponíveis para jogadores:
--    !frags   — Placar atual de frags por time
--    !online  — Jogadores online agrupados por time
--    !joinlow — Muda para o time com menos jogadores (Recompensa: 2 tokens)
--    !streak  — Ver sua sequência atual de abates
--    !help    — Lista de comandos da war
-- ============================================================

-- ─── Mapeamento de Times ─────────────────────────────────────
-- Deve coincidir com war_outfit_enforcer.lua e player_login_logout.lua

local TEAM_INFO = {
    [1] = { name = "Antica",   color = "Vermelho" },
    [2] = { name = "Nova",     color = "Azul"     },
    [3] = { name = "Secura",   color = "Verde"    },
    [4] = { name = "Amera",    color = "Dourado"  },
    [5] = { name = "Calmera",  color = "Roxo"     },
    [6] = { name = "Hiberna",  color = "Ciano"    },
    [7] = { name = "Harmonia", color = "Laranja"  },
}

local WAR_FRAG_GOAL = 100  -- deve coincidir com war_score_rotation.lua

WAR_STREAK = 45202

-- ─── Helpers ─────────────────────────────────────────────────

local function getPlayerTeamId(player)
    if WarCurrentTeam and WarCurrentTeam[player:getId()] then
        return WarCurrentTeam[player:getId()]
    end
    local res = db.storeQuery(string.format(
        "SELECT `guild_id` FROM `guild_membership` WHERE `player_id` = %d LIMIT 1",
        player:getGuid()
    ))
    if not res then return 0 end
    local guildId = result.getNumber(res, "guild_id")
    result.free(res)
    return guildId > 0 and guildId or 0
end

-- ─── Comando: !frags ─────────────────────────────────────────

local fragsCmd = TalkAction("!frags")

function fragsCmd.onSay(player, words, param)
    db.asyncStoreQuery(
        "SELECT g.`id`, g.`name`, IFNULL(SUM(ws.`frags`), 0) AS total "..
        "FROM `guilds` g "..
        "LEFT JOIN `war_scores` ws ON ws.`guild_id` = g.`id` "..
        "WHERE g.`id` BETWEEN 1 AND 7 "..
        "GROUP BY g.`id` ORDER BY total DESC",
        function(resultId)
            local lines = { "⚔ [=== PLACAR DA GUERRA ===] ⚔" }
            if resultId ~= false then
                local i = 1
                repeat
                    local guildId  = result.getNumber(resultId, "id")
                    local guildName = result.getString(resultId, "name")
                    local teamInfo = TEAM_INFO[guildId]
                    local teamName = teamInfo and teamInfo.name or guildName
                    local frags    = tonumber(result.getNumber(resultId, "total"))
                    local bar      = string.rep("█", math.floor(frags / WAR_FRAG_GOAL * 10))
                    local pct      = math.floor(frags / WAR_FRAG_GOAL * 100)
                    lines[#lines + 1] = string.format(
                        "%d. %-10s %3d frags  [%s%s] %d%%",
                        i, teamName, frags, bar, string.rep("░", 10 - #bar), pct
                    )
                    i = i + 1
                until not result.next(resultId)
                result.free(resultId)
            else
                lines[#lines + 1] = "Nenhum combate registrado ainda."
            end
            lines[#lines + 1] = string.format("Meta: %d frags para vencer o round.", WAR_FRAG_GOAL)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, table.concat(lines, "\n"))
        end
    )
    return false
end

fragsCmd:separator(" ")
fragsCmd:register()

-- ─── Comando: !online ──────────────────────────────────────

local onlineCmd = TalkAction("!warteams")

function onlineCmd.onSay(player, words, param)
    local players = Game.getPlayers()
    local teams   = {}  -- [guildId] = { name=..., players={...} }

    for _, p in ipairs(players) do
        if p:getGroup():getId() < 4 then
            local gid = getPlayerTeamId(p)
            if gid and gid > 0 then
                if not teams[gid] then
                    local info = TEAM_INFO[gid]
                    teams[gid] = {
                        name    = info and info.name or ("Time " .. gid),
                        players = {}
                    }
                end
                teams[gid].players[#teams[gid].players + 1] =
                    string.format("%s[%d]", p:getName(), p:getLevel())
            end
        end
    end

    local lines = { "⚔ [=== TIMES EM CAMPO ===] ⚔" }
    local total = 0
    for gid = 1, 7 do
        local team = teams[gid]
        if team and #team.players > 0 then
            lines[#lines + 1] = string.format(
                "  %s (%d): %s",
                team.name, #team.players, table.concat(team.players, ", ")
            )
            total = total + #team.players
        end
    end
    lines[#lines + 1] = string.format("Total: %d jogadores online.", total)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, table.concat(lines, "\n"))
    return false
end

onlineCmd:separator(" ")
onlineCmd:register()

-- ─── Comando: !joinlow ───────────────────────────────────────

local joinLowCmd = TalkAction("!joinlow")

function joinLowCmd.onSay(player, words, param)
    if player:getGroup():getId() >= 4 then return false end
    
    local playerTeamId = getPlayerTeamId(player)
    
    -- 1. Identificar o time com menos jogadores ativos no campo
    local activePlayers = Game.getPlayers()
    local counts = { [1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0 }
    
    for _, p in ipairs(activePlayers) do
        if p:getGroup():getId() < 4 then
            local tid = (WarCurrentTeam and WarCurrentTeam[p:getId()]) or getPlayerTeamId(p)
            if tid and counts[tid] then
                counts[tid] = counts[tid] + 1
            end
        end
    end
    
    local lowestTeamId = 1
    local lowestCount  = counts[1]
    for tid = 2, 7 do
        if counts[tid] < lowestCount then
            lowestCount = counts[tid]
            lowestTeamId = tid
        end
    end
    
    -- 2. Validar se já está no time mais baixo
    if playerTeamId == lowestTeamId then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Você já está no time com menos jogadores.")
        return false
    end
    
    -- 3. Executar a mudança
    -- Atualiza em memória
    if WarCurrentTeam then
        WarCurrentTeam[player:getId()] = lowestTeamId
    end
    
    -- Atualiza no Banco de Dados (temporário nesta sessão, resetado no startup)
    db.query(string.format(
        "UPDATE `guild_membership` SET `guild_id` = %d WHERE `player_id` = %d",
        lowestTeamId, player:getGuid()
    ))
    
    -- 4. Recompensas e Efeitos
    if addTokens then
        addTokens(player, 2)
    end
    
    local newTeamName = TEAM_INFO[lowestTeamId] and TEAM_INFO[lowestTeamId].name or "Time " .. lowestTeamId
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
        string.format("[ Balanced ] Você mudou para o %s! Recompensa: 2 War Tokens.", newTeamName))
    
    -- Forçar atualização de outfit (guild colors)
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "Suas cores de time serão atualizadas no próximo spawn ou respawn.")
    
    -- Teleportar para o spawn para evitar abusos tácticos no meio da fight
    local spawnPos = WarGetBestSpawnPoint and WarGetBestSpawnPoint(player) or player:getTown():getTemplePosition()
    player:teleportTo(spawnPos)
    spawnPos:sendMagicEffect(CONST_ME_TELEPORT)
    
    if applySpawnProtection then
        applySpawnProtection(player)
    end
    
    return false
end

joinLowCmd:separator(" ")
joinLowCmd:register()

-- ─── Comando: !streak ────────────────────────────────────────

local streakCmd = TalkAction("!streak")

function streakCmd.onSay(player, words, param)
    local streak = math.max(0, player:getStorageValue(WAR_STREAK))
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
        string.format("Sua sequencia atual e de %d abates sem morrer.", streak))
    return false
end

streakCmd:separator(" ")
streakCmd:register()

-- ─── Atalho: !shop ───────────────────────────────────────────

local shopCmd = TalkAction("!shop")

function shopCmd.onSay(player, words, param)
    -- Chama a lógica do !buy enviando param vazio para mostrar o menu
    local buy = TalkAction("!buy")
    if buy and buy.onSay then
        return buy.onSay(player, "!buy", "")
    end
    -- Fallback caso a tentativa de chamar direto falhe
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "Use !buy para abrir a loja.")
    return false
end

shopCmd:separator(" ")
shopCmd:register()

-- ─── Comando: !help (war) ────────────────────────────────────

local helpCmd = TalkAction("!warhelp")

function helpCmd.onSay(player, words, param)
    local myTeamId   = getPlayerTeamId(player)
    local myTeamInfo = TEAM_INFO[myTeamId]
    local myTeam     = myTeamInfo and myTeamInfo.name or "Sem time"

    local msg = table.concat({
        "⚔ [=== AETHRIUM WAR — COMANDOS ===] ⚔",
        string.format("  Seu time: %s", myTeam),
        "",
        "  !frags     — Placar de frags por time",
        "  !warteams  — Jogadores online por time",
        "  !joinlow   — Mudar para o time com menos players (+2 tokens)",
        "  !buy       — Loja de upgrades (stats/skills/tiers)",
        "  !warhelp   — Este menu",
        "",
        "  Ganhos: 1 token por Kill | 0.5 por Assistencia",
        "  Dica: Upgrades de !buy sao perdidos ao morrer!",
        "",
        string.format("  Meta do round: %d frags. Vença e a arena rotaciona!", WAR_FRAG_GOAL),
    }, "\n")

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, msg)
    return false
end

helpCmd:separator(" ")
helpCmd:register()
