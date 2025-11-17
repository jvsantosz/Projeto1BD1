 -- Questões que NUNCA foram usadas em nenhuma avaliação

SELECT q.id_questao, q.descricao_questao
FROM questoes q
WHERE q.id_questao NOT IN (
    SELECT id_questao FROM avaliacao_questao
);
