# Requisitos funcionais do SIGEX

## 1. Princípio central
O SIGEX deve manter rastreabilidade individual, temporal e auditável de cada extintor, desde seu cadastro até manutenção, inspeções, movimentações, alocação, descarregamento e baixa.

## 2. Identidade única
Cada extintor possui identificador único e QR Code operacional. O mesmo registro pode ser localizado por leitura do QR Code ou pela digitação do identificador.

O QR Code do ativo identifica o extintor. Um segundo QR Code, quando instalado para auditoria de inspeção, identifica o ponto de checagem e não substitui a identidade do ativo.

## 3. Inspeção
A inspeção deve ser executável em dispositivo móvel:
- localizar o extintor por QR Code ou identificador;
- carregar checklist parametrizado;
- registrar data/hora e operador;
- registrar resultado por item;
- registrar observações;
- registrar fotografia quando houver irregularidade;
- gerar ocorrência vinculada ao extintor e à inspeção.

## 4. Irregularidades e comunicação
Uma irregularidade pode conter:
- categoria;
- descrição;
- item do checklist/norma relacionado;
- severidade;
- foto(s);
- observação;
- operador responsável;
- data/hora;
- status de tratamento;
- responsável pela tratativa.

Quando configurado, o sistema deve notificar em tempo real os responsáveis cadastrados para a unidade, por e-mail e, futuramente, por outros canais integráveis.

A referência a normas, incluindo a ICA 92-20, deve ser parametrizável e versionada. O sistema não deve transformar uma interpretação normativa em regra fixa sem validação do responsável técnico.

## 5. Auditoria de inspeção
Deve existir uma modalidade de auditoria que permita verificar se a inspeção física ocorreu.
O operador realiza a leitura do QR Code específico de checagem afixado no extintor. O sistema registra:
- ponto de checagem;
- extintor relacionado;
- operador;
- data/hora;
- localização/unidade;
- resultado;
- eventual divergência.

O dashboard deve permitir identificar extintores sem inspeção registrada, inspeções atrasadas, divergências e padrões anômalos de checagem.

## 6. Manutenção
O prontuário do extintor deve registrar:
- envio para manutenção;
- motivo;
- empresa/órgão responsável;
- datas de saída e retorno;
- documentos/comprovantes;
- resultado;
- substituição temporária, quando aplicável;
- retorno à condição operacional.

## 7. Validade e alertas
O sistema deve controlar prazos relevantes do extintor e gerar alertas configuráveis para vencimentos e pendências.

## 8. Perfis e autorização
Acesso deve ser concedido mediante cadastro prévio.
A autorização deve considerar perfil/função e unidade, com princípio do menor privilégio.

Exemplos de funções:
- administrador;
- gestor do CINDACTA III;
- gestor/encarregado de DTCEA;
- operador de inspeção;
- responsável por manutenção;
- auditor;
- consulta.

## 9. Dashboard
O dashboard deve apresentar visualização limpa e objetiva, incluindo:
- total de extintores;
- distribuição por unidade;
- situação operacional;
- vencimentos próximos;
- manutenções em andamento;
- inspeções realizadas e pendentes;
- irregularidades abertas;
- movimentações em trânsito;
- alertas;
- indicadores de auditoria.

A visão global deve ser permitida a usuários autorizados do CINDACTA III. Usuários de DTCEA devem visualizar somente o escopo autorizado da própria unidade.

## 10. Segurança e auditoria
Ações críticas devem produzir trilha de auditoria.
Registros históricos e transacionais não devem ser apagados fisicamente por usuários comuns.
Qualquer mudança relevante deve identificar quem, quando, o quê e, quando aplicável, o estado anterior e posterior.

## 11. Regras de movimentação
Mantém-se a regra já definida:
- CINDACTA III -> CINDACTA III: permitido;
- CINDACTA III -> DTCEA: permitido;
- DTCEA -> CINDACTA III: permitido;
- DTCEA -> DTCEA: proibido.

A regra deve permanecer no domínio/backend e ser coberta por testes.
