WITH AvaliacaoTotal AS (
    -- 1. Calcula a pontuação máxima de cada avaliação
    SELECT
        aq.id_avaliacao,
        SUM(aq.valor) AS valor_total
    FROM avaliacao_questao aq
    GROUP BY aq.id_avaliacao
),
AlunoPontuacao AS (
    -- 2. Calcula a pontuação obtida por cada aluno em cada avaliação
    SELECT
        r.id_aluno,
        r.id_avaliacao,
        SUM(r.pontos) AS pontos_obtidos
    FROM resposta r
    GROUP BY r.id_aluno, r.id_avaliacao
),
AlunoNota AS (
    -- 3. Combina as duas para calcular a nota percentual de cada avaliação
    SELECT
        ap.id_aluno,
        ap.id_avaliacao,
        (ap.pontos_obtidos::decimal / at.valor_total) * 100 AS nota_percentual
    FROM AlunoPontuacao ap
    JOIN AvaliacaoTotal at ON ap.id_avaliacao = at.id_avaliacao
)
-- 4. Nota final por disciplina
SELECT
    a.id_aluno,
    a.nome AS nome_aluno,
    d.id_disciplina,
    d.nome AS nome_disciplina,
    AVG(an.nota_percentual) AS nota_final_percentual
FROM AlunoNota an
JOIN avaliacao av ON an.id_avaliacao = av.id_avaliacao
JOIN disciplina d ON av.id_disciplina = d.id_disciplina
JOIN aluno a ON an.id_aluno = a.id_aluno
GROUP BY a.id_aluno, a.nome, d.id_disciplina, d.nome
ORDER BY a.nome, d.nome;
