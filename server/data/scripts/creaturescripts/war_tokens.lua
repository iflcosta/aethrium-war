-- ============================================================
--  Aethrium War — War Tokens
-- ============================================================

WAR_TOKENS          = 45200
WAR_TOKEN_FRACTIONS = 45201

local NATIVE_SPECIAL_SKILLS = {
    SPECIALSKILL_CRITICALHITCHANCE,
    SPECIALSKILL_CRITICALHITAMOUNT,
    SPECIALSKILL_LIFELEECHCHANCE,
    SPECIALSKILL_LIFELEECHAMOUNT,
    SPECIALSKILL_MANALEECHCHANCE,
    SPECIALSKILL_MANALEECHAMOUNT,
}

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

-- Zera tokens e special skills nativas ao morrer.
-- Tier-based items (dodge/fatal/momentum/transcendence) resetam via restoreWarItems.
function resetTokensOnDeath(player)
    player:setStorageValue(WAR_TOKENS, 0)
    player:setStorageValue(WAR_TOKEN_FRACTIONS, 0)
    for _, skill in ipairs(NATIVE_SPECIAL_SKILLS) do
        local current = player:getSpecialSkill(skill)
        if current and current > 0 then
            player:addSpecialSkill(skill, -current)
        end
    end
    -- Momentum e Transcendence (storage-based)
    if WAR_MOMENTUM      then player:setStorageValue(WAR_MOMENTUM, 0) end
    if WAR_TRANSCENDENCE then player:setStorageValue(WAR_TRANSCENDENCE, 0) end
end
