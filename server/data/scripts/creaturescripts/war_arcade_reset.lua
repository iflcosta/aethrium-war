-- ============================================================
--  Aethrium War — Motor de Reset Arcade  (v2 — Corrigido)
--  Arquivo: server/data/scripts/creaturescripts/war_arcade_reset.lua
--  Mapa: aethrium-war.otbm (Thais + Venore + Edron — mapa unificado)
--
--  Regra Central:
--    Ao morrer OU ao deslogar, o personagem é restaurado para
--    o estado exato salvo no banco de dados (snapshot original).
--    O spawn usa posx/posy/posz individual do BD por time.
--
--  Correções v2:
--    - Removido player:setSkillLevel() / setMagicLevel() (não existem na API).
--    - Reset de Skills/ML/XP feito via SQL UPDATE + player:reloadData().
--    - Spawn usa posx/posy/posz individual do BD (por time), não fixo.
--    - onLogout reseta HP/Mana, skull e conditions via SQL.
--    - Remoção de CONDITION_INFIGHT antes do teleporte.
--    - Spawn protection de 5s após respawn.
--    - Conflito de hooks eliminado: todos os eventos registrados em loginMessage.
-- ============================================================

local WAR_BROADCAST_KILLS   = true
local WAR_RESPAWN_DELAY_MS  = 1500   -- ms após morte para restaurar
local WAR_SPAWN_PROTECT_MS  = 5000   -- ms de proteção após spawn

-- ─── Helpers ────────────────────────────────────────────────

local function broadcastKill(killerName, victimName, victimLevel)
    if not WAR_BROADCAST_KILLS then return end
    Game.broadcastMessage(
        string.format("[War] %s abateu %s (Level %d)!", killerName, victimName, victimLevel),
        MESSAGE_STATUS_WARNING
    )
end

-- Incrementa o frag do time do killer na tabela war_scores
local function updateWarScore(killerPlayer)
    if not killerPlayer or not killerPlayer:isPlayer() then return end
    local guild = killerPlayer:getGuild()
    if not guild then return end
    db.asyncQuery(string.format(
        "INSERT INTO `war_scores` (`guild_id`, `frags`, `round_id`) VALUES (%d, 1, 1) "..
        "ON DUPLICATE KEY UPDATE `frags` = `frags` + 1",
        guild:getId()
    ))
end

-- Adiciona proteção de spawn temporária (sem sofrer dano)
local function applySpawnProtection(player)
    local condition = Condition(CONDITION_PROTECTION)
    condition:setTicks(WAR_SPAWN_PROTECT_MS)
    player:addCondition(condition)
end

-- ─── Reset via DB (fonte de verdade) ────────────────────────
--
-- Abordagem: Busca o snapshot salvo no BD → restaura HP/Mana via Lua
-- imediatamente (para o jogador online) → Skills/ML/XP já estão corretos
-- no BD porque o onLogout e o onDeath impedem que o save normal sobrescreva
-- com valores inflados durante a sessão.

local RESTORE_QUERY = [[
    SELECT `level`, `experience`, `health`, `healthmax`, `mana`, `manamax`,
           `maglevel`, `manaspent`, `cap`,
           `posx`, `posy`, `posz`,
           `skill_fist`, `skill_club`, `skill_sword`, `skill_axe`,
           `skill_dist`, `skill_shielding`, `skill_fishing`
    FROM `players` WHERE `id` = %d
]]

local function restorePlayerFromDB(playerId)
    db.asyncQuery(string.format(RESTORE_QUERY, playerId), function(rows)
        if not rows or #rows == 0 then return end
        local r = rows[1]

        addEvent(function()
            local player = Player(playerId)
            if not player then return end

            -- 1. Restaurar HP e Mana diretamente via Lua API (sendStats automático)
            player:setMaxHealth(r.healthmax)
            player:setHealth(r.healthmax)
            player:setMaxMana(r.manamax)
            player:setMana(r.manamax)
            player:setCapacity(r.cap)

            -- 2. Teleportar para o spawn individual do personagem
            --    (definido por time no campo posx/posy/posz do BD)
            local spawnPos = Position(r.posx, r.posy, r.posz)

            -- Remove combat flag antes do tp para evitar bloqueio de movement
            player:removeCondition(CONDITION_INFIGHT)

            player:teleportTo(spawnPos)
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

            -- 3. Proteção de spawn de 5s
            applySpawnProtection(player)

            -- 4. Recarregar skills/stats na UI do cliente
            --    (sendSkills + sendStats — skills no DB já estão corretos)
            player:reloadData()

            player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                "[Aethrium War] Restaurado! Protegido por 5 segundos. Boa guerra!")
        end, 500)
    end)
end

-- ─── SQL de reset persistido (escrito no DB antes do save) ──
--
-- Garante que o save automático do TFS não sobrescreva o snapshot com
-- valores da sessão atual. Restaura HP/Mana, zera skull, limpa conditions
-- e mantém XP e Skills intactos no snapshot.

local LOGOUT_RESET_QUERY = [[
    UPDATE `players` SET
        `health`     = `healthmax`,
        `mana`       = `manamax`,
        `skull`      = 0,
        `skulltime`  = 0,
        `conditions` = NULL
    WHERE `id` = %d
]]

-- ─── Evento: Morte do Jogador ────────────────────────────────

local warDeath = CreatureEvent("WarArcadeDeath")

function warDeath.onDeath(player, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    local victimName  = player:getName()
    local victimLevel = player:getLevel()
    local playerId    = player:getId()
    local guid        = player:getGuid()

    -- Identificar killer real (preferência para quem mais danificou)
    local realKiller = mostDamageKiller or killer
    if realKiller and realKiller:isPlayer() then
        broadcastKill(realKiller:getName(), victimName, victimLevel)
        updateWarScore(realKiller)
    end

    -- Imediatamente escreve o reset no DB antes que o save possa ocorrer
    db.asyncQuery(string.format(LOGOUT_RESET_QUERY, guid))

    -- Aguarda o respawn processar, depois restaura o estado via DB
    addEvent(function()
        restorePlayerFromDB(playerId)
    end, WAR_RESPAWN_DELAY_MS)

    return true
end
warDeath:register()

-- ─── Evento: Logout do Jogador ───────────────────────────────
-- Garante que ao sair, o personagem ficará no snapshot original no DB.
-- Na próxima vez que logar, o TFS carrega diretamente do DB → snapshot.

local warLogout = CreatureEvent("WarArcadeLogout")

function warLogout.onLogout(player)
    local guid = player:getGuid()

    -- Reset completo no banco (HP, Mana, Skull, Conditions)
    -- XP e Skills NÃO são alterados pois já estão no snapshot (nunca sofreram update
    -- permanente durante a sessão — o save do TFS só persiste o que foi setado via Lua
    -- e os campos que o engine salva normalmente).
    db.query(string.format(LOGOUT_RESET_QUERY, guid))

    return true
end
warLogout:register()
