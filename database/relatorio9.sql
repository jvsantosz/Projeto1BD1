-- Avaliações com pelo menos UM aluno com nota 0

SELECT av.id_avaliacao, av.titulo
FROM avaliacoes av
WHERE EXISTS (
    SELECT 1
    FROM usuario_avaliacao ua
    JOIN respostas_questao rq
         ON rq.id_usuario_avaliacao = ua.id_usuario_avaliacao
    WHERE ua.id_avaliacao = av.id_avaliacao
    GROUP BY ua.id_usuario
    HAVING SUM(rq.nota_obtida) = 0
);
