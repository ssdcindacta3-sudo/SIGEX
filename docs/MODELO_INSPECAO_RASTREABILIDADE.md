# Modelo de inspeção e rastreabilidade

## Entidades adicionais

### checklist_templates
Define versões dos checklists utilizados nas inspeções.

Campos conceituais:
- id
- nome
- versão
- ativo
- vigência
- referência normativa
- criado_em

### checklist_items
Itens pertencentes a uma versão de checklist.

Campos:
- id
- checklist_template_id
- código
- descrição
- ordem
- obrigatório

### inspeções
Registro da execução de um checklist para um extintor.

Campos adicionais recomendados:
- checklist_template_id
- extintor_id
- operador_id
- início
- conclusão
- resultado
- localização registrada
- modo de identificação (QR/numeração)

### inspection_answers
Resposta individual de cada item.

Campos:
- inspeção_id
- checklist_item_id
- resultado
- observação

### irregularidades
Ocorrências identificadas durante uma inspeção ou por outro evento operacional.

Campos:
- extintor_id
- inspeção_id
- categoria
- severidade
- descrição
- referência_normativa
- status
- responsável_id
- aberta_em
- encerrada_em

### irregularidade_fotos
Fotografias associadas à ocorrência.

Campos:
- irregularidade_id
- armazenamento_uri
- hash
- criado_em
- criado_por

### pontos_qr_inspecao
Identidade do QR Code destinado à auditoria de presença física.

Campos:
- id
- extintor_id
- código
- ativo
- instalado_em
- desativado_em

### checagens_qr
Eventos de verificação do QR Code de auditoria.

Campos:
- ponto_qr_id
- extintor_id
- operador_id
- inspeção_id opcional
- data_hora
- resultado
- observação

## Regra de integridade
Uma checagem não deve ser considerada prova suficiente de uma inspeção completa. Ela comprova a passagem do operador pelo ponto de verificação; a inspeção propriamente dita permanece registrada com checklist e respostas.

## Evidências
Fotos, respostas, QR scans, ocorrências e alterações críticas devem manter vínculo com usuário, data/hora e entidade de origem para permitir reconstrução posterior do evento.

## Privacidade e armazenamento
Fotografias devem ser armazenadas fora da tabela transacional como objetos/documentos, mantendo no banco apenas metadados e referência segura. A política de retenção deve ser definida pelo órgão responsável.
