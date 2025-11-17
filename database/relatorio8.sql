-- Questões que NUNCA foram respondidas

SELECT q.id_questao, q.descricao_questao
FROM questoes q
WHERE NOT EXISTS (
    SELECT 1
    FROM avaliacao_questao aq
    JOIN respostas_questao rq 
         ON rq.id_avaliacao_questao = aq.id_avaliacao_questao
    WHERE aq.id_questao = q.id_questao
);
