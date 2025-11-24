<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Top 5 - Avaliação ${idAvaliacao}</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1000px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #667eea; padding-bottom: 10px; }
        .btn { padding: 8px 16px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; }
        .ranking-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        .ranking-table th, .ranking-table td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        .ranking-table th { background: #667eea; color: white; }
        .ranking-table tr:hover { background: #f5f5f5; }
        .medal { font-size: 1.5em; margin-right: 10px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .stat-card { background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2em; font-weight: bold; color: #667eea; }
        .avaliacao-info { background: #e7f3ff; padding: 15px; border-radius: 8px; margin: 20px 0; }
        .percent-badge { background: #28a745; color: white; padding: 3px 8px; border-radius: 12px; font-size: 0.8em; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>🏆 Top 5 - Avaliação ${idAvaliacao}</h1>
        <a href="/professor/relatorios" class="btn">← Voltar aos Relatórios</a>
    </div>

    <!-- Informações da Avaliação -->
    <div class="avaliacao-info">
        <h3 style="margin: 0 0 10px 0;">📝 Avaliação ID: ${idAvaliacao}</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px;">
            <div><strong>ID:</strong> ${idAvaliacao}</div>
            <div><strong>Total de Alunos:</strong> ${top5Alunos.size()}</div>
        </div>
    </div>

    <c:if test="${not empty top5Alunos}">
        <div class="stats-grid">
            <div class="stat-card">
                <div>Melhor Nota</div>
                <div class="stat-number">
                    <fmt:formatNumber value="${top5Alunos[0].nota}" pattern="#.##"/>
                </div>
            </div>
            <div class="stat-card">
                <div>Melhor Percentual</div>
                <div class="stat-number">
                    <fmt:formatNumber value="${top5Alunos[0].percentual}" pattern="#.##"/>%
                </div>
            </div>
            <div class="stat-card">
                <div>Média do Top 5</div>
                <div class="stat-number">
                    <c:set var="somaNotas" value="0" />
                    <c:forEach items="${top5Alunos}" var="aluno">
                        <c:set var="somaNotas" value="${somaNotas + aluno.nota.doubleValue()}" />
                    </c:forEach>
                    <fmt:formatNumber value="${somaNotas / top5Alunos.size()}" pattern="#.##"/>
                </div>
            </div>
            <div class="stat-card">
                <div>Participantes</div>
                <div class="stat-number">${top5Alunos.size()}</div>
            </div>
        </div>

        <table class="ranking-table">
            <thead>
            <tr>
                <th>Posição</th>
                <th>Aluno</th>
                <th>Nota</th>
                <th>Percentual</th>
                <th>Desempenho</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${top5Alunos}" var="aluno" varStatus="status">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${status.index == 0}"><span class="medal">🥇</span> 1º</c:when>
                            <c:when test="${status.index == 1}"><span class="medal">🥈</span> 2º</c:when>
                            <c:when test="${status.index == 2}"><span class="medal">🥉</span> 3º</c:when>
                            <c:otherwise>${status.index + 1}º</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <strong>${aluno.nome}</strong>
                        <div style="font-size: 0.8em; color: #666;">ID: ${aluno.idUsuario}</div>
                    </td>
                    <td><strong><fmt:formatNumber value="${aluno.nota}" pattern="#.##"/></strong></td>
                    <td>
                        <span class="percent-badge">
                            <fmt:formatNumber value="${aluno.percentual}" pattern="#.##"/>%
                        </span>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${aluno.percentual >= 90}">
                                <span style="color: #28a745;">⭐ Excelente</span>
                            </c:when>
                            <c:when test="${aluno.percentual >= 70}">
                                <span style="color: #17a2b8;">📊 Bom</span>
                            </c:when>
                            <c:when test="${aluno.percentual >= 50}">
                                <span style="color: #ffc107;">📈 Regular</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #dc3545;">📉 Insuficiente</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- Informações Adicionais -->
        <div style="background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 20px;">
            <h4 style="margin: 0 0 10px 0;">📈 Análise do Desempenho</h4>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; font-size: 0.9em;">
                <div>
                    <strong>Maior Nota:</strong>
                    <fmt:formatNumber value="${top5Alunos[0].nota}" pattern="#.##"/>
                </div>
                <div>
                    <strong>Menor Nota do Top 5:</strong>
                    <fmt:formatNumber value="${top5Alunos[top5Alunos.size()-1].nota}" pattern="#.##"/>
                </div>
                <div>
                    <strong>Maior Percentual:</strong>
                    <fmt:formatNumber value="${top5Alunos[0].percentual}" pattern="#.##"/>%
                </div>
                <div>
                    <strong>Menor Percentual:</strong>
                    <fmt:formatNumber value="${top5Alunos[top5Alunos.size()-1].percentual}" pattern="#.##"/>%
                </div>
            </div>
        </div>
    </c:if>

    <c:if test="${empty top5Alunos}">
        <div style="text-align: center; padding: 40px; color: #666;">
            <div style="font-size: 3em;">📊</div>
            <h3>Nenhum dado disponível</h3>
            <p>Não há dados suficientes para gerar o ranking desta avaliação.</p>
            <p style="font-size: 0.9em; color: #999;">
                Os alunos podem não ter realizado a avaliação ainda ou não há notas concluídas.
            </p>
        </div>
    </c:if>
</div>
</body>
</html>