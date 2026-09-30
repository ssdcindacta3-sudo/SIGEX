# SIGEX — Especificação Técnica do Banco de Dados

## 1. Objetivo

Esta especificação transforma o modelo conceitual do SIGEX em uma estrutura relacional preparada para implementação. O banco deve preservar a identidade individual dos extintores, o histórico das movimentações e a integridade das regras institucionais.

## 2. Convenções

- Todas as tabelas devem possuir identificador primário estável.
- IDs podem ser UUID.
- Datas e horas devem ser armazenadas com timezone quando o banco suportar.
- Campos de criação e atualização devem ser mantidos automaticamente.
- Exclusão física deve ser evitada para registros transacionais e históricos.
- Registros que deixarem de ser utilizados devem preferencialmente receber status/ativo=false.

## 3. Tabelas

### unidades

- id — PK
- codigo — UNIQUE, NOT NULL
- sigla — UNIQUE, NOT NULL
- nome — NOT NULL
- tipo — NOT NULL: CINDACTA_III ou DTCEA
- ativo — NOT NULL, default true
- created_at
- updated_at

### usuarios

- id — PK
- nome — NOT NULL
- identificacao_funcional — UNIQUE
- email — UNIQUE
- perfil — NOT NULL
- unidade_id — FK → unidades.id
- ativo — NOT NULL
- created_at
- updated_at

### tipos_extintor

- id — PK
- codigo — UNIQUE, NOT NULL
- descricao — NOT NULL
- agente_extintor
- capacidade
- norma_referencia
- ativo
- created_at
- updated_at

### extintores

- id — PK
- numero_identificacao — UNIQUE, NOT NULL
- tipo_extintor_id — FK → tipos_extintor.id
- fabricante
- modelo
- numero_serie
- ano_fabricacao
- data_aquisicao
- unidade_atual_id — FK → unidades.id
- situacao — NOT NULL
- data_ultima_inspecao
- data_proxima_inspecao
- observacoes
- ativo
- created_at
- updated_at

Índices recomendados:
- numero_identificacao
- unidade_atual_id
- tipo_extintor_id
- situacao
- data_proxima_inspecao

### movimentacoes

- id — PK
- numero — UNIQUE, NOT NULL
- unidade_origem_id — FK → unidades.id
- unidade_destino_id — FK → unidades.id
- solicitante_id — FK → usuarios.id
- responsavel_id — FK → usuarios.id, nullable
- data_solicitacao
- data_autorizacao
- data_saida
- data_recebimento
- status — NOT NULL
- motivo
- observacoes
- created_at
- updated_at

Índices recomendados:
- numero
- unidade_origem_id
- unidade_destino_id
- status
- data_solicitacao

### movimentacao_itens

- id — PK
- movimentacao_id — FK → movimentacoes.id
- extintor_id — FK → extintores.id
- situacao_na_saida
- situacao_no_recebimento
- observacoes
- created_at

Constraint recomendada:
- UNIQUE(movimentacao_id, extintor_id)

Índices:
- movimentacao_id
- extintor_id

### manutencoes

- id — PK
- extintor_id — FK → extintores.id
- tipo
- empresa_responsavel
- numero_ordem_servico
- data_envio
- data_retorno
- resultado
- custo
- observacoes
- created_at
- updated_at

### inspecoes

- id — PK
- extintor_id — FK → extintores.id
- unidade_id — FK → unidades.id
- usuario_id — FK → usuarios.id
- data_inspecao
- resultado
- validade
- observacoes
- created_at

### auditoria

- id — PK
- usuario_id — FK → usuarios.id, nullable
- unidade_id — FK → unidades.id, nullable
- entidade
- entidade_id
- operacao
- data_hora
- dados_anteriores
- dados_novos
- ip_origem
- observacao

Índices:
- entidade + entidade_id
- usuario_id
- unidade_id
- data_hora
- operacao

## 4. Constraints e integridade

### 4.1 Unidade

Deve existir exatamente uma unidade ativa com tipo CINDACTA_III na configuração institucional do sistema.

### 4.2 Movimentação

Uma movimentação deve possuir origem e destino diferentes.

A matriz institucional deve ser validada antes da autorização:

- CINDACTA III → CINDACTA III: permitido.
- CINDACTA III → DTCEA: permitido.
- DTCEA → CINDACTA III: permitido.
- DTCEA → DTCEA: proibido.

### 4.3 Extintor

Um extintor só pode ser movimentado se:

1. estiver ativo;
2. pertencer à unidade de origem;
3. não estiver baixado;
4. não possuir outra movimentação incompatível em aberto.

## 5. Máquina de estados da movimentação

Fluxo normal:

RASCUNHO → SOLICITADA → AUTORIZADA → EM_TRANSITO → RECEBIDA

Fluxos alternativos:

- SOLICITADA → REJEITADA
- SOLICITADA → CANCELADA
- AUTORIZADA → CANCELADA, quando permitido pela regra operacional.

Uma movimentação RECEBIDA não deve retornar a estado anterior.

## 6. Transação de envio

A operação de envio deve ocorrer em uma única transação lógica:

1. validar usuário;
2. validar origem e destino;
3. validar matriz institucional;
4. validar cada extintor;
5. criar/atualizar status da movimentação;
6. registrar data e responsável;
7. alterar situação dos extintores para EM_TRANSITO;
8. registrar auditoria;
9. confirmar a transação.

Se qualquer etapa crítica falhar, a operação deve ser revertida.

## 7. Transação de recebimento

1. validar movimentação EM_TRANSITO;
2. validar unidade destinatária;
3. registrar situação de cada item;
4. atualizar unidade_atual_id dos extintores;
5. atualizar situação dos extintores;
6. registrar data e responsável pelo recebimento;
7. alterar movimentação para RECEBIDA;
8. registrar auditoria;
9. confirmar a transação.

## 8. Concorrência

O backend deve impedir que duas operações simultâneas movimentem o mesmo extintor.

Quando suportado pelo banco, utilizar transações e mecanismos de bloqueio/controle de concorrência apropriados.

## 9. Auditoria

Operações críticas devem gerar auditoria, incluindo:

- criação;
- alteração;
- autorização;
- rejeição;
- envio;
- recebimento;
- cancelamento;
- manutenção;
- inspeção;
- alteração de situação;
- operações administrativas relevantes.

Registros de auditoria não devem ser apagados por operações comuns do aplicativo.

## 10. Relatórios derivados

O banco deve permitir consultas para:

- estoque atual por unidade;
- estoque por tipo de extintor;
- extintores em trânsito;
- extintores em manutenção;
- extintores próximos do vencimento de inspeção;
- histórico completo de um extintor;
- histórico de movimentações por unidade;
- movimentações por período;
- movimentações por usuário;
- auditoria por entidade;
- indicadores consolidados do CINDACTA III e DTCEAs.

## 11. Regra de ouro

O estoque atual é consequência dos registros individuais dos extintores e das operações confirmadas. Não deve existir uma tabela de quantidade de estoque que possa ser alterada manualmente e se tornar uma segunda fonte de verdade.

## 12. Próxima implementação

A próxima etapa técnica deve transformar esta especificação em migrations/schema do banco escolhido e testes automatizados das regras de movimentação antes da construção das telas finais.