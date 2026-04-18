local WarOutfitEnforcer = CreatureEvent("WarOutfitEnforcer")

-- Paleta de cores degradê artística por time (Guild ID)
local TEAM_PALETTE = {
    [1] = { head = 94,  body = 113, legs = 95,  feet = 114 }, -- Antica   → Vermelho
    [2] = { head = 105, body = 5,   legs = 23,  feet = 10  }, -- Nova     → Azul
    [3] = { head = 50,  body = 82,  legs = 68,  feet = 86  }, -- Secura   → Verde
    [4] = { head = 210, body = 192, legs = 174, feet = 156 }, -- Amera    → Dourado
    [5] = { head = 132, body = 131, legs = 114, feet = 133 }, -- Calmera  → Roxo
    [6] = { head = 172, body = 154, legs = 136, feet = 118 }, -- Hiberna  → Ciano
    [7] = { head = 11,  body = 31,  legs = 13,  feet = 15  }, -- Harmonia → Laranja
}

-- [[ SCRIPT HÍBRIDO ANTICRASH ]]
-- Esta função detecta se a engine envia os dados como Tabela (TFS 1.x moderno)
-- ou como Números Posicionais (Engines antigas/downgrade).
function WarOutfitEnforcer.onChangeOutfit(player, ...)
    local args = {...}
    local outfit = args[1]

    -- 1. Verificação do Player
    if not player or type(player) ~= "userdata" then
        return true, outfit
    end

    -- 2. Bypass para Administradores (GOD)
    local group = player:getGroup()
    if group then
        local groupId = (type(group) == "number") and group or group:getId()
        if groupId >= 4 then
            return true, outfit -- Retorna o outfit original sem modificações
        end
    end

    -- 3. Detecção de Formato e Aplicação da Paleta
    local guild = player:getGuild()
    if not guild then
        return true, outfit
    end

    local palette = TEAM_PALETTE[guild:getId()]
    if not palette then
        return true, outfit
    end

    -- CASO A: Argumento é uma TABELA (TFS 1.x)
    if type(outfit) == "table" then
        outfit.lookHead = palette.head
        outfit.lookBody = palette.body
        outfit.lookLegs = palette.legs
        outfit.lookFeet = palette.feet
        return true, outfit
    end

    -- CASO B: Argumentos são NÚMEROS (Engines 8.6 antigas)
    -- Ordem: lookType, lookHead, lookBody, lookLegs, lookFeet, lookAddons, lookMount
    if type(outfit) == "number" then
        local lookType   = args[1]
        local lookHead   = palette.head
        local lookBody   = palette.body
        local lookLegs   = palette.legs
        local lookFeet   = palette.feet
        local lookAddons = args[6] or 0
        local lookMount  = args[7] or 0
        
        -- Retorna a sequência modificada esperada pela engine
        return true, lookType, lookHead, lookBody, lookLegs, lookFeet, lookAddons, lookMount
    end

    -- Caso de segurança
    return true, outfit
end

WarOutfitEnforcer:type("changeoutfit")
WarOutfitEnforcer:register()
