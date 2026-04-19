-- ============================================================
--  Aethrium War — War Shop (!buy)
-- ============================================================

local SHOP_ITEMS = {
    skill = {
        cost = 5,
        desc = "+5 em todas as skills de combate",
        apply = function(player)
            local skills = { SKILL_SWORD, SKILL_AXE, SKILL_CLUB, SKILL_DISTANCE, SKILL_SHIELD }
            for _, sk in ipairs(skills) do
                player:addSkillLevel(sk, 5)
            end
        end,
    },
    ml = {
        cost = 5,
        desc = "+5 Magic Level",
        apply = function(player)
            if SKILL_MAGLEVEL then
                player:addSkillLevel(SKILL_MAGLEVEL, 5)
            end
        end,
    },
    crit = {
        cost = 10,
        desc = "+1% Critical Hit chance (+50% dano no acerto)",
        apply = function(player)
            local cur = player:getStorageValue(WAR_CRIT_CHANCE)
            player:setStorageValue(WAR_CRIT_CHANCE, math.max(0, cur) + 1)
        end,
    },
    dodge = {
        cost = 10,
        desc = "+1% Dodge chance (evitar dano completamente)",
        apply = function(player)
            local cur = player:getStorageValue(WAR_DODGE_CHANCE)
            player:setStorageValue(WAR_DODGE_CHANCE, math.max(0, cur) + 1)
        end,
    },
}

local SHOP_ORDER = { "skill", "ml", "crit", "dodge" }

local function showShop(player)
    local lines = {
        "[=== WAR SHOP ===]",
        string.format("Seus tokens: %d", getTokens(player)),
        string.format("Crit: %d%% | Dodge: %d%%",
            math.max(0, player:getStorageValue(WAR_CRIT_CHANCE)),
            math.max(0, player:getStorageValue(WAR_DODGE_CHANCE))),
        "",
    }
    for _, key in ipairs(SHOP_ORDER) do
        local item = SHOP_ITEMS[key]
        lines[#lines + 1] = string.format("  !buy %-8s — %2d tokens — %s", key, item.cost, item.desc)
    end
    lines[#lines + 1] = ""
    lines[#lines + 1] = "Todos os efeitos sao perdidos ao morrer."
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, table.concat(lines, "\n"))
end

local buyCmd = TalkAction("!buy")

function buyCmd.onSay(player, words, param)
    if player:getGroup():getId() >= 4 then return false end

    local what = param:lower():match("^%s*(%a+)%s*$")
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

    if not spendTokens(player, item.cost) then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, string.format(
            "Tokens insuficientes. Necessario: %d | Voce tem: %d",
            item.cost, getTokens(player)))
        return false
    end

    item.apply(player)
    player:sendTextMessage(MESSAGE_STATUS_SMALL, string.format(
        "[Shop] %s aplicado! Tokens restantes: %d",
        item.desc, getTokens(player)))
    return false
end

buyCmd:separator(" ")
buyCmd:register()
