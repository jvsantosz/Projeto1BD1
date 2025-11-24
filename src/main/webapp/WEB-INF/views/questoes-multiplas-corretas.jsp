<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Questões com Múltiplas Alternativas Corretas</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #ffc107; padding-bottom: 10px; }
        .btn { padding: 8px 16px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; }
        .questao-item { background: #fff3cd; border: 1px solid #ffc107; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
        .questao-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px; }
        .questao-texto { flex: 1; margin-right: 20px; }
        .warning-badge { background: #ffc107; color: #856404; padding: 5px 10px; border-radius: 15px; font-size: 0.8em; }
        .questao-info { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 10px; margin: 10px 0; font-size: 0.9em; color: #666; }
        .acoes { display: flex; gap: 10px; margin-top: 10px; }
        .btn-small { padding: 5px 10px; font-size: 0.8em; text-decoration: none; border-radius: 4px; }
        .btn-edit { background: #17a2b8; color: white; }
        .btn-fix { background: #dc3545; color: white; }
        .pontuacao-badge { background: #ffc107; color: black; padding: 2px 8px; border-radius: 12px; font-size: 0.8em; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>❓ Questões com Múltiplas Alternativas Corretas</h1>
        <a href="/professor/relatorios" class="btn">← Voltar</a>
    </div>

    <c:if test="${not empty questoes}">
        <div class="warning-badge" style="display: inline-block; margin-bottom: 20px;">
                ${questoes.size()} questão(ões) com múltiplas corretas
        </div>

        <c:forEach items="${questoes}" var="questao">
            <div class="questao-item">
                <div class="questao-header">
                    <div class="questao-texto">
                        <h3 style="margin: 0 0 10px 0;">${questao.descricaoQuestao}</h3>
                        <div class="questao-info">
                            <div><strong>ID:</strong> ${questao.idQuestao}</div>
                            <div><strong>Tipo:</strong> ${questao.tipoQuestao}</div>
                            <div>
                                <strong>Pontuação:</strong>
                                <span class="pontuacao-badge">${questao.valorPontuacao} pts</span>
                            </div>
                            <c:if test="${not empty questao.dataCriacao}">
                                <div><strong>Criada em:</strong> ${questao.dataCriacao}</div>
                            </c:if>
                        </div>
                    </div>
                    <div class="warning-badge">MÚLTIPLAS CORRETAS</div>
                </div>

                <div class="acoes">
                    <a href="/professor/questoes/editar/${questao.idQuestao}" class="btn-small btn-edit">✏️ Corrigir Questão</a>
                    <a href="/professor/questoes/${questao.idQuestao}/alternativas" class="btn-small btn-fix">🔍 Ver Alternativas</a>
                </div>
            </div>
        </c:forEach>
    </c:if>

    <c:if test="${empty questoes}">
        <div style="text-align: center; padding: 40px; color: #28a745;">
            <div style="font-size: 3em;">✅</div>
            <h3>Todas as questões estão configuradas corretamente!</h3>
            <p>Nenhuma questão com múltiplas alternativas corretas foi encontrada.</p>
        </div>
    </c:if>
</div>
</body>
</html>