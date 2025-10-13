# Relatórios Planejados – Sistema de Avaliação

Este documento descreve os relatórios que serão implementados no sistema de avaliações, explorando **consultas SQL avançadas** (junções, agregações, agrupamentos, ranking, ordenações, subconsultas, filtros etc.) e apresentados em **tabelas e gráficos** no front-end.

---

## 1. Média geral por avaliação
- **Descrição**: mostra a média das notas de todos os usuários em uma avaliação específica.  
- **SQL**: `AVG(nota_obtida)` agrupado por avaliação.  
- **Visualização**: gráfico de barras comparando avaliações.  

---

## 2. Desempenho individual vs turma
- **Descrição**: compara a média de um usuário com a média geral da turma em cada avaliação.  
- **SQL**: `JOIN` entre respostas de um usuário e todos os usuários, cálculo com `AVG`.  
- **Visualização**: gráfico de linhas (usuário vs turma).  

---

## 3. Questões com maior índice de erro
- **Descrição**: identifica as questões com mais erros em determinada avaliação.  
- **SQL**: `COUNT` + `GROUP BY` questão, filtrando respostas incorretas.  
- **Visualização**: gráfico de barras horizontais (questão × % de acertos).  

---

## 4. Ranking de usuários
- **Descrição**: mostra a classificação dos alunos em cada avaliação de acordo com a nota final.  
- **SQL**: `SUM(nota_obtida)` por usuário, `ORDER BY` desc, usando `RANK()` ou `DENSE_RANK()`.  
- **Visualização**: tabela estilo ranking (posição, usuário, nota).  

---

## 5. Evolução temporal do desempenho
- **Descrição**: acompanha a evolução das notas de um aluno ao longo do tempo.  
- **SQL**: `AVG(nota_obtida)` agrupado por data/avaliação.  
- **Visualização**: gráfico de linha temporal (datas × nota).  

---

## 6. Participação de usuários
- **Descrição**: mostra a porcentagem de usuários que responderam ou não cada avaliação.  
- **SQL**: subconsulta com `COUNT(respostas)` dividido pelo número total de usuários esperados.  
- **Visualização**: gráfico de pizza ou barra.  

---

## 7. Distribuição de notas por questão
- **Descrição**: mostra como as notas estão distribuídas em cada questão (quem acertou, quem errou, quem deixou em branco).  
- **SQL**: `GROUP BY questao_id`, `COUNT` por tipo de resposta.  
- **Visualização**: gráfico para cada questão. 

---

## 8. Relatório de desempenho agregado
- **Descrição**: mostra estatísticas como **maior nota, menor nota, média e mediana** de uma avaliação.  
- **SQL**: `MAX`, `MIN`, `AVG` e subconsulta para calcular a mediana.  
- **Visualização**: tabela resumo.  

---

## 📌 Observações
- Todos os relatórios serão acessados via **controllers** no back-end, consultando os dados no **PostgreSQL**.  
- O front-end exibirá as informações em **gráficos interativos (React + Chart.js / Recharts)** e **tabelas dinâmicas**.  
- Um relatório pode utilizar **múltiplas consultas SQL** combinadas para enriquecer as visualizações.  
