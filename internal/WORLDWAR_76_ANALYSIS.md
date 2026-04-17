# 🔍 Análise do YurOTS 7.6 — World War Server

> Documento de referência para o upgrade para TFS 1.8 + OTClient Redemption
> Gerado em 16/04/2026 — baseado no código-fonte original do YurOTS 7.6

---

## 📋 Resumo Executivo

O World War 7.6 é um servidor **PvP-Enforced puro** baseado no **YurOTS** (OpenTibia 7.6) com armazenamento **XML** para contas, personagens e guilds. A mecânica central é um sistema de **times numerados de 1 a 7**, onde cada número de conta representa um time inspirado nos servidores do Tibia Real (Antica, Nova, Secura, etc.), e os jogadores competem entre si em um mapa de guerra.

---

## 🏦 Sistema de Contas — O Coração do War

### Como funciona o 1/1, 2/2... 7/7

O sistema é **deceptivamente simples**: não existe cadastro. São **7 contas fixas pré-criadas** em XML, onde o número digitado pelo jogador é literalmente o nome do arquivo:

| Arquivo | Conta/Senha | Time | Guild |
|---------|-------------|------|-------|
| `accounts/1.xml` | `1` / `1` | Antica | Antica Team |
| `accounts/2.xml` | `2` / `2` | Nova | Nova Team |
| `accounts/3.xml` | `3` / `3` | Secura | Secura Team |
| `accounts/4.xml` | `4` / `4` | Amera | Amera Team |
| `accounts/5.xml` | `5` / `5` | Calmera | Calmera Team |
| `accounts/6.xml` | `6` / `6` | Hiberna | Hiberna Team |
| `accounts/7.xml` | `7` / `7` | Harmonia | Harmonia Team |

**Estrutura do arquivo XML de conta** (`accounts/1.xml`):
```xml
<?xml version="1.0"?>
<account pass="1" type="0" premDays="0" ip="127.0.0.1">
  <characters>
    <character name="Bubble"/>
    <character name="Xanadu"/>
    <character name="Sephirothe"/>
    <!-- ~25-37 personagens por conta/time -->
  </characters>
</account>
```

### Loader — `IOAccountXML::loadAccount(unsigned long accno)`

O loader abre `data/accounts/{accno}.xml` diretamente. O número digitado pelo jogador **é o número do arquivo**. Não há hashing, não há lookup em banco. `accno` === número do time.

> **Insight chave para o TFS 1.8**: O sistema já funciona naturalmente se criarmos contas com `id = 1..7` e `password = sha1('N')`. **Nenhum hook especial no login é necessário**.

---

## 👥 Sistema de Times — Guilds

Os times são implementados via **sistema de Guilds do YurOTS** (`guilds.cpp` + `guilds.xml`). Cada conta corresponde exatamente a uma guild com o mesmo conjunto de personagens.

### 7 Guilds = 7 Times (dados reais)

| Guild | Conta | Chars | Nível Range |
|-------|-------|-------|-------------|
| Antica Team | 1 | 29 | 150–222 |
| Nova Team | 2 | 37 | 143–222 |
| Secura Team | 3 | 19 | 148–185 |
| Amera Team | 4 | 25 | 137–185 |
| Calmera Team | 5 | 25 | 147–185 |
| Hiberna Team | 6 | 25 | 141–185 |
| Harmonia Team | 7 | 25 | 140–185 |

**Total: 235 personagens** | Knight: 102 | Paladin: 58 | Sorcerer: 53 | Druid: 21

### Estrutura da Guild (`guilds.xml`)
```xml
<guild name="Antica Team">
  <member status="3" name="Bubble" rank="Leader" nick=""/>
  <member status="3" name="Xanadu" rank="Member" nick=""/>
  <!-- ... -->
</guild>
```

- **`status="3"`** = GUILD_MEMBER (membro ativo na guerra)
- **`rank`** = "Leader" ou "Member" (visual apenas)
- A guild define quem pode atacar quem (aliados vs inimigos)

---

## 🧑 Estrutura dos Personagens

