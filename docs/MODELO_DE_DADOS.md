# SIGEX — Modelo de Dados Inicial

## 1. Objetivo
Modelo conceitual inicial para rastreabilidade individual dos extintores, estoque por unidade e histórico completo das movimentações.

## 2. Entidades principais

### Unidade
- id
- codigo
- sigla
- nome
- tipo_unidade: CINDACTA_III | DTCEA
- ativo
- created_at
- updated_at

### Usuário
- id
- nome
- identificacao_funcional
- email
- perfil
- unidade_id
- ativo
- created_at
- updated_at

Perfis conceituais: ADMINISTRADOR, GESTOR, OPERADOR, CONSULTA.

### Tipo de Extintor
- id
- codigo
- descricao
- agente_extintor
- capacidade
- norma_referencia
- ativo

### Extintor
- id
- numero_identificacao
- tipo_extintor_id
- fabricante
- modelo
- numero_serie
- ano_fabricacao
- data_aquisicao
- unidade_atual_id
- situacao
- data_ultima_inspecao
- data_proxima_inspecao
- observacoes
- created_at
- updated_at

Situações: DISPONIVEL, EM_USO, EM_MANUTENCAO, INOPERANTE, BAIXADO, EM_TRANSITO.

Regra: um extintor ativo possui uma única unidade atual.

## 3. Movimentação

### Movimentação
- id
- numero
- unidade_origem_id
- unidade_destino_id
- solicitante_id
- responsavel_id
- data_solicitacao
- data_saida
- data_recebimento
- status
- motivo
- observacoes
- created_at
- updated_at

Status: RASCUNHO, SOLICITADA, AUTORIZADA, EM_TRANSITO, RECEBIDA, CANCELADA, REJEITADA.

### Item da Movimentação
- id
- movimentacao_id
- extintor_id
- situacao_na_saida
- situacao_no_recebimento
- observacoes

Uma movimentação pode conter vários extintores.

## 4. Regra institucional de transferência

| Origem | Destino | Resultado |
|---|---|---|
| CINDACTA III | CINDACTA III | PERMITIDO |
| CINDACTA III | DTCEA | PERMITIDO |
| DTCEA | CINDACTA III | PERMITIDO |
| DTCEA | DTCEA | BLOQUEADO |

A regra deve existir no domínio/backend e não somente na interface. Requisições manipuladas externamente também devem ser rejeitadas e auditadas.

## 5. Estoque

O estoque operacional deve ser derivado dos extintores ativos cuja unidade atual corresponde à unidade consultada, considerando suas situações. A fonte de verdade permanece nos registros individuais dos extintores e nas movimentações.

## 6. Manutenção

Campos: id, extintor_id, tipo, empresa_responsavel, numero_ordem_servico, data_envio, data_retorno, resultado, custo, observacoes, created_at, updated_at.

Tipos: PREVENTIVA, CORRETIVA, RECARGA, TESTE, OUTRA.

## 7. Inspeção

Campos: id, extintor_id, unidade_id, usuario_id, data_inspecao, resultado, validade, observacoes, created_at.

Cada inspeção é um evento histórico e não deve apagar o resultado anterior.

## 8. Auditoria

Campos: id, usuario_id, unidade_id, entidade, entidade_id, operacao, data_hora, dados_anteriores, dados_novos, ip_origem, observacao.

Operações: CREATE, UPDATE, DELETE, AUTHORIZE, REJECT, SEND, RECEIVE, LOGIN, LOGOUT.

## 9. Relacionamentos

- Unidade 1:N Usuário
- Unidade 1:N Extintor
- TipoExtintor 1:N Extintor
- Unidade 1:N Movimentação (origem)
- Unidade 1:N Movimentação (destino)
- Usuário 1:N Movimentação (solicitante)
- Usuário 1:N Movimentação (responsável)
- Movimentação 1:N ItemMovimentação
- Extintor 1:N ItemMovimentação
- Extintor 1:N Manutenção
- Extintor 1:N Inspeção
- Usuário 1:N Auditoria

## 10. Integridade

1. Identificação do extintor deve ser única.
2. Item de movimentação deve apontar para extintor existente.
3. Movimentação deve possuir origem e destino válidos.
4. Origem e destino não podem ser a mesma unidade em uma transferência.
5. DTCEA → DTCEA deve ser rejeitado.
6. Extintor não pode estar simultaneamente em duas movimentações abertas incompatíveis.
7. Recebimento deve atualizar a unidade atual do extintor.
8. Envio deve registrar EM_TRANSITO quando aplicável.
9. Cancelamentos e rejeições não apagam histórico.
10. Operações críticas geram auditoria.

## 11. Fluxo de transferência

1. Usuário cria solicitação.
2. Sistema valida origem, destino, perfil e situação dos extintores.
3. Sistema valida a matriz institucional.
4. Solicitação é autorizada ou rejeitada.
5. Na saída, os itens passam para EM_TRANSITO.
6. Sistema registra data/hora e responsável.
7. Destino confirma recebimento.
8. Unidade atual de cada extintor é atualizada.
9. Movimentação passa para RECEBIDA.
10. Registros de auditoria são gerados.

## 12. Decisão arquitetural

O SIGEX deve tratar cada extintor como ativo individual rastreável, e não apenas como quantidade de estoque. Isso permite rastrear o ciclo de vida completo e reduzir inconsistências entre estoque, movimentação, manutenção e inspeção.