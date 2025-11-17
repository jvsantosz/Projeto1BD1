-- Questões onde TODAS as alternativas são incorretas

SELECT q.id_questao, q.descricao_questao
FROM questoes q
WHERE TRUE = ALL (
    SELECT NOT eh_correta
    FROM opcoes_questao
    WHERE id_questao = q.id_questao
);
