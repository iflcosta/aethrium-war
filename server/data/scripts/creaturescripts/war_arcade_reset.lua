-- ============================================================
--  Aethrium War — Motor de Reset Arcade (v3 — Snapshot Mode)
--  Arquivo: server/data/scripts/creaturescripts/war_arcade_reset.lua
-- ============================================================

local WAR_BROADCAST_KILLS   = true
local WAR_RESPAWN_DELAY_MS  = 1500   -- ms após morte para restaurar
local WAR_SPAWN_PROTECT_MS  = 5000   -- ms de proteção após spawn

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

local function applySpawnProtection(player)
    local condition = Condition(CONDITION_PROTECTION)
    condition:setTicks(WAR_SPAWN_PROTECT_MS)
    player:addCondition(condition)
end

-- ─── Snapshot Sync (A Fonte da Verdade) ──────────────────────

local RESET_TO_SNAPSHOT_QUERY = [[
    UPDATE `players` p
    INNER JOIN `players_snapshot` ps ON p.`id` = ps.`id`
    SET p.`level`           = ps.`level`,
        p.`experience`      = ps.`experience`,
        p.`health`          = ps.`healthmax`,
        p.`healthmax`       = ps.`healthmax`,
        p.`mana`            = ps.`manamax`,
        p.`manamax`         = ps.`manamax`,
        p.`maglevel`        = ps.`maglevel`,
        p.`skill_fist`      = ps.`skill_fist`,
        p.`skill_club`      = ps.`skill_club`,
        p.`skill_sword`     = ps.`skill_sword`,
        p.`skill_axe`       = ps.`skill_axe`,
        p.`skill_dist`      = ps.`skill_dist`,
        p.`skill_shielding` = ps.`skill_shielding`,
        p.`skill_fishing`   = ps.`skill_fishing`,
        p.`skull`           = 0,
        p.`skulltime`       = 0,
        p.`conditions`      = NULL
    WHERE p.`id` = %d
]]

local function resetPlayerToSnapshot(player)
    if not player or not player:isPlayer() then return end
    
    -- Ignora GODs e personagens sem snapshot
    if player:getGroup():getId() >= 4 then
        return
    end

    local guid = player:getGuid()
    
    -- 1. Executa o reset no banco para persistência
    db.query(string.format(RESET_TO_SNAPSHOT_QUERY, guid))
    
    -- 2. Busca os valores exatos para aplicar via Lua (atualização instantânea da UI)
    local resultId = db.storeQuery(string.format("SELECT `experience`, `maglevel`, `healthmax`, `manamax` FROM `players_snapshot` WHERE `id` = %d", guid))
    if resultId ~= false then
        -- Uso seguro da API de resultados (global result ou objeto resultId)
        local targetExp = (type(result) == "table" and result.getNumber) and result.getNumber(resultId, "experience") or 0
        local targetHealth = (type(result) == "table" and result.getNumber) and result.getNumber(resultId, "healthmax") or 100
        local targetMana = (type(result) == "table" and result.getNumber) and result.getNumber(resultId, "manamax") or 100
        
        if type(result) == "table" and result.free then
            result.free(resultId)
        end

        -- Ajusta a experiência (substancial para mudar o Level na UI)
        local currentExp = player:getExperience()
        if targetExp > 0 and currentExp ~= targetExp then
            player:addExperience(targetExp - currentExp, false)
        end
        
        -- Garante vida e mana cheias
        player:addHealth(targetHealth - player:getHealth())
        player:addMana(targetMana - player:getMana())
        
        -- Remove sinal de batalha residual
        player:removeCondition(CONDITION_INFIGHT)
    end
end

-- ─── Evento: Login do Jogador (Reset Arcade) ─────────────────

local warLogin = CreatureEvent("WarArcadeLogin")
function warLogin.onLogin(player)
    -- Ao logar, força o Snapshot (Herói volta ao estado perfeito de guerra)
    resetPlayerToSnapshot(player)
    return true
end
warLogin:register()

-- ─── Evento: Morte do Jogador (Registro de Frag) ─────────────

local warDeath = CreatureEvent("WarArcadeDeath")
function warDeath.onDeath(player, corpse, killer)
    if killer and killer:isPlayer() then
        updateWarScore(killer)
    end
    -- O reset NÃO acontece aqui. Acontecerá quando o jogador deslogar e logar novamente.
    return true
end
warDeath:register()
