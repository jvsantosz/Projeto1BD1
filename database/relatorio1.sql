-- Nota Percentual por Aluno em Cada Avaliação
SELECT
    u.id_usuario,
    u.nome,
    av.id_avaliacao,
    av.titulo,
    ROUND((
        -- pontos do aluno (subquery)
        (SELECT SUM(COALESCE(rq.nota_obtida, 0))
         FROM usuario_avaliacao ua
         JOIN respostas_questao rq 
              ON rq.id_usuario_avaliacao = ua.id_usuario_avaliacao
         WHERE ua.id_usuario = u.id_usuario
           AND ua.id_avaliacao = av.id_avaliacao
        ) 
        /
        -- valor total da avaliação (subquery)
        (SELECT SUM(COALESCE(aq.pontuacao_especifica_na_avaliacao, q.valor_pontuacao))
         FROM avaliacao_questao aq
         JOIN questoes q ON q.id_questao = aq.id_questao
         WHERE aq.id_avaliacao = av.id_avaliacao)
    ) * 100, 2) AS nota_percentual
FROM usuarios u
JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
JOIN avaliacoes av ON av.id_avaliacao = ua.id_avaliacao
ORDER BY u.nome, av.titulo;
