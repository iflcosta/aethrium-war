-- ============================================================
--  Aethrium War — Outfit Enforcer
--  Impede que jogadores alterem as cores do time.
-- ============================================================

local TEAM_COLORS = {
    [1] = { head = 88,  body = 88,  legs = 107, feet = 126 },
    [2] = { head = 94,  body = 94,  legs = 113, feet = 132 },
    [3] = { head = 50,  body = 82,  legs = 68,  feet = 86  },
    [4] = { head = 210, body = 192, legs = 174, feet = 156 },
    [5] = { head = 132, body = 131, legs = 114, feet = 133 },
    [6] = { head = 172, body = 154, legs = 136, feet = 118 },
    [7] = { head = 11,  body = 31,  legs = 13,  feet = 15  },
}

local function getTeamColors(player)
    local resultId = db.storeQuery(string.format(
        "SELECT `guild_id` FROM `guild_membership` WHERE `player_id` = %d LIMIT 1",
        player:getGuid()
    ))
    if not resultId then return nil end
    local guildId = result.getNumber(resultId, "guild_id")
    result.free(resultId)
    return TEAM_COLORS[guildId]
end

local WarOutfitEnforcer = CreatureEvent("WarOutfitEnforcer")

function WarOutfitEnforcer.onChangeOutfit(player, outfit)
    if not player then return true, outfit end
    if player:getGroup():getId() >= 4 then return true, outfit end

    local colors = getTeamColors(player)
    if not colors then return true, outfit end

    outfit.lookHead = colors.head
    outfit.lookBody = colors.body
    outfit.lookLegs = colors.legs
    outfit.lookFeet = colors.feet
    return true, outfit
end

WarOutfitEnforcer:type("changeoutfit")
WarOutfitEnforcer:register()
