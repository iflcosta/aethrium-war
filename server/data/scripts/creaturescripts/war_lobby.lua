-- ============================================================
--  World War — Lobby de Balanceamento
-- ============================================================

WarCurrentTeam  = {}  -- [playerId] = teamId  (runtime; limpo no logout)
WarLobbyPlayers = {}  -- [playerId] = true

-- Coordenadas do lobby (área neutra, sem PvP) — substituir após mapeamento
WAR_LOBBY_POS = { x = 155, y = 433, z = 7 }

local WAR_MAX_DIFF             = 2
local WAR_LOBBY_CHECK_INTERVAL = 5000
local WAR_TEAM_STORAGE         = 45005 -- Storage para o time temporário (1, 2 ou 3)

local TEAM_NAMES = {
    [1] = "Antica",
    [2] = "Nova",
    [3] = "Secura",
    [4] = "Amera",
    [5] = "Calmera",
    [6] = "Hiberna",
    [7] = "Harmonia",
}

-- ─── Contagem de jogadores no campo (exclui lobby e GODs) ────

local function getTeamCounts()
    local counts = {}
    local usedIps = {} -- [teamId] = { [ip] = true }

    for pid, tid in pairs(WarCurrentTeam) do
        if not WarLobbyPlayers[pid] then
            local p = Player(pid)
            if p and p:getGroup():getId() < 4 then
                local ip = p:getIp()
                usedIps[tid] = usedIps[tid] or {}
                
                if not usedIps[tid][ip] then
                    counts[tid] = (counts[tid] or 0) + 1
                    usedIps[tid][ip] = true
                end
            else
                WarCurrentTeam[pid] = nil
            end
        end
    end
    return counts
end

local function getTeamAverage(counts)
    local total, active = 0, 0
    for _, n in pairs(counts) do
        if n > 0 then
            total  = total + n
            active = active + 1
        end
    end
    return active > 0 and (total / active) or 0
end

-- Retorna true se o time teamId estiver cheio (campo, sem lobby players).
-- O player verificado deve já estar em WarLobbyPlayers para não inflar a contagem.
function isTeamFull(teamId)
    -- Balanceador desativado para testes: todas as equipes liberadas.
    return false
end

-- Retorna o time (1, 2 ou 3) com menos jogadores online.
local function getSmallestTeam()
    local counts = getTeamCounts()
    local smallestTeam = 1
    local minPlayers = counts[1] or 0

    for tid = 2, 3 do
        local n = counts[tid] or 0
        if n < minPlayers then
            minPlayers = n
            smallestTeam = tid
        end
    end
    return smallestTeam
end

-- ─── HUD ─────────────────────────────────────────────────────

local function buildLobbyHUD(counts, avg)
    local lines = { "[Times online — campo de batalha]" }
    for tid = 1, 7 do
        local name   = TEAM_NAMES[tid] or ("Time " .. tid)
        local n      = counts[tid] or 0
        local status = (n >= avg + WAR_MAX_DIFF) and "CHEIO" or "DISPONIVEL"
        if n > 0 or (counts[tid] ~= nil) then
            table.insert(lines, string.format("%-10s (%d): %2d players — %s", name, tid, n, status))
        end
    end
    table.insert(lines, "\nAguardando vaga no campo de batalha...")
    return table.concat(lines, "\n")
end

-- ─── Loop de verificação por player no lobby ─────────────────

local function lobbyCheckLoop(cid)
    local player = Player(cid)
    if not player or not WarLobbyPlayers[cid] then return end

    local teamId = WarCurrentTeam[cid]
    if not teamId then
        WarLobbyPlayers[cid] = nil
        return
    end

    local counts = getTeamCounts()
    local avg    = getTeamAverage(counts)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, buildLobbyHUD(counts, avg))

    if (counts[teamId] or 0) < avg + WAR_MAX_DIFF then
        -- Vaga abriu: teleporta para o campo
        WarLobbyPlayers[cid] = nil
        local spawnPos = WarGetBestSpawnPoint and WarGetBestSpawnPoint(player)
            or Position(WAR_LOBBY_POS.x, WAR_LOBBY_POS.y, WAR_LOBBY_POS.z)
        player:teleportTo(spawnPos)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[ Vaga aberta! Entrando no campo de batalha. ]")
        if applySpawnProtection then
            applySpawnProtection(player, spawnPos)
        end
        return
    end

    addEvent(lobbyCheckLoop, WAR_LOBBY_CHECK_INTERVAL, cid)
