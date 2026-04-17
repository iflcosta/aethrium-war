# 🏰 Aethrium War Server — Plano de Implementação em 10 Fases

> **Projeto**: Upgrade do World War 7.6 (YurOTS) → TFS 1.8 + OTClient Redemption (protocolo 8.6)
> **Repositório**: `github.com/iflcosta/aethrium-war` (público)
> **Servidor**: Linux (Ubuntu/Debian) com Docker
> **Metodologia**: Entrega faseada — aprovação entre cada fase antes de avançar

---

## 🔖 Visão Geral

| # | Fase | Foco | Status |
|---|------|------|--------|
| 1 | 📦 Repositório & Estrutura | GitHub, README, estrutura de pastas | ⏳ Próxima |
| 2 | 🗄️ Banco de Dados | Contas 1/1..7/7, Guilds/Times, war_scores | ⬜ |
| 3 | 👥 Personagens | 235 chars XML → SQL, níveis reais | ⬜ |
| 4 | ⚙️ Config & Boot | TFS 1.8 em modo War, Linux | ⬜ |
| 5 | 🗺️ Mapas | Thais + Venore + Edron com rotação | ⬜ |
| 6 | ⚔️ War Core Lua | Frags, Score, XP, Reset, Comandos | ⬜ |
| 7 | 🔌 Protocolo | isMehah + Extended Opcodes Redemption | ⬜ |
| 8 | 📊 Scoreboard & HUD | Interface visual no OTClient | ⬜ |
| 9 | 🛡️ Anti-Cheat | Anti-trap, spawn prot, multi-conta | ⬜ |
| 10 | 🚀 Deploy | Linux Docker, v1.0.0, docs finais | ⬜ |

---

## 🧮 Sistema de XP por Kill (Análise do Source 7.6)

### Fórmula Real (extraída de `creature.cpp` + `player.h`)

```
XP_ganha = (dano_killer / dano_total) × (XP_morto × 7%) × EXP_MUL_PVP
```

### Tabela de Referência

| Level do Morto | XP Total ~ | XP Perdida (7%) | Incentivo |
|---------------:|----------:|----------------:|-----------|
| 140 | 14M | 980K | — |
| 160 | 33M | 2.31M | 2.4× |
| 180 | 66M | 4.62M | 4.7× |
| 200 | 107M | 7.49M | 7.6× |
| 250 | 280M | 19.6M | 20× |
| 292 | 342M | 23.9M | **24.4×** |

> Matar o top do time inimigo vale 24× mais XP que matar o mais fraco — incentivo orgânico perfeito para war.

### Decisão Adotada: Opção D

- **XP real**: fórmula 7.6 intacta (7% da XP do morto vai para o killer)
- **Score de war separado**: tabela `war_scores` por guild/round define o vencedor
- **Sem perda de equipment**: só perde XP ao morrer

---

## 📦 Fase 1 — Repositório & Estrutura Base

**Objetivo**: Criar o repositório público no GitHub com estrutura profissional e README que apresente o projeto à comunidade.

### Entregáveis
- [ ] Repositório `github.com/iflcosta/aethrium-war` criado (público)
- [ ] `README.md` com pitch do projeto, screenshot do 7.6, roadmap das 10 fases
- [ ] `.gitignore` para C++, Lua, binários pesados
- [ ] Estrutura de pastas criada com README em cada diretório
- [ ] `docs/` com: TECHNICAL_SPEC, WORLDWAR_ANALYSIS, XP_SYSTEM, SETUP_GUIDE, HOSTING_GUIDE, WAR_RULES
- [ ] GitHub Issues para Fases 2–10 com Labels e Milestones
- [ ] GitHub Discussions ativado para a comunidade

### Estrutura do Repositório
```
aethrium-war/
├── README.md
├── PLANO_IMPLEMENTACAO.md
├── WORLDWAR_76_ANALYSIS.md
├── TECHNICAL_SPEC_WAR_PROJECT.md
├── docs/
├── server/              ← TFS 1.8 adaptado para war
├── client/              ← OTClient Redemption + módulos war
├── database/
│   ├── schema.sql
│   └── seed/
│       ├── 01_accounts.sql
│       ├── 02_guilds.sql
│       └── 03_players_all.sql
├── maps/
│   ├── thais/
│   ├── venore/
│   └── edron/
├── tools/
│   ├── xml_to_sql.py
│   └── list_players.py
└── docker/
    ├── docker-compose.yml
    └── Dockerfile.server
```

