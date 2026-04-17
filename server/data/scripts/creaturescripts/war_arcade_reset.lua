-- ============================================================
--  Aethrium War — Motor de Reset Arcade
--  Arquivo: server/data/scripts/creaturescripts/war_arcade_reset.lua
--
--  Regra Central:
--    Ao morrer OU ao deslogar, o personagem é restaurado para
--    o estado exato salvo no banco de dados (snapshot original).
--    Isso garante que ninguém perde itens definitivamente e que
--    a guerra seja contínua e justa.
-- ============================================================

local WAR_SPAWN_X = 1024
local WAR_SPAWN_Y = 633
local WAR_SPAWN_Z = 7

-- Sinaliza broadcasts de kills
local WAR_BROADCAST_KILLS = true

-- ─── Funções Auxiliares ────────────────────────────────────

local function broadcastKill(killerName, victimName, victimLevel)
    if not WAR_BROADCAST_KILLS then return end
    local msg = string.format(
        "[War] %s abateu %s (Level %d)!",
        killerName, victimName, victimLevel
    )
    Game.broadcastMessage(msg, MESSAGE_STATUS_WARNING)
end

local function updateWarScore(killerPlayer)
    if not killerPlayer or not killerPlayer:isPlayer() then return end
    local guild = killerPlayer:getGuild()
    if not guild then return end
    local guildId = guild:getId()
    db.asyncQuery(string.format(
        "INSERT INTO `war_scores` (`guild_id`, `frags`, `round_id`) VALUES (%d, 1, 1) "..
        "ON DUPLICATE KEY UPDATE `frags` = `frags` + 1",
        guildId
    ))
end

local function restorePlayerFromDB(playerId)
    -- Busca o snapshot salvo do jogador
    local query = string.format(
        "SELECT `level`, `vocation`, `health`, `healthmax`, `mana`, `manamax`, "..
        "`experience`, `maglevel`, `cap`, `posx`, `posy`, `posz`, "..
        "`skill_fist`, `skill_club`, `skill_sword`, `skill_axe`, `skill_dist`, "..
        "`skill_shielding`, `skill_fishing` "..
        "FROM `players` WHERE `id` = %d",
        playerId
    )

    db.asyncQuery(query, function(rows)
        if not rows or #rows == 0 then return end
        local r = rows[1]

        -- Agenda a restauração para o próximo tick (após morte/respawn processar)
        addEvent(function()
            local player = Player(playerId)
            if not player then return end

            -- Restaurar HP e Mana
            player:setHealth(r.healthmax)
            player:setMaxHealth(r.healthmax)
            player:setMana(r.manamax)
            player:setMaxMana(r.manamax)

            -- Restaurar Skills
            player:setSkillLevel(SKILL_FIST,      r.skill_fist)
            player:setSkillLevel(SKILL_CLUB,      r.skill_club)
            player:setSkillLevel(SKILL_SWORD,     r.skill_sword)
            player:setSkillLevel(SKILL_AXE,       r.skill_axe)
            player:setSkillLevel(SKILL_DISTANCE,  r.skill_dist)
            player:setSkillLevel(SKILL_SHIELD,    r.skill_shielding)
            player:setSkillLevel(SKILL_FISHING,   r.skill_fishing)

            -- Restaurar Magia e Capacidade
            player:setMagicLevel(r.maglevel)
            player:setCapacity(r.cap)

            -- Teleportar de volta ao spawn do time
            player:teleportTo(Position(WAR_SPAWN_X, WAR_SPAWN_Y, WAR_SPAWN_Z))
            player:setPosition(Position(WAR_SPAWN_X, WAR_SPAWN_Y, WAR_SPAWN_Z))

            player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                "[Aethrium War] Você foi restaurado ao seu estado original. Boa guerra!")
        end, 500)
    end)
end

-- ─── Evento: Morte do Jogador ──────────────────────────────

local warDeath = CreatureEvent("WarArcadeDeath")

function warDeath.onDeath(player, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    local victimName  = player:getName()
    local victimLevel = player:getLevel()
    local playerId    = player:getId()

    -- Identificar killer real
    local realKiller = mostDamageKiller or killer
    if realKiller and realKiller:isPlayer() then
        broadcastKill(realKiller:getName(), victimName, victimLevel)
        updateWarScore(realKiller)
    end

    -- Agendar restauração após o respawn processar (1.5s)
    addEvent(function()
        restorePlayerFromDB(playerId)
    end, 1500)

    return true
end
warDeath:register()

-- ─── Evento: Logout do Jogador ─────────────────────────────
-- O reset no logout garante que a stat do char nunca "evolua"
-- entre sessões — cada login começa do zero definido no DB.

local warLogout = CreatureEvent("WarArcadeLogout")

function warLogout.onLogout(player)
    local playerId = player:getId()
    local guid     = player:getGuid()

    -- Reset direto no banco: repõe HP/Mana do snapshot via SQL
    db.asyncQuery(string.format(
        "UPDATE `players` SET `health` = `healthmax`, `mana` = `manamax`, "..
        "`skull` = 0, `skulltime` = 0, `conditions` = NULL "..
        "WHERE `id` = %d",
        guid
    ))

    return true
end
warLogout:register()

-- ─── Hook de Login para Registrar os Eventos ──────────────

local warLogin = CreatureEvent("WarArcadeLogin")

function warLogin.onLogin(player)
    player:registerEvent("WarArcadeDeath")
    player:registerEvent("WarArcadeLogout")
    return true
end
warLogin:register()