end

-- ─── API pública ─────────────────────────────────────────────

local function fetchTeamId(player)
    -- Primeiro, verifica se o jogador já tem um time temporário atribuído por Storage
    local storageTeam = player:getStorageValue(WAR_TEAM_STORAGE)
    if storageTeam and storageTeam >= 1 and storageTeam <= 3 then
        return storageTeam
    end

    -- Se não tiver storage, busca a guilda real no banco
    local res = db.storeQuery(string.format(
        "SELECT `guild_id` FROM `guild_membership` WHERE `player_id` = %d LIMIT 1",
        player:getGuid()
    ))
    
    if not res then return nil end
    local guildId = result.getNumber(res, "guild_id")
    result.free(res)
    
    -- Se a guilda for 1, 2 ou 3, ela é o time.
    if guildId >= 1 and guildId <= 3 then
        return guildId
    end
    
    -- Se for guilda 4-7 ou sem guilda, retorna nil para ser processado no login
    return nil
end

function enterLobby(player)
    local cid = player:getId()
    WarLobbyPlayers[cid] = true
    player:teleportTo(Position(WAR_LOBBY_POS.x, WAR_LOBBY_POS.y, WAR_LOBBY_POS.z))
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
        "[ Seu time esta cheio. Aguarde uma vaga no lobby. ]")
    addEvent(lobbyCheckLoop, WAR_LOBBY_CHECK_INTERVAL, cid)
end

-- Chamado no login: popula WarCurrentTeam e decide lobby vs campo.
function checkWarLobbyOnLogin(player)
    if player:getGroup():getId() >= 4 then return end

    local cid    = player:getId()
    local pGuid  = player:getGuid()
    
    -- Busca a guilda atual no DB
    local guildRes = db.storeQuery(string.format("SELECT `guild_id` FROM `guild_membership` WHERE `player_id` = %d LIMIT 1", pGuid))
    local realGuild = 0
    if guildRes then
        realGuild = result.getNumber(guildRes, "guild_id")
        result.free(guildRes)
    end

    local teamId = nil

    -- Se a guilda for 4-7 ou sem guilda, agora todas as 7 equipes são válidas.
    if realGuild == 0 then
        -- Escolhe o time baseado no ID da conta (1/1 -> 1, 2/2 -> 2, etc.)
        local accountId = player:getAccountId()
        teamId = (accountId % 7)
        if teamId == 0 then teamId = 7 end
        
        player:setStorageValue(WAR_TEAM_STORAGE, teamId)

        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "[ TEST MODE ] Voce entrou no time padrão da sua conta: " .. TEAM_NAMES[teamId] .. "!")
        print(">> [ACCOUNT] Jogador " .. player:getName() .. " (Acc: " .. accountId .. ") escalado para G" .. teamId)
    else
        teamId = realGuild
    end

    -- Popula a variável global para outros scripts
    WarCurrentTeam[cid] = teamId
    
    -- FORÇA ATUALIZAÇÃO VISUAL IMEDIATA
    if WarVisuals and WarVisuals.onLogin then
        WarVisuals.onLogin(player)
    end
    WarLobbyPlayers[cid] = true

    local pos      = player:getPosition()
    local inLobby  = (pos.x == WAR_LOBBY_POS.x and pos.y == WAR_LOBBY_POS.y and pos.z == WAR_LOBBY_POS.z)
    local inPZ     = player:getTile():hasFlag(TILESTATE_PROTECTIONZONE)

    -- Lobby desativado para testes: todos vão direto pro campo
    WarLobbyPlayers[cid] = nil
    
    local spawnPos = WarGetBestSpawnPoint and WarGetBestSpawnPoint(player)
        or Position(WAR_LOBBY_POS.x, WAR_LOBBY_POS.y, WAR_LOBBY_POS.z)
        
    player:teleportTo(spawnPos)
    
    if applySpawnProtection then 
        applySpawnProtection(player, spawnPos) 
    end
end

-- Limpa o tracking de runtime ao deslogar
function clearWarTracking(player)
    local cid = player:getId()
    WarCurrentTeam[cid]  = nil
    WarLobbyPlayers[cid] = nil
end

-- ─── Evento de logout (WarArcadeLogout) ──────────────────────

local warLogout = CreatureEvent("WarArcadeLogout")
function warLogout.onLogout(player)
    clearWarTracking(player)
    return true
end
warLogout:type("logout")
warLogout:register()