### Personagens Reais (não templates)

Os 235 personagens **já existem com dados completos** — níveis reais entre **137 e 292**, não apenas os templates de nível 60. A tela de login exibia `Nome (Level Vocação)`:

```
Andinho (163 Paladin)     ← Conta 4, Amera Team
Band (206 Sorcerer)       ← Conta 1, Antica Team
Eternal (292 Knight)      ← Conta 3, Secura Team
```

### Templates de Vocação (conta 9 — admin)
Existem **personagens-template** de nível 60 para cada vocação:
- `Knight.xml`, `Knight1.xml` .. `Knight4.xml`
- `Paladin.xml`, `Paladin1.xml` .. `Paladin4.xml`
- `Sorcerer.xml`, `Sorcerer1.xml` .. `Sorcerer4.xml`
- `Druid.xml`, `Druid1.xml` .. `Druid4.xml`

### Atributos de um Personagem Real (Andinho — Paladin 163)
```xml
<player name="Andinho" account="4" voc="3" level="158"
  exp="63286700" maglevel="25" cap="300">
  <spawn x="1004" y="574" z="6"/>   <!-- posição de respawn -->
  <skills>
    <skill skillid="4" level="100"/> <!-- dist -->
    <skill skillid="5" level="50"/>  <!-- shield -->
  </skills>
  <inventory>
    <!-- Full set + supplies: mpheal, GFBs, avalanches, etc. -->
  </inventory>
</player>
```

---

## 🗺️ Mapas Disponíveis no 7.6

O servidor tem **múltiplos mapas** em `data/world/`:

| Arquivo | Formato | Tamanho | Observação |
|---------|---------|---------|------------|
| `thais.otx` | OTX (XML) | 3.9MB | **Mapa ativo no 7.6** |
| `mapa.otbm` | OTBM | 7.8MB | Mapa global maior (inclui Venore, Edron) |
| `neverland.otbm` | OTBM | 436KB | Mapa alternativo |
| `Dangara.otx` | OTX | 1.1MB | Mapa customizado |

**⚠️ Importante**: Não há rotação de mapa automática no 7.6. A troca era **manual** (restart com config diferente). Isso será **aprimorado** no TFS 1.8 com rotação automática.

---

## ⚙️ Configurações de War (config.lua)

### Mundo PvP Total
```lua
worldtype = "pvp-enforced"  -- kill sem penalidade
redunjust = 1               -- 1 kill = red skull
banunjust = 999999999       -- nunca banido por kills
redtime   = 9999999*60      -- red skull permanente
fragtime  = 9999999*60      -- frags nunca somem
diepercent = {"7","7","7","7","100"}  -- perde 7% XP + backpack inteira
```

### Sistema de XP (anti-grind)
```lua
expmul    = 1   -- XP de monstros normal
expmulpvp = 1   -- XP de kills PvP normal (fórmula: 7% da XP do morto)
```

### Outras Configs
```lua
autosave  = 0   -- saves manuais apenas
kicktime  = 15  -- kick após 15min idle (anti-AFK)
maxplayers = 100
```

---

## 🧮 Sistema de XP por Kill (Source Analisado)

### Fórmula Real (`creature.cpp` + `player.h`)

```cpp
// 1. XP perdida pelo morto
exp_t getLostExperience() {
    return experience * DIE_PERCENT_EXP / 100;  // 7% no war
}

// 2. XP ganha pelo killer (proporcional ao dano)
exp_t getGainedExperience(Creature* attacker) {
    gainexperience = (attackerDamage * lostExperience) / totalDamage;
    return gainexperience * EXP_MUL_PVP;  // EXP_MUL_PVP = 1 no war
}
```

### XP por Kill — Tabela de Referência

| Morto Level | XP Total ~| XP Perdida (7%) | Quem ganha |
|------------:|----------:|----------------:|-----------|
| 140 | ~14M | ~980K | Killer |
| 160 | ~33M | ~2.31M | Killer |
| 180 | ~66M | ~4.62M | Killer |
| 200 | ~107M | ~7.49M | Killer |
| 250 | ~280M | ~19.6M | Killer |
| 292 | ~342M | ~23.9M | Killer |

