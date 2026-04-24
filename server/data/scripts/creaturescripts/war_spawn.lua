-- ============================================================
--  World War — Sistema de Spawn Dinâmico (CS2 Deathmatch)
--  Três arenas no mapa world-war.otbm: Thais, Venore, Edron
-- ============================================================

WAR_CURRENT_MAP = 1  -- índice da arena ativa; atualizado pela rotação
WAR_DEBUG_FIXED_SPAWN = false  -- true = spawn fixo no primeiro ponto (para testes)

-- Spawn points por arena e por zona de população.
-- center: sempre ativo
-- mid:    ativo com >= 6 players online
-- edge:   ativo com >= 12 players online
-- TODO: substituir offsets placeholder pelas coordenadas reais após mapeamento
WAR_MAPS = {
    [1] = {
        name = "Thais",
        center = {
            { x = 173, y = 221, z = 7 },
            { x = 190, y = 212, z = 7 },
            { x = 153, y = 212, z = 7 },
            { x = 174, y = 192, z = 7 },
            { x = 216, y = 213, z = 7 },
            { x = 133, y = 214, z = 7 },
            { x = 142, y = 236, z = 7 },
            { x = 230, y = 199, z = 7 },
        },
        mid = {
            { x = 229, y = 242, z = 7 },
            { x = 229, y = 258, z = 7 },
            { x = 207, y = 252, z = 7 },
            { x = 185, y = 249, z = 7 },
            { x = 156, y = 249, z = 7 },
            { x = 128, y = 246, z = 7 },
        },
        edge = {
            { x = 172, y = 187, z = 7 },
            { x = 200, y = 180, z = 7 },
            { x = 230, y = 179, z = 7 },
            { x = 173, y = 177, z = 7 },
            { x = 193, y = 230, z = 7 },
        },
    },
    [2] = {
        name = "Venore",
        center = {
            { x = 613, y = 157, z = 6 },
            { x = 615, y = 143, z = 6 },
            { x = 614, y = 175, z = 6 },
            { x = 595, y = 158, z = 6 },
            { x = 623, y = 189, z = 6 },
        },
        mid = {
            { x = 658, y = 159, z = 6 },
            { x = 580, y = 141, z = 6 },
            { x = 592, y = 139, z = 6 },
            { x = 595, y = 182, z = 6 },
            { x = 597, y = 208, z = 6 },
        },
        edge = {
            { x = 597, y = 219, z = 6 },
            { x = 559, y = 215, z = 6 },
            { x = 534, y = 212, z = 6 },
            { x = 558, y = 126, z = 6 },
            { x = 668, y = 125, z = 6 },
            { x = 614, y = 212, z = 6 },
        },
    },
    [3] = {
        name = "Edron",
        center = {
            { x = 1064, y = 260, z = 7 },
            { x = 1048, y = 249, z = 7 },
            { x = 1043, y = 283, z = 7 },
            { x = 1031, y = 293, z = 7 },
            { x = 1060, y = 305, z = 7 },
        },
        mid = {
            { x = 1080, y = 306, z = 7 },
            { x = 1086, y = 284, z = 7 },
            { x = 1099, y = 296, z = 7 },
            { x = 1087, y = 337, z = 7 },
            { x = 1093, y = 263, z = 7 },
        },
        edge = {
            { x = 1110, y = 247, z = 7 },
            { x = 1131, y = 238, z = 7 },
            { x = 1145, y = 214, z = 7 },
            { x = 1179, y = 227, z = 7 },
            { x = 1144, y = 192, z = 7 },
        },
    },
}

local POP_MID_THRESHOLD  = 6
local POP_EDGE_THRESHOLD = 12
local SPAWN_RADIUS       = 15

local function getActiveSpawnPoints()
    local map = WAR_MAPS[WAR_CURRENT_MAP]
    if not map then map = WAR_MAPS[1] end

    local online = Game.getPlayerCount()
    local points = {}

    for _, pos in ipairs(map.center) do
        table.insert(points, pos)
    end
    if online >= POP_MID_THRESHOLD and map.mid then
        for _, pos in ipairs(map.mid) do
            table.insert(points, pos)
        end
    end
    if online >= POP_EDGE_THRESHOLD and map.edge then
        for _, pos in ipairs(map.edge) do
            table.insert(points, pos)
        end
    end
    return points
end

local function getPlayerTeamId(player)
    local cid = player:getId()
    if WarCurrentTeam and WarCurrentTeam[cid] then
        return WarCurrentTeam[cid]
    end
    
    local storageTeam = player:getStorageValue(45005) -- WAR_TEAM_STORAGE
    if storageTeam and storageTeam >= 1 and storageTeam <= 7 then
        return storageTeam
    end

    local res = db.storeQuery(string.format(
        "SELECT `guild_id` FROM `guild_membership` WHERE `player_id` = %d LIMIT 1",
        player:getGuid()
    ))
    if not res then return nil end
    local guildId = result.getNumber(res, "guild_id")
    result.free(res)
    return guildId > 0 and guildId or nil
end

local function scoreSpawnPoint(pos, playerTeamId)
    local enemies = 0
    local allies  = 0
    local spectators = Game.getSpectators(
        Position(pos.x, pos.y, pos.z), false, true,
        SPAWN_RADIUS, SPAWN_RADIUS, SPAWN_RADIUS, SPAWN_RADIUS
    )
    for _, creature in ipairs(spectators) do
        if creature:isPlayer() then
            local t = getPlayerTeamId(creature)
            if t then
                if t == playerTeamId then allies = allies + 1
                else enemies = enemies + 1
                end
            end
        end
    end
    local bonus = 0
    if allies >= 2 then bonus = 3
    elseif allies == 1 then bonus = 1
    end
    return (enemies * -2) + allies + bonus, enemies
end

-- Retorna a melhor Position de spawn para o player dado.
function WarGetBestSpawnPoint(player)
    if WAR_DEBUG_FIXED_SPAWN then
        local map = WAR_MAPS[WAR_CURRENT_MAP]
        if map and map.center and map.center[1] then
            return Position(map.center[1].x, map.center[1].y, map.center[1].z)
        end
    end
    local teamId = getPlayerTeamId(player)
    local points = getActiveSpawnPoints()

    if #points == 0 then
        local town = player:getTown()
        return town and town:getTemplePosition() or Position(173, 221, 7)
    end

    local bestScore    = nil
    local leastPenalty = math.huge
    local bestCandidates = {}
    local leastPenPos    = nil

    for _, pos in ipairs(points) do
        local score, penalty = scoreSpawnPoint(pos, teamId)
        if bestScore == nil or score > bestScore then
            bestScore    = score
            bestCandidates = { pos }
        elseif score == bestScore then
            table.insert(bestCandidates, pos)
        end
        if penalty < leastPenalty then
            leastPenalty = penalty
            leastPenPos  = pos
        end
    end

    -- Empates quebrados aleatoriamente
    local bestPos = bestCandidates[math.random(#bestCandidates)]

    local chosen = (bestScore ~= nil and bestScore < 0) and leastPenPos or bestPos
    
    -- Adiciona um pequeno offset aleatório para não nascerem exatamente no mesmo sqm
    local finalPos = Position(chosen.x, chosen.y, chosen.z)
    finalPos.x = finalPos.x + math.random(-1, 1)
    finalPos.y = finalPos.y + math.random(-1, 1)
    
    return finalPos
end
