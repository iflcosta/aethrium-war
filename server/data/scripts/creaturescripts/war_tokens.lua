-- ============================================================
--  Aethrium War — War Tokens + Combat Modifiers (Crit/Dodge)
-- ============================================================

WAR_TOKENS          = 45200  -- tokens inteiros
WAR_TOKEN_FRACTIONS = 45201  -- frações: 0 ou 1; ao chegar em 2 vira 1 token
WAR_CRIT_CHANCE     = 45210  -- % de chance de critical hit
WAR_DODGE_CHANCE    = 45211  -- % de chance de esquivar

-- ─── Helpers de Token ────────────────────────────────────────

function getTokens(player)
    local v = player:getStorageValue(WAR_TOKENS)
    return v >= 0 and v or 0
end

function addTokens(player, amount)
    local current = getTokens(player)
    local new = current + amount
    player:setStorageValue(WAR_TOKENS, new)
    player:sendTextMessage(MESSAGE_STATUS_SMALL,
        string.format("[ +%d War Token%s ] Total: %d", amount, amount ~= 1 and "s" or "", new))
end

function spendTokens(player, amount)
    local current = getTokens(player)
    if current < amount then return false end
    player:setStorageValue(WAR_TOKENS, current - amount)
    return true
end

-- Assistência: 2 frações = 1 token
function addTokenFraction(player)
    local fracs = player:getStorageValue(WAR_TOKEN_FRACTIONS)
    if fracs < 0 then fracs = 0 end
    fracs = fracs + 1
    if fracs >= 2 then
        player:setStorageValue(WAR_TOKEN_FRACTIONS, 0)
        addTokens(player, 1)
    else
        player:setStorageValue(WAR_TOKEN_FRACTIONS, fracs)
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "[ Assistência: 1/2 token ]")
    end
end

-- Chamado em resetPlayerToArcadeState: zera tudo ao morrer
function resetTokensOnDeath(player)
    player:setStorageValue(WAR_TOKENS, 0)
    player:setStorageValue(WAR_TOKEN_FRACTIONS, 0)
    player:setStorageValue(WAR_CRIT_CHANCE, 0)
    player:setStorageValue(WAR_DODGE_CHANCE, 0)
end

-- ─── Combat Modifiers: Crit e Dodge via healthchange ─────────

local combatMod = CreatureEvent("WarCombatModifiers")
function combatMod.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if primaryDamage <= 0 then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    -- Dodge: receiver esquiva do dano
    if creature:isPlayer() then
        local dodge = creature:getStorageValue(WAR_DODGE_CHANCE)
        if dodge > 0 and math.random(100) <= dodge then
            creature:getPosition():sendMagicEffect(CONST_ME_POFF)
            creature:sendTextMessage(MESSAGE_STATUS_SMALL, "[ Esquivou! ]")
            return 0, primaryType, 0, secondaryType
        end
    end

    -- Critical: attacker aplica +50% de dano
    if attacker and attacker:isPlayer() then
        local crit = attacker:getStorageValue(WAR_CRIT_CHANCE)
        if crit > 0 and math.random(100) <= crit then
            local bonus = math.floor(primaryDamage * 0.5)
            attacker:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
            attacker:sendTextMessage(MESSAGE_STATUS_SMALL, "[ Critical Hit! ]")
            return primaryDamage + bonus, primaryType, secondaryDamage, secondaryType
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
combatMod:type("healthchange")
combatMod:register()
