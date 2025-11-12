WITH AvaliacaoTotal AS (
    -- 1. Valor total de cada avaliação
    SELECT
        aq.id_avaliacao,
        SUM(aq.valor) AS valor_total
    FROM avaliacao_questao aq
    GROUP BY aq.id_avaliacao
),
AlunoPontuacao AS (
    -- 2. Soma das notas obtidas por aluno em cada avaliação
    SELECT
        a.id_usuario AS id_aluno,
        a.id_avaliacao,
        SUM(nr.nota) AS pontos_obtidos
    FROM atribuicao a
    JOIN resposta r ON r.id_atribuicao = a.id
    JOIN nota_resposta nr ON nr.id_resposta = r.id
    GROUP BY a.id_usuario, a.id_avaliacao
),
AlunoNota AS (
    -- 3. Calcula nota percentual por avaliação
    SELECT
        ap.id_aluno,
        ap.id_avaliacao,
        (ap.pontos_obtidos / at.valor_total) * 100 AS nota_percentual
    FROM AlunoPontuacao ap
    JOIN AvaliacaoTotal at ON ap.id_avaliacao = at.id_avaliacao
)
-- 4. Nota final por curso/disciplina
SELECT
    u.id AS id_aluno,
    u.nome_completo AS nome_aluno,
    c.id AS id_curso,
    c.nome AS nome_curso,
    ROUND(AVG(an.nota_percentual), 2) AS nota_final_percentual
FROM AlunoNota an
JOIN avaliacao av ON an.id_avaliacao = av.id
JOIN curso c ON av.id_curso = c.id
JOIN usuario u ON an.id_aluno = u.id
GROUP BY u.id, u.nome_completo, c.id, c.nome
ORDER BY u.nome_completo, c.nome;
