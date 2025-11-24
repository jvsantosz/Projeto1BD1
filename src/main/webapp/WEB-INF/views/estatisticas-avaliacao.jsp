<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Estatísticas - ${estatisticas.tituloAvaliacao}</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #17a2b8; padding-bottom: 10px; }
        .btn { padding: 8px 16px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .stat-card { background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2em; font-weight: bold; }
        .stat-card.primary .stat-number { color: #667eea; }
        .stat-card.success .stat-number { color: #28a745; }
        .stat-card.warning .stat-number { color: #ffc107; }
        .stat-card.info .stat-number { color: #17a2b8; }
        .performance-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 20px 0; }
        .performance-card { background: #f8f9fa; padding: 15px; border-radius: 8px; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>📈 Estatísticas - ${estatisticas.tituloAvaliacao}</h1>
        <a href="/professor/relatorios" class="btn">← Voltar</a>
    </div>

    <c:if test="${not empty estatisticas && estatisticas.tituloAvaliacao != 'Avaliação não encontrada'}">
        <!-- Informações da Avaliação -->
        <div style="background: #e7f3ff; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
            <h3 style="margin: 0 0 10px 0;">📝 ${estatisticas.tituloAvaliacao}</h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; font-size: 0.9em;">
                <div><strong>ID:</strong> ${idAvaliacao}</div>
                <div><strong>Questões:</strong> ${estatisticas.totalQuestoes}</div>
                <div><strong>Alunos:</strong> ${estatisticas.totalAlunos}</div>
            </div>
        </div>

        <!-- Estatísticas Principais -->
        <div class="stats-grid">
            <div class="stat-card primary">
                <div>Participantes</div>
                <div class="stat-number">${estatisticas.totalAlunos}</div>
            </div>
            <div class="stat-card success">
                <div>Nota Média</div>
                <div class="stat-number"><fmt:formatNumber value="${estatisticas.mediaGeral}" pattern="#.##"/></div>
            </div>
            <div class="stat-card warning">
                <div>Taxa de Conclusão</div>
                <div class="stat-number"><fmt:formatNumber value="${estatisticas.taxaConclusao}" pattern="#.##"/>%</div>
                <div style="font-size: 0.8em; color: #666;">
                        ${estatisticas.alunosConcluiram} concluíram
                </div>
            </div>
            <div class="stat-card info">
                <div>Maior Nota</div>
                <div class="stat-number">${estatisticas.maiorNota}</div>
            </div>
        </div>

        <!-- Performance Detalhada -->
        <div class="performance-grid">
            <div class="performance-card">
                <h4>📊 Distribuição de Desempenho</h4>
                <div style="display: grid; gap: 10px;">
                    <div>
                        <strong>Menor Nota:</strong> ${estatisticas.menorNota}
                    </div>
                    <div>
                        <strong>Alunos com Zero:</strong> ${estatisticas.totalZeros}
                    </div>
                    <div>
                        <strong>Alunos Acima da Média:</strong>
                        <c:set var="acimaMedia" value="${estatisticas.alunosConcluiram - estatisticas.totalZeros}" />
                            ${acimaMedia}
                    </div>
                </div>
            </div>

            <div class="performance-card">
                <h4>📈 Análise de Desempenho</h4>
                <div style="display: grid; gap: 10px;">
                    <c:choose>
                        <c:when test="${estatisticas.mediaGeral >= 80}">
                            <div style="color: #28a745;">✅ Avaliação considerada Fácil</div>
                        </c:when>
                        <c:when test="${estatisticas.mediaGeral >= 60}">
                            <div style="color: #ffc107;">⚠️ Avaliação considerada Moderada</div>
                        </c:when>
                        <c:otherwise>
                            <div style="color: #dc3545;">❌ Avaliação considerada Difícil</div>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${estatisticas.taxaConclusao >= 90}">
                            <div style="color: #28a745;">✅ Alta taxa de participação</div>
                        </c:when>
                        <c:when test="${estatisticas.taxaConclusao >= 70}">
                            <div style="color: #ffc107;">⚠️ Participação moderada</div>
                        </c:when>
                        <c:otherwise>
                            <div style="color: #dc3545;">❌ Baixa participação</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </c:if>

    <c:if test="${empty estatisticas || estatisticas.tituloAvaliacao == 'Avaliação não encontrada'}">
        <div style="text-align: center; padding: 40px; color: #666;">
            <div style="font-size: 3em;">❌</div>
            <h3>Estatísticas não disponíveis</h3>
            <p>Não foi possível carregar as estatísticas para esta avaliação.</p>
            <p style="font-size: 0.9em; color: #999;">
                A avaliação pode não existir ou não ter dados suficientes.
            </p>
        </div>
    </c:if>
</div>
</body>
</html>