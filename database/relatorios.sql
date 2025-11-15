WITH AvaliacaoTotal AS (
    SELECT
        aq.id_avaliacao,
        SUM(aq.valor) AS valor_total
    FROM avaliacao_questao aq
    GROUP BY aq.id_avaliacao
    HAVING SUM(aq.valor) > 0
),

AlunoPontuacao AS (
    SELECT
        a.id_usuario AS id_aluno,
        a.id_avaliacao,
        COALESCE(SUM(nr.nota), 0) AS pontos_obtidos
    FROM atribuicao a
    LEFT JOIN resposta r ON r.id_atribuicao = a.id
    LEFT JOIN nota_resposta nr ON nr.id_resposta = r.id
    GROUP BY a.id_usuario, a.id_avaliacao
),

AlunoNota AS (
    SELECT
        ap.id_aluno,
        ap.id_avaliacao,
        CASE 
            WHEN at.valor_total > 0 THEN 
                (ap.pontos_obtidos / at.valor_total) * 100
            ELSE 0 
        END AS nota_percentual
    FROM AlunoPontuacao ap
    JOIN AvaliacaoTotal at ON at.id_avaliacao = ap.id_avaliacao
)

SELECT
    u.id AS id_aluno,
    u.nome_completo AS nome_aluno,
    c.id AS id_curso,
    c.nome AS nome_curso,
    ROUND(AVG(an.nota_percentual), 2) AS nota_final_percentual,
    COUNT(an.id_avaliacao) AS quantidade_avaliacoes
FROM usuario u
JOIN atribuicao a ON a.id_usuario = u.id
JOIN avaliacao av ON av.id = a.id_avaliacao
JOIN curso c ON c.id = av.id_curso
JOIN AlunoNota an ON an.id_aluno = u.id 
                  AND an.id_avaliacao = av.id   -- INNER JOIN correto
WHERE u.id_papel = (SELECT id FROM papel WHERE nome = 'ALUNO')
GROUP BY u.id, u.nome_completo, c.id, c.nome
ORDER BY u.nome_completo, c.nome;
