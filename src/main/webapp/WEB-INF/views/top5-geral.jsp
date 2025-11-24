<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Top 5 Alunos - Geral</title>
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
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>🏆 Top 5 Alunos (Geral)</h1>
        <a href="/professor/relatorios" class="btn">← Voltar</a>
    </div>

    <c:if test="${not empty top5Alunos && !empty top5Alunos}">
        <div class="stats-grid">
            <div class="stat-card">
                <div>Melhor Média</div>
                <div class="stat-number">
                    <c:if test="${not empty top5Alunos[0]}">
                        <fmt:formatNumber value="${top5Alunos[0].mediaGeral}" pattern="#.##"/>
                    </c:if>
                </div>
            </div>
            <div class="stat-card">
                <div>Média do Top 5</div>
                <div class="stat-number">
                    <c:set var="soma" value="0" />
                    <c:forEach items="${top5Alunos}" var="aluno">
                        <c:set var="soma" value="${soma + aluno.mediaGeral}" />
                    </c:forEach>
                    <fmt:formatNumber value="${soma / top5Alunos.size()}" pattern="#.##"/>
                </div>
            </div>
        </div>

        <table class="ranking-table">
            <thead>
            <tr>
                <th>Posição</th>
                <th>Aluno</th>
                <th>Média Geral</th>
                <th>Avaliações Realizadas</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${top5Alunos}" var="aluno" varStatus="status">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${status.index == 0}">🥇</c:when>
                            <c:when test="${status.index == 1}">🥈</c:when>
                            <c:when test="${status.index == 2}">🥉</c:when>
                            <c:otherwise>${status.index + 1}º</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <strong>${aluno.nome}</strong>
                        <c:if test="${not empty aluno.email}">
                            <div style="font-size: 0.8em; color: #666;">${aluno.email}</div>
                        </c:if>
                    </td>
                    <td><strong><fmt:formatNumber value="${aluno.mediaGeral}" pattern="#.##"/></strong></td>
                    <td>${aluno.totalAvaliacoes}</td>
                    <td>
                        <c:choose>
                            <c:when test="${aluno.mediaGeral >= 90}">
                                <span style="color: green;">⭐ Excelente</span>
                            </c:when>
                            <c:when test="${aluno.mediaGeral >= 70}">
                                <span style="color: orange;">📊 Bom</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: red;">📈 Em progresso</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty top5Alunos || empty top5Alunos}">
        <div style="text-align: center; padding: 40px; color: #666;">
            <div style="font-size: 3em;">📊</div>
            <h3>Nenhum dado disponível</h3>
            <p>Não há dados suficientes para gerar o ranking de alunos.</p>
            <p style="font-size: 0.9em; color: #999;">
                Os alunos podem não ter realizado avaliações ainda.
            </p>
        </div>
    </c:if>
</div>
</body>
</html>