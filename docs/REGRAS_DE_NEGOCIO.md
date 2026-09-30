# SIGEX — Regras de Negócio

## RN-001 — Identificação individual
Todo extintor ativo deve possuir identificação única.

## RN-002 — Unidade atual
Cada extintor ativo deve possuir exatamente uma unidade atual.

## RN-003 — Origem da movimentação
O usuário somente pode iniciar movimentação a partir de uma unidade para a qual possua autorização operacional.

## RN-004 — Matriz de transferência
CINDACTA III pode enviar para CINDACTA III ou qualquer DTCEA.
DTCEA pode enviar somente para CINDACTA III.
DTCEA não pode enviar diretamente para outro DTCEA.

## RN-005 — Extintor disponível
Um extintor somente pode ser incluído em nova transferência se estiver disponível para movimentação e vinculado à unidade de origem.

## RN-006 — Transferência em trânsito
Após a saída confirmada, o extintor deve ser identificado como EM_TRANSITO até o recebimento.

## RN-007 — Recebimento
O recebimento deve atualizar a unidade atual do extintor para a unidade destinatária.

## RN-008 — Histórico
Nenhuma transferência confirmada pode ser apagada do histórico por usuário operacional.

## RN-009 — Auditoria
Operações críticas devem registrar usuário, unidade, data/hora, operação e dados relevantes.

## RN-010 — Cancelamento
Cancelamentos não devem apagar registros. O sistema deve manter a ocorrência e seu responsável.

## RN-011 — Rejeição
Uma solicitação rejeitada deve permanecer registrada com motivo da rejeição quando informado.

## RN-012 — Manutenção
Um extintor em manutenção não deve ser disponibilizado para uma nova transferência incompatível com sua situação.

## RN-013 — Inspeção
Cada inspeção é um evento histórico independente. Uma nova inspeção não substitui a anterior.

## RN-014 — Integridade
Validações críticas devem existir no backend/domínio, independentemente das validações existentes nas telas.

## RN-015 — Estoque
O estoque deve ser calculado a partir dos extintores registrados e de sua unidade atual/situação.

## RN-016 — Recebimento parcial
A possibilidade de recebimento parcial deve ser uma decisão explícita da regra operacional. Até essa decisão, o fluxo padrão considera a movimentação como recebida integralmente ou não recebida.

## RN-017 — Rastreabilidade
Para qualquer extintor, o sistema deve conseguir reconstruir sua trajetória por meio dos registros de movimentação, manutenção, inspeção e auditoria.

## RN-018 — Exclusão
Registros históricos e transacionais não devem ser excluídos fisicamente por usuários comuns.

## RN-019 — Perfil
Permissões devem ser verificadas tanto pelo perfil do usuário quanto pela unidade à qual ele está vinculado.

## RN-020 — Segurança da regra institucional
Nenhuma alteração de interface, chamada de API ou integração externa pode permitir uma transferência DTCEA → DTCEA.