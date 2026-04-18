-- ============================================================
--  Aethrium War — Outfit Enforcer (Identidade Visual por Time)
--  Arquivo: server/data/scripts/creaturescripts/war_outfit_enforcer.lua
--
--  Cada time tem um espectro de cores oficial.
--  O jogador escolhe o outfit livremente, mas o servidor
--  sobrescreve a PALETA para o espectro do seu time.
-- ============================================================

-- ─── Paleta de Cores por Guild ─────────────────────────────
-- Formato: { head, body, legs, feet }
-- Os valores são índices de cor do cliente Tibia 8.6
local TEAM_PALETTE = {
    [1] = { head = 94,  body = 113, legs = 95,  feet = 114 }, -- Antica Team   → Vermelho Degradê
    [2] = { head = 105, body = 5,   legs = 23,  feet = 10  }, -- Nova Team     → Azul Degradê
    [3] = { head = 50,  body = 82,  legs = 68,  feet = 86  }, -- Secura Team   → Verde Degradê
    [4] = { head = 210, body = 192, legs = 174, feet = 156 }, -- Amera Team    → Dourado Degradê
    [5] = { head = 132, body = 131, legs = 114, feet = 133 }, -- Calmera Team  → Roxo Degradê
    [6] = { head = 172, body = 154, legs = 136, feet = 118 }, -- Hiberna Team  → Ciano Degradê
    [7] = { head = 11,  body = 31,  legs = 13,  feet = 15  }, -- Harmonia Team → Laranja Degradê
}

-- ─── Evento: Mudança de Outfit ─────────────────────────────

local warOutfit = CreatureEvent("WarOutfitEnforcer")

function warOutfit.onChangeOutfit(player, outfit)
    -- Bypass para administradores
    if player:getGroup():getId() >= 4 then
        return true
    end

    local guild = player:getGuild()
    if not guild then
        return true -- Sem guild, permite livre (neutro)
    end

    local guildId = guild:getId()
    local palette = TEAM_PALETTE[guildId]

    if not palette then
        return true -- Guild desconhecida, não interfere
    end

    -- Preserva o tipo de outfit escolhido, força as cores graduais
    outfit.lookHead  = palette.head
    outfit.lookBody  = palette.body
    outfit.lookLegs  = palette.legs
    outfit.lookFeet  = palette.feet

    player:setOutfit(outfit)
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "As cores do seu time foram harmonizadas com degradâ estético.")
    return false 
end
warOutfit:register()

-- ─── Nota ─────────────────────────────────────────────────
-- O registro do WarOutfitEnforcer e a aplicação inicial da paleta
-- são feitos pelo hook loginMessage em player_login_logout.lua
-- para centralizar todos os eventos War em um único ponto de entrada.
