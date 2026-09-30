# Arquitetura inicial do SIGEX

## Princípios

O sistema será organizado para que regras institucionais críticas não dependam da interface.

### Camadas

- **Apresentação:** telas, formulários, dashboards e navegação.
- **Aplicação:** casos de uso e orquestração das operações.
- **Domínio:** entidades, regras de negócio e validações.
- **Persistência/infraestrutura:** banco de dados, autenticação, armazenamento e integrações.

## Domínio inicial

### Unidade
Representa o CINDACTA III ou um DTCEA.

Campos conceituais:
- identificador
- sigla
- nome
- tipo
- status

### Extintor
Representa uma unidade física rastreável.

Campos conceituais:
- identificador patrimonial ou código único
- tipo
- capacidade
- fabricante/modelo
- localização atual
- situação operacional
- datas relevantes
- observações

### Movimentação
Registra a transferência de um ou mais extintores.

Campos conceituais:
- identificador
- origem
- destino
- extintores
- solicitante
- responsável
- data/hora
- motivo
- situação
- observações
- histórico de alterações

## Regra de autorização de movimentação

A validação deve ser feita no domínio/aplicação:

| Origem | Destino | Permitido |
|---|---|---|
| CINDACTA III | CINDACTA III | Sim |
| CINDACTA III | DTCEA | Sim |
| DTCEA | CINDACTA III | Sim |
| DTCEA | DTCEA | Não |

A regra deverá permanecer centralizada para evitar divergência entre telas, APIs e integrações.

## Segurança

O modelo deverá prever:
- autenticação;
- autorização por perfil;
- autorização vinculada à unidade;
- trilha de auditoria;
- registro de usuário e timestamp nas operações críticas.

## Estratégia de evolução

A primeira implementação deverá priorizar o núcleo transacional: unidades, extintores, estoque e movimentações. Relatórios e recursos acessórios serão construídos sobre dados transacionais já rastreáveis.
