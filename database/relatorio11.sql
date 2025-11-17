-- Alunos que responderam TODAS as avaliações atribuídas

SELECT u.id_usuario, u.nome
FROM usuarios u
WHERE NOT EXISTS (
    SELECT 1
    FROM usuario_avaliacao ua
    WHERE ua.id_usuario = u.id_usuario
      AND NOT EXISTS (
        SELECT 1
        FROM respostas_questao rq
        WHERE rq.id_usuario_avaliacao = ua.id_usuario_avaliacao
      )
);
