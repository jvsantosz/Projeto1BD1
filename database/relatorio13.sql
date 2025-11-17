-- Ranking dos 5 alunos com maior média geral

SELECT
    u.id_usuario,
    u.nome,
    ROUND(AVG(rq.nota_obtida), 2) AS media_geral
FROM usuarios u
JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
JOIN respostas_questao rq ON rq.id_usuario_avaliacao = ua.id_usuario_avaliacao
GROUP BY u.id_usuario, u.nome
ORDER BY media_geral DESC
LIMIT 5;
