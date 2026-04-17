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
    [1] = { head = 113, body = 113, legs = 95,  feet = 95  }, -- Antica Team   → Vermelho
    [2] = { head = 5,   body = 5,   legs = 23,  feet = 23  }, -- Nova Team     → Azul
    [3] = { head = 50,  body = 50,  legs = 68,  feet = 68  }, -- Secura Team   → Verde
    [4] = { head = 210, body = 210, legs = 192, feet = 192 }, -- Amera Team    → Dourado
    [5] = { head = 132, body = 132, legs = 114, feet = 114 }, -- Calmera Team  → Roxo
    [6] = { head = 172, body = 172, legs = 154, feet = 154 }, -- Hiberna Team  → Ciano
    [7] = { head = 31,  body = 31,  legs = 13,  feet = 13  }, -- Harmonia Team → Laranja
}

-- ─── Evento: Mudança de Outfit ─────────────────────────────

local warOutfit = CreatureEvent("WarOutfitEnforcer")

function warOutfit.onChangeOutfit(player, outfit)
    local guild = player:getGuild()
    if not guild then
        return true -- Sem guild, permite livre (admin / sem time)
    end

    local guildId = guild:getId()
    local palette = TEAM_PALETTE[guildId]

    if not palette then
        return true -- Guild desconhecida, não interfere
    end

    -- Preserva o tipo de outfit escolhido, força as cores
    outfit.lookHead  = palette.head
    outfit.lookBody  = palette.body
    outfit.lookLegs  = palette.legs
    outfit.lookFeet  = palette.feet

    player:setOutfit(outfit)
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "As cores do seu time estão travadas com sucesso. Apenas o modelo foi alterado.")
    return false -- Retorna false para rejeitar a mudança de cor original do cliente sem mostrar erro
end
warOutfit:register()

-- ─── Nota ─────────────────────────────────────────────────
-- O registro do WarOutfitEnforcer e a aplicação inicial da paleta
-- são feitos pelo hook loginMessage em player_login_logout.lua
-- para centralizar todos os eventos War em um único ponto de entrada.
