-- ============================================================
--  Aethrium War — Sistema de Spawn Dinâmico (CS2 Deathmatch)
--  Três arenas no mapa aethrium-war.otbm: Thais, Venore, Edron
-- ============================================================

WAR_CURRENT_MAP = 1  -- índice da arena ativa; atualizado pela rotação

-- Spawn points por arena e por zona de população.
-- center: sempre ativo
-- mid:    ativo com >= 6 players online
-- edge:   ativo com >= 12 players online
-- TODO: substituir offsets placeholder pelas coordenadas reais após mapeamento
WAR_MAPS = {
    [1] = {
        name = "Thais",
        center = {
            { x = 1024, y = 633, z = 7 },
            { x = 1030, y = 633, z = 7 },
            { x = 1018, y = 633, z = 7 },
            { x = 1024, y = 639, z = 7 },
            { x = 1024, y = 627, z = 7 },
            { x = 1030, y = 639, z = 7 },
        },
        mid = {
            { x = 1038, y = 633, z = 7 },
            { x = 1010, y = 633, z = 7 },
            { x = 1024, y = 645, z = 7 },
            { x = 1024, y = 621, z = 7 },
        },
        edge = {
            { x = 1048, y = 633, z = 7 },
            { x = 1000, y = 633, z = 7 },
            { x = 1024, y = 653, z = 7 },
            { x = 1024, y = 613, z = 7 },
        },
    },
    [2] = {
        name = "Venore",
        center = {
            { x = 1063, y = 607, z = 7 },
            { x = 1069, y = 607, z = 7 },
            { x = 1057, y = 607, z = 7 },
            { x = 1063, y = 613, z = 7 },
            { x = 1063, y = 601, z = 7 },
            { x = 1069, y = 613, z = 7 },
        },
        mid = {
            { x = 1077, y = 607, z = 7 },
            { x = 1049, y = 607, z = 7 },
            { x = 1063, y = 619, z = 7 },
            { x = 1063, y = 595, z = 7 },
        },
        edge = {
            { x = 1087, y = 607, z = 7 },
            { x = 1039, y = 607, z = 7 },
            { x = 1063, y = 629, z = 7 },
            { x = 1063, y = 585, z = 7 },
        },
    },
    [3] = {
        name = "Edron",
        center = {
            { x = 1004, y = 574, z = 6 },
            { x = 1010, y = 574, z = 6 },
            { x =  998, y = 574, z = 6 },
            { x = 1004, y = 580, z = 6 },
            { x = 1004, y = 568, z = 6 },
            { x = 1010, y = 580, z = 6 },
        },
        mid = {
            { x = 1018, y = 574, z = 6 },
            { x =  990, y = 574, z = 6 },
            { x = 1004, y = 586, z = 6 },
            { x = 1004, y = 562, z = 6 },
        },
        edge = {
            { x = 1028, y = 574, z = 6 },
            { x =  980, y = 574, z = 6 },
            { x = 1004, y = 596, z = 6 },
            { x = 1004, y = 552, z = 6 },
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
    if WarCurrentTeam and WarCurrentTeam[player:getId()] then
        return WarCurrentTeam[player:getId()]
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
            local t = WarCurrentTeam and WarCurrentTeam[creature:getId()]
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
    local teamId = getPlayerTeamId(player)
    local points = getActiveSpawnPoints()

    if #points == 0 then
        local town = player:getTown()
        return town and town:getTemplePosition() or Position(1024, 633, 7)
    end

    local bestPos      = nil
    local bestScore    = nil
    local leastPenPos  = nil
    local leastPenalty = math.huge

    for _, pos in ipairs(points) do
        local score, penalty = scoreSpawnPoint(pos, teamId)
        if bestScore == nil or score > bestScore then
            bestScore = score
            bestPos   = pos
        end
        if penalty < leastPenalty then
            leastPenalty = penalty
            leastPenPos  = pos
        end
    end

    local chosen = (bestScore ~= nil and bestScore < 0) and leastPenPos or bestPos
    return Position(chosen.x, chosen.y, chosen.z)
end
