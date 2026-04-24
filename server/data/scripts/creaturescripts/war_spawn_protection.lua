-- ============================================================
--  World War — Spawn Protection (5 segundos)
-- ============================================================

WarSpawnProtection = {}  -- [playerId] = true

local PROTECT_MS      = 5000
local EFFECT_INTERVAL = 600
local MOVE_POLL_MS    = 200   -- intervalo de checagem de movimento
local EFFECT_TYPE     = CONST_ME_MAGIC_BLUE

local function pulseEffect(cid, forcedPos)
    if not WarSpawnProtection[cid] then return end
    local p = Player(cid)
    if not p then
        WarSpawnProtection[cid] = nil
        return
    end
    local pos = forcedPos or p:getPosition()
    pos:sendMagicEffect(EFFECT_TYPE)
    addEvent(pulseEffect, EFFECT_INTERVAL, cid)
end

local function expireProtection(cid)
    if not WarSpawnProtection[cid] then return end
    WarSpawnProtection[cid] = nil
    local p = Player(cid)
    if p then
        p:sendTextMessage(MESSAGE_STATUS_SMALL, "[ Proteção de spawn expirou. ]")
    end
end

-- Polling de movimento: compara posição atual com a do spawn
local function watchMovement(cid, ox, oy, oz)
    if not WarSpawnProtection[cid] then return end
    local p = Player(cid)
    if not p then
        WarSpawnProtection[cid] = nil
        return
    end
    local pos = p:getPosition()
    if pos.x ~= ox or pos.y ~= oy or pos.z ~= oz then
        WarSpawnProtection[cid] = nil
        p:sendTextMessage(MESSAGE_STATUS_SMALL, "[ Proteção de spawn removida (você se moveu). ]")
        return
    end
    addEvent(watchMovement, MOVE_POLL_MS, cid, ox, oy, oz)
end

-- Ativa 5s de invulnerabilidade com efeito visual pulsante.
function applySpawnProtection(player, forcedPos)
    if not player or not player:isPlayer() then return end
    if player:getGroup():getId() >= 4 then return end
    local cid = player:getId()
    local pos = forcedPos or player:getPosition()
    WarSpawnProtection[cid] = true
    pulseEffect(cid, pos)
    addEvent(watchMovement, MOVE_POLL_MS, cid, pos.x, pos.y, pos.z)
    addEvent(expireProtection, PROTECT_MS, cid)
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "[ Proteção de spawn ativa por 5 segundos. ]")
end

-- ─── Bloqueia dano recebido e quebra proteção do atacante ────

local hcEvent = CreatureEvent("WarSpawnProtectDamage")
function hcEvent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature:isPlayer() and WarSpawnProtection[creature:getId()] then
        return 0, primaryType, 0, secondaryType
    end
    if attacker and attacker:isPlayer() then
        local aid = attacker:getId()
        if WarSpawnProtection[aid] then
            WarSpawnProtection[aid] = nil
            attacker:sendTextMessage(MESSAGE_STATUS_SMALL, "[ Proteção de spawn removida (você atacou). ]")
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
hcEvent:type("healthchange")
hcEvent:register()
