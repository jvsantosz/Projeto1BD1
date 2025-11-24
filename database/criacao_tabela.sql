BEGIN;

-- 1. DROP de todas as tabelas na ordem correta (por dependências)
DROP TABLE IF EXISTS respostas_questao CASCADE;
DROP TABLE IF EXISTS usuario_avaliacao CASCADE;
DROP TABLE IF EXISTS avaliacao_questao CASCADE;
DROP TABLE IF EXISTS opcoes_questao CASCADE;
DROP TABLE IF EXISTS avaliacoes CASCADE;
DROP TABLE IF EXISTS questoes CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- 2. Criar tabelas na ORDEM CORRETA de dependências

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

-- 3. INSERIR DADOS DE TESTE

-- Inserir usuários
INSERT INTO usuarios (nome, email, senha, tipo_usuario) VALUES 
('Professor Admin', 'professor@teste.com', '123456', 'PROFESSOR'),
('Aluno João', 'aluno1@teste.com', '123456', 'ALUNO'),
('Aluna Maria', 'aluna2@teste.com', '123456', 'ALUNO');

-- Inserir questões
INSERT INTO questoes (descricao_questao, tipo_questao, valor_pontuacao, id_usuario_criador) VALUES 
('Qual é a capital do Brasil?', 'MULTIPLA', 2.0, 1),
('Explique o que é POO:', 'TEXTO', 5.0, 1),
('Quanto é 2 + 2?', 'NUMERICA', 1.0, 1);

-- Inserir opções para questão múltipla escolha
INSERT INTO opcoes_questao (id_questao, texto_opcao, eh_correta, ordem) VALUES 
(1, 'São Paulo', false, 1),
(1, 'Rio de Janeiro', false, 2),
(1, 'Brasília', true, 3),
(1, 'Salvador', false, 4);

-- Inserir avaliação
INSERT INTO avaliacoes (titulo, descricao, data_inicio, data_fim, id_usuario_criador) VALUES 
('Avaliação de Geografia', 'Teste sobre capitais brasileiras', NOW(), NOW() + INTERVAL '1 hour', 1);

-- Associar questões à avaliação
INSERT INTO avaliacao_questao (id_avaliacao, id_questao, ordem_na_avaliacao, pontuacao_especifica_na_avaliacao) VALUES 
(1, 1, 1, 2.0),
(1, 2, 2, 5.0);

-- Atribuir avaliação aos alunos
INSERT INTO usuario_avaliacao (id_usuario, id_avaliacao, status_resposta) VALUES 
(2, 1, 'ATRIBUIDA'),
(3, 1, 'ATRIBUIDA');

COMMIT;

-- 4. VERIFICAR se tudo foi criado corretamente
SELECT 'usuarios' as tabela, COUNT(*) as registros FROM usuarios
UNION ALL
SELECT 'questoes', COUNT(*) FROM questoes
UNION ALL
SELECT 'opcoes_questao', COUNT(*) FROM opcoes_questao
UNION ALL
SELECT 'avaliacoes', COUNT(*) FROM avaliacoes
UNION ALL
SELECT 'avaliacao_questao', COUNT(*) FROM avaliacao_questao
UNION ALL
SELECT 'usuario_avaliacao', COUNT(*) FROM usuario_avaliacao
UNION ALL
SELECT 'respostas_questao', COUNT(*) FROM respostas_questao;
