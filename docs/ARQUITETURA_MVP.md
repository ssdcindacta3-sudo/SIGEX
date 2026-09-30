# SIGEX — Arquitetura Executável do MVP

## 1. Objetivo

Definir a estrutura técnica inicial para transformar a documentação do SIGEX em uma aplicação web funcional, evolutiva e segura.

## 2. Stack recomendada

### Frontend
- React + TypeScript
- Vite
- Tailwind CSS
- Componentes reutilizáveis

### Backend
- TypeScript
- Node.js
- API REST
- Camada de domínio separada das rotas

### Banco de dados
- PostgreSQL
- Migrations versionadas
- Constraints e índices no banco

### Autenticação
- Autenticação baseada em sessão/token conforme a plataforma de implantação.
- Autorização por perfil e unidade.

### Testes
- Testes unitários para regras de negócio.
- Testes de integração para movimentações.
- Testes de autorização.

## 3. Organização do projeto

Proposta inicial:

apps/
- web/              # frontend
- api/              # backend

packages/
- domain/           # entidades e regras de negócio
- shared/           # tipos e utilitários compartilhados

database/
- migrations/       # evolução do schema
- seeds/            # dados iniciais controlados

docs/
- arquitetura/
- regras/
- operacao/

tests/
- unit/
- integration/

## 4. Módulos do MVP

### Módulo 1 — Autenticação
- login
- logout
- sessão
- recuperação de acesso conforme solução de identidade adotada

### Módulo 2 — Usuários e permissões
- cadastro
- perfil
- unidade vinculada
- ativação/inativação
- permissões por operação

### Módulo 3 — Unidades
- CINDACTA III
- DTCEAs
- situação da unidade

### Módulo 4 — Tipos de extintor
- cadastro
- edição
- ativação/inativação
- classificação

### Módulo 5 — Extintores
- cadastro individual
- identificação
- localização atual
- situação
- dados técnicos
- histórico

### Módulo 6 — Estoque
- visão geral por unidade
- filtros
- agrupamento por tipo
- situação operacional
- extintores em trânsito

### Módulo 7 — Movimentações
- nova solicitação
- seleção de extintores
- validação de origem/destino
- autorização
- saída
- recebimento
- rejeição
- cancelamento
- histórico

### Módulo 8 — Auditoria
- eventos críticos
- usuário
- unidade
- data/hora
- entidade afetada

## 5. API inicial

Rotas conceituais:

POST /auth/login
POST /auth/logout

GET /units
POST /units
PATCH /units/:id

GET /users
POST /users
PATCH /users/:id

GET /extinguisher-types
POST /extinguisher-types
PATCH /extinguisher-types/:id

GET /extinguishers
POST /extinguishers
GET /extinguishers/:id
PATCH /extinguishers/:id

GET /movements
POST /movements
GET /movements/:id
POST /movements/:id/authorize
POST /movements/:id/reject
POST /movements/:id/dispatch
POST /movements/:id/receive
POST /movements/:id/cancel

GET /audits

## 6. Regra crítica da API

A API deve executar as mesmas regras de domínio independentemente da tela que originou a chamada.

Exemplo:

POST /movements

Antes de criar a movimentação, o domínio deve validar:

1. usuário autenticado;
2. perfil autorizado;
3. unidade de origem autorizada;
4. unidade de destino válida;
5. origem diferente do destino;
6. matriz institucional de transferência;
7. extintores pertencentes à origem;
8. extintores disponíveis;
9. ausência de movimentação incompatível;
10. geração de auditoria.

## 7. Dashboard inicial

O painel principal deve apresentar, conforme autorização do usuário:

- total de extintores;
- extintores por unidade;
- extintores por situação;
- movimentações pendentes;
- movimentações em trânsito;
- extintores em manutenção;
- inspeções próximas do vencimento;
- alertas operacionais.

## 8. Princípios de interface

- Navegação simples.
- Responsividade para computador, tablet e celular.
- Identificação clara da unidade atual do usuário.
- Ações incompatíveis devem aparecer desabilitadas ou não disponíveis.
- Mensagens de erro devem explicar o motivo da operação bloqueada.
- Operações críticas devem exigir confirmação.

## 9. Observabilidade

O sistema deverá registrar erros técnicos separadamente da auditoria funcional.

Devem existir mecanismos para identificar:
- erro de API;
- falha de banco;
- falha de autenticação;
- tentativa de operação não autorizada;
- violação de regra de negócio.

## 10. Estratégia de implementação

Fase 1: infraestrutura e banco.
Fase 2: autenticação e autorização.
Fase 3: unidades, usuários e tipos.
Fase 4: extintores e estoque.
Fase 5: movimentações.
Fase 6: auditoria e histórico.
Fase 7: dashboard.
Fase 8: testes e endurecimento de segurança.

## 11. Critério de conclusão do MVP

O MVP será considerado funcional quando um usuário autorizado puder cadastrar um extintor, visualizar seu estoque, criar uma transferência válida, acompanhar a autorização, registrar a saída, receber o equipamento na unidade destino e consultar todo o histórico, enquanto uma tentativa DTCEA → DTCEA for rejeitada pelo backend.