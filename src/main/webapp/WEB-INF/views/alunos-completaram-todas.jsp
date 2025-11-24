<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Alunos que Completaram Todas as Avaliações</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #28a745; padding-bottom: 10px; }
        .btn { padding: 8px 16px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; }
        .aluno-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        .aluno-table th, .aluno-table td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        .aluno-table th { background: #28a745; color: white; }
        .aluno-table tr:hover { background: #f5f5f5; }
        .completed-badge { background: #28a745; color: white; padding: 3px 8px; border-radius: 12px; font-size: 0.8em; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .stat-card { background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2em; font-weight: bold; color: #28a745; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>✅ Alunos que Completaram Todas as Avaliações</h1>
        <a href="/professor/relatorios" class="btn">← Voltar</a>
    </div>

    <c:if test="${not empty resultados}">
        <div class="stats-grid">
            <div class="stat-card">
                <div>Completaram Todas</div>
                <div class="stat-number">${resultados.size()}</div>
            </div>
        </div>

        <table class="aluno-table">
            <thead>
            <tr>
                <th>Aluno</th>
                <th>Avaliações Completadas</th>
                <th>Total de Avaliações</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${resultados}" var="resultado">
                <tr>
                    <td>
                        <strong>${resultado[1]}</strong>
                        <div style="font-size: 0.8em; color: #666;">ID: ${resultado[0]}</div>
                    </td>
                    <td>
                        <span class="completed-badge">${resultado[2]} avaliações</span>
                    </td>
                    <td>
                        <strong>${resultado[3]}</strong>
                    </td>
                    <td>
                        <span style="color: #28a745;">✅ Completo</span>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty resultados}">
        <div style="text-align: center; padding: 40px; color: #666;">
            <div style="font-size: 3em;">📊</div>
            <h3>Nenhum aluno completou todas as avaliações</h3>
            <p>Nenhum aluno concluiu todas as avaliações disponíveis até o momento.</p>
        </div>
    </c:if>
</div>
</body>
</html>