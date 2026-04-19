-- Mapeamento de itens por vocação BASE (1-4, 9)
-- Vocs promovidas (5-8, 10) são mapeadas para a base automaticamente
local WAR_ITEMS = {
	[VOCATION.ID.SORCERER] = {
		items = {
			{ 8072, 1 }, -- spellbook of enlightenment
			{ 8092, 1 }, -- wand of starstorm
			{ 8043, 1 }, -- focus cape
			{ 3210, 1 }, -- hat of the mad
			{ 645,  1 }, -- blue legs
			{ 3079, 1 }, -- boots of haste
			{ 3055, 1 }, -- platinum amulet
		},
		container = {
			{ 3155, 100 }, -- sd
			{ 3160, 100 }, -- uh
			{ 238,  100 }, -- great mana potion
			{ 3003,   1 }, -- rope
			{ 5710,   1 }, -- light shovel
		},
	},

	[VOCATION.ID.DRUID] = {
		items = {
			{ 8072, 1 }, -- spellbook of enlightenment
			{ 8082, 1 }, -- rod of underworld
			{ 8043, 1 }, -- focus cape
			{ 3210, 1 }, -- hat of the mad
			{ 645,  1 }, -- blue legs
			{ 3079, 1 }, -- boots of haste
			{ 3055, 1 }, -- platinum amulet
		},
		container = {
			{ 3155, 100 }, -- sd
			{ 3160, 100 }, -- uh
			{ 238,  100 }, -- great mana potion
			{ 3003,   1 }, -- rope
			{ 5710,   1 }, -- light shovel
		},
	},

	[VOCATION.ID.PALADIN] = {
		items = {
			{ 3414,  1 }, -- mastermind shield
			{ 7378,  1 }, -- royal spear
			{ 8063,  1 }, -- paladin armor
			{ 10385, 1 }, -- zaoan helmet
			{ 645,   1 }, -- blue legs
			{ 3079,  1 }, -- boots of haste
			{ 3055,  1 }, -- platinum amulet
		},
		container = {
			{ 3155, 100 }, -- sd
			{ 3160, 100 }, -- uh
			{ 238,  100 }, -- great mana potion
			{ 3003,   1 }, -- rope
			{ 5710,   1 }, -- light shovel
		},
	},

	[VOCATION.ID.KNIGHT] = {
		items = {
			{ 3414,  1 }, -- mastermind shield
			{ 7383,  1 }, -- relic sword
			{ 3386,  1 }, -- dragon scale mail
			{ 10385, 1 }, -- zaoan helmet
			{ 10387, 1 }, -- zaoan legs
			{ 3079,  1 }, -- boots of haste
			{ 3055,  1 }, -- platinum amulet
		},
		container = {
			{ 3155, 100 }, -- sd
			{ 3160, 100 }, -- uh
			{ 239,  100 }, -- great health potion
			{ 3003,   1 }, -- rope
			{ 5710,   1 }, -- light shovel
		},
	},
}

-- Mapeia voc promovida para voc base (5→1, 6→2, 7→3, 8→4, 10→9)
local function getBaseVocId(vocId)
	if vocId >= 5 and vocId <= 8 then
		return vocId - 4
	elseif vocId == 10 then
		return 9
	end
	return vocId
end

local function clearPlayerItems(player)
	for slot = 1, 10 do
		local item = player:getSlotItem(slot)
		if item then item:remove() end
	end
	-- Remove a backpack principal (slot 3 = CONST_SLOT_BACKPACK)
	local bp = player:getSlotItem(3)
	if bp then bp:remove() end
end

-- Função global: pode ser chamada no reset de morte também
function restoreWarItems(player)
	if not player or not player:isPlayer() then return end
	if player:getGroup():getId() >= 4 then return end -- ignora GODs

	local baseVocId = getBaseVocId(player:getVocation():getId())
	local cfg = WAR_ITEMS[baseVocId]
	if not cfg then return end

	clearPlayerItems(player)

	if cfg.items then
		for _, entry in ipairs(cfg.items) do
			player:addItem(entry[1], entry[2])
		end
	end

	local backpack = player:addItem(2854, 1) or player:addItem(1987, 1)
	if backpack and cfg.container then
		for _, entry in ipairs(cfg.container) do
			backpack:addItem(entry[1], entry[2])
		end
	end
end

local firstItems = CreatureEvent("FirstItems")
function firstItems.onLogin(player)
	restoreWarItems(player)
	return true
end
firstItems:register()
