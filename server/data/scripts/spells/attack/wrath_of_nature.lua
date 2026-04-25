-- gerado por Spell Converter
-- script original
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLPLANTS)
combat:setArea(createCombatArea(AREA_CIRCLE6X6))

local function callback(player, level, magicLevel)
	local min = (level / 2) + (magicLevel * 3) + 32
	local max = (level / 2) + (magicLevel * 9) + 40
	return -min, -max
end

combat:setCallback(CallBackParam.LEVELMAGICVALUE, callback)

local spell = Spell("instant")
function spell.onCastSpell(creature, variant) return combat:execute(creature, variant) end


spell:group("attack")
spell:id(121)
spell:name("Wrath of Nature")
spell:words("exevo gran mas tera")
spell:level(55)
spell:mana(700)
spell:isPremium(true)
spell:isSelfTarget(true)
spell:cooldown(0)
spell:groupCooldown(2000)
spell:needLearn(false)
spell:vocation("druid", "elder druid")
spell:register()
