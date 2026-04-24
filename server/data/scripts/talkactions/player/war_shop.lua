-- ============================================================
--  World War -War Shop (!buy)
-- ============================================================

local VOC_MAGE    = { [1]=true, [2]=true, [5]=true, [6]=true }
local VOC_KNIGHT  = { [4]=true, [8]=true }
local VOC_PALADIN = { [3]=true, [7]=true }

-- Valor interno por 1% nas special skills nativas (100 = 1%)
local SPECIAL_SKILL_PER_PCT = 100

local function getCost(item, vocId)
    return item.costs and item.costs[vocId] or item.cost
end

local SHOP_ITEMS = {
    -- ─── Skills de combate ───────────────────────────────────
    skill = {
        desc  = "+5 skill de combate",
        costs = { [3]=5, [7]=5, [4]=5, [8]=5 },
        apply = function(player, vocId)
            if VOC_PALADIN[vocId] then
                player:addSkillLevel(SKILL_DISTANCE, 5)
            else
                for _, sk in ipairs({ SKILL_SWORD, SKILL_AXE, SKILL_CLUB, SKILL_SHIELD }) do
                    player:addSkillLevel(sk, 5)
                end
            end
        end,
    },
    ml = {
        desc  = "+5 Magic Level",
        costs = { [1]=5, [2]=5, [5]=5, [6]=5, [3]=10, [7]=10 },
        apply = function(player, vocId)
            player:addMagicLevel(5)
            player:sendSkills()
        end,
    },
    -- ─── Special skills nativas ──────────────────────────────
    crit = {
        cost = 10,
        desc = "+1% Critical Hit Chance",
        apply = function(player, vocId)
            player:addSpecialSkill(SPECIALSKILL_CRITICALHITCHANCE, SPECIAL_SKILL_PER_PCT)
        end,
    },
    critdmg = {
        cost = 10,
        desc = "+1% Critical Hit Damage",
        apply = function(player, vocId)
            player:addSpecialSkill(SPECIALSKILL_CRITICALHITAMOUNT, SPECIAL_SKILL_PER_PCT)
        end,
    },
    lifeleech = {
        cost = 10,
        desc = "+1% Life Leech Chance",
        apply = function(player, vocId)
            player:addSpecialSkill(SPECIALSKILL_LIFELEECHCHANCE, SPECIAL_SKILL_PER_PCT)
        end,
    },
    lifeleechamt = {
        cost = 10,
        desc = "+1% Life Leech Amount",
        apply = function(player, vocId)
            player:addSpecialSkill(SPECIALSKILL_LIFELEECHAMOUNT, SPECIAL_SKILL_PER_PCT)
        end,
    },
    manaleech = {
        cost = 10,
        desc = "+1% Mana Leech Chance",
        apply = function(player, vocId)
            player:addSpecialSkill(SPECIALSKILL_MANALEECHCHANCE, SPECIAL_SKILL_PER_PCT)
        end,
    },
    manaleechamt = {
        cost = 10,
        desc = "+1% Mana Leech Amount",
        apply = function(player, vocId)
            player:addSpecialSkill(SPECIALSKILL_MANALEECHAMOUNT, SPECIAL_SKILL_PER_PCT)
        end,
    },
    -- ─── Tier-based (aparecem na UI do cliente) ──────────────
    dodge = {
        cost = 10,
        desc = "+1 tier Dodge (armadura)",
        apply = function(player, vocId)
            local item = player:getSlotItem(CONST_SLOT_ARMOR)
            if not item then
                player:sendTextMessage(MESSAGE_STATUS_SMALL, "Equipe uma armadura primeiro.")
                return false
            end
            item:setTier(item:getTier() + 1)
        end,
    },
    fatal = {
        cost = 10,
        desc = "+1 tier Fatal (arma)",
        apply = function(player, vocId)
            local item = player:getSlotItem(CONST_SLOT_LEFT) or player:getSlotItem(CONST_SLOT_RIGHT)
            if not item then
                player:sendTextMessage(MESSAGE_STATUS_SMALL, "Equipe uma arma primeiro.")
                return false
            end
            item:setTier(item:getTier() + 1)
        end,
    },
    momentum = {
        cost = 5,
        desc = "+2% velocidade (mage: spells | knight/pal: melee)",
        apply = function(player, vocId)
            local cur = math.max(0, player:getStorageValue(WAR_MOMENTUM))
            if cur >= 10 then
                player:sendTextMessage(MESSAGE_STATUS_SMALL, "Momentum maximo atingido (10 tiers = 20%).")
                return false
            end
            player:setStorageValue(WAR_MOMENTUM, cur + 1)
        end,
    },
    transcendence = {
        costs = { [1]=5, [2]=5, [5]=5, [6]=5 },
        desc = "-5% custo de mana por magia (max 25%) [mage]",
        apply = function(player, vocId)
            local cur = math.max(0, player:getStorageValue(WAR_TRANSCENDENCE))
            if cur >= 5 then
                player:sendTextMessage(MESSAGE_STATUS_SMALL, "Transcendence maximo atingido (5 tiers = 25%).")
                return false
            end
            player:setStorageValue(WAR_TRANSCENDENCE, cur + 1)
        end,
    },
}

