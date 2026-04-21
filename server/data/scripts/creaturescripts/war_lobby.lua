-- ============================================================
--  Aethrium War — Lobby de Balanceamento
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
    local counts = getTeamCounts()
    local avg    = getTeamAverage(counts)
    return (counts[teamId] or 0) >= avg + WAR_MAX_DIFF
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
        spawnPos:sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[ Vaga aberta! Entrando no campo de batalha. ]")
        if applySpawnProtection then
            applySpawnProtection(player)
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

    -- Se a guilda for 4-7 ou sem guilda, precisamos espelhar para 1-3 via Storage
    if realGuild > 3 or realGuild == 0 then
        local storageTeam = player:getStorageValue(WAR_TEAM_STORAGE)
        if storageTeam and storageTeam >= 1 and storageTeam <= 3 then
            teamId = storageTeam
        else
            -- Escolhe o time de destino (Consolidação)
            if realGuild >= 4 and realGuild <= 7 then
                teamId = ((realGuild - 1) % 3) + 1
            else
                teamId = math.random(1, 3)
            end
            player:setStorageValue(WAR_TEAM_STORAGE, teamId)
        end

        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "[ WAR ] Seu time original (" .. (TEAM_NAMES[realGuild] or "Nenhum") .. ") esta inativo. Voce foi recrutado para: " .. TEAM_NAMES[teamId] .. "!")
        print(">> [STORAGE] Jogador " .. player:getName() .. " movido de G" .. realGuild .. " para G" .. teamId)
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

    if isTeamFull(teamId) then
        enterLobby(player)
    else
        WarLobbyPlayers[cid] = nil
        -- Se estiver no lobby ou logando agora em uma zona de proteção (templo), vai pro campo
        if inLobby or inPZ then
            local spawnPos = WarGetBestSpawnPoint and WarGetBestSpawnPoint(player)
                or Position(WAR_LOBBY_POS.x, WAR_LOBBY_POS.y, WAR_LOBBY_POS.z)
            player:teleportTo(spawnPos)
            spawnPos:sendMagicEffect(CONST_ME_TELEPORT)
            if applySpawnProtection then applySpawnProtection(player) end
        end
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
