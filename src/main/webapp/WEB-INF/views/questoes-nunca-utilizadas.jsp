<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Questões Nunca Utilizadas</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #6f42c1; padding-bottom: 10px; }
        .btn { padding: 8px 16px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; }
        .questao-item { background: #fff; border: 1px solid #e0e0e0; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
        .questao-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px; }
        .questao-texto { flex: 1; margin-right: 20px; }
        .unused-badge { background: #6f42c1; color: white; padding: 5px 10px; border-radius: 15px; font-size: 0.8em; }
        .acoes { display: flex; gap: 10px; margin-top: 10px; }
        .btn-small { padding: 5px 10px; font-size: 0.8em; text-decoration: none; border-radius: 4px; }
        .btn-use { background: #28a745; color: white; }
        .btn-edit { background: #17a2b8; color: white; }
        .questao-info { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 10px; margin: 10px 0; font-size: 0.9em; color: #666; }
        .pontuacao-badge { background: #ffc107; color: black; padding: 2px 8px; border-radius: 12px; font-size: 0.8em; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>📊 Questões Nunca Utilizadas</h1>
        <a href="/professor/relatorios" class="btn">← Voltar</a>
    </div>

    <c:if test="${not empty questoes}">
        <div class="unused-badge" style="display: inline-block; margin-bottom: 20px;">
                ${questoes.size()} questão(ões) não utilizadas
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
                    <div class="unused-badge">NÃO UTILIZADA</div>
                </div>

                <div class="acoes">
                    <a href="/professor/avaliacoes/adicionar-questao?questaoId=${questao.idQuestao}" class="btn-small btn-use">📝 Usar em Avaliação</a>
                    <a href="/professor/questoes/editar/${questao.idQuestao}" class="btn-small btn-edit">✏️ Editar</a>
                    <a href="/professor/questoes/${questao.idQuestao}/alternativas" class="btn-small" style="background: #6f42c1; color: white;">🔍 Ver Alternativas</a>
                </div>
            </div>
        </c:forEach>

        <!-- Estatísticas e Ações -->
        <div style="background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 20px;">
            <h4 style="margin: 0 0 10px 0;">📈 Estatísticas das Questões Não Utilizadas</h4>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; font-size: 0.9em;">
                <div>
                    <strong>Total de Questões no Sistema:</strong><br>
                    <span style="font-size: 1.2em; color: #6f42c1;">${totalQuestoesSistema}</span>
                </div>
                <div>
                    <strong>Questões Não Utilizadas:</strong><br>
                    <span style="font-size: 1.2em; color: #6f42c1;">${questoes.size()}</span>
                </div>
                <div>
                    <strong>Taxa de Utilização:</strong><br>
                    <span style="font-size: 1.2em; color: #28a745;">
                        <c:if test="${totalQuestoesSistema > 0}">
                            <fmt:formatNumber value="${(totalQuestoesSistema - questoes.size()) / totalQuestoesSistema * 100}" pattern="#.##"/>%
                        </c:if>
                    </span>
                </div>
                <div>
                    <strong>Pontuação Total Disponível:</strong><br>
                    <span style="font-size: 1.2em; color: #ffc107;">
                        <c:set var="totalPontos" value="0" />
                        <c:forEach items="${questoes}" var="q">
                            <c:set var="totalPontos" value="${totalPontos + q.valorPontuacao.doubleValue()}" />
                        </c:forEach>
                        <fmt:formatNumber value="${totalPontos}" pattern="#.##"/> pts
                    </span>
                </div>
            </div>
        </div>

        <!-- Ações em Lote -->
        <div style="background: #e7f3ff; padding: 15px; border-radius: 8px; margin-top: 20px;">
            <h4 style="margin: 0 0 10px 0;">🚀 Ações em Lote</h4>
            <p style="margin: 0 0 10px 0; font-size: 0.9em;">
                Utilize estas questões não utilizadas para criar novas avaliações ou atualizar avaliações existentes.
            </p>
            <div style="display: flex; gap: 10px;">
                <a href="/professor/avaliacoes/nova?questoesSelecionadas=${questoesIds}" class="btn-small btn-use">
                    📋 Criar Nova Avaliação
                </a>
                <a href="/professor/questoes/exportar?tipo=naoUtilizadas" class="btn-small" style="background: #6c757d; color: white;">
                    📤 Exportar Lista
                </a>
            </div>
        </div>
    </c:if>

    <c:if test="${empty questoes}">
        <div style="text-align: center; padding: 40px; color: #28a745;">
            <div style="font-size: 3em;">✅</div>
            <h3>Todas as questões foram utilizadas!</h3>
            <p>Nenhuma questão não utilizada foi encontrada no banco de dados.</p>
            <p style="font-size: 0.9em; color: #666; margin-top: 10px;">
                Isso significa que todo o seu banco de questões está sendo aproveitado nas avaliações.
            </p>
            <div style="margin-top: 20px;">
                <a href="/professor/questoes/nova" class="btn" style="background: #28a745;">
                    ➕ Criar Nova Questão
                </a>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>