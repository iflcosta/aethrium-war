# Design de Sistema: Dynamic War Dynamics & Balancing
**Projeto**: Aethrium War (Arcade Mode)  
**Autor**: Antigravity Plan  
**Status**: Aprovado para Implementação

---

## 1. Visão Geral

O objetivo é garantir PvP constante e intenso independentemente do número de jogadores online. O sistema cobre três pilares:

1. **Balanceamento de times** via lobby de espera
2. **Respawn dinâmico** estilo CS2 Deathmatch
3. **Spawn protection** contra spawn kill

---

## 2. Afiliação de Times

- O time permanente do player é definido pela **`guild_membership`** no MySQL — nunca muda entre sessões
- Em runtime, o time atual é rastreado por uma **variável Lua global em memória**:

```lua
WarCurrentTeam = {}  -- [playerId] = teamId
-- Login:    WarCurrentTeam[player:getId()] = teamIdDaGuild
-- Logout:   WarCurrentTeam[player:getId()] = nil
-- Transfer: WarCurrentTeam[player:getId()] = novoTeamId
```

- Transfers temporários (`!joinlow` ou auto-balance) existem apenas durante a sessão — no próximo restart todos voltam ao time original da guild
- `!joinlow` e bot de IA como substituto de players: **feature futura**

---

## 3. Lobby de Espera

### Conceito
Quando o time de um player está acima do limite permitido, ele entra num **lobby único neutro** (sem PvP, sem guild visível) em vez de ser bloqueado no login.

### Regra de Balanceamento
- Calcula a **média de jogadores** entre os times que têm ao menos 1 player online (times com 0 players são ignorados)
- Um time está **cheio** se tiver `média + 2` ou mais jogadores
- Exemplo com 4 times ativos (8, 8, 8, 5): média = 7.25 → limite = 9.25 → times com 8 estão **liberados**, nenhum está cheio

### Fluxo
1. Player loga → sistema verifica se o time dele está cheio
2. **Cheio** → teleporta para o lobby, ativa HUD informativo
3. **Disponível** → segue login normal, teleporta para spawn point no campo
4. A cada **5 segundos**, o sistema verifica se abriu vaga para players no lobby
5. Quando vaga abrir → teleporta automaticamente para spawn point

### Relog no Lobby
Se o player deslogar enquanto estiver no lobby, na próxima vez que logar o sistema detecta a posição do lobby e reexecuta a verificação de balanceamento — sem ficar preso.

### HUD no Lobby
Mensagem atualizada a cada 5 segundos mostrando o estado dos times:

```
[Times online]
Antica  (1):  8 players — CHEIO
Nova    (2):  8 players — CHEIO
Secura  (3):  5 players — DISPONÍVEL
Amera   (4):  5 players — DISPONÍVEL
...
```

---

## 4. Sistema de Respawn (Estilo CS2 Deathmatch)

### Pontos de Spawn
Lista de coordenadas pré-definidas divididas em zonas, desbloqueadas conforme a população online:

```lua
SPAWN_POINTS = {
    center = { ... },  -- sempre ativos
    mid    = { ... },  -- desbloqueados com população média
    edge   = { ... },  -- desbloqueados com servidor cheio
}
```

- Qualquer time pode nascer em qualquer ponto — sem segmentação por time
- As zonas ativas são determinadas pelo total de players online no momento

### Seleção Inteligente de Ponto
Cada ponto disponível recebe um **score**:

```
score = (inimigos em 15sqm) * -2
      + (aliados  em 15sqm) * +1
      + bonus_aliados
```

Onde `bonus_aliados`:
- **+3** se houver 2 ou mais aliados no raio
- **+1** se houver 1 aliado
- **0** se não houver aliados

O player nasce no ponto com **maior score**. Em caso de todos os pontos com score negativo (mapa muito congestionado), escolhe o ponto com **menor penalidade**.

### Fluxo na Morte
1. Player morre → `WarArcadeDeath` dispara
2. **2 segundos de delay** (efeito visual / tela)
3. Sistema calcula scores e seleciona o melhor ponto ativo
4. Teleporta o player
5. **5 segundos de spawn protection** ativam automaticamente

---

## 5. Spawn Protection

- **Duração**: 5 segundos de invulnerabilidade total
- **Efeito visual**: magic effect periódico piscando (transparência não é suportada no cliente 8.60)
- **Quebra imediata** se o player:
  - Mover (dar o primeiro passo)
  - Atacar um inimigo
  - Lançar qualquer spell

---

## 6. Guia Técnico de Implementação

### Arquivos a criar/modificar

| Arquivo | Responsabilidade |
|---|---|
| `player_login_logout.lua` | Checar balanceamento no login, atualizar `WarCurrentTeam` |
| `war_arcade_reset.lua` | Substituir teleporte fixo pelo sistema de spawn dinâmico, adicionar timer de 2s |
| `war_lobby.lua` (novo) | Lógica do lobby: HUD, verificação periódica, teleporte automático |
| `war_spawn.lua` (novo) | Lista de spawn points, cálculo de score, seleção de ponto |
| `war_spawn_protection.lua` (novo) | Condição de invulnerabilidade, efeito visual, quebra por ação |

### Variáveis Globais Necessárias

```lua
WarCurrentTeam    = {}   -- [playerId] = teamId (runtime)
WarLobbyPlayers   = {}   -- [playerId] = true (quem está no lobby)
WAR_LOBBY_POS     = {x=..., y=..., z=...}  -- coordenadas do lobby (a definir)
WAR_MAX_DIFF      = 2    -- diferença máxima tolerada em relação à média
WAR_LOBBY_CHECK_INTERVAL = 5000  -- ms entre verificações de vaga
WAR_RESPAWN_DELAY        = 2000  -- ms de delay antes do respawn
WAR_SPAWN_PROTECT_MS     = 5000  -- ms de spawn protection
```

### Pendências antes de implementar
- [ ] Coordenadas do lobby (a mapear)
- [ ] Lista de spawn points por zona (center / mid / edge) a mapear no `aethrium-war`

---

## 7. Roadmap

| Feature | Prioridade |
|---|---|
| Sistema de spawn dinâmico + score | Alta |
| Spawn protection 5s | Alta |
| Lobby + HUD + balanceamento | Alta |
| `!joinlow` voluntário | Futura |
| Bot IA de balanceamento (substituto de player) | Futura |
