-- Avaliações com tempo de duração ACIMA da média

SELECT id_avaliacao, titulo, duracao_minutos
FROM avaliacoes
WHERE duracao_minutos >
      (SELECT AVG(duracao_minutos) FROM avaliacoes);
