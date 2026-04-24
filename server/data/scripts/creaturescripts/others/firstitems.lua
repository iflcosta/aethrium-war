-- ============================================================
--  World War — First Items & Restore
-- ============================================================

local WAR_ITEMS = {
    -- ─── Sorcerer ────────────────────────────────────────────
    [VOCATION.ID.SORCERER] = {
        items = {
            { 3420, 1 }, -- demon shield
            { 3071, 1 }, -- wand of inferno
            { 3567, 1 }, -- blue robe
            { 3387, 1 }, -- demon helmet
            { 645, 1 }, -- blue legs
            { 3079, 1 }, -- boots of haste
            { 3055, 1 }, -- platinum amulet
        },
        container = {
            { 3731, 100 }, -- fire mushroom
            { 3155, 1 }, -- sudden death rune
            { 3160, 1 }, -- ultimate healing rune
            { 3191, 1 }, -- great fireball rune
            { 3149, 1 }, -- energy bomb rune
            { 3192, 1 }, -- fire bomb rune
            { 3148, 1 }, -- destroy field rune
            { 3180, 1 }, -- magic wall rune
            { 3175, 1 }, -- stone shower rune
            { 3198, 1 }, -- heavy magic missile rune
            { 238, 1 }, -- great mana potion
        },
    },

    -- ─── Druid ───────────────────────────────────────────────
    [VOCATION.ID.DRUID] = {
        items = {
            { 3420, 1 }, -- demon shield
            { 8084, 1 }, -- springsprout rod
            { 3567, 1 }, -- blue robe
            { 3387, 1 }, -- demon helmet
            { 645, 1 }, -- blue legs
            { 3079, 1 }, -- boots of haste
            { 3055, 1 }, -- platinum amulet
        },
        container = {
            { 3731, 100 }, -- fire mushroom
            { 3160, 1 }, -- ultimate healing rune
            { 3155, 1 }, -- sudden death rune
            { 3161, 1 }, -- avalanche rune
            { 3165, 1 }, -- paralyze rune
            { 3156, 1 }, -- wild growth rune
            { 3192, 1 }, -- fire bomb rune
            { 3148, 1 }, -- destroy field rune
            { 3180, 1 }, -- magic wall rune
            { 3175, 1 }, -- stone shower rune
            { 238, 1 }, -- great mana potion
        },
    },

    -- ─── Paladin ─────────────────────────────────────────────
    [VOCATION.ID.PALADIN] = {
        items = {
            { 3414, 1 }, -- mastermind shield
            { 3366, 1 }, -- magic plate armor
            { 3387, 1 }, -- demon helmet
            { 3364, 1 }, -- golden legs
            { 3079, 1 }, -- boots of haste
            { 3055, 1 }, -- platinum amulet
        },
        container = {
            { 3731, 100 }, -- fire mushroom
            { 5803, 1 }, -- arbalest (two-handed, equip para usar bolts sem shield)
            { 6528, 1 }, -- infernal bolt
            { 7368, 1 }, -- assassin star (usar na mao esquerda + shield na direita)
            { 3155, 1 }, -- sudden death rune
            { 3160, 1 }, -- ultimate healing rune
            { 3200, 1 }, -- explosion rune
            { 3165, 1 }, -- paralyze rune
            { 3192, 1 }, -- fire bomb rune
            { 3148, 1 }, -- destroy field rune
            { 3180, 1 }, -- magic wall rune
            { 23374, 1 }, -- ultimate spirit potion
            { 237, 1 }, -- strong mana potion
        },
    },

    -- ─── Knight ──────────────────────────────────────────────
    [VOCATION.ID.KNIGHT] = {
        items = {
            { 3414, 1 }, -- mastermind shield
            { 3288, 1 }, -- magic sword (equipada por padrão)
            { 3366, 1 }, -- magic plate armor
            { 3387, 1 }, -- demon helmet
            { 3364, 1 }, -- golden legs
            { 3079, 1 }, -- boots of haste
            { 3055, 1 }, -- platinum amulet
        },
        container = {
            { 3731, 100 }, -- fire mushroom
            { 3319,  1 }, -- stonecutter axe
            { 3309,  1 }, -- thunder hammer
            { 3155,  1 }, -- sudden death rune
            { 3160,  1 }, -- ultimate healing rune
            { 3200,  1 }, -- explosion rune
            { 3198,  1 }, -- heavy magic missile rune
            { 3192, 1 }, -- fire bomb rune
            { 3148, 1 }, -- destroy field rune
            { 3180, 1 }, -- magic wall rune
            { 7643,  1 }, -- ultimate health potion
            { 239,   1 }, -- great health potion
            { 268,   1 }, -- mana potion
        },
    },
}

-- ─── Helpers ─────────────────────────────────────────────────

local function getBaseVocId(vocId)
    if vocId >= 5 and vocId <= 8 then return vocId - 4 end
    if vocId == 10 then return 9 end
    return vocId
end

local function clearPlayerItems(player)
    for slot = 1, 10 do
        local item = player:getSlotItem(slot)
        if item then item:remove() end
    end
    local bp = player:getSlotItem(CONST_SLOT_BACKPACK)
    if bp then bp:remove() end
end

-- ─── API Global ───────────────────────────────────────────────

function restoreWarItems(player)
    if not player or not player:isPlayer() then return end
    if player:getGroup():getId() >= 4 then return end

    local baseVocId = getBaseVocId(player:getVocation():getId())
    local cfg = WAR_ITEMS[baseVocId]
    if not cfg then return end

    clearPlayerItems(player)

    -- Equipamento fixo
    if cfg.items then
        for _, entry in ipairs(cfg.items) do
            player:addItem(entry[1], entry[2])
        end
    end

    -- Backpack com consumíveis
    local backpack = player:addItem(2854, 1) or player:addItem(1987, 1)
    if backpack and cfg.container then
        for _, entry in ipairs(cfg.container) do
            backpack:addItem(entry[1], entry[2])
        end
        -- Backpack extra para God Flowers (pois não estão agrupando)
        local flowerBP = backpack:addItem(2859, 1)
        if flowerBP then
            for i = 1, 5 do
                flowerBP:addItem(2981, 1)
            end
        end
    end
end

-- ─── Evento ──────────────────────────────────────────────────

local firstItems = CreatureEvent("FirstItems")
function firstItems.onLogin(player)
    restoreWarItems(player)
    return true
end
firstItems:register()
