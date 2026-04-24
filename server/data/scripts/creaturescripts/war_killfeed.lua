-- ============================================================
--  World War — Killfeed Visual
--  Arquivo: server/data/scripts/creaturescripts/war_killfeed.lua
--
--  Separado do war_arcade_reset.lua para manter responsabilidades claras:
--    war_arcade_reset.lua  → lógica de estado (reset, spawn, DB)
--    war_killfeed.lua      → apresentação visual (efeitos, mensagens)
--
--  Funcionalidades:
--    1. Efeito mágico no local da morte
--    2. Mensagem de kill com nomes dos times (não apenas nomes de jogadores)
--    3. Combo streak: broadcast especial a cada 5 kills consecutivos
-- ============================================================

-- ─── Configuração Global do Killfeed ────────────────────────
WarKillfeed = {}

local TEAM_NAME = {
    [1] = "Antica",   [2] = "Nova",    [3] = "Secura",
    [4] = "Amera",    [5] = "Calmera", [6] = "Hiberna",
    [7] = "Harmonia",
}

-- Streak kill tracking: [playerId] = { count, lastKillTime }
local killStreaks = {}
local STREAK_WINDOW_SECS = 120  -- janela de 2 min para contar streak

function WarKillfeed.getTeamName(player)
    local teamId = WarCurrentTeam and WarCurrentTeam[player:getId()]
    if not teamId then
        local res = db.storeQuery(string.format(
            "SELECT `guild_id` FROM `guild_membership` WHERE `player_id` = %d LIMIT 1",
            player:getGuid()
        ))
        if not res then return "Sem Time" end
        teamId = result.getNumber(res, "guild_id")
        result.free(res)
        if not teamId or teamId == 0 then return "Sem Time" end
    end
    return TEAM_NAME[teamId] or ("Time " .. teamId)
end

-- ─── Atualizar e verificar streak ────────────────────────────

local function updateStreak(killerId)
    local now = os.time()
    local s = killStreaks[killerId]

    if not s or (now - s.lastKillTime) > STREAK_WINDOW_SECS then
        killStreaks[killerId] = { count = 1, lastKillTime = now }
        return 1
    end

    s.count = s.count + 1
    s.lastKillTime = now
    return s.count
end

local function resetStreak(killerId)
    killStreaks[killerId] = nil
end

-- ─── Efeitos visuais no local da morte ───────────────────────

local DEATH_EFFECTS = {
    CONST_ME_MORTAREA,    -- névoa de morte (vermelho)
    CONST_ME_EXPLOSIONAREA,
}

function WarKillfeed.playDeathEffect(position)
    -- Efeito primário: explosão
    position:sendMagicEffect(CONST_ME_EXPLOSIONAREA)
    -- Efeito secundário: névoa (500ms depois)
    addEvent(function()
        position:sendMagicEffect(CONST_ME_MORTAREA)
    end, 500)
end

-- ─── Mensagem de kill formatada ──────────────────────────────

local function buildKillMessage(killerName, killerTeam, victimName, victimTeam, victimLevel, streak)
    local base = string.format(
        "** [%s] %s eliminou [%s] %s (LV %d)",
        killerTeam, killerName, victimTeam, victimName, victimLevel
    )

    -- Streak announcements
    if streak == 5 then
        return base .. " -- KILLING SPREE! !!!"
    elseif streak == 10 then
        return base .. " -- RAMPAGE!! !!!"
    elseif streak == 15 then
        return base .. " -- UNSTOPPABLE!!! !!!"
    elseif streak > 0 and streak % 5 == 0 then
        return base .. string.format(" -- %dx STREAK!", streak)
    end

    return base
end

-- 🚀 FUNÇÃO MESTRE: Registro Manual de Kill (Para Arcade Engine)
function WarKillfeed.recordKill(player, killer)
    local victimName  = player:getName()
    local victimLevel = player:getLevel()
    local victimTeam  = WarKillfeed.getTeamName(player)
    local deathPos    = player:getPosition()

    -- Efeito mágico no local da "morte"
    WarKillfeed.playDeathEffect(deathPos)

    -- Identificar killer
    if killer and killer:isPlayer() then
        local killerName  = killer:getName()
        local killerTeam  = WarKillfeed.getTeamName(killer)
        local killerId    = killer:getId()

        -- Streak do killer
        local streak = updateStreak(killerId)

        -- Efeito de conquista no killer
        killer:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

        -- Mensagem de kill no chat global
        local msg = buildKillMessage(killerName, killerTeam, victimName, victimTeam, victimLevel, streak)
        Game.broadcastMessage(msg, MESSAGE_STATUS_WARNING)

        killer:sendTextMessage(MESSAGE_EVENT_ADVANCE,
            string.format("[+Frag] %s eliminado! Streak: %d kill%s",
                victimName, streak, streak > 1 and "s" or ""))
        
        -- Reset streak da vítima
        resetStreak(player:getId())
        
        return true
    end

    -- Morte sem killer identificado
    Game.broadcastMessage(
        string.format("!! %s [%s] caiu em batalha!", victimName, victimTeam),
        MESSAGE_STATUS_WARNING
    )
    resetStreak(player:getId())
    return true
end

-- ─── CreatureEvent: onDeath (Legado/Suporte) ─────────────────
local killfeed = CreatureEvent("WarKillfeed")

function killfeed.onDeath(player, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    local realKiller = mostDamageKiller or killer
    return WarKillfeed.recordKill(player, realKiller)
end
killfeed:register()

-- ─── Hook de Login para registrar o KillFeed ─────────────────
-- NOTA: O registro é feito em player_login_logout.lua via loginMessage.
-- Este bloco serve apenas como fallback de emergência caso o loginMessage
-- não registre por algum motivo (ex: reload parcial de scripts).

local killfeedLogin = CreatureEvent("WarKillfeedLogin")

function killfeedLogin.onLogin(player)
    player:registerEvent("WarKillfeed")
    return true
end
killfeedLogin:register()
