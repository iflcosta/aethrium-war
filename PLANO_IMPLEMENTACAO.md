# 🏰 Aethrium War Server — Plano de Implementação Completo

> **Projeto**: Upgrade do World War 7.6 (YurOTS) → TFS 1.8 + OTClient Redemption (protocolo 8.6)
> **Repositório**: `github.com/iflcosta/aethrium-war` (público)
> **Servidor**: Linux (Ubuntu/Debian) com Docker
> **Metodologia**: Entrega faseada — aprovação obrigatória entre cada fase

---

## 🔖 Visão Geral das 10 Fases

| # | Fase | Foco | Status |
|---|------|------|--------|
| 1 | 📦 Repositório & Estrutura | GitHub, README, estrutura | ⏳ Próxima |
| 2 | 🗄️ Banco de Dados | Contas 1/1..7/7, Guilds/Times | ⬜ |
| 3 | 👥 Personagens | 235 chars XML → SQL | ⬜ |
| 4 | ⚙️ Config & Core War | TFS 1.8 + Motor Arcade | ⬜ |
| 5 | 🗺️ Mapas | Rotação por Pontuação (MVP) | ⬜ |
| 6 | ⚔️ War Scripts Lua | Reset, Outfit Color Lock | ⬜ |
| 7 | 🔌 Protocolo Redemption | isMehah + Extended Opcodes | ⬜ |
| 8 | 📊 Scoreboard & HUD | Interface visual no cliente | ⬜ |
| 9 | 🛡️ Anti-Cheat & Regras | Proteções de war | ⬜ |
| 10 | 🚀 Deploy & Docs | Linux, Docker, v1.0.0 | ⬜ |

---

## 🧮 Análise do Sistema de XP por Kill — Base 7.6

> Esta análise é fundamental para o design do sistema de progressão do Aethrium War.

### Fórmula Real (extraída do source YurOTS — `creature.cpp`)

```cpp
// Passo 1: Calcular XP que o morto "perde" ao morrer
exp_t getLostExperience() {
    return experience * DIE_PERCENT_EXP / 100;
    // No World War 7.6: DIE_PERCENT_EXP = 7 (perde 7% da XP)
}

// Passo 2: Distribuir entre quem atacou (proporcional ao dano feito)
exp_t getGainedExperience(attacker) {
    gainexperience = attackerDamage * lostExperience / totalDamage;
    return gainexperience * EXP_MUL_PVP; // EXP_MUL_PVP = 1 no 7.6
}
```

### 🔀 Pilares do MVP (Strategic Alignment)

> Itens obrigatórios para o lançamento inicial conforme o Roadmap Estratégico.

1.  **Motor de Reset Arcade**: Progressão abolida. Morte/Logout = Reset total para os stats iniciais do BD (HP, Mana, XP, Skills, Inventário).
2.  **Identidade Visual Forçada**: Script `onOutfit` trava a paleta de cores do time (Antica = Vermelho, Nova = Azul, etc.), resolvendo o caos visual em batalhas massivas.
3.  **Rotação por Pontuação (MVP)**: O round termina quando um time atinge X frags (ex: 100). O servidor anuncia o vencedor, reseta scores e rotaciona o mapa.

---

## 📦 Fase 1 — Repositório & Estrutura Base

**Objetivo**: Criar o repositório público no GitHub com estrutura profissional, README que apresente o projeto à comunidade e documentação estratégica.

### Entregáveis
- [ ] Repositório `github.com/iflcosta/aethrium-war` criado (público)
- [ ] `README.md` com pitch do projeto e roadmap
- [ ] `docs/ROADMAP_ESTRATEGICO.md` — Visão CTO do projeto
- [ ] Estrutura de pastas completa (`server/`, `client/`, `database/`, etc.)
- [ ] GitHub Issues para as fases seguintes

---

## 🗄️ Fase 2 — Banco de Dados (Contas e Times)

**Objetivo**: MySQL do TFS 1.8 com as 7 contas de times (1/1 a 7/7), guilds e suporte ao sistema de scores.

### Entregáveis
- [ ] `database/schema.sql` — Schema TFS 1.8
- [ ] `database/seed/01_accounts.sql` — 7 contas (ID 1-7, Senha N)
- [ ] `database/seed/02_guilds.sql` — 7 guilds oficiais
- [ ] Tabela `war_scores` para registro de frags do round

---

## 👥 Fase 3 — Personagens (Seed dos 7 Times)

**Objetivo**: Migração dos 235 personagens reais do XML para SQL.

### Entregáveis
- [ ] `tools/xml_to_sql.py` — Script de conversão
- [ ] `database/seed/03_players_all.sql` — INSERTs dos jogadores
- [ ] Verificação: Login mostra a lista de heróis com nível e vocação original

---

## ⚙️ Fase 4 — Config & Core War (Motor Arcade)

**Objetivo**: Configurar o TFS 1.8 para operar em modo PvP-Enforced com a lógica de reset instantâneo.

### Entregáveis
- [ ] `server/config.lua` — PvP Enforced (rateExp=1, rateSkill=999)
- [ ] Lógica de Reset Arcade: Scripts Lua integrados ao `onDeath` e `onLogout` para restaurar stats do BD.
- [ ] `server/data/XML/vocations.xml` e `spells.xml` adaptados para war clássico.

---

## 🗺️ Fase 5 — Mapas e Rotação por Pontuação

**Objetivo**: Thais, Venore e Edron adaptados com sistema de vitória por frags.

### Entregáveis
- [ ] Mapas OTBM com zonas de safe/war definidas
- [ ] `server/data/scripts/globalevents/map_rotation.lua` — Lógica "Primeiro a atingir X frags vence"

---

## ⚔️ Fase 6 — War Scripts (Visual & Gameplay)

**Objetivo**: Implementar scripts de identidade visual e regras de combate.

### Entregáveis
- [ ] `onOutfit` lock: Forçar cores da guild no personagem
- [ ] Broadcast de frags e gerenciamento de score in-game

---

## 🚀 Próximas Fases (Resumo)
- **Fase 7-8**: Integração Cliente (OTClient Redemption) e HUD Visual (Scoreboard, Killfeed)
- **Fase 9**: Anti-Cheat e Proteções de War
- **Fase 10**: Deploy em Linux via Docker

---

## 🔄 Fluxo de Aprovação
Cada fase concluída requer um **Pull Request** e aprovação manual do usuário.

---
*Atualizado em 16/04/2026 para alinhar com o Roadmap Estratégico Arcade MVP.*
