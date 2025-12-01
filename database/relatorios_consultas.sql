-- 📊 Nota Percentual por Aluno em Cada Avaliação
SELECT
    u.id_usuario,
    u.nome,
    av.id_avaliacao,
    av.titulo,
    CASE 
        WHEN ua.nota_total_obtida IS NOT NULL AND ua.nota_total_obtida > 0 
        THEN ROUND((ua.nota_total_obtida / 
             (SELECT COALESCE(SUM(COALESCE(aq.pontuacao_especifica_na_avaliacao, q.valor_pontuacao)), 1)
              FROM avaliacao_questao aq
              JOIN questoes q ON q.id_questao = aq.id_questao
              WHERE aq.id_avaliacao = av.id_avaliacao)
             ) * 100, 2)
        ELSE 0 
    END AS nota_percentual
FROM usuarios u
JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
JOIN avaliacoes av ON av.id_avaliacao = ua.id_avaliacao
WHERE u.tipo_usuario = 'ALUNO'
ORDER BY u.nome, av.titulo;

-- ❌ Questões onde TODAS as alternativas são incorretas
SELECT DISTINCT q.id_questao, q.descricao_questao
FROM questoes q
JOIN opcoes_questao oq ON oq.id_questao = q.id_questao
WHERE q.id_questao NOT IN (
    SELECT DISTINCT id_questao 
    FROM opcoes_questao 
    WHERE eh_correta = true
)
AND q.tipo_questao = 'MULTIPLA';

-- ✅ Alunos que completaram TODAS as avaliações ativas
SELECT 
    u.id_usuario,
    u.nome,
    COUNT(DISTINCT ua.id_avaliacao) as avaliacoes_completadas
FROM usuarios u
LEFT JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario 
    AND ua.status_resposta = 'CONCLUIDA'
WHERE u.tipo_usuario = 'ALUNO'
GROUP BY u.id_usuario, u.nome
HAVING COUNT(DISTINCT ua.id_avaliacao) = (
    SELECT COUNT(*) 
    FROM avaliacoes 
    WHERE status = 'ATIVA'
);

-- ⏰ Avaliações com tempo de duração ACIMA da média
SELECT id_avaliacao, titulo, duracao_minutos
FROM avaliacoes
WHERE duracao_minutos > (
    SELECT COALESCE(AVG(duracao_minutos), 0) 
    FROM avaliacoes 
    WHERE duracao_minutos IS NOT NULL
);

-- 🏆 Ranking dos 5 alunos com maior média geral
SELECT
    u.id_usuario,
    u.nome,
    u.email,
    ROUND(AVG(COALESCE(ua.nota_total_obtida, 0)), 2) AS media_geral,
    COUNT(ua.id_usuario_avaliacao) AS total_avaliacoes
FROM usuarios u
LEFT JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
WHERE u.tipo_usuario = 'ALUNO'
GROUP BY u.id_usuario, u.nome, u.email
HAVING COUNT(ua.id_usuario_avaliacao) > 0
ORDER BY media_geral DESC
LIMIT 5;

-- 📋 Alunos que NUNCA fizeram avaliação
SELECT u.id_usuario, u.nome
FROM usuarios u
WHERE u.tipo_usuario = 'ALUNO'
AND NOT EXISTS (
    SELECT 1
    FROM usuario_avaliacao ua
    WHERE ua.id_usuario = u.id_usuario
);

-- 📝 Avaliações sem nenhuma questão cadastrada
SELECT av.id_avaliacao, av.titulo
FROM avaliacoes av
WHERE NOT EXISTS (
    SELECT 1
    FROM avaliacao_questao aq
    WHERE aq.id_avaliacao = av.id_avaliacao
);

-- 📊 Questões que NUNCA foram usadas em nenhuma avaliação
SELECT q.id_questao, q.descricao_questao
FROM questoes q
WHERE NOT EXISTS (
    SELECT 1
    FROM avaliacao_questao aq
    WHERE aq.id_questao = q.id_questao
);

-- 💯 Alunos que tiraram nota máxima em TODAS as avaliações
SELECT u.id_usuario, u.nome
FROM usuarios u
WHERE u.tipo_usuario = 'ALUNO'
AND NOT EXISTS (
    SELECT 1
    FROM usuario_avaliacao ua
    WHERE ua.id_usuario = u.id_usuario
    AND ua.status_resposta = 'CONCLUIDA'
    AND (
        ua.nota_total_obtida IS NULL
        OR ua.nota_total_obtida < (
            SELECT COALESCE(SUM(COALESCE(aq.pontuacao_especifica_na_avaliacao, q.valor_pontuacao)), 0)
            FROM avaliacao_questao aq
            JOIN questoes q ON q.id_questao = aq.id_questao
            WHERE aq.id_avaliacao = ua.id_avaliacao
        )
    )
)
AND EXISTS (
    SELECT 1 
    FROM usuario_avaliacao 
    WHERE id_usuario = u.id_usuario 
    AND status_resposta = 'CONCLUIDA'
);

