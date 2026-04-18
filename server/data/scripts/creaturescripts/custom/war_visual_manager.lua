-- ============================================================
--  Aethrium War — Visual Manager (Outfits & Addons)
--  Arquivo: server/data/scripts/creaturescripts/custom/war_visual_manager.lua
--
--  Este script desbloqueia globalmente os outfits/addons 8.6
--  e padroniza o visual inicial 7.6 por vocação.
-- ============================================================

local VOC_OUTFITS = {
    -- [VocationID] = { male = looktype, female = looktype }
    [1] = { male = 130, female = 138 }, -- Sorcerer
    [2] = { male = 128, female = 136 }, -- Druid
    [3] = { male = 129, female = 137 }, -- Paladin
    [4] = { male = 131, female = 139 }, -- Knight
    [5] = { male = 130, female = 138 }, -- MS
    [6] = { male = 128, female = 136 }, -- ED
    [7] = { male = 129, female = 137 }, -- RP
    [8] = { male = 131, female = 139 }, -- EK
}

local TEAM_COLORS = {
    [1] = { head = 88,  body = 88,  legs = 107, feet = 126 }, -- Antica   → Azul Reais
    [2] = { head = 94,  body = 94,  legs = 113, feet = 132 }, -- Nova     → Vermelho Reais
    [3] = { head = 50,  body = 82,  legs = 68,  feet = 86  }, -- Secura   → Verde
    [4] = { head = 210, body = 192, legs = 174, feet = 156 }, -- Amera    → Dourado
    [5] = { head = 132, body = 131, legs = 114, feet = 133 }, -- Calmera  → Roxo
    [6] = { head = 172, body = 154, legs = 136, feet = 118 }, -- Hiberna  → Ciano
    [7] = { head = 11,  body = 31,  legs = 13,  feet = 15  }, -- Harmonia → Laranja
}

local STORAGE_FIRST_OUTFIT = 45001

local visualManager = CreatureEvent("WarVisualManager")

function visualManager.onLogin(player)
    local pSex = player:getSex()
    if pSex ~= PLAYERSEX_MALE and pSex ~= PLAYERSEX_FEMALE then
        player:setSex(PLAYERSEX_MALE)
    end

    -- ─── 1. Desbloqueio Global de Outfits & Addons (Até 8.6) ─────
    local maleOutfits = {
        128, 129, 130, 131, 132, 133, 134, 143, 144, 145, 146, 151, 152, 153, 154,
        251, 268, 273, 278, 289, 325, 328, 335, 367, 1824
    }
    local femaleOutfits = {
        136, 137, 138, 139, 140, 141, 142, 147, 148, 149, 150, 155, 156, 157, 158,
        252, 269, 270, 279, 288, 324, 329, 336, 366, 1825
    }

    local targetList = player:getSex() == PLAYERSEX_MALE and maleOutfits or femaleOutfits
    for _, looktype in ipairs(targetList) do
        player:addOutfitAddon(looktype, 3) -- 3 = Addon 1 + Addon 2
    end

    -- ─── 2. Padronização 7.6 no Primeiro Login ──────────────────
    if player:getStorageValue(STORAGE_FIRST_OUTFIT) == -1 then
        local vocId = player:getVocation():getId()
        local outfitSet = VOC_OUTFITS[vocId]

        if outfitSet then
            local current = player:getOutfit()
            current.lookType = (player:getSex() == PLAYERSEX_MALE) and outfitSet.male or outfitSet.female
            player:setOutfit(current)
        end
        player:setStorageValue(STORAGE_FIRST_OUTFIT, 1)
    end

    -- ─── 3. Forçar Cores do Time (Todo Login) ──────────────────
    local guild = player:getGuild()
    if guild and player:getGroup():getId() < 4 then
        local colors = TEAM_COLORS[guild:getId()]
        if colors then
            -- Pequeno delay de 200ms para evitar kick do OTClient por spam de pacotes no login
            addEvent(function(cid)
                local p = Player(cid)
                if p then
                    local current = p:getOutfit()
                    current.lookHead = colors.head
                    current.lookBody = colors.body
                    current.lookLegs = colors.legs
                    current.lookFeet = colors.feet
                    p:setOutfit(current)
                end
            end, 200, player:getId())
        end
    end

    return true
end

visualManager:type("login")
visualManager:register()
