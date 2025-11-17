-- Questões com MAIS de uma alternativa correta

SELECT q.id_questao, q.descricao_questao
FROM questoes q
WHERE q.id_questao IN (
    SELECT id_questao
    FROM opcoes_questao
    WHERE eh_correta = TRUE
    GROUP BY id_questao
    HAVING COUNT(*) > 1
);
