-- gerado por Spell Converter
-- script original
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEAREA)
combat:setArea(createCombatArea(AREA_WAVE4, AREADIAGONAL_WAVE4))

local function callback(player, level, magicLevel)
	local min = (level / 2) + (magicLevel * 0.8) + 5
	local max = (level / 2) + (magicLevel * 2) + 12
	return -min, -max
end

combat:setCallback(CallBackParam.LEVELMAGICVALUE, callback)

local spell = Spell("instant")
function spell.onCastSpell(creature, variant) return combat:execute(creature, variant) end


spell:group("attack")
spell:id(116)
spell:name("Ice Wave")
spell:words("exevo frigo hur")
spell:level(18)
spell:mana(25)
spell:cooldown(0)
spell:groupCooldown(2000)
spell:needLearn(false)
spell:needDirection(true)
spell:vocation("druid", "elder druid")
spell:register()
