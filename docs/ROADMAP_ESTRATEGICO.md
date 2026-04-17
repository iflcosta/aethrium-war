# 🗺️ AETHRIUM WAR: ROADMAP E ESCOPO TÉCNICO

> **Documento Diretor de Arquitetura e Escopo**
> Definição oficial das Fases de Lançamento (MVP vs. Fase 2 vs. Fase 3)
> *Atualizado conforme alinhamento estratégico da diretoria técnica.*

---

## 🎯 1. Visão Geral do Produto
O **Aethrium War** é um servidor de guerra que une a nostalgia dos combates em times clássicos (Antica, Nova, Secura) com uma arquitetura moderna e jogabilidade baseada em habilidade pura (Arcade).

* **Motor:** TFS 1.8 (Protocolo 8.6) + OTClient Redemption.
* **Combate:** Dinâmica fluida do 8.6 (com hotkeys), porém restrito aos itens, runas e magias da era clássica.
* **Pool de Heróis:** 235 personagens reais extraídos dos servidores 7.6 originais, com níveis variando de 137 a 292.

---

## 🚀 2. Escopo do MVP (Minimum Viable Product)
*Foco exclusivo em velocidade de entrega, jogabilidade pura e estabilidade do servidor. O que precisamos para o "Dia 1".*

### 2.1. Motor de Reset Arcade (Obrigatório)
* A progressão foi abolida para evitar o efeito "snowball".
* Ao morrer ou deslogar, um script Lua (`onDeath` / `onLogout`) restaura o personagem para o estado exato do banco de dados (XP, Nível, Skills e Inventário resetados).
* Ninguém perde itens permanentemente; a guerra é contínua e justa.

### 2.2. Login Clássico
* Utilização da estrutura nativa do TFS para ganho de velocidade.
* Sem criação de contas: as contas de `1` a `7` estão fixadas no SQL com senhas de `1` a `7`.
* O jogador digita `1/1` e o servidor retorna a lista de personagens do time Antica.

### 2.3. Identidade Visual Enforced (Servidor)
* Resolução do caos visual em batalhas massivas através do script `onOutfit`.
* O jogador pode escolher qualquer outfit, mas o servidor força e trava a paleta de cores para o espectro oficial da Guild (ex: Time Nova = apenas tons de azul; Antica = tons de vermelho).

### 2.4. Rotação de Mapas por Pontuação (E-Sport Feel)
* O MVP rodará com 3 mapas (Thais, Venore, Edron).
* A rotação não é por tempo, mas por **Frags**. O primeiro time a atingir a meta de kills (ex: 100 frags) vence o round.
* O servidor anuncia o time vencedor, reseta a arena e rotaciona para o próximo mapa automaticamente.

---

## 🔮 3. Escopo da Fase 2 (Retenção e Escala)
*Foco em inovação, meta-jogo, engajamento a longo prazo e melhorias de Quality of Life (QoL).*

### 3.1. O Novo Fluxo de Login (War Dashboard)
* O OTClient Redemption passa a atuar como o Launcher oficial.
* Antes do login, a interface consome uma API leve em tempo real mostrando: Status dos times, frags do round atual e top levels online.
* Gatilho de decisão: o jogador escolhe em qual time vai entrar baseado na situação da guerra naquele momento.

### 3.2. Contas Pessoais e Metajogo (Sistema de Heróis)
* Transição do login raiz para o estilo "Hero Shooter" (MOBA).
* O jogador cria uma conta global permanente.
* No lobby do cliente, ele seleciona um Time e "assume o controle" de um dos personagens clássicos disponíveis no pool (via *Session Token*).
* Ao fazer frags na arena, a pontuação é atrelada à sua Conta Pessoal, criando um **Ranking Global Definitivo** no site/Discord, mesmo que o personagem ingame seja resetado.

### 3.3. IA de Balanceamento (Agentes "Fillers")
* Sistema autônomo para injetar bots nos times que estiverem em desvantagem numérica.
* O nível dos bots é definido matematicamente pela média de level dos humanos daquele time.
* **Proteção de Ídolos:** Os bots utilizarão apenas os personagens genéricos (`is_core_char = 0`), nunca ocupando as lendas do servidor (Bubble, Eternal, etc.), deixando-os livres para os jogadores reais.

### 3.4. Shaders de Combate (Cliente)
* Implementação visual nativa no OTClient.
* Aplicação de *Outlines* (contornos) ou auras brilhantes no sprite dos personagens de acordo com a cor do time, destacando aliados e inimigos sem depender apenas do outfit.

---

## 💰 4. Escopo da Fase 3 (Monetização e Meta-Features 14+)
*Foco na sustentabilidade financeira do projeto através de cosméticos e recursos premium, garantindo competitividade justa (Zero Pay-to-Win).*

**Diferencial Técnico:** O TFS 1.8 utilizado possui *downgrade* para protocolo 8.6, mas retém o backend completo das versões 14+ (suporte nativo a Montarias, Asas, Auras, Shaders e In-Game Store). A monetização será feita inteiramente via interface *in-game*, sem necessidade de saídas para um site externo.

### 4.1. VIP Basic (Tier de Entrada)
* **Montarias e Outfits Tier 1:** Acesso a montarias terrestres imponentes e outfits de versões posteriores que combinem com a temática.
* **Paleta de Cores Premium:** Desbloqueia variações vibrantes (Metálicas/Neon) dentro do espectro travado.
* **Badges de Chat:** Ícone exclusivo nos canais públicos.

### 4.2. VIP Pro (Tier de Elite)
* **Montarias e Outfits Tier 2 (Animados):** Acesso a montarias lendárias e roupas com animação.
* **Killfeed Destacado:** Eliminações aparecem com ícone de caveira especial.
* **Efeitos Mágicos (Spawn/Death):** Efeito cosmético (ex: pilar de luz) disparado no respawn ou morte.

### 4.3. The Store (Loja Avulsa In-Game)
* **Wings & Auras:** Venda de Asas e auras de combate que respeitam o esquema de cor da Guild.
* **Títulos de Guerra (Titles):** Títulos customizados acima do nome.
* **Skins de Magias:** Alterações puramente visuais (ex: Suddden Death com caveira 3D).
* **Coleções Sazonais:** Pacotes limitados.

---
*Gerado e aprovado pela Diretoria Técnica (CTO).*
