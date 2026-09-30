# Fluxo Operacional de Inspeção

## Objetivo

Garantir que cada inspeção de um extintor produza uma evidência temporal, vinculada ao ativo, ao operador, ao checklist utilizado e, quando necessário, à irregularidade identificada.

## Fluxo principal

1. O operador identifica o extintor por QR Code ou pelo número patrimonial/identificador.
2. O SIGEX valida a identidade do ativo e a autorização do operador.
3. O sistema abre o checklist vigente aplicável ao extintor.
4. O operador responde aos itens.
5. O SIGEX impede a conclusão enquanto houver item obrigatório sem resposta.
6. O resultado é derivado das respostas.
7. Caso exista não conformidade, a irregularidade é vinculada à inspeção e ao extintor.
8. O operador pode anexar evidência fotográfica.
9. A irregularidade recebe responsável e severidade.
10. O sistema registra evento de auditoria.
11. O sistema gera uma notificação para o responsável cadastrado quando a regra de negócio exigir comunicação.
12. O dashboard passa a refletir a nova inspeção e suas pendências.

## Identificação do ativo

O SIGEX deve aceitar dois caminhos:

- QR Code individual do extintor;
- pesquisa manual pelo identificador único.

O QR Code deve apontar para um identificador do ativo, e não armazenar informações operacionais mutáveis.

## QR Code de auditoria

O QR Code destinado à checagem/auditoria é independente do QR Code de identificação do extintor.

A leitura do QR de auditoria deve gerar uma evidência de presença física e permitir verificar se a inspeção prevista para aquele ponto/ativo está registrada.

A leitura do QR de auditoria, isoladamente, não substitui o checklist completo.

## Irregularidades

Toda irregularidade deve manter:

- extintor;
- inspeção de origem;
- operador;
- data/hora;
- categoria;
- descrição;
- severidade;
- referência normativa, quando aplicável;
- responsável;
- status;
- evidências fotográficas, quando existentes.

## Notificações

A notificação deve ser consequência de uma regra de negócio, e não de uma ação manual do operador.

O destinatário deve ser obtido a partir dos responsáveis previamente cadastrados para a unidade/processo.

O mecanismo de envio deve ser desacoplado do registro da irregularidade para evitar perda de rastreabilidade caso o serviço de e-mail esteja indisponível.

## Princípio de auditoria

Uma alteração crítica não deve apagar o fato anterior. O histórico deve registrar quem realizou a ação, quando, sobre qual ativo e qual foi o resultado.
