-- ============================================================
--  World War — Visual Manager (v3.1)
--  Gerencia Outfits e Cores Nativas.
-- ============================================================

local PLAYERSEX_FEMALE = 0
local PLAYERSEX_MALE = 1
local PLAYERSEX_WAR_MALE = 3

local TEAM_COLORS = {
    [1] = { head = 88,  body = 88,  legs = 107, feet = 126 },
    [2] = { head = 94,  body = 94,  legs = 113, feet = 132 },
    [3] = { head = 50,  body = 82,  legs = 68,  feet = 86  },
    [4] = { head = 210, body = 192, legs = 174, feet = 156 },
    [5] = { head = 132, body = 131, legs = 114, feet = 133 },
    [6] = { head = 172, body = 154, legs = 136, feet = 118 },
    [7] = { head = 11,  body = 31,  legs = 13,  feet = 15  },
}

local VOC_OUTFITS = {
    [1] = { male = 131, female = 139 },
    [2] = { male = 130, female = 138 },
    [3] = { male = 129, female = 137 },
    [4] = { male = 131, female = 142 },
    [5] = { male = 131, female = 139 },
    [6] = { male = 130, female = 138 },
    [7] = { male = 129, female = 137 },
    [8] = { male = 131, female = 142 },
}

WarVisuals = {}

local visualEvent = CreatureEvent("WarVisualManager")

function visualEvent.onLogin(player)
    if player:getGroup():getId() >= 4 then return true end

    local teamId = WarCurrentTeam and WarCurrentTeam[player:getId()]
    if not teamId then return true end

    -- Força todos os jogadores a serem do sexo masculino (1)
    if player:getSex() ~= PLAYERSEX_MALE then
        player:setSex(PLAYERSEX_MALE)
    end

    local maleOutfits = { 128, 129, 130, 131, 132, 133, 134, 143, 144, 145, 146, 151, 152, 153, 154, 251, 268, 273, 278, 289, 325, 328, 335, 367, 430, 432, 463, 464, 465, 466, 472, 512, 516, 541, 542 }
    local femaleOutfits = { 136, 137, 138, 139, 140, 141, 142, 147, 148, 149, 150, 155, 156, 157, 158, 252, 269, 270, 279, 288, 324, 329, 336, 366, 431, 433, 471, 513, 514, 541, 542 }

    local targetList = (player:getSex() == PLAYERSEX_MALE) and maleOutfits or femaleOutfits
    for _, looktype in ipairs(targetList) do
        player:addOutfitAddon(looktype, 3)
    end

    local storageFirstOutfit = 45001
    if player:getStorageValue(storageFirstOutfit) == -1 then
        local vocId = player:getVocation():getId()
        local outfitSet = VOC_OUTFITS[vocId]
        if outfitSet then
            local current = player:getOutfit()
            current.lookType = (player:getSex() == PLAYERSEX_MALE) and outfitSet.male or outfitSet.female
            player:setOutfit(current)
        end
        player:setStorageValue(storageFirstOutfit, 1)
    end

    local colors = TEAM_COLORS[teamId]
    if colors then
        addEvent(function(cid)
            local p = Player(cid)
            if not p then return end
            local current = p:getOutfit()
            current.lookHead = colors.head
            current.lookBody = colors.body
            current.lookLegs = colors.legs
            current.lookFeet = colors.feet
            p:setOutfit(current)
        end, 200, player:getId())
    end

    return true
end

WarVisuals.onLogin = visualEvent.onLogin

visualEvent:type("login")
visualEvent:register()
