local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREAREA)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

local function callback(player, _engineLevel, magicLevel)
	local level = getWarLevel and getWarLevel(player) or _engineLevel
	local min = (level / 5) + (magicLevel * 8.0) + 50
	local max = (level / 5) + (magicLevel * 13.0) + 80
	return -min, -max
end

combat:setCallback(CallBackParam.LEVELMAGICVALUE, callback)

local spell = Spell("instant")
function spell.onCastSpell(creature, variant) return combat:execute(creature, variant) end

spell:group("attack")
spell:id(106)
spell:name("Hell's Core")
spell:words("exevo gran mas flam")
spell:level(60)
spell:mana(1100)
spell:isPremium(true)
spell:isSelfTarget(true)
spell:cooldown(0)
spell:groupCooldown(2000)
spell:needLearn(false)
spell:vocation("sorcerer", "master sorcerer")
spell:register()
