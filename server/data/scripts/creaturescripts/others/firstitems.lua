-- ============================================================
--  Aethrium War — First Items & Restore
-- ============================================================

local WAR_ITEMS = {
    -- ─── Sorcerer ────────────────────────────────────────────
    [VOCATION.ID.SORCERER] = {
        items = {
            { 3071, 1 }, -- wand of inferno
            { 8072, 1 }, -- spellbook of enlightenment
            { 3416, 1 }, -- demon shield
            { 8062, 1 }, -- robe of the underworld (armor 12, sorc only)
            { 3385, 1 }, -- crown helmet (armor 7, sem restricao de vocacao)
            {  822, 1 }, -- lightning legs (armor 8, mage only)
            { 3079, 1 }, -- boots of haste
            { 3055, 1 }, -- platinum amulet
        },
        container = {
            { 3731, 50 }, -- fire mushroom
            { 3155, 1 }, -- sudden death rune
            { 3160, 1 }, -- ultimate healing rune
            { 3191, 1 }, -- great fireball rune
            { 3149, 1 }, -- energy bomb rune
            { 3175, 1 }, -- stone shower rune
            { 3198, 1 }, -- heavy magic missile rune
            { 23373, 1 }, -- ultimate mana potion
        },
    },

    -- ─── Druid ───────────────────────────────────────────────
    [VOCATION.ID.DRUID] = {
        items = {
            { 3067, 1 }, -- hailstorm rod
            { 8072, 1 }, -- spellbook of enlightenment
            { 3416, 1 }, -- demon shield
            { 8038, 1 }, -- robe of the ice queen (armor 12, druid only)
            { 3385, 1 }, -- crown helmet (armor 7, sem restricao de vocacao)
            {  823, 1 }, -- glacier kilt (armor 8, mage only)
            { 3079, 1 }, -- boots of haste
            { 3055, 1 }, -- platinum amulet
        },
        container = {
            { 3731, 50 }, -- fire mushroom
            { 3160, 1 }, -- ultimate healing rune
            { 3155, 1 }, -- sudden death rune
            { 3161, 1 }, -- avalanche rune
            { 3165, 1 }, -- paralyze rune
            { 3156, 1 }, -- wild growth rune
            { 3175, 1 }, -- stone shower rune
            { 23373, 1 }, -- ultimate mana potion
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
            { 3731, 50 }, -- fire mushroom
            { 5803, 1 }, -- arbalest (two-handed, equip para usar bolts sem shield)
            { 6528, 1 }, -- infernal bolt
            { 7368, 1 }, -- assassin star (usar na mao esquerda + shield na direita)
            { 3155, 1 }, -- sudden death rune
            { 3160, 1 }, -- ultimate healing rune
            { 3200, 1 }, -- explosion rune
            { 3165, 1 }, -- paralyze rune
            { 23374, 1 }, -- ultimate spirit potion
        },
    },

    -- ─── Knight ──────────────────────────────────────────────
    [VOCATION.ID.KNIGHT] = {
        items = {
            { 3288, 1 }, -- magic sword (equipada por padrão)
            { 3414, 1 }, -- mastermind shield
            { 3366, 1 }, -- magic plate armor
            { 3387, 1 }, -- demon helmet
            { 3364, 1 }, -- golden legs
            { 3079, 1 }, -- boots of haste
            { 3055, 1 }, -- platinum amulet
        },
        container = {
            { 3731, 50 }, -- fire mushroom
            { 3319,  1 }, -- stonecutter axe
            { 3309,  1 }, -- thunder hammer
            { 3155,  1 }, -- sudden death rune
            { 3160,  1 }, -- ultimate healing rune
            { 3200,  1 }, -- explosion rune
            { 3198,  1 }, -- heavy magic missile rune
            { 7643,  1 }, -- ultimate health potion
            { 239,   1 }, -- great health potion
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
    end
end

-- ─── Evento ──────────────────────────────────────────────────

local firstItems = CreatureEvent("FirstItems")
function firstItems.onLogin(player)
    restoreWarItems(player)
    return true
end
firstItems:register()
