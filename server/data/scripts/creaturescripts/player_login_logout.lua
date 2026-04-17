local function convertIp(int)
    if not int then return "0.0.0.0" end
    local b1 = int % 256
    local b2 = math.floor(int / 256) % 256
    local b3 = math.floor(int / 65536) % 256
    local b4 = math.floor(int / 16777216) % 256
    return string.format("%d.%d.%d.%d", b1, b2, b3, b4)
end

local loginMessage = CreatureEvent("loginMessage")

function loginMessage.onLogin(player)
    local prevColor = logger.colors.green
    local resetColor = logger.colors.reset
    local ipStr = convertIp(player:getIp())
    local vocation = player:getVocation():getName()
    local level = player:getLevel()

    logger.info("%s%s has logged in.%s [Lvl: %d] [Voc: %s] [IP: %s]", prevColor, player:getName(), resetColor, level, vocation, ipStr)

    local rewardChest = player:getRewardChest()
    local rewardContainerCount = 0
    for _, item in ipairs(rewardChest:getItems()) do
        if item:getId() == ITEM_REWARD_CONTAINER then
            rewardContainerCount = rewardContainerCount + 1
        end
    end
    if rewardContainerCount > 0 then
        player:sendTextMessage(MESSAGE_STATUS_DEFAULT, string.format("You have %d reward%s in your reward chest.", rewardContainerCount, rewardContainerCount > 1 and "s" or ""))
    end

    local serverName = configManager.getString(configKeys.SERVER_NAME)
    local loginStr = "Welcome to " .. serverName .. "!"
    if player:getLastLoginSaved() <= 0 then
        loginStr = loginStr .. " Please choose your outfit."
        player:sendOutfitWindow()
    else
        loginStr = string.format("Your last visit in %s: %s.", serverName, os.date("%d %b %Y %X", player:getLastLoginSaved()))
    end
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)

    local vocation = player:getVocation()
    local promotion = vocation:getPromotion()
    if player:isPremium() then
        local value = player:getStorageValue(PlayerStorageKeys.promotion)
        if value and value == 1 then
            player:setVocation(promotion)
        end
    elseif not promotion then
        player:setVocation(vocation:getDemotion())
    end

    -- Update Experience Rate Stamina
    player:updateStamina()

    player:registerEvent("logoutMessage")

    -- Aethrium War: Registra os eventos do Motor Arcade para este jogador
    player:registerEvent("WarArcadeDeath")
    player:registerEvent("WarArcadeLogout")
    player:registerEvent("WarOutfitEnforcer")
    player:registerEvent("WarKillfeed")

    -- Aplica a paleta de cores do time imediatamente no login
    local warGuild = player:getGuild()
    if warGuild then
        local WAR_TEAM_PALETTE = {
            [1] = { head = 113, body = 113, legs = 95,  feet = 95  }, -- Antica   → Vermelho
            [2] = { head = 5,   body = 5,   legs = 23,  feet = 23  }, -- Nova     → Azul
            [3] = { head = 50,  body = 50,  legs = 68,  feet = 68  }, -- Secura   → Verde
            [4] = { head = 210, body = 210, legs = 192, feet = 192 }, -- Amera    → Dourado
            [5] = { head = 132, body = 132, legs = 114, feet = 114 }, -- Calmera  → Roxo
            [6] = { head = 172, body = 172, legs = 154, feet = 154 }, -- Hiberna  → Ciano
            [7] = { head = 31,  body = 31,  legs = 13,  feet = 13  }, -- Harmonia → Laranja
        }
        local palette = WAR_TEAM_PALETTE[warGuild:getId()]
        if palette then
            local outfit = player:getOutfit()
            outfit.lookHead = palette.head
            outfit.lookBody = palette.body
            outfit.lookLegs = palette.legs
            outfit.lookFeet = palette.feet
            player:setOutfit(outfit)
        end
    end

    -- Mensagem de boas-vindas da War
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT,
        "[Aethrium War] !frags = placar | !warteams = times online | !warhelp = comandos")

    player:openChannel(10)

    if configManager.getBoolean(RESET_SYSTEM_ENABLED) then
        local reductionMultiplier = player:getResetExpReduction()
        player:setExperienceRate(ExperienceRateType.STAMINA, reductionMultiplier * 100)
    end

    if player:isTokenProtected() then
        player:setTokenLocked(true)
        player:popupFYI("=== TOKEN PROTECTION ===\n\nYour account is protected by TOKEN.\n\nYou cannot move or drop items until you unlock.\n\nType: !token <your_password>\n\nto unlock your character.")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "[Token] You are LOCKED! Type !token <password> to unlock.")
    end

    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, "[Mount] Use Ctrl+M to mount or dismount your mount.")

    return true
end
loginMessage:register()

local logoutMessage = CreatureEvent("logoutMessage")
function logoutMessage.onLogout(player)
    local prevColor = logger.colors.red
    local resetColor = logger.colors.reset
    local ipStr = convertIp(player:getIp())
    local vocation = player:getVocation():getName()
    local level = player:getLevel()

    logger.info("%s%s has logged out.%s [Lvl: %d] [Voc: %s] [IP: %s]", prevColor, player:getName(), resetColor, level, vocation, ipStr)
    local playerId = player:getId()
    nextUseStaminaTime[playerId] = nil
    if Game.getStorageValue(GlobalStorageKeys.workbenchOwner) == playerId then
        Game.setStorageValue(GlobalStorageKeys.workbenchOwner, -1)
    end
    return true
end
logoutMessage:register()
