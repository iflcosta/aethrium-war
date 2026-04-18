-- gerado por Spell Converter
-- script original
local spell = Spell("instant")
function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3153, 1)
end


spell:group("support")
spell:id(166)
spell:name("Cure Poison Rune")
spell:words("adana pox")
spell:level(15)
spell:mana(200)
spell:soul(1)
spell:cooldown(0)
spell:groupCooldown(2000)
spell:needLearn(false)
spell:isAggressive(false)
spell:vocation("druid", "elder druid")
spell:register()
