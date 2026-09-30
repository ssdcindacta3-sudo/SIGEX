# SIGEX — Sistema de Gerenciamento de Extintores

## Objetivo

O SIGEX será uma aplicação para controle, rastreabilidade e gerenciamento do ciclo de vida dos extintores sob responsabilidade do CINDACTA III e dos DTCEAs.

## Regra institucional de movimentação

- O CINDACTA III pode enviar extintores para qualquer DTCEA.
- O CINDACTA III pode receber extintores de qualquer DTCEA.
- Um DTCEA pode enviar extintores somente para o CINDACTA III.
- Um DTCEA não pode enviar extintores diretamente para outro DTCEA.
- Toda movimentação deverá possuir registro, origem, destino, responsável, data/hora e histórico.

## Diretrizes de desenvolvimento

1. Separar claramente apresentação, regras de negócio e persistência.
2. Implementar controle de acesso por perfil e unidade.
3. Manter rastreabilidade das operações.
4. Validar as regras de movimentação no backend, e não apenas na interface.
5. Evitar alterações diretas na `main`; desenvolver em branches e integrar por Pull Request.
6. Manter documentação técnica e de regras de negócio versionada.

## Roadmap inicial

- [ ] Arquitetura técnica
- [ ] Modelo de dados
- [ ] Autenticação e autorização
- [ ] Cadastro de unidades
- [ ] Cadastro e identificação de extintores
- [ ] Estoque por unidade
- [ ] Movimentações e transferências
- [ ] Histórico e auditoria
- [ ] Manutenções/inspeções
- [ ] Relatórios e indicadores
- [ ] Testes automatizados
- [ ] Deploy e operação
