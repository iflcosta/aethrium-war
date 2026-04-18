-- ============================================================
--  Aethrium War — Comandos de Guerra
--  Arquivo: server/data/scripts/talkactions/player/war_commands.lua
--
--  Comandos disponíveis para jogadores:
--    !frags   — Placar atual de frags por time
--    !online  — Jogadores online agrupados por time
--    !time    — Tempo restante para rotação (baseado em frags)
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

-- ─── Helpers ─────────────────────────────────────────────────

local function getPlayerTeamId(player)
    local guild = player:getGuild()
    return guild and guild:getId() or 0
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
        local guild = p:getGuild()
        if guild then
            local gid = guild:getId()
            if not teams[gid] then
                local info = TEAM_INFO[gid]
                teams[gid] = {
                    name    = info and info.name or guild:getName(),
                    players = {}
                }
            end
            teams[gid].players[#teams[gid].players + 1] =
                string.format("%s[%d]", p:getName(), p:getLevel())
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
        "  !warhelp   — Este menu",
        "",
        "  Logins: 1/1=Antica  2/2=Nova  3/3=Secura",
        "          4/4=Amera   5/5=Calmera  6/6=Hiberna  7/7=Harmonia",
        "",
        string.format("  Meta do round: %d frags. Vença e a arena rotaciona!", WAR_FRAG_GOAL),
    }, "\n")

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, msg)
    return false
end

helpCmd:separator(" ")
helpCmd:register()
