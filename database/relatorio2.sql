-- Alunos que NUNCA fizeram avaliação

SELECT u.id_usuario, u.nome
FROM usuarios u
WHERE NOT EXISTS (
    SELECT 1
    FROM usuario_avaliacao ua
    WHERE ua.id_usuario = u.id_usuario
);
