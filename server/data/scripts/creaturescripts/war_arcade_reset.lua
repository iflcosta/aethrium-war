-- ============================================================
--  Aethrium War — Motor de Reset Arcade (V4 — Dynamic 250)
--  Arquivo: data/scripts/creaturescripts/war_arcade_reset.lua
-- ============================================================

local WAR_BROADCAST_KILLS   = true
local WAR_SPAWN_PROTECT_MS  = 5000   -- ms de proteção após spawn

local WAR_LEVEL = 250
local L = WAR_LEVEL - 1
local WAR_EXP = math.floor((50 * (L * L * L) - 150 * (L * L) + 400 * L) / 3)

local WAR_XP      = 100000000
local WAR_STREAK  = 45202

local WAR_STATS = {
    -- Knight (Level 1-250: 3850 HP, 1245 Mana, 6520 Cap)
    [4] = { hp = 3850, mana = 1245, cap = 6520, ml = 10, defaultSkill = 120 },
    [8] = { hp = 3850, mana = 1245, cap = 6520, ml = 10, defaultSkill = 120 },
    -- Paladin (Level 1-250: 2640 HP, 3665 Mana, 5310 Cap)
    [3] = { hp = 2640, mana = 3665, cap = 5310, ml = 30, defaultSkill = 120 },
    [7] = { hp = 2640, mana = 3665, cap = 5310, ml = 30, defaultSkill = 120 },
    -- Mages (Level 1-250: 1430 HP, 7295 Mana, 2890 Cap)
    [1] = { hp = 1430, mana = 7295, cap = 2890, ml = 120, defaultSkill = 30 },
    [5] = { hp = 1430, mana = 7295, cap = 2890, ml = 120, defaultSkill = 30 },
    [2] = { hp = 1430, mana = 7295, cap = 2890, ml = 120, defaultSkill = 30 },
    [6] = { hp = 1430, mana = 7295, cap = 2890, ml = 120, defaultSkill = 30 },
    -- Monks (HP/Mana Paladin, Cap Knight)
    [9] = { hp = 2640, mana = 3665, cap = 6520, ml = 20, defaultSkill = 120 },
    [10]= { hp = 2640, mana = 3665, cap = 6520, ml = 20, defaultSkill = 120 }
}

-- ─── Helpers ────────────────────────────────────────────────

local function formatNumber(n)
    local s = tostring(math.floor(n))
    return s:reverse():gsub("(%d%d%d)" , "%1."):reverse():gsub("^%.", "")
end

local function getKillerTeamId(killerPlayer)
    if WarCurrentTeam and WarCurrentTeam[killerPlayer:getId()] then
        return WarCurrentTeam[killerPlayer:getId()]
    end
    local res = db.storeQuery(string.format(
        "SELECT `guild_id` FROM `guild_membership` WHERE `player_id` = %d LIMIT 1",
        killerPlayer:getGuid()
    ))
    if not res then return nil end
    local guildId = result.getNumber(res, "guild_id")
    result.free(res)
    return guildId > 0 and guildId or nil
end

local function updateWarScore(killerPlayer)
    if not killerPlayer or not killerPlayer:isPlayer() then return end
    local guildId = getKillerTeamId(killerPlayer)
    if not guildId then return end
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


