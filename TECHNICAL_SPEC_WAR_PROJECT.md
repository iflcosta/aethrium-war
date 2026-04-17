# Especificação Técnica: Projeto 8.6 World War (Redemption Edition)

## 🎯 Objetivo do Projeto
Desenvolver um servidor de Guerra (War) de alta performance na versão 8.6, utilizando a engine moderna **TFS 1.8** e o **OTClient Redemption**. O foco é replicar a experiência clássica dos servidores "World War" 7.6 (onde o login era feito por times 1/1, 2/2, etc.) com a estabilidade e os recursos visuais de um cliente moderno.
Pastas>
Servidor TFS 1.8: pvpe-1.8
OTClient Redemption: otclient-4.0
Servidor 7.6: worldwar

---

## 🏗️ Arquitetura de Comunicação (The "Glue")

Para que o TFS 1.8 e o OTClient Redemption se comuniquem perfeitamente na versão 8.6, os seguintes ajustes técnicos são mandatórios:

### 1. Detecção e Identificação do Cliente
O servidor deve reconhecer o cliente Redemption para habilitar recursos estendidos sem quebrar o protocolo 8.6 básico.
- **Implementação**: No `protocolgame.cpp`, monitorar o `OperatingSystem` enviado no primeiro pacote.
- **Flag**: Ativar `isMehah = true` quando o SO for identificado como `CLIENTOS_OTCLIENT_WINDOWS`.
- **Efeito**: Isso sinaliza para a engine que, embora o `CLIENT_VERSION` seja 8.6, o cliente suporta Opcodes Estendidos e buffers modernos.

### 2. Protocolo Híbrido 8.6
- **Definitions**: Fixar `CLIENT_VERSION_MIN/MAX` em `860`.
- **Packet Handling**: Manter os pacotes de movimento, combate e inventário no padrão 8.6 (U16 IDs).
- **Recursos Modernos via Opcodes**: Utilizar o **Opcode 0x32 (Extended Opcodes)** para implementar o sistema de times, placares (Scoreboard) e janelas customizadas de War.

### 3. Arquitetura de Itens: ClientID System
Diferente do TFS tradicional, esta versão 1.8 utiliza **ClientID** nativamente em todo o ecossistema.
- **Unificação de IDs**: Não existe mais o `ServerID` (do items.xml) e o `ClientID` (do .dat). O ID que você vê no ObjectBuilder/OTClient é o mesmo usado no `items.xml`, nos scripts Lua, no Banco de Dados (tabela `player_items`) e no Mapa.
- **Vantagem**: Elimina a necessidade de tabelas de conversão, reduzindo bugs de "item trocado" e simplificando a criação de conteúdo.
- **Requisito de Ferramentas**: Para editar o mapa, é **obrigatório** o uso do RME modificado para ClientID, caso contrário, todos os itens aparecerão trocados no editor.

### 4. Sistema de Login Multi-Account (Nuance 7.6)
O comportamento clássico de `1/1` até `7/7` requer uma camada de tradução no Login Protocol.
- **Lógica de Autenticação**: Modificar `protocollogin.cpp` e `IOLoginData.cpp`.
- **Fluxo**: 
    1. O jogador digita conta `1` e senha `1`.
    2. O servidor intercepta e mapeia essa string para uma conta fixa no banco de dados (ex: `Account ID 1001`).
    3. O servidor retorna a lista de personagens correspondentes ao "Time 1".
- **Facilidade**: Isso permite que centenas de jogadores entrem na guerra instantaneamente usando contas genéricas sem necessidade de registro prévio.

---

## 🛠️ Roteiro de Implementação para o Assistente

Quando este projeto for iniciado, o assistente deverá seguir este fluxo:

1.  **Análise da Base 7.6**: Estudar o banco de dados e a estrutura de personagens/times para entender as vocações e balanceamento originais.
2.  **Configuração da Source (TFS 1.x)**:
    - Injetar os handlers de `isMehah` para compatibilidade com o Redemption.
    - Habilitar RSA e Adler Checksum compatíveis com 8.6.
    - Implementar o "Login Hook" para as contas de times (`1/1`..`7/7`).
3.  **Configuração do Client (Redemption)**:
    - Definir `g_game.setProtocolVersion(860)`.
    - Adaptar os módulos de `g_game` para ocultar janelas desnecessárias e focar na interface de War.
4.  **Desenvolvimento do War Core**: Criar os scripts Lua de balanceamento, sistemas de death-broadcast e anti-entra-trap.

---

## 📂 Arquivos de Referência do Projeto
- **`data/`**: Contendo mapas, vocações e itens balanceados para 8.6.
- **`src/`**: Folder com as sources completas do TFS 1.8 revisado.
- **`otclient-redemption/`**: Source e módulos do cliente alvo.

---
*Documento de Especificação Técnica - Gerado por Antigravity (Senior AI Coding Assistant) em 16/04/2026*
