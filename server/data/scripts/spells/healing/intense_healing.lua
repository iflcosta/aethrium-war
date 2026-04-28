local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

local function callback(player, _engineLevel, magicLevel)
	local level = getWarLevel and getWarLevel(player) or _engineLevel
	local min = (level / 5) + (magicLevel * 3.4) + 21
	local max = (level / 5) + (magicLevel * 6.45) + 45
	return min, max
end

combat:setCallback(CallBackParam.LEVELMAGICVALUE, callback)

local spell = Spell("instant")
function spell.onCastSpell(creature, variant) return combat:execute(creature, variant) end

spell:group("healing")
spell:id(23)
spell:name("Intense Healing")
spell:words("exura gran")
spell:level(11)
spell:mana(70)
spell:isSelfTarget(true)
spell:cooldown(0)
spell:groupCooldown(1000)
spell:needLearn(false)
spell:vocation("sorcerer", "master sorcerer", "druid", "elder druid", "paladin", "royal paladin")
spell:register()
