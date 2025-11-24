<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Alunos Acima da Média</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #17a2b8; padding-bottom: 10px; }
        .btn { padding: 8px 16px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; }
        .aluno-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        .aluno-table th, .aluno-table td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        .aluno-table th { background: #17a2b8; color: white; }
        .aluno-table tr:hover { background: #f5f5f5; }
        .above-average { color: #28a745; font-weight: bold; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .stat-card { background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2em; font-weight: bold; color: #17a2b8; }
        .progress-bar { background: #e9ecef; border-radius: 10px; height: 10px; margin: 5px 0; }
        .progress-fill { background: #28a745; height: 100%; border-radius: 10px; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>📈 Alunos Acima da Média</h1>
        <a href="/professor/relatorios" class="btn">← Voltar</a>
    </div>

    <c:if test="${not empty alunosAcimaMedia}">
        <div class="stats-grid">
            <div class="stat-card">
                <div>Média da Turma</div>
                <div class="stat-number">${mediaGeral}</div>
            </div>
            <div class="stat-card">
                <div>Alunos Acima da Média</div>
                <div class="stat-number">${alunosAcimaMedia.size()}</div>
            </div>
            <div class="stat-card">
                <div>Percentual</div>
                <div class="stat-number">
                    <fmt:formatNumber value="${(alunosAcimaMedia.size() / totalAlunos) * 100}" pattern="#.##"/>%
                </div>
            </div>
        </div>

        <table class="aluno-table">
            <thead>
            <tr>
                <th>Aluno</th>
                <th>Nota Média</th>
                <th>Desvio da Média</th>
                <th>Avaliações Realizadas</th>
                <th>Progresso</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${alunosAcimaMedia}" var="aluno">
                <tr>
                    <td>
                        <strong>${aluno.nome}</strong>
                        <div style="font-size: 0.8em; color: #666;">${aluno.matricula}</div>
                    </td>
                    <td class="above-average">${aluno.notaMedia}</td>
                    <td class="above-average">
                        +<fmt:formatNumber value="${aluno.notaMedia - mediaGeral}" pattern="#.##"/>
                    </td>
                    <td>${aluno.totalAvaliacoes}</td>
                    <td style="width: 150px;">
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: ${aluno.notaMedia}%"></div>
                        </div>
                        <div style="font-size: 0.8em; text-align: center;">${aluno.notaMedia}%</div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${aluno.notaMedia >= 90}">
                                <span style="color: #ffd700;">🏆 Excelente</span>
                            </c:when>
                            <c:when test="${aluno.notaMedia >= 80}">
                                <span style="color: #28a745;">⭐ Muito Bom</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #17a2b8;">📈 Acima da Média</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty alunosAcimaMedia}">
        <div style="text-align: center; padding: 40px; color: #666;">
            <div style="font-size: 3em;">📊</div>
            <h3>Nenhum aluno acima da média</h3>
            <p>Nenhum aluno está com desempenho acima da média da turma no momento.</p>
        </div>
    </c:if>
</div>
</body>
</html>