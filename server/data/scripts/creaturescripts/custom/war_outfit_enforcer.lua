local WarOutfitEnforcer = CreatureEvent("WarOutfitEnforcer")

-- Paleta de cores degradê artística por time (Guild ID)
-- Head (Claro) -> Body (Médio) -> Legs (Escuro) -> Feet (Muito Escuro)
local TEAM_PALETTE = {
    [1] = { head = 94,  body = 113, legs = 95,  feet = 114 }, -- Antica   → Vermelho Degradê
    [2] = { head = 105, body = 5,   legs = 23,  feet = 10  }, -- Nova     → Azul Degradê
    [3] = { head = 50,  body = 82,  legs = 68,  feet = 86  }, -- Secura   → Verde Degradê
    [4] = { head = 210, body = 192, legs = 174, feet = 156 }, -- Amera    → Dourado Degradê
    [5] = { head = 132, body = 131, legs = 114, feet = 133 }, -- Calmera  → Roxo Degradê
    [6] = { head = 172, body = 154, legs = 136, feet = 118 }, -- Hiberna  → Ciano Degradê
    [7] = { head = 11,  body = 31,  legs = 13,  feet = 15  }, -- Harmonia → Laranja Degradê
}

function WarOutfitEnforcer.onChangeOutfit(player, outfit)
    -- Bypass para Administradores (GOD)
    if player:getGroup():getId() >= 4 then
        return true, outfit
    end

    local guild = player:getGuild()
    if guild then
        local palette = TEAM_PALETTE[guild:getId()]
        if palette then
            -- Força a paleta degradê no outfit recebido
            outfit.lookHead = palette.head
            outfit.lookBody = palette.body
            outfit.lookLegs = palette.legs
            outfit.lookFeet = palette.feet
        end
    end

    -- Retorna true para permitir a mudança e o outfit modificado
    return true, outfit
end

WarOutfitEnforcer:type("changeoutfit")
WarOutfitEnforcer:register()
