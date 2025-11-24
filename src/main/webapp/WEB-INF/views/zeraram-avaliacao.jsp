<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Alunos que Zeraram - Avaliação ${idAvaliacao}</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1000px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #dc3545; padding-bottom: 10px; }
        .btn { padding: 8px 16px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; }
        .aluno-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        .aluno-table th, .aluno-table td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        .aluno-table th { background: #dc3545; color: white; }
        .aluno-table tr:hover { background: #f5f5f5; }
        .zero-badge { background: #dc3545; color: white; padding: 3px 8px; border-radius: 12px; font-size: 0.8em; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .stat-card { background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2em; font-weight: bold; color: #dc3545; }
        .avaliacao-info { background: #f8d7da; padding: 15px; border-radius: 8px; margin: 20px 0; }
        .btn-contact { background: #ffc107; color: black; padding: 5px 10px; text-decoration: none; border-radius: 4px; font-size: 0.8em; }
        .btn-analysis { background: #17a2b8; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; font-size: 0.8em; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>0️⃣ Alunos que Zeraram - Avaliação ${idAvaliacao}</h1>
        <a href="/professor/relatorios" class="btn">← Voltar aos Relatórios</a>
    </div>

    <!-- Informações da Avaliação -->
    <div class="avaliacao-info">
        <h3 style="margin: 0 0 10px 0;">📝 Avaliação ID: ${idAvaliacao}</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px;">
            <div><strong>ID:</strong> ${idAvaliacao}</div>
            <div><strong>Total de Alunos:</strong> ${alunosZero.size()}</div>
        </div>
    </div>

    <c:if test="${not empty alunosZero}">
        <div class="stats-grid">
            <div class="stat-card">
                <div>Total de Zeros</div>
                <div class="stat-number">${alunosZero.size()}</div>
            </div>
        </div>

        <table class="aluno-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Aluno</th>
                <th>Email</th>
                <th>Ações</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${alunosZero}" var="aluno">
                <tr>
                    <td>${aluno.idUsuario}</td>
                    <td>
                        <strong>${aluno.nome}</strong>
                    </td>
                    <td>${aluno.email}</td>
                    <td>
                        <a href="mailto:${aluno.email}" class="btn-contact">📧 Contatar</a>
                        <a href="/professor/alunos/${aluno.idUsuario}/desempenho" class="btn-analysis">📊 Análise</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- Análise e Recomendações -->
        <div style="background: #fff3cd; padding: 15px; border-radius: 8px; margin-top: 20px;">
            <h4 style="margin: 0 0 10px 0;">🔍 Análise dos Resultados</h4>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div>
                    <h5>Possíveis Causas:</h5>
                    <ul style="margin: 0; padding-left: 20px; font-size: 0.9em;">
                        <li>Dificuldade excessiva da avaliação</li>
                        <li>Falta de preparo dos alunos</li>
                        <li>Problemas técnicos durante a prova</li>
                        <li>Tempo insuficiente para conclusão</li>
                    </ul>
                </div>
                <div>
                    <h5>Ações Recomendadas:</h5>
                    <ul style="margin: 0; padding-left: 20px; font-size: 0.9em;">
                        <li>Revisar a dificuldade das questões</li>
                        <li>Oferecer recuperação ou segunda chamada</li>
                        <li>Agendar aula de revisão do conteúdo</li>
                        <li>Entrar em contato individual com os alunos</li>
                    </ul>
                </div>
            </div>
        </div>
    </c:if>

    <c:if test="${empty alunosZero}">
        <div style="text-align: center; padding: 40px; color: #28a745;">
            <div style="font-size: 3em;">🎉</div>
            <h3>Nenhum aluno zerou esta avaliação!</h3>
            <p>Todos os alunos que realizaram a prova obtiveram nota acima de zero.</p>
            <div style="margin-top: 20px;">
                <a href="/professor/relatorios/estatisticas-avaliacao/${idAvaliacao}" class="btn" style="background: #17a2b8;">
                    📈 Ver Estatísticas Completas
                </a>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>