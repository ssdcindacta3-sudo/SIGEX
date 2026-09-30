# Banco de dados

O diretório contém migrações versionadas do PostgreSQL.

## Regra de integridade

O estoque não é uma quantidade editável isoladamente. Cada extintor é um ativo rastreável e sua unidade atual, situação e histórico de movimentações formam a fonte de verdade operacional.

A matriz de transferência deve ser validada na camada de domínio/API e, nas operações transacionais críticas, dentro da mesma transação que altera o estado dos extintores.

Migrações futuras devem preservar rastreabilidade e evitar exclusão física de registros transacionais.
