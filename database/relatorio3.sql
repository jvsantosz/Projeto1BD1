-- Avaliações sem nenhuma questão cadastrada

SELECT av.id_avaliacao, av.titulo
FROM avaliacoes av
WHERE NOT EXISTS (
    SELECT 1
    FROM avaliacao_questao aq
    WHERE aq.id_avaliacao = av.id_avaliacao
);
