local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

local function callback(player, _engineLevel, magicLevel)
	local level = getWarLevel and getWarLevel(player) or _engineLevel
	local min = (level / 5) + (magicLevel * 6.8) + 42
	local max = (level / 5) + (magicLevel * 12.9) + 90
	return min, max
end

combat:setCallback(CallBackParam.LEVELMAGICVALUE, callback)

local spell = Spell("instant")
function spell.onCastSpell(creature, variant) return combat:execute(creature, variant) end

spell:group("healing")
spell:id(24)
spell:name("Ultimate Healing")
spell:words("exura vita")
spell:level(20)
spell:mana(160)
spell:isSelfTarget(true)
spell:cooldown(0)
spell:groupCooldown(1000)
spell:needLearn(false)
spell:vocation("sorcerer", "master sorcerer", "druid", "elder druid")
spell:register()