-- 📈 Alunos acima da média geral
SELECT
    u.id_usuario,
    u.nome,
    ROUND(AVG(COALESCE(ua.nota_total_obtida, 0)), 2) AS media_aluno
FROM usuarios u
JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
WHERE u.tipo_usuario = 'ALUNO'
GROUP BY u.id_usuario, u.nome
HAVING AVG(COALESCE(ua.nota_total_obtida, 0)) > (
    SELECT COALESCE(AVG(COALESCE(nota_total_obtida, 0)), 0)
    FROM usuario_avaliacao
    WHERE nota_total_obtida IS NOT NULL
);

-- ❓ Questões com MAIS de uma alternativa correta
SELECT q.id_questao, q.descricao_questao
FROM questoes q
WHERE q.id_questao IN (
    SELECT id_questao
    FROM opcoes_questao
    WHERE eh_correta = true
    GROUP BY id_questao
    HAVING COUNT(*) > 1
);

-- 📝 Questões que NUNCA foram respondidas
SELECT q.id_questao, q.descricao_questao
FROM questoes q
WHERE NOT EXISTS (
    SELECT 1
    FROM avaliacao_questao aq
    JOIN respostas_questao rq ON rq.id_avaliacao_questao = aq.id_avaliacao_questao
    WHERE aq.id_questao = q.id_questao
)
AND EXISTS (
    SELECT 1 FROM avaliacao_questao WHERE id_questao = q.id_questao
);

-- 0️⃣ Avaliações com pelo menos UM aluno com nota 0
SELECT DISTINCT av.id_avaliacao, av.titulo
FROM avaliacoes av
JOIN usuario_avaliacao ua ON ua.id_avaliacao = av.id_avaliacao
WHERE COALESCE(ua.nota_total_obtida, 0) = 0;

-- 🏆 Top 5 Alunos por Avaliação Específica
SELECT
    u.id_usuario,
    u.nome,
    ua.nota_total_obtida as nota,
    ROUND((ua.nota_total_obtida / 
         (SELECT COALESCE(SUM(COALESCE(aq.pontuacao_especifica_na_avaliacao, q.valor_pontuacao)), 1)
          FROM avaliacao_questao aq
          JOIN questoes q ON q.id_questao = aq.id_questao
          WHERE aq.id_avaliacao = ?)
         ) * 100, 2) AS percentual
FROM usuarios u
JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
WHERE ua.id_avaliacao = ?
AND ua.status_resposta = 'CONCLUIDA'
ORDER BY ua.nota_total_obtida DESC
LIMIT 5;

-- 0️⃣ Alunos que Zeraram uma Avaliação
SELECT u.id_usuario, u.nome
FROM usuarios u
JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
WHERE ua.id_avaliacao = ?
AND COALESCE(ua.nota_total_obtida, 0) = 0
AND ua.status_resposta = 'CONCLUIDA';

-- 📈 Estatísticas Gerais da Avaliação
SELECT
    av.titulo,
    COUNT(DISTINCT ua.id_usuario) as total_alunos,
    COUNT(CASE WHEN ua.status_resposta = 'CONCLUIDA' THEN 1 END) as alunos_concluiram,
    COALESCE(AVG(CASE WHEN ua.status_resposta = 'CONCLUIDA' THEN ua.nota_total_obtida END), 0) as media_geral,
    COALESCE(MAX(CASE WHEN ua.status_resposta = 'CONCLUIDA' THEN ua.nota_total_obtida END), 0) as maior_nota,
    COALESCE(MIN(CASE WHEN ua.status_resposta = 'CONCLUIDA' AND ua.nota_total_obtida > 0 THEN ua.nota_total_obtida END), 0) as menor_nota,
    COUNT(CASE WHEN ua.status_resposta = 'CONCLUIDA' AND COALESCE(ua.nota_total_obtida, 0) = 0 THEN 1 END) as total_zeros,
    (SELECT COUNT(*) FROM avaliacao_questao WHERE id_avaliacao = ?) as total_questoes
FROM avaliacoes av
LEFT JOIN usuario_avaliacao ua ON ua.id_avaliacao = av.id_avaliacao
WHERE av.id_avaliacao = ?
GROUP BY av.id_avaliacao, av.titulo;

-- ================================================
-- REPOSITÓRIO: AvaliacaoQuestaoRepository
-- ================================================

-- Inserir uma questão em uma avaliação
INSERT INTO avaliacao_questao 
(id_avaliacao, id_questao, ordem_na_avaliacao, pontuacao_especifica_na_avaliacao)
VALUES (?, ?, ?, ?);

