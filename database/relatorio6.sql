-- Alunos acima da média geral

SELECT
    u.id_usuario,
    u.nome,
    ROUND(AVG(rq.nota_obtida), 2) AS media_aluno
FROM usuarios u
JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
JOIN respostas_questao rq ON rq.id_usuario_avaliacao = ua.id_usuario_avaliacao
GROUP BY u.id_usuario, u.nome
HAVING AVG(rq.nota_obtida) >
       (SELECT AVG(nota_obtida) FROM respostas_questao);
