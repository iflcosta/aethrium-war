-- ============================================================
--  Aethrium War — Sistema de Spawn Dinâmico (CS2 Deathmatch)
-- ============================================================

-- Zonas de spawn por população — coordenadas a definir após mapeamento do mapa
-- center: sempre ativo
-- mid:    ativo com >= 6 players online
-- edge:   ativo com >= 12 players online
WAR_SPAWN_ZONES = {
    center = {
        { x = 1000, y = 1000, z = 7 },  -- TODO: substituir pelas coordenadas reais do mapa
        { x = 1005, y = 1000, z = 7 },
        { x = 1000, y = 1005, z = 7 },
        { x = 1005, y = 1005, z = 7 },
        { x = 1002, y = 1002, z = 7 },
        { x = 1003, y = 998,  z = 7 },
    },
    mid = {
        { x = 990,  y = 990,  z = 7 },
        { x = 1015, y = 990,  z = 7 },
        { x = 990,  y = 1015, z = 7 },
        { x = 1015, y = 1015, z = 7 },
    },
    edge = {
        { x = 975,  y = 975,  z = 7 },
        { x = 1025, y = 975,  z = 7 },
        { x = 975,  y = 1025, z = 7 },
        { x = 1025, y = 1025, z = 7 },
    },
}

local POP_MID_THRESHOLD  = 6
local POP_EDGE_THRESHOLD = 12
local SPAWN_RADIUS       = 15

local function getActiveSpawnPoints()
    local online = Game.getPlayerCount()
    local points = {}
    for _, pos in ipairs(WAR_SPAWN_ZONES.center) do
        table.insert(points, pos)
    end
    if online >= POP_MID_THRESHOLD then
        for _, pos in ipairs(WAR_SPAWN_ZONES.mid) do
            table.insert(points, pos)
        end
    end
    if online >= POP_EDGE_THRESHOLD then
        for _, pos in ipairs(WAR_SPAWN_ZONES.edge) do
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
                if t == playerTeamId then
                    allies = allies + 1
                else
                    enemies = enemies + 1
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

    -- Se todos os pontos têm score negativo, escolhe o de menor penalidade
    local chosen = (bestScore ~= nil and bestScore < 0) and leastPenPos or bestPos
    return Position(chosen.x, chosen.y, chosen.z)
end
