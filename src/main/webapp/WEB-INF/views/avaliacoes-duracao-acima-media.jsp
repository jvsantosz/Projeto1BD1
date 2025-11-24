<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Avaliações com Duração Acima da Média</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #17a2b8; padding-bottom: 10px; }
        .btn { padding: 8px 16px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; }
        .avaliacao-item { background: #e7f3ff; border: 1px solid #17a2b8; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
        .avaliacao-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px; }
        .duration-badge { background: #17a2b8; color: white; padding: 5px 10px; border-radius: 15px; font-size: 0.8em; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .stat-card { background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2em; font-weight: bold; color: #17a2b8; }
        .avaliacao-info { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 10px; margin: 10px 0; font-size: 0.9em; color: #666; }
        .acoes { display: flex; gap: 10px; margin-top: 10px; }
        .btn-small { padding: 5px 10px; font-size: 0.8em; text-decoration: none; border-radius: 4px; }
        .btn-analyze { background: #17a2b8; color: white; }
        .btn-adjust { background: #ffc107; color: black; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>⏰ Avaliações com Duração Acima da Média</h1>
        <a href="/professor/relatorios" class="btn">← Voltar</a>
    </div>

    <c:if test="${not empty avaliacoes}">
        <div class="stats-grid">
            <div class="stat-card">
                <div>Acima da Média</div>
                <div class="stat-number">${avaliacoes.size()}</div>
            </div>
        </div>

        <c:forEach items="${avaliacoes}" var="avaliacao">
            <div class="avaliacao-item">
                <div class="avaliacao-header">
                    <div style="flex: 1; margin-right: 20px;">
                        <h3 style="margin: 0 0 10px 0;">${avaliacao.titulo}</h3>
                        <div class="avaliacao-info">
                            <div><strong>ID:</strong> ${avaliacao.idAvaliacao}</div>
                            <div><strong>Duração:</strong> ${avaliacao.duracaoMinutos} min</div>
                            <div><strong>Status:</strong> ${avaliacao.status}</div>
                            <c:if test="${not empty avaliacao.dataInicio}">
                                <div><strong>Início:</strong> ${avaliacao.dataInicio}</div>
                            </c:if>
                        </div>
                        <c:if test="${not empty avaliacao.descricao}">
                            <p style="margin: 10px 0 0 0; color: #666;">${avaliacao.descricao}</p>
                        </c:if>
                    </div>
                    <div class="duration-badge">
                            ${avaliacao.duracaoMinutos} min
                    </div>
                </div>

                <div class="acoes">
                    <a href="/professor/avaliacoes/editar/${avaliacao.idAvaliacao}" class="btn-small btn-adjust">⏱️ Ajustar Duração</a>
                    <a href="/professor/avaliacoes/${avaliacao.idAvaliacao}" class="btn-small btn-analyze">📝 Ver Detalhes</a>
                </div>
            </div>
        </c:forEach>
    </c:if>

    <c:if test="${empty avaliacoes}">
        <div style="text-align: center; padding: 40px; color: #28a745;">
            <div style="font-size: 3em;">✅</div>
            <h3>Todas as avaliações têm duração adequada!</h3>
            <p>Nenhuma avaliação com duração acima da média foi encontrada.</p>
        </div>
    </c:if>
</div>
</body>
</html>