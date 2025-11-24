<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Estatísticas - Avaliação</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .header {
            background: rgba(255, 255, 255, 0.95);
            padding: 20px 40px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.1);
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        .btn-primary { background: #667eea; color: white; }
        .btn-warning { background: #f39c12; color: white; }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .stat-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            margin: 10px 0;
        }
        .stat-label {
            font-size: 0.9em;
            color: #666;
        }
        .excelente { color: #28a745; }
        .bom { color: #17a2b8; }
        .regular { color: #ffc107; }
        .ruim { color: #dc3545; }
        .distribuicao {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 10px;
            margin: 20px 0;
        }
        .faixa {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }
        .progress-bar {
            background: #e9ecef;
            border-radius: 10px;
            height: 20px;
            margin: 10px 0;
            overflow: hidden;
        }
        .progress {
            height: 100%;
            border-radius: 10px;
        }
        .progress-excelente { background: #28a745; }
        .progress-bom { background: #17a2b8; }
        .progress-regular { background: #ffc107; }
        .progress-ruim { background: #dc3545; }
    </style>
</head>
<body>
<div class="header">
    <h1>📈 Estatísticas da Avaliação</h1>
    <div>
        <a href="/professor/relatorios" class="btn btn-warning">📊 Voltar aos Relatórios</a>
        <a href="/professor/relatorios/top5-avaliacao/${idAvaliacao}" class="btn btn-primary">🏆 Ver Top 5</a>
    </div>
</div>

<div class="container">
    <div class="card">
        <h2>🎯 Desempenho da Turma</h2>
        <p style="color: #666; margin-bottom: 20px;">
            Estatísticas gerais do desempenho dos alunos nesta avaliação
        </p>

        <c:if test="${empty estatisticas}">
            <div style="text-align: center; padding: 40px; color: #666;">
                <h3>📝 Dados Insuficientes</h3>
                <p>Não há dados estatísticos disponíveis para esta avaliação ainda.</p>
            </div>
        </c:if>

        <c:if test="${not empty estatisticas}">
            <!-- Estatísticas Principais -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Total de Alunos</div>
                    <div class="stat-number">${estatisticas.totalAlunos}</div>
                    <small>Matriculados</small>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Concluíram</div>
                    <div class="stat-number">${estatisticas.alunosConcluiram}</div>
                    <small>Finalizaram a prova</small>
                </div>
                <div class="stat-card">
                    <div class="stat-label
                        <c:choose>
                            <c:when test="${estatisticas.mediaGeral >= 70}">excelente</c:when>
                            <c:when test="${estatisticas.mediaGeral >= 50}">bom</c:when>
                            <c:otherwise>ruim</c:otherwise>
                        </c:choose>">
                        Média da Turma
                    </div>
                    <div class="stat-number">${estatisticas.mediaGeral}</div>
                    <small>Pontos</small>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Zeraram</div>
                    <div class="stat-number ruim">${estatisticas.totalZeros}</div>
                    <small>Nota zero</small>
                </div>
            </div>

            <!-- Notas Extremas -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 30px 0;">
                <div style="background: #d4edda; padding: 20px; border-radius: 10px; text-align: center;">
                    <div class="stat-label">🏆 Maior Nota</div>
                    <div class="stat-number excelente">${estatisticas.maiorNota}</div>
                    <small>Melhor desempenho</small>
                </div>
                <div style="background: #f8d7da; padding: 20px; border-radius: 10px; text-align: center;">
                    <div class="stat-label">📉 Menor Nota</div>
                    <div class="stat-number ruim">${estatisticas.menorNota}</div>
                    <small>Pior desempenho</small>
                </div>
            </div>

            <!-- Taxa de Conclusão -->
            <div style="background: #e7f3ff; padding: 20px; border-radius: 10px; margin: 20px 0;">
                <h4>📊 Taxa de Conclusão</h4>
                <c:set var="percentualConclusao" value="${(estatisticas.alunosConcluiram / estatisticas.totalAlunos) * 100}" />
                <div style="display: flex; justify-content: space-between; margin: 10px 0;">
                    <span>Progresso:</span>
                    <span><strong>${estatisticas.alunosConcluiram}</strong> de <strong>${estatisticas.totalAlunos}</strong> alunos</span>
                </div>
                <div class="progress-bar">
                    <div class="progress progress-bom" style="width: ${percentualConclusao}%"></div>
                </div>
                <div style="text-align: center; margin-top: 10px;">
                    <strong><fmt:formatNumber value="${percentualConclusao}" maxFractionDigits="1" />%</strong> de conclusão
                </div>
            </div>

            <!-- Análise do Professor -->
            <div style="background: #fff3cd; padding: 20px; border-radius: 10px; margin-top: 20px;">
                <h4>💡 Análise do Desempenho</h4>
                <c:choose>
                    <c:when test="${estatisticas.mediaGeral >= 70}">
                        <p>✅ <strong>Excelente desempenho da turma!</strong> A média indica que a maioria dos alunos compreendeu bem o conteúdo.</p>
                    </c:when>
                    <c:when test="${estatisticas.mediaGeral >= 50}">
                        <p>⚠️ <strong>Desempenho regular.</strong> Considere revisar alguns tópicos com a turma.</p>
                    </c:when>
                    <c:otherwise>
                        <p>❌ <strong>Desempenho abaixo do esperado.</strong> Recomenda-se revisão completa do conteúdo e possivelmente nova aplicação.</p>
                    </c:otherwise>
                </c:choose>

                <c:if test="${estatisticas.totalZeros > 0}">
                    <p>📌 <strong>${estatisticas.totalZeros} aluno(s) zerou/zeraram a avaliação.</strong> Verifique se houve problemas de acesso ou compreensão.</p>
                </c:if>

                <c:if test="${percentualConclusao < 100}">
                    <p>⏰ <strong>Atenção:</strong> ${100 - percentualConclusao}% dos alunos ainda não concluíram a avaliação.</p>
                </c:if>
            </div>
        </c:if>
    </div>
</div>
</body>
</html>