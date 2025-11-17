--  Alunos que tiraram 100% em TODAS as Avaliações

SELECT 
    u.id_usuario,
    u.nome
FROM usuarios u
WHERE 100 <= ALL (
    SELECT 
        ROUND(
            (SUM(rq.nota_obtida) /
             (SELECT SUM(COALESCE(aq.pontuacao_especifica_na_avaliacao, q.valor_pontuacao))
              FROM avaliacao_questao aq
              JOIN questoes q ON q.id_questao = aq.id_questao
              WHERE aq.id_avaliacao = ua.id_avaliacao
             ) * 100), 2)
        AS nota_percentual
    FROM usuario_avaliacao ua
    JOIN respostas_questao rq ON rq.id_usuario_avaliacao = ua.id_usuario_avaliacao
    WHERE ua.id_usuario = u.id_usuario
    GROUP BY ua.id_avaliacao
);
