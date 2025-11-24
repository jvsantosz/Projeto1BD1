BEGIN;


-- Tabela USUARIOS (não depende de ninguém)
CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(180) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo_usuario VARCHAR(50) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT NOW(),
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela QUESTOES (depende de usuarios)
CREATE TABLE questoes (
    id_questao SERIAL PRIMARY KEY,
    descricao_questao TEXT NOT NULL,
    tipo_questao VARCHAR(50) NOT NULL,
    valor_pontuacao DECIMAL(5,2),
    feedback_correto TEXT,
    feedback_incorreto TEXT,
    data_criacao TIMESTAMP DEFAULT NOW(),
    id_usuario_criador INTEGER NOT NULL REFERENCES usuarios(id_usuario)
);

-- Tabela OPCOES_QUESTAO (depende de questoes)
CREATE TABLE opcoes_questao (
    id_opcao SERIAL PRIMARY KEY,
    id_questao INTEGER NOT NULL REFERENCES questoes(id_questao) ON DELETE CASCADE,
    texto_opcao VARCHAR(255) NOT NULL,
    eh_correta BOOLEAN NOT NULL DEFAULT FALSE,
    ordem SMALLINT
);

-- Tabela AVALIACOES (depende de usuarios)
CREATE TABLE avaliacoes (
    id_avaliacao SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,
    data_inicio TIMESTAMP NOT NULL,
    data_fim TIMESTAMP,
    duracao_minutos INTEGER,
    status VARCHAR(50) NOT NULL DEFAULT 'RASCUNHO',
    id_usuario_criador INTEGER NOT NULL REFERENCES usuarios(id_usuario),
   
);

-- Tabela AVALIACAO_QUESTAO (depende de avaliacoes e questoes)
CREATE TABLE avaliacao_questao (
    id_avaliacao_questao SERIAL PRIMARY KEY,
    id_avaliacao INTEGER NOT NULL REFERENCES avaliacoes(id_avaliacao) ON DELETE CASCADE,
    id_questao INTEGER NOT NULL REFERENCES questoes(id_questao) ON DELETE CASCADE,
    ordem_na_avaliacao SMALLINT NOT NULL,
    pontuacao_especifica_na_avaliacao DECIMAL(5,2),
    UNIQUE(id_avaliacao, id_questao)
);

-- Tabela USUARIO_AVALIACAO (depende de usuarios e avaliacoes)
CREATE TABLE usuario_avaliacao (
    id_usuario_avaliacao SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id_usuario),
    id_avaliacao INTEGER NOT NULL REFERENCES avaliacoes(id_avaliacao),
    data_inicio_real TIMESTAMP,
    data_fim_real TIMESTAMP,
    status_resposta VARCHAR(50) NOT NULL DEFAULT 'ATRIBUIDA',
    nota_total_obtida DECIMAL(5,2),
    UNIQUE(id_usuario, id_avaliacao)
);

-- Tabela RESPOSTAS_QUESTAO (depende de usuario_avaliacao e avaliacao_questao)
CREATE TABLE respostas_questao (
    id_resposta_questao SERIAL PRIMARY KEY,
    id_usuario_avaliacao INTEGER NOT NULL REFERENCES usuario_avaliacao(id_usuario_avaliacao) ON DELETE CASCADE,
    id_avaliacao_questao INTEGER NOT NULL REFERENCES avaliacao_questao(id_avaliacao_questao) ON DELETE CASCADE,
    texto_resposta TEXT,
    id_opcao_selecionada INTEGER REFERENCES opcoes_questao(id_opcao),
    nota_obtida DECIMAL(5,2),
    data_resposta TIMESTAMP DEFAULT NOW(),
    UNIQUE(id_usuario_avaliacao, id_avaliacao_questao)
);

COMMIT;


SELECT 'respostas_questao', COUNT(*) FROM respostas_questao;