**Conclusão**: Matar um level 292 dá **~24× mais XP** que matar um level 140 — incentivo orgânico para caçar os tops inimigos!

### Comportamento com Múltiplos Atacantes

Se 3 pessoas matam um level 200 (XP = 7.49M):
- 60% do dano → **4.49M XP**
- 30% do dano → **2.25M XP**
- 10% do dano → **749K XP**

---

## 💬 Comandos do Servidor (7.6)

### Comandos de Jogador (acesso 0)
| Comando | Função |
|---------|--------|
| `!frags` | Ver kills do personagem |
| `!report` | Reportar ao GM |
| `!online` | Ver jogadores online |

### Mensagem de Login (MOTD)
```
"Welcome to World War Server."
"Use 1/1 = Antica  2/2 = Nova  3/3 = Secura"
"    4/4 = Amera   5/5 = Calmera  6/6 = Hiberna  7/7 = Harmonia"
"Use !frags to see how many players you pwned."
"Use !report to report stuff!"
```

---

## 🔧 Stack Técnica do 7.6

| Componente | Tecnologia |
|------------|------------|
| Armazenamento | XML puro (sem banco de dados) |
| Contas | `IOAccountXML` — `data/accounts/{N}.xml` |
| Personagens | `IOPlayerXML` — `data/players/{nome}.xml` |
| Times | Sistema de Guilds (`guilds.xml`) |
| Mapa | OTX (XML) ou OTBM |
| Protocolo | OpenTibia 7.6 |
| OS do servidor | Windows (YurOTS.exe) |

---

## 🚀 Mapeamento 7.6 → TFS 1.8

### O que REPLICAR (mesma lógica, tecnologia nova)

| Mecânica 7.6 | Implementação TFS 1.8 |
|---|---|
| `accounts/N.xml` (conta fixa) | `accounts` table: `id=N`, `password=sha1('N')` |
| `players/{nome}.xml` | Tabela `players` com `account_id` 1-7 |
| `guilds.xml` (times) | Tabelas `guilds` + `guild_membership` |
| Spawn fixo por char | Campos `posx/posy/posz` na tabela `players` |
| `!frags` command | Lua talkaction + tabela `war_scores` |

### O que ADICIONAR (melhorias sobre o 7.6)

1. **Rotação de Mapas** — GlobalEvent Lua com rotação Thais → Venore → Edron
2. **Scoreboard por time** — tabela `war_scores` + Extended Opcodes via OTClient Redemption
3. **Death broadcast** — `onDeath` Lua event global
4. **Spawn protection** — imunidade de 5s após respawn
5. **Anti multi-IP por time** — máximo 1 char do mesmo time por IP
6. **Docker** — deploy em 1 comando no Linux
7. **Reset automático** — evento periódico que restaura HP/mana/items

### Fluxo de Login 1/1 no TFS 1.8
```
Jogador digita: account=1, senha=1
       ↓
TFS 1.8: IOLoginData::loadAccount(1)
       ↓
MySQL retorna: conta id=1, personagens do Time Antica
       ↓
Cliente exibe: lista com "Andinho (163 Paladin)", "Band (206 Sorcerer)"...
```

---

## 📊 Assets do Projeto para Migrar

### Personagens
- **235 chars** nos XMLs do 7.6 — converter via `tools/xml_to_sql.py`
- Cada char: nome, level, voc, exp, hp, mana, skills, inventory, spawn_pos
- Mapeamento de ItemID 7.6 → 8.6 necessário para itens do inventário

### Mapas
- Thais: `thais.otx` (3.9MB) → converter para OTBM TFS 1.8
- Venore + Edron: recortar do `mapa.otbm` (7.8MB)
- Atenção ao **ClientID System** do TFS 1.8 — items podem ter IDs diferentes

---

*Análise completa gerada por Antigravity em 16/04/2026*
*Baseada no código-fonte do YurOTS 7.6 (worldwar/) e nos 235 arquivos XML de personagens*
