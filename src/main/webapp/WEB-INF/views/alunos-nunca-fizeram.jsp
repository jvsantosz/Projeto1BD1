<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Alunos que Nunca Fizeram Avaliações</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1000px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #17a2b8; padding-bottom: 10px; }
        .btn { padding: 8px 16px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; }
        .aluno-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        .aluno-table th, .aluno-table td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        .aluno-table th { background: #17a2b8; color: white; }
        .aluno-table tr:hover { background: #f5f5f5; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .stat-card { background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2em; font-weight: bold; color: #17a2b8; }
        .btn-contact { background: #28a745; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; font-size: 0.8em; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>📋 Alunos que Nunca Fizeram Avaliações</h1>
        <a href="/professor/relatorios" class="btn">← Voltar</a>
    </div>

    <c:if test="${not empty alunos}">
        <div class="stats-grid">
            <div class="stat-card">
                <div>Nunca Fizeram</div>
                <div class="stat-number">${alunos.size()}</div>
            </div>
        </div>

        <table class="aluno-table">
            <thead>
            <tr>
                <th>Aluno</th>
                <th>Email</th>
                <th>ID</th>
                <th>Ações</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${alunos}" var="aluno">
                <tr>
                    <td>${aluno.nome}</td>
                    <td>${aluno.email}</td>
                    <td>${aluno.idUsuario}</td>
                    <td>
                        <a href="mailto:${aluno.email}" class="btn-contact">📧 Contatar</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty alunos}">
        <div style="text-align: center; padding: 40px; color: #28a745;">
            <div style="font-size: 3em;">🎉</div>
            <h3>Todos os alunos participaram!</h3>
            <p>Nenhum aluno encontrado que nunca tenha realizado avaliações.</p>
        </div>
    </c:if>
</div>
</body>
</html>