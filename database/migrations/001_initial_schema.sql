CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE unidade_tipo AS ENUM ('CINDACTA_III', 'DTCEA');
CREATE TYPE situacao_extintor AS ENUM (
  'DISPONIVEL',
  'EM_USO',
  'EM_MANUTENCAO',
  'INOPERANTE',
  'BAIXADO',
  'EM_TRANSITO'
);
CREATE TYPE movimentacao_status AS ENUM (
  'RASCUNHO',
  'SOLICITADA',
  'AUTORIZADA',
  'EM_TRANSITO',
  'RECEBIDA',
  'CANCELADA',
  'REJEITADA'
);

CREATE TABLE unidades (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nome text NOT NULL,
  sigla text NOT NULL UNIQUE,
  tipo unidade_tipo NOT NULL,
  ativa boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE usuarios (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nome text NOT NULL,
  email text NOT NULL UNIQUE,
  unidade_id uuid NOT NULL REFERENCES unidades(id),
  perfil text NOT NULL,
  ativo boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE tipos_extintor (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo text NOT NULL UNIQUE,
  descricao text NOT NULL,
  capacidade_kg numeric(10,2),
  ativo boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE extintores (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patrimonio text NOT NULL UNIQUE,
  numero_serie text UNIQUE,
  tipo_extintor_id uuid NOT NULL REFERENCES tipos_extintor(id),
  unidade_id uuid NOT NULL REFERENCES unidades(id),
  situacao situacao_extintor NOT NULL DEFAULT 'DISPONIVEL',
  validade date,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE movimentacoes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  unidade_origem_id uuid NOT NULL REFERENCES unidades(id),
  unidade_destino_id uuid NOT NULL REFERENCES unidades(id),
  solicitante_id uuid NOT NULL REFERENCES usuarios(id),
  status movimentacao_status NOT NULL DEFAULT 'RASCUNHO',
  observacao text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT movimentacao_unidades_diferentes
    CHECK (unidade_origem_id <> unidade_destino_id)
);

CREATE TABLE movimentacao_itens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  movimentacao_id uuid NOT NULL REFERENCES movimentacoes(id),
  extintor_id uuid NOT NULL REFERENCES extintores(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (movimentacao_id, extintor_id)
);

CREATE TABLE manutencoes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  extintor_id uuid NOT NULL REFERENCES extintores(id),
  data_inicio timestamptz NOT NULL,
  data_fim timestamptz,
  tipo text NOT NULL,
  resultado text,
  observacao text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE inspecoes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  extintor_id uuid NOT NULL REFERENCES extintores(id),
  data_inspecao timestamptz NOT NULL,
  resultado text NOT NULL,
  observacao text,
  usuario_id uuid REFERENCES usuarios(id),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE auditoria (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id uuid REFERENCES usuarios(id),
  entidade text NOT NULL,
  entidade_id uuid,
  acao text NOT NULL,
  dados_anteriores jsonb,
  dados_novos jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_extintores_unidade ON extintores(unidade_id);
CREATE INDEX idx_extintores_situacao ON extintores(situacao);
CREATE INDEX idx_movimentacoes_origem ON movimentacoes(unidade_origem_id);
CREATE INDEX idx_movimentacoes_destino ON movimentacoes(unidade_destino_id);
CREATE INDEX idx_movimentacoes_status ON movimentacoes(status);
CREATE INDEX idx_movimentacao_itens_extintor ON movimentacao_itens(extintor_id);
CREATE INDEX idx_auditoria_entidade ON auditoria(entidade, entidade_id);

-- A matriz CINDACTA III/DTCEA é regra de domínio e deve ser validada
-- também na transação da API antes de autorizar/despachar/receber.
