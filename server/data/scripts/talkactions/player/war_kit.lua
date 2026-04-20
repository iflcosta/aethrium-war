-- ============================================================
--  Aethrium War — Kit de Arma (!kit)
--  Apenas para Knights: escolhe tipo de arma antes do spawn.
--  O kit é restaurado automaticamente ao morrer/resetar.
-- ============================================================

WAR_KIT_WEAPON = 45210  -- storage: ID da arma escolhida

local KNIGHT_KITS = {
    sword = { id = 3288, name = "Magic Sword"       },
    axe   = { id = 3319, name = "Stonecutter Axe"   },
    club  = { id = 3309, name = "Thunder Hammer"    },
}

local VOC_KNIGHT = { [4]=true, [8]=true }

local kitCmd = TalkAction("!kit")

function kitCmd.onSay(player, words, param)
    if player:getGroup():getId() >= 4 then return false end

    local vocId = player:getVocation():getId()
    if not VOC_KNIGHT[vocId] then
        player:sendTextMessage(MESSAGE_STATUS_SMALL,
            "Apenas Knights podem escolher kit de arma.")
        return false
    end

    local choice = param:lower():match("^%s*(%a+)%s*$")
    if not choice then
        -- Mostra opções disponíveis
        local lines = {
            "[=== KIT DE ARMA ===]",
            "Escolha seu tipo de arma melee:",
            "  !kit sword — Magic Sword (Atk 48, Def 35)",
            "  !kit axe   — Stonecutter Axe (Atk 50, Def 25)",
            "  !kit club  — Thunder Hammer (Atk 52, Def 22)",
            "",
            "O kit e aplicado no proximo respawn.",
        }
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, table.concat(lines, "\n"))
        return false
    end

    local kit = KNIGHT_KITS[choice]
    if not kit then
        player:sendTextMessage(MESSAGE_STATUS_SMALL,
            "Kit invalido. Use: !kit sword | !kit axe | !kit club")
        return false
    end

    player:setStorageValue(WAR_KIT_WEAPON, kit.id)
    player:sendTextMessage(MESSAGE_STATUS_SMALL,
        string.format("[Kit] %s selecionado. Sera equipado no proximo respawn.", kit.name))

    return false
end

kitCmd:separator(" ")
kitCmd:register()