-- Buscar questões de uma avaliação com detalhes da questão
SELECT aq.*, q.descricao_questao, q.valor_pontuacao as valor_padrao_questao
FROM avaliacao_questao aq
JOIN questoes q ON q.id_questao = aq.id_questao
WHERE aq.id_avaliacao = ?
ORDER BY aq.ordem_na_avaliacao;

-- Deletar todas as questões de uma avaliação
DELETE FROM avaliacao_questao WHERE id_avaliacao = ?;

-- Deletar questão específica da avaliação
DELETE FROM avaliacao_questao WHERE id_avaliacao_questao = ?;

-- Deletar relação específica avaliação-questão
DELETE FROM avaliacao_questao WHERE id_avaliacao = ? AND id_questao = ?;

-- Buscar por ID
SELECT * FROM avaliacao_questao WHERE id_avaliacao_questao = ?;

-- Verificar se questão já está na avaliação
SELECT COUNT(*) FROM avaliacao_questao WHERE id_avaliacao = ? AND id_questao = ?;

-- Contar questões de uma avaliação
SELECT COUNT(*) FROM avaliacao_questao WHERE id_avaliacao = ?;

-- Atualizar ordem de uma questão na avaliação
UPDATE avaliacao_questao SET ordem_na_avaliacao = ? WHERE id_avaliacao = ? AND id_questao = ?;

-- Atualizar pontuação específica de uma questão
UPDATE avaliacao_questao SET pontuacao_especifica_na_avaliacao = ? WHERE id_avaliacao_questao = ?;

-- ================================================
-- REPOSITÓRIO: AvaliacaoRepository
-- ================================================

-- Inserir nova avaliação
INSERT INTO avaliacoes 
(id_usuario_criador, titulo, descricao, data_inicio, data_fim, 
 duracao_minutos, status)
VALUES (?, ?, ?, ?, ?, ?, ?);

-- Buscar avaliações por criador
SELECT * FROM avaliacoes WHERE id_usuario_criador = ? ORDER BY id_avaliacao DESC;

-- Buscar avaliação por ID
SELECT * FROM avaliacoes WHERE id_avaliacao = ?;

-- Atualizar avaliação
UPDATE avaliacoes SET 
titulo=?, descricao=?, data_inicio=?, data_fim=?, 
duracao_minutos=?, status=?
WHERE id_avaliacao=?;

-- Excluir avaliação
DELETE FROM avaliacoes WHERE id_avaliacao = ?;

-- Buscar avaliações disponíveis (ativas e dentro do período)
SELECT * FROM avaliacoes 
WHERE status = 'ATIVA' 
AND (data_inicio IS NULL OR data_inicio <= NOW())
AND (data_fim IS NULL OR data_fim >= NOW())
ORDER BY id_avaliacao DESC;

-- Listar todas as avaliações
SELECT * FROM avaliacoes ORDER BY id_avaliacao DESC;

-- ================================================
-- REPOSITÓRIO: OpcaoQuestaoRepository
-- ================================================

-- Listar opções de uma questão
SELECT * FROM opcoes_questao WHERE id_questao = ? ORDER BY ordem;

-- Inserir nova opção
INSERT INTO opcoes_questao (id_questao, texto_opcao, eh_correta, ordem)
VALUES (?, ?, ?, ?);

-- Deletar todas as opções de uma questão
DELETE FROM opcoes_questao WHERE id_questao = ?;

-- Deletar opção específica
DELETE FROM opcoes_questao WHERE id_opcao = ?;

-- ================================================
-- REPOSITÓRIO: QuestaoRepository
-- ================================================

-- Listar todas as questões
SELECT * FROM questoes ORDER BY data_criacao DESC;

-- Buscar questão por ID
SELECT * FROM questoes WHERE id_questao = ?;

-- Inserir nova questão
INSERT INTO questoes 
(descricao_questao, tipo_questao, valor_pontuacao, feedback_correto, 
 feedback_incorreto, data_criacao, id_usuario_criador)
VALUES (?, ?, ?, ?, ?, ?, ?);

-- Atualizar questão
UPDATE questoes 
SET descricao_questao=?, tipo_questao=?, valor_pontuacao=?, 
    feedback_correto=?, feedback_incorreto=?
WHERE id_questao=?;

-- Deletar questão
DELETE FROM questoes WHERE id_questao = ?;

-- Buscar questões por criador
SELECT * FROM questoes WHERE id_usuario_criador = ? ORDER BY data_criacao DESC;

-- Buscar questões por tipo
SELECT * FROM questoes WHERE tipo_questao = ? ORDER BY data_criacao DESC;

