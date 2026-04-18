-- ============================================================
--  Aethrium War — Motor de Reset Arcade (V4 — Dynamic 250)
--  Arquivo: data/scripts/creaturescripts/war_arcade_reset.lua
-- ============================================================

local WAR_BROADCAST_KILLS   = true
local WAR_SPAWN_PROTECT_MS  = 5000   -- ms de proteção após spawn

local WAR_LEVEL = 250
local L = WAR_LEVEL - 1
local WAR_EXP = math.floor((50 * (L * L * L) - 150 * (L * L) + 400 * L) / 3)

local WAR_STATS = {
    -- Knights (Level 1-8 Sem Voc = 185 HP, 90 Mana, 470 Cap | Level 8-250 = +3630 HP, +1210 Mana, +6050 Cap)
    [4] = { hp = 3815, mana = 1300, cap = 6520, ml = 9, defaultSkill = 100 },
    [8] = { hp = 3815, mana = 1300, cap = 6520, ml = 9, defaultSkill = 100 },
    -- Paladins (Level 8-250 = +2420 HP, +3630 Mana, +4840 Cap)
    [3] = { hp = 2605, mana = 3720, cap = 5310, ml = 25, defaultSkill = 100 },
    [7] = { hp = 2605, mana = 3720, cap = 5310, ml = 25, defaultSkill = 100 },
    -- Mages (Sorcerer/Druid) (Level 8-250 = +1210 HP, +7260 Mana, +2420 Cap)
    [1] = { hp = 1395, mana = 7350, cap = 2890, ml = 80, defaultSkill = 20 },
    [5] = { hp = 1395, mana = 7350, cap = 2890, ml = 80, defaultSkill = 20 },
    [2] = { hp = 1395, mana = 7350, cap = 2890, ml = 80, defaultSkill = 20 },
    [6] = { hp = 1395, mana = 7350, cap = 2890, ml = 80, defaultSkill = 20 },
    -- Custom (Monks com stats baseados em paladin)
    [9] = { hp = 2605, mana = 3720, cap = 5310, ml = 15, defaultSkill = 100 },
    [10]= { hp = 2605, mana = 3720, cap = 5310, ml = 15, defaultSkill = 100 }
}

-- ─── Helpers ────────────────────────────────────────────────

local function updateWarScore(killerPlayer)
    if not killerPlayer or not killerPlayer:isPlayer() then return end
    local guild = killerPlayer:getGuild()
    if not guild then return end
    local guildId = guild:getId()
    db.asyncQuery(string.format(
        "INSERT INTO `war_scores` (`guild_id`, `frags`, `round_id`) VALUES (%d, 1, 1) "..
        "ON DUPLICATE KEY UPDATE `frags` = `frags` + 1",
        guildId
    ))

    if WarRotation and WarRotation.checkScores then
        WarRotation.checkScores()
    end
end

-- Proteção de spawn removida pois o jogador nasce no Templo (PZ).


local function resetPlayerToArcadeState(player)
    if not player or not player:isPlayer() then return end
    
    -- Ignora GODs
    if player:getGroup():getId() >= 4 then
        return
    end

    local vocId = player:getVocation():getId()
    local targetStats = WAR_STATS[vocId] or WAR_STATS[4] -- Failsafe Knight
    
    -- Ajusta a Experiência e Nível matematicamente
    local currentExp = player:getExperience()
    if currentExp > WAR_EXP then
        player:removeExperience(currentExp - WAR_EXP, false)
    elseif currentExp < WAR_EXP then
        player:addExperience(WAR_EXP - currentExp, false)
    end
    
    -- Ajusta Max HP, Max Mana e Cap instantaneamente
    player:setMaxHealth(targetStats.hp)
    player:setMaxMana(targetStats.mana)
    player:setCapacity(targetStats.cap)
    
    -- Cura completamente
    player:addHealth(player:getMaxHealth())
    player:addMana(player:getMaxMana())
    
    -- Limpa conditions adversas e skulls temporárias
    player:removeCondition(CONDITION_INFIGHT)
    player:removeCondition(CONDITION_FIRE)
    player:removeCondition(CONDITION_ENERGY)
    player:removeCondition(CONDITION_POISON)
    player:removeCondition(CONDITION_FREEZING)
    player:removeCondition(CONDITION_DAZZLED)
    player:removeCondition(CONDITION_CURSED)
    player:removeCondition(CONDITION_PARALYZE)
    player:setSkull(SKULL_NONE)
end

-- ─── Evento: Login do Jogador ────────────────────────────────

local warLogin = CreatureEvent("WarArcadeLogin")
function warLogin.onLogin(player)
    resetPlayerToArcadeState(player)
    
    -- Liberação de todos os Addons do Tibia 8.60
    if player:getStorageValue(88888) ~= 1 then
        for i = 128, 367 do
            player:addOutfitAddon(i, 3)
        end
        player:setStorageValue(88888, 1)
    end
    
    return true
end
warLogin:register()

-- ─── Evento: Preparo para a Morte (Instant Respawn) ──────────

local warDeath = CreatureEvent("WarArcadeDeath")
function warDeath.onPrepareDeath(player, killer)
    if killer and killer:isPlayer() then
        updateWarScore(killer)
        -- Opção de killfeed dinâmico se existir:
        -- broadcastMessage(killer:getName() .. " fragged " .. player:getName(), MESSAGE_STATUS_WARNING)
    end
    
    -- Aplica o reset de guerra instantâneo
    resetPlayerToArcadeState(player)
    
    -- Teleporta o jogador de volta para a sua base (Town do Templo)
    local town = player:getTown()
    if town then
        player:teleportTo(town:getTemplePosition())
    else
        -- Fallback se a town estiver bugada
        player:teleportTo(Position(32369, 32241, 7))
    end
    
    -- Envia um pequeno alerta gráfico ao invés da tela preta de morte
    player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Você foi derrotado e restaurado à base.")
    
    -- Retorna FALSO para cancelar a morte original do Tibia (bloqueia perda de item, skull e you are dead screen)
    return false
end
warDeath:register()
