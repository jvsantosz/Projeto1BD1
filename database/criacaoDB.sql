
BEGIN;

-- Tipos de papéis de usuários
CREATE TABLE papel (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(50) NOT NULL UNIQUE  -- e.g., 'ALUNO','PROFESSOR','ADMIN'
);

-- Usuários do sistema
CREATE TABLE usuario (
  id SERIAL PRIMARY KEY,
  nome_usuario VARCHAR(100) NOT NULL UNIQUE,
  nome_completo VARCHAR(200),
  email VARCHAR(200) UNIQUE,
  senha_hash VARCHAR(200) NOT NULL,
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
  id_papel INTEGER NOT NULL REFERENCES papel(id)
);

-- Cursos / Disciplinas
CREATE TABLE curso (
  id SERIAL PRIMARY KEY,
  codigo VARCHAR(30) UNIQUE,
  nome VARCHAR(200) NOT NULL,
  descricao TEXT
);

-- Semestre / Período
CREATE TABLE semestre (
  id SERIAL PRIMARY KEY,
  ano INTEGER NOT NULL CHECK (ano > 2000),
  periodo VARCHAR(20) NOT NULL -- e.g., '1', '2', '2025-1'
);

-- Tipos de questões
CREATE TABLE tipo_questao (
  id SERIAL PRIMARY KEY,
  codigo VARCHAR(30) NOT NULL UNIQUE, -- 'MULTIPLA','TEXTO','NUMERICA'
  descricao VARCHAR(200)
);

-- Questões
CREATE TABLE questao (
  id SERIAL PRIMARY KEY,
  codigo VARCHAR(50),
  titulo TEXT NOT NULL,
  enunciado TEXT NOT NULL,
  id_tipo_questao INTEGER NOT NULL REFERENCES tipo_questao(id),
  valor_padrao NUMERIC(6,2) DEFAULT 0,
  criado_por INTEGER REFERENCES usuario(id),
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Opções de questão (para múltipla escolha)
CREATE TABLE opcao_questao (
  id SERIAL PRIMARY KEY,
  id_questao INTEGER NOT NULL REFERENCES questao(id) ON DELETE CASCADE,
  letra CHAR(1) NOT NULL, -- 'A', 'B', 'C'...
  texto TEXT NOT NULL,
  correta BOOLEAN DEFAULT FALSE
);
CREATE UNIQUE INDEX ux_opcao_questao_letra ON opcao_questao(id_questao, letra);

-- Avaliações
CREATE TABLE avaliacao (
  id SERIAL PRIMARY KEY,
  titulo VARCHAR(300) NOT NULL,
  descricao TEXT,
  id_curso INTEGER REFERENCES curso(id),
  id_semestre INTEGER REFERENCES semestre(id),
  inicio_em TIMESTAMP WITH TIME ZONE,
  fim_em TIMESTAMP WITH TIME ZONE,
  duracao_minutos INTEGER,
  anonima BOOLEAN DEFAULT FALSE,
  possui_nota BOOLEAN DEFAULT TRUE,
  criada_por INTEGER REFERENCES usuario(id),
  criada_em TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Associação Avaliação <-> Questão
CREATE TABLE avaliacao_questao (
  id SERIAL PRIMARY KEY,
  id_avaliacao INTEGER NOT NULL REFERENCES avaliacao(id) ON DELETE CASCADE,
  id_questao INTEGER NOT NULL REFERENCES questao(id) ON DELETE CASCADE,
  valor NUMERIC(8,2) NOT NULL DEFAULT 0,
  ordem INTEGER DEFAULT 0,
  UNIQUE(id_avaliacao, id_questao)
);

-- Atribuição de avaliação a usuários
CREATE TABLE atribuicao (
  id SERIAL PRIMARY KEY,
  id_avaliacao INTEGER NOT NULL REFERENCES avaliacao(id) ON DELETE CASCADE,
  id_usuario INTEGER REFERENCES usuario(id),
  token UUID NOT NULL DEFAULT gen_random_uuid(),
  atribuida_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
  iniciada_em TIMESTAMP WITH TIME ZONE,
  enviada_em TIMESTAMP WITH TIME ZONE,
  status VARCHAR(20) NOT NULL DEFAULT 'ATRIBUIDA', -- 'ATRIBUIDA','EM_ANDAMENTO','ENVIADA'
  UNIQUE(id_avaliacao, id_usuario)
);

-- Respostas
CREATE TABLE resposta (
  id SERIAL PRIMARY KEY,
  id_atribuicao INTEGER NOT NULL REFERENCES atribuicao(id) ON DELETE CASCADE,
  id_questao INTEGER NOT NULL REFERENCES questao(id) ON DELETE CASCADE,
  resposta_texto TEXT,
  id_opcao_selecionada INTEGER REFERENCES opcao_questao(id),
  criada_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(id_atribuicao, id_questao)
);

-- Notas atribuídas às respostas
CREATE TABLE nota_resposta (
  id SERIAL PRIMARY KEY,
  id_resposta INTEGER NOT NULL REFERENCES resposta(id) ON DELETE CASCADE,
  id_avaliador INTEGER REFERENCES usuario(id),
  nota NUMERIC(8,2) NOT NULL,
  avaliada_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
  comentarios TEXT
);

COMMIT;
