local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEAREA)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

local function callback(player, _engineLevel, magicLevel)
	local level = getWarLevel and getWarLevel(player) or _engineLevel
	local min = (level / 5) + (magicLevel * 5.5) + 25
	local max = (level / 5) + (magicLevel * 11.0) + 50
	return -min, -max
end

combat:setCallback(CallBackParam.LEVELMAGICVALUE, callback)

local spell = Spell("instant")
function spell.onCastSpell(creature, variant) return combat:execute(creature, variant) end

spell:group("attack")
spell:id(107)
spell:name("Eternal Winter")
spell:words("exevo gran mas frigo")
spell:level(60)
spell:mana(1050)
spell:isPremium(true)
spell:isSelfTarget(true)
spell:cooldown(0)
spell:groupCooldown(2000)
spell:needLearn(false)
spell:vocation("druid", "elder druid")
spell:register()
