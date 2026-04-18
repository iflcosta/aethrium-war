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

local function formatNumber(n)
    local s = tostring(math.floor(n))
    return s:reverse():gsub("(%d%d%d)" , "%1."):reverse():gsub("^%.", "")
end

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
    
    -- ─── Configuração de Outfit Inicial por Vocação ───────────
    local vocationId = player:getVocation():getId()
    local isMale = player:getSex() == PLAYERSEX_MALE
    local newLookType = nil

    if vocationId == 4 or vocationId == 8 then -- Knight
        newLookType = isMale and 134 or 142 -- Warrior
    elseif vocationId == 2 or vocationId == 6 then -- Druid
        newLookType = isMale and 133 or 141 -- Summoner
    elseif vocationId == 1 or vocationId == 5 then -- Sorcerer
        newLookType = isMale and 130 or 138 -- Mage
    elseif vocationId == 3 or vocationId == 7 then -- Paladin
        newLookType = isMale and 129 or 137 -- Hunter
    end

    if newLookType then
        local currentOutfit = player:getOutfit()
        currentOutfit.lookType = newLookType
        currentOutfit.lookAddons = 3
        player:setOutfit(currentOutfit)
    end

    -- ─── Registro de Eventos Críticos ──────────────────────────
    player:registerEvent("WarArcadeDeath")
    player:registerEvent("WarKillfeed")

    -- Liberação massiva de Addons para todos os outfits (8.60)
    if player:getStorageValue(88888) ~= 1 then
        for i = 128, 367 do
            player:addOutfitAddon(i, 3)
        end
        player:setStorageValue(88888, 1)
    end
    
    return true
end
warLogin:register()

local function distributePvPExperience(player)
    local victimXp = player:getExperience()
    local xpLossPool = math.floor(victimXp * 0.10) -- 10% da XP total conforme solicitado
    
    local damageMap = player:getDamageMap()
    if not damageMap then return end

    local totalPlayerDamage = 0
    local contributors = {}

    -- 1. Filtrar apenas jogadores e calcular dano total
    for cid, data in pairs(damageMap) do
        local attacker = Creature(cid)
        if attacker and attacker:isPlayer() and attacker:getId() ~= player:getId() then
            totalPlayerDamage = totalPlayerDamage + data.total
            table.insert(contributors, {p = attacker, dmg = data.total})
        end
    end

    if totalPlayerDamage <= 0 then return end

    -- 2. Distribuir XP proporcionalmente
    for _, entry in ipairs(contributors) do
        local share = entry.dmg / totalPlayerDamage
        local reward = math.floor(xpLossPool * share)
        if reward > 0 then
            entry.p:addExperience(reward, true)
            entry.p:sendTextMessage(MESSAGE_EVENT_ADVANCE, 
                string.format("[WAR XP] Você recebeu %s de XP pela participação no abate de %s (%d%% do dano).", 
                formatNumber(reward), player:getName(), math.floor(share * 100)))
        end
    end
end

-- ─── Evento: Preparo para a Morte (Instant Respawn) ──────────

local warDeath = CreatureEvent("WarArcadeDeath")
function warDeath.onPrepareDeath(player, killer)
    -- 1. Identificar o Assassino Real para o Killfeed/Score
    local realKiller = killer
    if not realKiller or not realKiller:isPlayer() then
        -- Fallback para quem deu mais dano caso o killer direto seja monstro/campo
        -- mas para o reset arcade focamos na distribuição global.
    end

    -- 2. Processamento Dinâmico de Kill
    -- [FRAG] Atualiza o placar das Guildas (usa o killer principal)
    if realKiller and realKiller:isPlayer() and realKiller:getId() ~= player:getId() then
        updateWarScore(realKiller)
    end

    -- [XP] Distribuição Proporcional de 10% do XP da vítima
    distributePvPExperience(player)
    
    -- [VISUAL] Dispara o KillFeed
    if WarKillfeed and WarKillfeed.recordKill then
        WarKillfeed.recordKill(player, realKiller)
    end
    
    -- 3. Aplica o reset de guerra instantâneo (Restore HP/Mana/Skills)
    resetPlayerToArcadeState(player)

    
    -- 4. Teleporta o jogador de volta para a sua base (Town do Templo)
    local town = player:getTown()
    local spawnPos = town and town:getTemplePosition() or Position(1024, 633, 7)
    player:teleportTo(spawnPos)
    
    -- 5. Feedback Visual no Vítima
    spawnPos:sendMagicEffect(CONST_ME_TELEPORT)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Você foi derrotado e restaurado à base.")
    
    -- Retorna FALSO para cancelar a morte original do Tibia
    -- Isso evita a tela de "You are Dead", perda de itens e queda de level real.
    return false
end
warDeath:register()