local SHOP_ORDER = { "skill", "ml", "crit", "critdmg", "lifeleech", "lifeleechamt", "manaleech", "manaleechamt", "dodge", "fatal", "momentum", "transcendence" }

function showShop(player)
    local vocId = player:getVocation():getId()
    local armorTier  = (player:getSlotItem(CONST_SLOT_ARMOR)  and player:getSlotItem(CONST_SLOT_ARMOR):getTier())  or 0
    local weaponTier = (player:getSlotItem(CONST_SLOT_LEFT)   and player:getSlotItem(CONST_SLOT_LEFT):getTier())   or
                       (player:getSlotItem(CONST_SLOT_RIGHT)  and player:getSlotItem(CONST_SLOT_RIGHT):getTier())  or 0
    local lines = {
        "[=== WAR SHOP ===]",
        string.format("Tokens: %d | Crit: %d%% | Dodge tier: %d | Fatal tier: %d",
            getTokens(player),
            math.floor(player:getSpecialSkill(SPECIALSKILL_CRITICALHITCHANCE) / SPECIAL_SKILL_PER_PCT),
            armorTier, weaponTier),
        "",
    }
    for _, key in ipairs(SHOP_ORDER) do
        local item = SHOP_ITEMS[key]
        local cost = getCost(item, vocId)
        if cost then
            lines[#lines + 1] = string.format(
                "  !buy %-14s -%2d tokens -%s", key, cost, item.desc)
        end
    end
    lines[#lines + 1] = ""
    lines[#lines + 1] = "Efeitos perdidos ao morrer."
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, table.concat(lines, "\n"))
end

local buyCmd = TalkAction("!buy")

function buyCmd.onSay(player, words, param)
    if player:getGroup():getId() >= 4 then return false end

    local vocId = player:getVocation():getId()
    local what  = param:lower():match("^%s*([%a]+)%s*$")
    if not what then
        showShop(player)
        return false
    end

    local item = SHOP_ITEMS[what]
    if not item then
        player:sendTextMessage(MESSAGE_STATUS_SMALL,
            "Item desconhecido. Use !buy para ver o catalogo.")
        return false
    end

    local cost = getCost(item, vocId)
    if not cost then
        player:sendTextMessage(MESSAGE_STATUS_SMALL,
            "Sua vocacao nao pode comprar este item.")
        return false
    end

    if not spendTokens(player, cost) then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, string.format(
            "Tokens insuficientes. Necessario: %d | Voce tem: %d",
            cost, getTokens(player)))
        return false
    end

    if item.apply(player, vocId) == false then
        -- refund -apply() returned false (e.g. no item equipped)
        player:setStorageValue(WAR_TOKENS, getTokens(player) + cost)
        return false
    end
    player:sendTextMessage(MESSAGE_STATUS_SMALL, string.format(
        "[Shop] %s aplicado! Tokens restantes: %d",
        item.desc, getTokens(player)))
    return false
end

buyCmd:separator(" ")
buyCmd:register()
