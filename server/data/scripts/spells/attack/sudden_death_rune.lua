local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SUDDENDEATH)

local function callback(player, _engineLevel, magicLevel)
	local level = getWarLevel and getWarLevel(player) or _engineLevel
	local min = (level / 5) + (magicLevel * 4.1) + 62
	local max = (level / 5) + (magicLevel * 7.1) + 62
	return -min, -max
end

combat:setCallback(CallBackParam.LEVELMAGICVALUE, callback)

local spell = Spell("rune")
function spell.onCastSpell(creature, variant, isHotkey)
	return combat:execute(creature, variant)
end

spell:group("attack")
spell:id(3155)
spell:runeId(3155)
spell:name("Sudden Death Rune")
spell:level(45)
spell:magicLevel(15)
spell:cooldown(0)
spell:groupCooldown(2000)
spell:needLearn(false)
spell:allowFarUse(true)
spell:charges(1)
spell:isBlocking(true, false)
spell:register()