### Critério de Aceitação
> ✅ Repositório público, README apresenta o projeto, Issues abertas, Discussions ativo.

---

## 🗄️ Fase 2 — Banco de Dados (Contas e Times)

**Objetivo**: MySQL do TFS 1.8 com as 7 contas de times, guilds e infraestrutura de war score.

### Entregáveis
- [ ] `database/schema.sql` — schema TFS 1.8 completo
- [ ] `database/seed/01_accounts.sql` — 7 contas (`id=N`, `password=sha1('N')`)
- [ ] `database/seed/02_guilds.sql` — 7 guilds + memberships
- [ ] Tabela extra `war_scores` (guild_id, round, kills, deaths, score)
- [ ] `database/reset_war.sql` — script de reset entre rounds

### SQL Principal
```sql
-- 7 contas fixas
INSERT INTO accounts (id, name, password, type, premdays) VALUES
(1,'1',SHA1('1'),0,65535), (2,'2',SHA1('2'),0,65535),
(3,'3',SHA1('3'),0,65535), (4,'4',SHA1('4'),0,65535),
(5,'5',SHA1('5'),0,65535), (6,'6',SHA1('6'),0,65535),
(7,'7',SHA1('7'),0,65535);

-- 7 guilds (times)
INSERT INTO guilds (id, name, ownerid) VALUES
(1,'Antica Team',1),(2,'Nova Team',2),(3,'Secura Team',3),
(4,'Amera Team',4),(5,'Calmera Team',5),
(6,'Hiberna Team',6),(7,'Harmonia Team',7);

-- Score de war
CREATE TABLE war_scores (
  guild_id INT, round INT DEFAULT 1,
  kills INT DEFAULT 0, deaths INT DEFAULT 0,
  PRIMARY KEY (guild_id, round)
);
```

### Critério de Aceitação
> ✅ Login `1/1` retorna Time Antica. Login `7/7` retorna Harmonia. Tabela `war_scores` existe.

---

## 👥 Fase 3 — Personagens (235 chars do 7.6)

**Objetivo**: Converter os 235 personagens XML → SQL preservando níveis, vocações, skills e inventários.

### Inventário Real

| Time | Conta | Chars | Nível Range |
|------|-------|-------|-------------|
| Antica Team | 1 | 29 | 150–222 |
| Nova Team | 2 | 37 | 143–222 |
| Secura Team | 3 | 19 | 148–185 |
| Amera Team | 4 | 25 | 137–185 |
| Calmera Team | 5 | 25 | 147–185 |
| Hiberna Team | 6 | 25 | 141–185 |
| Harmonia Team | 7 | 25 | 140–185 |

**Total**: Knight: 102 | Paladin: 58 | Sorcerer: 53 | Druid: 21

### Entregáveis
- [ ] `tools/xml_to_sql.py` — conversor automático XML 7.6 → SQL TFS 1.8
- [ ] `database/seed/03_players_all.sql` — 235 INSERTs
- [ ] `database/seed/04_player_items.sql` — inventários (ItemID 7.6 → 8.6)
- [ ] Tela de login exibe `Andinho (163 Paladin)` igual ao screenshot original

### Critério de Aceitação
> ✅ Login `1/1` exibe lista com nível e vocação idêntica ao screenshot. Stats e inventário corretos ao entrar.

---

## ⚙️ Fase 4 — Config & Boot TFS 1.8

**Objetivo**: TFS 1.8 operando em modo war puro no Linux.

### Entregáveis
- [ ] `server/config.lua` — PvP enforced, sem grind, sem PvE
- [ ] `server/data/XML/vocations.xml` — 4 vocações, sem promote
- [ ] `server/data/XML/spells.xml` — apenas spells de war
- [ ] Servidor inicia sem erros no Linux
- [ ] `docs/SETUP_GUIDE.md` — guia de instalação Linux

### Configs Chave
```lua
worldType        = "pvp-enforced"
rateExperience   = 1      -- XP real (fórmula 7.6)
rateSkill        = 999    -- skills instantâneas no war
rateMagic        = 999    -- ML instantâneo
rateLoot         = 0      -- sem loot
deathLostPercent = 7      -- 7% XP ao morrer (killer ganha)
killsToRedSkull  = 1      -- 1 kill = red skull
```

### Critério de Aceitação
> ✅ TFS 1.8 inicia no Linux sem erros, PvP enforced, vocações e spells corretas.

---

## 🗺️ Fase 5 — Os 3 Mapas de Guerra

