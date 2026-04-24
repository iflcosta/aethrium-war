-- ============================================================
--  World War — Friendly Fire Enforcer (50% Damage)
--  Reduz o dano entre aliados do mesmo time.
-- ============================================================

local warFriendlyFire = CreatureEvent("WarFriendlyFire")

function warFriendlyFire.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not attacker or not attacker:isPlayer() or not creature:isPlayer() then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    if attacker:getId() == creature:getId() then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    local attackerTeam = WarCurrentTeam and WarCurrentTeam[attacker:getId()]
    local targetTeam   = WarCurrentTeam and WarCurrentTeam[creature:getId()]

    if attackerTeam and targetTeam and attackerTeam == targetTeam then
        primaryDamage = math.ceil(primaryDamage * 0.5)
        secondaryDamage = math.ceil(secondaryDamage * 0.5)
        creature:getPosition():sendMagicEffect(CONST_ME_LOSEENERGY)
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

warFriendlyFire:type("healthchange")
warFriendlyFire:register()
