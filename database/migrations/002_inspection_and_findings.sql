CREATE TYPE resultado_inspecao AS ENUM ('CONFORME', 'NAO_CONFORME', 'INCONCLUSIVA');
CREATE TYPE resultado_item_inspecao AS ENUM ('CONFORME', 'NAO_CONFORME', 'NAO_APLICAVEL');
CREATE TYPE severidade_irregularidade AS ENUM ('BAIXA', 'MEDIA', 'ALTA', 'CRITICA');
CREATE TYPE status_irregularidade AS ENUM ('ABERTA', 'EM_TRATAMENTO', 'RESOLVIDA', 'CANCELADA');

CREATE TABLE checklist_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nome text NOT NULL,
  versao text NOT NULL,
  referencia_normativa text,
  vigente_desde date,
  ativo boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (nome, versao)
);

CREATE TABLE checklist_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  checklist_template_id uuid NOT NULL REFERENCES checklist_templates(id),
  codigo text NOT NULL,
  descricao text NOT NULL,
  ordem integer NOT NULL,
  obrigatorio boolean NOT NULL DEFAULT true,
  UNIQUE (checklist_template_id, codigo)
);

CREATE TABLE inspecoes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  extintor_id uuid NOT NULL REFERENCES extintores(id),
  operador_id uuid NOT NULL REFERENCES usuarios(id),
  checklist_template_id uuid NOT NULL REFERENCES checklist_templates(id),
  identificacao_modo text NOT NULL CHECK (identificacao_modo IN ('QR_ATIVO', 'NUMERO')),
  iniciou_em timestamptz NOT NULL DEFAULT now(),
  concluiu_em timestamptz,
  resultado resultado_inspecao NOT NULL DEFAULT 'INCONCLUSIVA',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE inspection_answers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  inspecao_id uuid NOT NULL REFERENCES inspecoes(id),
  checklist_item_id uuid NOT NULL REFERENCES checklist_items(id),
  resultado resultado_item_inspecao NOT NULL,
  observacao text,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (inspecao_id, checklist_item_id)
);

CREATE TABLE irregularidades (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  extintor_id uuid NOT NULL REFERENCES extintores(id),
  inspecao_id uuid NOT NULL REFERENCES inspecoes(id),
  categoria text NOT NULL,
  severidade severidade_irregularidade NOT NULL,
  descricao text NOT NULL,
  referencia_normativa text,
  status status_irregularidade NOT NULL DEFAULT 'ABERTA',
  responsavel_id uuid REFERENCES usuarios(id),
  aberta_em timestamptz NOT NULL DEFAULT now(),
  encerrada_em timestamptz
);

CREATE TABLE irregularidade_fotos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  irregularidade_id uuid NOT NULL REFERENCES irregularidades(id),
  storage_uri text NOT NULL,
  sha256 text NOT NULL,
  capturada_em timestamptz NOT NULL DEFAULT now(),
  capturada_por uuid NOT NULL REFERENCES usuarios(id)
);

CREATE INDEX idx_inspecoes_extintor ON inspecoes(extintor_id);
CREATE INDEX idx_inspecoes_operador ON inspecoes(operador_id);
CREATE INDEX idx_inspecoes_resultado ON inspecoes(resultado);
CREATE INDEX idx_irregularidades_extintor ON irregularidades(extintor_id);
CREATE INDEX idx_irregularidades_status ON irregularidades(status);
CREATE INDEX idx_irregularidades_severidade ON irregularidades(severidade);
CREATE INDEX idx_irregularidade_fotos_irregularidade ON irregularidade_fotos(irregularidade_id);
