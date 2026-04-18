# Projeto: Sistema de Balanceamento Dinâmico de Times (Aethrium War)

## 1. Visão Geral
O objetivo deste sistema é manter a intensidade do PvP estável em servidores de War com baixa população. Em vez de permitir que os jogadores se espalhem por 7 times vazios, o sistema os concentrará em 2 times ativos durante períodos de baixa online, liberando novos slots de times progressivamente conforme a população do servidor aumenta.

---

## 2. Requisitos Técnicos
- **Motor**: TFS 1.8 (Downgrade 8.60).
- **Linguagem**: Lua (RevScripts).
- **Escopo**: O sistema deve ser **Transitório** (Ephemeral). Alterações no time (Guild) não devem ser salvas no banco de dados para preservar a conta original do jogador.
- **Integração Visual**: Deve sincronizar com o `WarOutfitEnforcer` para garantir que as cores do jogador mudem instantaneamente ao serem movidos de time.

---

## 3. Lógica de Escalonamento (Thresholds)
A quantidade de times disponíveis deve ser calculada dinamicamente no login:

| Jogadores Online | Times Disponíveis | IDs dos Times Ativos |
| :--- | :--- | :--- |
| 1 - 14 | 2 Times | 1, 2 |
| 15 - 24 | 3 Times | 1, 2, 3 |
| 25 - 34 | 4 Times | 1, 2, 3, 4 |
| 35 - 44 | 5 Times | 1, 2, 3, 4, 5 |
| 45 - 54 | 6 Times | 1, 2, 3, 4, 5, 6 |
| 55+ | Todos (7) | Todos |

---

## 4. Algoritmo de Alocação
Ao detectar que um jogador logou em um time que está atualmente "Trancado" pelo sistema:

1.  **Cálculo da Alocação**: O sistema identifica qual dos times ativos tem o menor número de jogadores online no exato momento.
2.  **Troca de Ponteiro**: Utiliza `player:setGuild(Guild(targetID))` para mover o jogador apenas na memória do servidor.
3.  **Balanceamento**: Em caso de empate, a alocação deve ser feita de forma aleatória entre os times com menor população para evitar sobrecarga em um lado.
4.  **Exceção**: Jogadores com Group ID >= 4 (GODs/CMs) são ignorados pelo sistema para permitir testes e monitoramento.

---

## 5. Fluxo de Implementação (Passo a Passo)

### Passo 1: Script de Gerenciamento (`war_team_manager.lua`)
Criar o script em `data/scripts/creaturescripts/custom/war_team_manager.lua`.
- Deve conter a lógica de checagem de online e alocação.
- Deve ser registrado como evento do tipo `"login"`.

### Passo 2: Registro Global (`player_login_logout.lua`)
- Adicionar `player:registerEvent("WarTeamManager")` no topo do hook de login.
- **Importante**: Este registro deve ocorrer antes do `WarVisualManager` para que o carregamento visual já use o time corrigido.

### Passo 3: Sincronização de Outfits
- Garantir que `WarOutfitEnforcer.onLogin` force o `player:getOutfit()` após a mudança do time.
- Utilizar um `addEvent` curto (ex: 200ms) para disparar a atualização visual e evitar conflitos de protocolo no login.

---

## 6. Considerações de Segurança
- **Não persistência**: O script **NUNCA** deve chamar métodos que salvem a `guild_membership` no banco de dados (ex: `IOGuild`).
- **Resiliência**: Se uma guild ID ativa falhar no carregamento, o sistema deve cair para o "Default" (Time 1 ou 2) para evitar que o player fique sem time.

---
**Autor do Plano:** Antigravity AI
**Responsável pela Implementação:** Claude AI 
**Data:** 18 de Abril de 2026
