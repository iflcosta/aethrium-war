-- ============================================================
--  World War — Comandos de Guerra
--  Arquivo: server/data/scripts/talkactions/player/war_commands.lua
--
--  Comandos disponíveis para jogadores:
--    !frags   — Placar atual de frags por time
--    !online  — Jogadores online agrupados por time
--    !joinlow — Muda para o time com menos jogadores (Recompensa: 2 tokens)
--    !streak  — Ver sua sequência atual de abates
--    !help    — Tutorial completo e funcionamento
--    !commands — Lista rápida de comandos da war
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

-- !joinlow desabilitado por enquanto

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
    if showShop then
        showShop(player)
    else
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Use !buy para abrir a loja.")
    end
    return false
end

shopCmd:separator(" ")
shopCmd:register()

-- ─── Comando: !help / !commands (Central) ─────────────────────

local helpCmd = TalkAction("!help")
local commandsCmd = TalkAction("!commands")

local function sendUniversalHelp(player)
    local myTeamId   = getPlayerTeamId(player)
    local myTeamInfo = TEAM_INFO[myTeamId]
    local myTeam     = myTeamInfo and myTeamInfo.name or "Sem time"

    local lines = {
        "⚔ [=== BEM-VINDO AO WORLD WAR ===] ⚔",
        "",
        "CONTEXTO DO SERVIDOR:",
        "O World War e uma simulacao de guerra arcade entre as 7 Grandes Nacoes.",
        "Nao ha RPG lento aqui: voce nasce pronto para a batalha!",
        "",
        "COMO FUNCIONA:",
        "1. ROUNDS: Os mapas (Thais, Venore, Edron) rotacionam a cada 20 minutos.",
        "2. TIMES: Sua conta (1-7) define seu time permanente.",
        "3. ECONOMIA: Ganhe 1 Token por kill e 0.5 por assistencia.",
        "4. UPGRADES: Use !buy para comprar Skills, ML e Tiers de Itens.",
        "⚠️ IMPORTANTE: Upgrades da loja sao PERDIDOS ao morrer. Tokens nao.",
        "",
        "LISTA DE COMANDOS:",
        "  !frags     - Placar atual do round (Meta de vitoria)",
        "  !warteams  - Jogadores online e seus times",
        "  !buy / !shop - Abre a loja de tokens (Status temporarios)",
        "  !streak    - Veja quantos abates voce fez sem morrer",
        "  !commands  - Esta lista rapida de comandos",
        "  !help      - Tutorial e funcionamento do servidor",
        "",
        "  Times: 1=Antica | 2=Nova | 3=Secura | 4=Amera",
        "         5=Calmera | 6=Hiberna | 7=Harmonia",
        "",
        string.format("Seu Time: %s", myTeam:upper()),
    }

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, table.concat(lines, "\n"))
end

function helpCmd.onSay(player, words, param)
    sendUniversalHelp(player)
    return false
end

function commandsCmd.onSay(player, words, param)
    sendUniversalHelp(player)
    return false
end

helpCmd:separator(" ")
helpCmd:register()

commandsCmd:separator(" ")
commandsCmd:register()

-- Manter !warhelp como alias legado
local warHelpAlias = TalkAction("!warhelp")
function warHelpAlias.onSay(player, words, param)
    sendUniversalHelp(player)
    return false
end
warHelpAlias:separator(" ")
warHelpAlias:register()