-- Buscar questões não utilizadas em avaliações
SELECT q.* FROM questoes q
LEFT JOIN avaliacao_questao aq ON q.id_questao = aq.id_questao
WHERE aq.id_avaliacao_questao IS NULL
ORDER BY q.data_criacao DESC;

-- Buscar questões com opções corretas
SELECT DISTINCT q.* 
FROM questoes q
JOIN opcoes_questao oq ON q.id_questao = oq.id_questao
WHERE oq.eh_correta = true
ORDER BY q.data_criacao DESC;

-- Buscar questões sem opções corretas (tipo múltipla escolha)
SELECT q.*
FROM questoes q
WHERE q.tipo_questao = 'MULTIPLA_ESCOLHA'
AND NOT EXISTS (
    SELECT 1
    FROM opcoes_questao oq
    WHERE oq.id_questao = q.id_questao
    AND oq.eh_correta = true
)
ORDER BY q.data_criacao DESC;

-- Contar questões por usuário
SELECT COUNT(*) FROM questoes WHERE id_usuario_criador = ?;

-- Buscar questões por descrição (busca parcial)
SELECT * FROM questoes WHERE descricao_questao ILIKE ? ORDER BY data_criacao DESC;

-- ================================================
-- REPOSITÓRIO: RespostaQuestaoRepository
-- ================================================

-- Buscar respostas por usuário_avaliacao
SELECT * FROM respostas_questao WHERE id_usuario_avaliacao = ?;

-- Buscar resposta por ID
SELECT * FROM respostas_questao WHERE id_resposta_questao = ?;

-- Buscar resposta específica por usuário e questão
SELECT * FROM respostas_questao WHERE id_usuario_avaliacao = ? AND id_avaliacao_questao = ?;

-- Inserir nova resposta
INSERT INTO respostas_questao (id_usuario_avaliacao, id_avaliacao_questao, texto_resposta, 
id_opcao_selecionada, nota_obtida, data_resposta) 
VALUES (?, ?, ?, ?, ?, ?);

-- Atualizar resposta
UPDATE respostas_questao SET texto_resposta = ?, id_opcao_selecionada = ?, 
nota_obtida = ?, data_resposta = ? WHERE id_resposta_questao = ?;

-- ================================================
-- REPOSITÓRIO: UsuarioAvaliacaoRepository
-- ================================================

-- Buscar por ID
SELECT * FROM usuario_avaliacao WHERE id_usuario_avaliacao = ?;

-- Buscar por usuário e avaliação
SELECT * FROM usuario_avaliacao WHERE id_usuario = ? AND id_avaliacao = ?;

-- Listar por avaliação
SELECT * FROM usuario_avaliacao WHERE id_avaliacao = ?;

-- Listar por usuário
SELECT * FROM usuario_avaliacao WHERE id_usuario = ? ORDER BY data_inicio_real DESC;

-- Inserir nova relação usuário-avaliação
INSERT INTO usuario_avaliacao (id_usuario, id_avaliacao, data_inicio_real, status_resposta, nota_total_obtida) 
VALUES (?, ?, ?, ?, ?);

-- Atualizar relação usuário-avaliação
UPDATE usuario_avaliacao SET data_fim_real = ?, status_resposta = ?, nota_total_obtida = ? 
WHERE id_usuario_avaliacao = ?;

-- Atualizar apenas o status
UPDATE usuario_avaliacao SET status_resposta = ? WHERE id_usuario_avaliacao = ?;

-- Atualizar apenas a nota
UPDATE usuario_avaliacao SET nota_total_obtida = ? WHERE id_usuario_avaliacao = ?;

-- ================================================
-- REPOSITÓRIO: UsuarioRepository
-- ================================================

-- Listar todos os usuários
SELECT * FROM usuarios ORDER BY id_usuario;

-- Buscar usuário por ID
SELECT * FROM usuarios WHERE id_usuario = ?;

-- Inserir novo usuário
INSERT INTO usuarios (nome, email, senha, tipo_usuario, data_cadastro, ativo)
VALUES (?, ?, ?, ?, now(), ?);

-- Atualizar usuário
UPDATE usuarios
SET nome=?, email=?, senha=?, tipo_usuario=?, ativo=?
WHERE id_usuario=?;

-- Deletar usuário
DELETE FROM usuarios WHERE id_usuario=?;

-- Contar usuários (teste de conexão)
SELECT COUNT(*) FROM usuarios;

-- Buscar usuário por email e senha
SELECT * FROM usuarios WHERE email = ? AND senha = ? AND ativo = true;

-- Buscar usuários por tipo
SELECT * FROM usuarios WHERE tipo_usuario = ? AND ativo = true ORDER BY nome;

-- Verificar se email já existe
SELECT COUNT(*) FROM usuarios WHERE email = ?;

-- Desativar usuário
UPDATE usuarios SET ativo = false WHERE id_usuario = ?;
