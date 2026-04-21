-- ============================================================
--  Aethrium War — Momentum & Transcendence
-- ============================================================

WAR_MOMENTUM      = 45204
WAR_TRANSCENDENCE = 45205

local MOMENTUM_MAX_TIERS      = 10  -- 10 * 2% = 20%
local TRANSCENDENCE_MAX_TIERS = 5   -- 5 * 5% = 25%

local VOC_MAGE  = { [1]=true, [2]=true, [5]=true, [6]=true }
local VOC_MELEE = { [3]=true, [4]=true, [7]=true, [8]=true }

local SPELL_EXHAUST_MS  = 2000
local MELEE_EXHAUST_MS  = 2000

local function getMomentumTiers(player)
    local v = player:getStorageValue(WAR_MOMENTUM)
    return v > 0 and v or 0
end

local function getTranscendenceTiers(player)
    local v = player:getStorageValue(WAR_TRANSCENDENCE)
    return v > 0 and v or 0
end

-- ─── Manachange: Momentum (mage exhaust) + Transcendence ─────

local manaEvent = CreatureEvent("WarManaChange")
function manaEvent.onManaChange(creature, attacker, primaryValue, primaryType, secondaryValue, secondaryType, origin)
    if not creature:isPlayer() then
        return primaryValue, primaryType, secondaryValue, secondaryType
    end
    -- Apenas consumo iniciado pelo próprio player (spell cast)
    if primaryValue >= 0 or attacker ~= nil then
        return primaryValue, primaryType, secondaryValue, secondaryType
    end

    local player = creature
    local vocId  = player:getVocation():getId()

    if VOC_MAGE[vocId] then
        -- Momentum: remove exhaust de spell antecipadamente
        local mTiers = getMomentumTiers(player)
        if mTiers > 0 then
            local delay = math.floor(SPELL_EXHAUST_MS * (1 - mTiers * 0.02))
            local pid   = player:getId()
            addEvent(function(cid)
                local p = Player(cid)
                if p then p:removeCondition(CONDITION_EXHAUST_COMBAT) end
            end, delay, pid)
        end

        -- Transcendence: reduz custo de mana
        local tTiers = getTranscendenceTiers(player)
        if tTiers > 0 then
            local reduction = math.min(tTiers * 0.05, 0.25)
            primaryValue = math.ceil(primaryValue * (1 - reduction))
        end
    end

    return primaryValue, primaryType, secondaryValue, secondaryType
end
manaEvent:type("manachange")
manaEvent:register()

-- ─── Healthchange: Momentum (melee exhaust) ──────────────────

local meleeEvent = CreatureEvent("WarMomentumMelee")
function meleeEvent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not attacker or not attacker:isPlayer() then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end
    if primaryType ~= COMBAT_PHYSICALDAMAGE then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    local vocId = attacker:getVocation():getId()
    if not VOC_MELEE[vocId] then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    local tiers = getMomentumTiers(attacker)
    if tiers <= 0 then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    local delay = math.floor(MELEE_EXHAUST_MS * (1 - tiers * 0.02))
    local pid   = attacker:getId()
    addEvent(function(cid)
        local p = Player(cid)
        if p then p:removeCondition(CONDITION_EXHAUST_WEAPON) end
    end, delay, pid)

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
meleeEvent:type("healthchange")
meleeEvent:register()