**Objetivo**: Thais, Venore e Edron adaptados ao TFS 1.8 com zonas de war e rotação automática.

### Os 3 Mapas

| # | Cidade | Estilo de PvP |
|---|--------|---------------|
| 🏰 **Thais** | Nostalgia máxima — hub central, depot como arena, ruas amplas |
| 🏙️ **Venore** | Labiríntico — Magic Walls táticas, paras em corredores, quem conhece o mapa domina |
| 🏯 **Edron** | Estratégico — castelo vertical, múltiplos andares, kiting e sieges |

### Zonas em Cada Mapa
```
Temple Zone (PZ)    ← Respawn de cada time
Transition Zone      ← Sem PZ, sem logout
Battleground         ← Campo de batalha
Depot Arena          ← Hot spot ao redor do depot
No-Logout Zone       ← Toda área fora dos temples
```

### Entregáveis
- [ ] `maps/thais/thais_war.otbm`
- [ ] `maps/venore/venore_war.otbm`
- [ ] `maps/edron/edron_war.otbm`
- [ ] Spawn points dos 7 times em cada mapa
- [ ] `server/data/scripts/globalevents/map_rotation.lua`
- [ ] Screenshots anotados dos 3 mapas

### Critério de Aceitação
> ✅ 3 mapas carregam, items corretos, PZ funciona, `/nextmap` rota sem erros.

---

## ⚔️ Fase 6 — War Core Lua

**Objetivo**: Scripts que dão vida à guerra — frags, XP, score, respawn, comandos.

### Entregáveis
- [ ] `server/data/scripts/creaturescripts/war_death.lua`
  - Broadcast: `[WAR FRAG] Bubble (Antica) eliminated Naraku (Nova)!`
  - Atualiza `war_scores`
  - Teleporta morto ao temple após 3s
- [ ] `server/data/scripts/creaturescripts/war_login.lua`
  - Spawn no temple do time ao logar
- [ ] `server/data/scripts/globalevents/war_reset.lua`
  - Reset periódico de HP/mana/items
- [ ] `server/data/scripts/talkactions/war_commands.lua`
  - `!frags` — kills/deaths pessoais
  - `!score` — placar dos 7 times
  - `!top` — top 5 killers do round
  - `!team` — membros online do time
  - `!nextmap` (GM) — rotação de mapa
  - `!resetwar` (GM) — reset do round

### Exemplo
```lua
function onDeath(player, corpse, killer, ...)
    -- Broadcast global do frag
    local msg = string.format("[WAR FRAG] %s (%s) eliminated %s (%s)!",
        killer:getName(), killer:getGuild():getName(),
        player:getName(), player:getGuild():getName())
    Game.broadcastMessage(msg, MESSAGE_EVENT_ADVANCE)
    -- Atualiza score no banco
    -- Teleporta morto ao temple após 3s
end
```

### Critério de Aceitação
> ✅ Frags anunciados, score atualiza, `!score`/`!frags` funcionam, respawn no temple correto.

---

## 🔌 Fase 7 — Protocolo (Integração Redemption)

**Objetivo**: TFS 1.8 detecta o OTClient Redemption e habilita Extended Opcodes para dados de war em tempo real.

### Entregáveis
- [ ] `server/src/protocolgame.cpp` — flag `isMehah` pelo OperatingSystem no handshake
- [ ] `server/src/protocolgame.h` — campo `bool isOTCRedemption`
- [ ] Extended Opcodes 0x32 configurados para score/killfeed
- [ ] `server/data/scripts/globalevents/extendedopcodes.lua`
- [ ] `client/modules/game_war/` — módulo Lua no cliente
- [ ] `docs/COMPILE_GUIDE.md` — compilação Linux (CMake + GCC)

### Opcodes de War
| Opcode | Direção | Dados |
|--------|---------|-------|
| `0x01` | Server→Client | Score (kills por guild) |
| `0x02` | Server→Client | Kill feed |
| `0x03` | Server→Client | Mapa atual |
| `0x04` | Client→Server | Request score |

### Critério de Aceitação
> ✅ Redemption detectado no log, Extended Opcodes funcionam, clientes 8.6 vanilla ainda conectam.

---

## 📊 Fase 8 — Scoreboard & Interface War

**Objetivo**: HUD visual de war no OTClient — scoreboard, kill feed, mini-placar permanente.