function resetPlayerToArcadeState(player)
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
    -- setCapacity() usa gramas internamente (oz * 100), por isso multiplicamos por 100
    player:setMaxHealth(targetStats.hp)
    player:setMaxMana(targetStats.mana)
    player:setCapacity(targetStats.cap * 100)
    
    -- Cura completamente
    player:addHealth(player:getMaxHealth())
    player:addMana(player:getMaxMana())
    
    -- Reseta skills de combate para o valor base da vocação
    local baseSkill = targetStats.defaultSkill
    local combatSkills = { SKILL_SWORD, SKILL_AXE, SKILL_CLUB, SKILL_DISTANCE, SKILL_SHIELD }
    for _, sk in ipairs(combatSkills) do
        local diff = baseSkill - player:getSkillLevel(sk)
        if diff ~= 0 then player:addSkillLevel(sk, diff) end
    end
    local mlDiff = targetStats.ml - player:getMagicLevel()
    if mlDiff ~= 0 then player:addMagicLevel(mlDiff) end

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
    player:addSoul(200 - player:getSoul())

    -- Zera tokens e bônus comprados (perdidos na morte)
    if resetTokensOnDeath then
        resetTokensOnDeath(player)
    end

    -- Restaura o equipamento de guerra
    if restoreWarItems then
        restoreWarItems(player)
    end
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
    player:registerEvent("WarSpawnProtectDamage")
    player:registerEvent("WarManaChange")
    player:registerEvent("WarMomentumMelee")

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
        -- Anti-Farm: Bloqueio por IP parm
        if realKiller:getIp() == player:getIp() then
            realKiller:sendTextMessage(MESSAGE_STATUS_SMALL, "[ Anti-Farm ] Abates no mesmo IP nao geram recompensas.")
            player:setStorageValue(WAR_STREAK, 0)
            return
        end
        
        updateWarScore(realKiller)
    end

    -- [TOKENS] Killer ganha 1 token; assistências ganham 1 fração (2 = 1 token)
    if addTokens and realKiller and realKiller:isPlayer() and realKiller:getId() ~= player:getId() then
        addTokens(realKiller, 1)
    end

    -- [MVP] Tracking de kills por player durante o round (em memória, reseta na rotação)
    if realKiller and realKiller:isPlayer() and realKiller:getId() ~= player:getId() then
        WarPlayerKills = WarPlayerKills or {}
        local kid = realKiller:getId()
        if not WarPlayerKills[kid] then
            local teamId = WarCurrentTeam and WarCurrentTeam[kid]
            WarPlayerKills[kid] = { name = realKiller:getName(), teamId = teamId, kills = 0 }
        end
        WarPlayerKills[kid].kills = WarPlayerKills[kid].kills + 1

        -- [KILLSTREAK] Anúncios Globais
        local streak = math.max(0, realKiller:getStorageValue(WAR_STREAK)) + 1
        realKiller:setStorageValue(WAR_STREAK, streak)
        
        if streak == 3 then
            Game.broadcastMessage(string.format("[KILLSTREAK] %s is on a Killing Spree! (3 abates)", realKiller:getName()), MESSAGE_STATUS_WARNING)
        elseif streak == 5 then
            Game.broadcastMessage(string.format("[KILLSTREAK] %s is on a Rampage! (5 abates)", realKiller:getName()), MESSAGE_STATUS_WARNING)
        elseif streak == 10 then
            Game.broadcastMessage(string.format("[KILLSTREAK] %s is GODLIKE! (10 abates)", realKiller:getName()), MESSAGE_STATUS_WARNING)
        end
    end
    
    -- [SHUT DOWN] Recompensa por encerrar sequência inimiga
    local victimStreak = math.max(0, player:getStorageValue(WAR_STREAK))
    if realKiller and realKiller:isPlayer() and victimStreak >= 5 then
        local bonus = 3
        if addTokens then addTokens(realKiller, bonus) end
        Game.broadcastMessage(string.format("SHUT DOWN! %s encerrou a sequencia de %d kills de %s! Recompensa: +%d tokens.", realKiller:getName(), victimStreak, player:getName(), bonus), MESSAGE_STATUS_WARNING)
    end
    
    -- Reseta streak da vítima
    player:setStorageValue(WAR_STREAK, 0)
    if addTokenFraction then
        local killerId = realKiller and realKiller:getId() or 0
        local damageMap = player:getDamageMap()
        if damageMap then
            for cid, _ in pairs(damageMap) do
                if cid ~= player:getId() and cid ~= killerId then
                    local assistant = Creature(cid)
                    if assistant and assistant:isPlayer() then
                        addTokenFraction(assistant)
                    end
                end
            end
        end
    end

    -- [XP] Distribuição Proporcional de 10% do XP da vítima
    distributePvPExperience(player)
    
    -- [VISUAL] Dispara o KillFeed
    if WarKillfeed and WarKillfeed.recordKill then
        WarKillfeed.recordKill(player, realKiller)
    end
    
    -- 3. Aplica o reset de guerra instantâneo (Restore HP/Mana/Skills)
    resetPlayerToArcadeState(player)

    -- Proteção imediata: evita dano durante os 2s de espera antes do teleporte
    if WarSpawnProtection then
        WarSpawnProtection[player:getId()] = true
    end

    -- 4. Respawn dinâmico com 2s de delay (estilo CS2 Deathmatch)
    local pid = player:getId()
    addEvent(function(cid)
        local p = Player(cid)
        if not p then return end
        local spawnPos
        if WarGetBestSpawnPoint then
            spawnPos = WarGetBestSpawnPoint(p)
        else
            local town = p:getTown()
            spawnPos = town and town:getTemplePosition() or Position(1024, 633, 7)
        end
        p:teleportTo(spawnPos)
        spawnPos:sendMagicEffect(CONST_ME_TELEPORT)
        p:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Você foi derrotado e voltou ao campo.")
        if applySpawnProtection then
            applySpawnProtection(p)
        end
    end, 2000, pid)
    
    -- Retorna FALSO para cancelar a morte original do Tibia
    -- Isso evita a tela de "You are Dead", perda de itens e queda de level real.
    return false
end
warDeath:register()
