-- ============================================================
--  Aethrium War — Spawn Protection (5 segundos)
-- ============================================================

WarSpawnProtection = {}  -- [playerId] = true

local PROTECT_MS      = 5000
local EFFECT_INTERVAL = 600
local EFFECT_TYPE     = CONST_ME_MAGIC_BLUE

local function pulseEffect(cid)
    if not WarSpawnProtection[cid] then return end
    local p = Player(cid)
    if not p then
        WarSpawnProtection[cid] = nil
        return
    end
    p:getPosition():sendMagicEffect(EFFECT_TYPE)
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

-- Ativa 5s de invulnerabilidade com efeito visual pulsante.
function applySpawnProtection(player)
    if not player or not player:isPlayer() then return end
    if player:getGroup():getId() >= 4 then return end
    local cid = player:getId()
    WarSpawnProtection[cid] = true
    pulseEffect(cid)
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

-- ─── Quebra proteção ao mover ────────────────────────────────

local moveEvent = CreatureEvent("WarSpawnProtectMove")
function moveEvent.onMove(creature, oldPos, newPos)
    if creature:isPlayer() then
        local cid = creature:getId()
        if WarSpawnProtection[cid] then
            WarSpawnProtection[cid] = nil
            creature:sendTextMessage(MESSAGE_STATUS_SMALL, "[ Proteção de spawn removida (você se moveu). ]")
        end
    end
    return true
end
moveEvent:type("move")
moveEvent:register()
