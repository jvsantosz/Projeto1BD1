<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Avaliações com Nota Zero</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #dc3545; padding-bottom: 10px; }
        .btn { padding: 8px 16px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; }
        .avaliacao-item { background: #f8d7da; border: 1px solid #dc3545; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
        .avaliacao-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px; }
        .zero-badge { background: #dc3545; color: white; padding: 5px 10px; border-radius: 15px; font-size: 0.8em; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .stat-card { background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2em; font-weight: bold; color: #dc3545; }
        .acoes { display: flex; gap: 10px; margin-top: 10px; }
        .btn-small { padding: 5px 10px; font-size: 0.8em; text-decoration: none; border-radius: 4px; }
        .btn-review { background: #17a2b8; color: white; }
        .btn-contact { background: #ffc107; color: black; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>0️⃣ Avaliações com Nota Zero</h1>
        <a href="/professor/relatorios" class="btn">← Voltar</a>
    </div>

    <c:if test="${not empty avaliacoes}">
        <div class="stats-grid">
            <div class="stat-card">
                <div>Avaliações com Zero</div>
                <div class="stat-number">${avaliacoes.size()}</div>
            </div>
        </div>

        <c:forEach items="${avaliacoes}" var="avaliacao">
            <div class="avaliacao-item">
                <div class="avaliacao-header">
                    <div style="flex: 1; margin-right: 20px;">
                        <h3 style="margin: 0 0 10px 0;">${avaliacao.titulo}</h3>
                        <div style="color: #666; font-size: 0.9em;">
                            <strong>ID:</strong> ${avaliacao.idAvaliacao}
                        </div>
                    </div>
                    <div class="zero-badge">NOTA ZERO</div>
                </div>

                <div class="acoes">
                    <a href="/professor/avaliacoes/${avaliacao.idAvaliacao}" class="btn-small btn-review">📊 Ver Avaliação</a>
                </div>
            </div>
        </c:forEach>
    </c:if>

    <c:if test="${empty avaliacoes}">
        <div style="text-align: center; padding: 40px; color: #28a745;">
            <div style="font-size: 3em;">🎉</div>
            <h3>Nenhuma avaliação com nota zero!</h3>
            <p>Nenhum aluno tirou zero nas avaliações até o momento.</p>
        </div>
    </c:if>
</div>
</body>
</html>