### Entregáveis
- [ ] `client/modules/game_war/game_war.otmod`
- [ ] `client/modules/game_war/warscoreboard.otui` + `.lua`
- [ ] `client/modules/game_war/killfeed.lua`
- [ ] `client/modules/game_war/warhud.lua`
- [ ] Screenshots da interface

### Interface
```
┌─────────────────────────────────────────┐
│  🏆 AETHRIUM WAR — Round 3 · Edron      │
├─────────────────────────────────────────┤
│  🔴 Antica Team    ████████   87 kills  │
│  🔵 Nova Team      ███████    71 kills  │
│  🟡 Secura Team    ██████     63 kills  │
│  🟢 Amera Team     █████      51 kills  │
│  🟣 Calmera Team   ████       44 kills  │
│  🟠 Hiberna Team   ████       42 kills  │
│  ⚪ Harmonia Team  ███        38 kills  │
└─────────────────────────────────────────┘
[Kill Feed]  Bubble → Naraku  (Antica vs Nova)  3s
```

### Critério de Aceitação
> ✅ Scoreboard via `/war`, atualiza em tempo real, kill feed por frag, HUD permanente visível.

---

## 🛡️ Fase 9 — Anti-Cheat & Regras

**Objetivo**: Proteções clássicas de war para garantir experiência justa.

### Entregáveis
- [ ] **No-logout zone**: battleground marcado no mapa
- [ ] **Spawn protection**: imunidade 5s após respawn (perde ao atacar)
- [ ] **Anti-teamkill**: bloqueio de ataque entre membros da mesma guild
- [ ] **Anti multi-IP**: max 1 char do mesmo time por IP simultaneamente
- [ ] **Anti-AFK**: idle >15min → teleporte para temple
- [ ] Scripts: `anti_afk.lua`, `spawn_protection.lua`, `anti_multiip.lua`
- [ ] `docs/WAR_RULES.md` — regras oficiais publicadas

### Critério de Aceitação
> ✅ Spawn protection ativa, multi-conta bloqueado, anti-AFK funciona.

---

## 🚀 Fase 10 — Deploy & Documentação Final

**Objetivo**: Qualquer voluntário da comunidade consegue hospedar em Linux com Docker.

### Stack de Deploy
```
Ubuntu 22.04 LTS
├── MySQL 8.0
├── TFS 1.8 (binário Linux x64)
├── OTClient Redemption (Windows/Linux)
└── Docker Compose
```

### Instalação em 1 Comando
```bash
git clone https://github.com/iflcosta/aethrium-war.git
cd aethrium-war
docker compose up -d
# Servidor online em :7171
```

### Entregáveis
- [ ] `docker/docker-compose.yml` — MySQL + TFS + volumes
- [ ] `docker/Dockerfile.server` — compila TFS 1.8 no Ubuntu 22.04
- [ ] `docker/init.sql` — schema + seed automáticos
- [ ] `docs/INSTALL.md` — guia manual Linux (sem Docker)
- [ ] `docs/HOSTING_GUIDE.md` — guia para hosts da comunidade
- [ ] `docs/TROUBLESHOOTING.md` — problemas comuns
- [ ] GitHub Actions CI — build automático
- [ ] Release `v1.0.0` com CHANGELOG

### Critério de Aceitação
> ✅ `docker compose up -d` sobe tudo em < 5 minutos. Host sem experiência hospeda seguindo o guia. Release v1.0.0 taggeada.

---

## 📌 Decisões Técnicas Confirmadas

| Item | Decisão |
|------|---------|
| GitHub | `github.com/iflcosta/aethrium-war` |
| Nome | **Aethrium War** |
| Engine | TFS 1.8 (pvpe-1.8) |
| Cliente | OTClient Redemption 4.0 (protocolo 8.6) |
| Hospedagem | **Linux** (Ubuntu/Debian) + Docker |
| Mapas | Thais (nostalgia) + Venore (tático) + Edron (estratégico) |
| Personagens | **235 chars** XML 7.6 → SQL (níveis originais 137–292) |
| XP por kill | Fórmula 7.6 — 7% da XP do morto vai para o killer |
| Score de war | Tabela `war_scores` separada por guild/round |
| Respawn | Teleporte automático para temple do time após 3s |
| Perda ao morrer | Só 7% de XP — sem perda de equipment |

## 🔄 Fluxo de Aprovação

```
[Implementação] → [Commit branch] → [Pull Request] → [Review] → [✅ Aprovação] → [Próxima fase]
```

---
*Gerado por Antigravity em 16/04/2026*
*Baseado na análise completa do source YurOTS 7.6 e TFS 1.8*
