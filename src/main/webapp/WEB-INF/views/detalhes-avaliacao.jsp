<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Detalhes da Avaliação</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .header {
            background: rgba(255, 255, 255, 0.95);
            padding: 20px 40px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.1);
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }
        .table th, .table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        .table tr:hover {
            background: #f8f9fa;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background: #667eea;
            color: white;
        }
        .btn-primary:hover {
            background: #5a6fd8;
        }
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        .btn-danger:hover {
            background: #c0392b;
        }
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        .btn-warning:hover {
            background: #e67e22;
        }
        .btn-success {
            background: #28a745;
            color: white;
        }
        .btn-success:hover {
            background: #218838;
        }
        .badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
        }
        .badge-success { background: #d4edda; color: #155724; }
        .badge-warning { background: #fff3cd; color: #856404; }
        .badge-danger { background: #f8d7da; color: #721c24; }
        .badge-info { background: #d1ecf1; color: #0c5460; }
        .mensagem {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .sucesso {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .erro {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        .info-card {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 15px;
            border-radius: 8px;
        }
        .info-label {
            font-size: 0.9em;
            color: #666;
            margin-bottom: 5px;
        }
        .info-value {
            font-size: 1.1em;
            font-weight: 600;
            color: #333;
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>📋 Detalhes da Avaliação</h1>
    <div>
        <a href="/avaliacoes" class="btn btn-warning">📝 Voltar para Lista</a>
        <a href="/avaliacoes/nova" class="btn btn-primary">➕ Nova Avaliação</a>
    </div>
</div>

<div class="container">
    <!-- Mensagens -->
    <c:if test="${param.sucesso != null}">
        <div class="mensagem sucesso">✅ ${param.sucesso}</div>
    </c:if>
    <c:if test="${param.erro != null}">
        <div class="mensagem erro">❌ ${param.erro}</div>
    </c:if>

    <!-- Informações da Avaliação -->
    <div class="card">
        <h2>${avaliacao.titulo}</h2>

        <div class="info-grid">
            <div class="info-card">
                <div class="info-label">📊 Status</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${avaliacao.status == 'ATIVA'}">
                            <span class="badge badge-success">✅ Ativa</span>
                        </c:when>
                        <c:when test="${avaliacao.status == 'INATIVA'}">
                            <span class="badge badge-danger">❌ Inativa</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-warning">${avaliacao.status}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="info-card">
                <div class="info-label">⏰ Duração</div>
                <div class="info-value">${avaliacao.duracaoMinutos} minutos</div>
            </div>

            <div class="info-card">
                <div class="info-label">📋 Total de Questões</div>
                <div class="info-value">${totalQuestoes} questões</div>
            </div>

            <div class="info-card">
                <div class="info-label">🆔 ID</div>
                <div class="info-value">#${avaliacao.idAvaliacao}</div>
            </div>
        </div>

        <c:if test="${not empty avaliacao.descricao}">
            <div style="margin-top: 20px;">
                <div class="info-label">📝 Descrição</div>
                <div style="background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 5px;">
                        ${avaliacao.descricao}
                </div>
            </div>
        </c:if>

        <!-- Datas -->
        <div style="margin-top: 20px;">
            <div class="info-label">📅 Período da Avaliação</div>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 10px;">
                <div>
                    <strong>Início:</strong>
                    <c:choose>
                        <c:when test="${not empty avaliacao.dataInicio}">
                            ${avaliacao.dataInicio}
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999;">Não definido</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <strong>Fim:</strong>
                    <c:choose>
                        <c:when test="${not empty avaliacao.dataFim}">
                            ${avaliacao.dataFim}
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999;">Não definido</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Ações -->
        <div style="display: flex; gap: 10px; margin-top: 25px; flex-wrap: wrap;">
            <c:if test="${avaliacao.status == 'ATIVA'}">
                <a href="/avaliacoes/status/${avaliacao.idAvaliacao}/INATIVA"
                   class="btn btn-warning"
                   onclick="return confirm('Deseja desativar esta avaliação?')">
                    ⏸️ Desativar
                </a>
            </c:if>
            <c:if test="${avaliacao.status == 'INATIVA'}">
                <a href="/avaliacoes/status/${avaliacao.idAvaliacao}/ATIVA"
                   class="btn btn-success"
                   onclick="return confirm('Deseja ativar esta avaliação?')">
                    ▶️ Ativar
                </a>
            </c:if>
            <a href="/avaliacoes/excluir/${avaliacao.idAvaliacao}"
               class="btn btn-danger"
               onclick="return confirm('Tem certeza que deseja excluir a avaliação: ${avaliacao.titulo}? Esta ação não pode ser desfeita.')">
                🗑️ Excluir Avaliação
            </a>
        </div>
    </div>

    <!-- Lista de Questões -->
    <div class="card">
        <h3>❓ Questões da Avaliação</h3>

        <c:if test="${empty avaliacaoQuestoes}">
            <div class="empty-state">
                <p>📝 Esta avaliação não possui questões.</p>
                <a href="/avaliacoes/nova" class="btn btn-primary">➕ Adicionar Questões</a>
            </div>
        </c:if>

        <c:if test="${not empty avaliacaoQuestoes}">
            <table class="table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Questão</th>
                    <th>Pontuação</th>
                    <th>Ordem</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="aq" items="${avaliacaoQuestoes}" varStatus="status">
                    <tr>
                        <td><strong>${status.index + 1}</strong></td>
                        <td>
                            <strong>Questão #${aq.idQuestao}</strong>
                            <!-- Aqui você pode adicionar mais detalhes da questão se quiser -->
                        </td>
                        <td>
                            <strong>${aq.pontuacaoEspecificaNaAvaliacao} pts</strong>
                        </td>
                        <td>
                            <span class="badge badge-info">${aq.ordemNaAvaliacao}ª</span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <div style="text-align: center; margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px;">
                <strong>📊 Resumo:</strong>
                    ${totalQuestoes} questões |
                Pontuação total:
                <c:set var="pontuacaoTotal" value="0" />
                <c:forEach var="aq" items="${avaliacaoQuestoes}">
                    <c:set var="pontuacaoTotal" value="${pontuacaoTotal + aq.pontuacaoEspecificaNaAvaliacao}" />
                </c:forEach>
                    ${pontuacaoTotal} pontos
            </div>
        </c:if>
    </div>

    <!-- Ações Rápidas -->
    <div class="card">
        <h3>🚀 Ações Rápidas</h3>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="/avaliacoes" class="btn btn-warning">📝 Todas as Avaliações</a>
            <a href="/avaliacoes/nova" class="btn btn-primary">➕ Nova Avaliação</a>
            <a href="/questoes" class="btn btn-success">❓ Gerenciar Questões</a>
            <a href="/menu-professor" class="btn btn-warning">👨‍🏫 Menu Professor</a>
        </div>
    </div>
</div>

<script>
    // Confirmações para ações
    function confirmarAcao(acao, titulo) {
        return confirm('Tem certeza que deseja ' + acao + ' a avaliação: \"' + titulo + '\"?');
    }

    // Atualizar informações em tempo real
    document.addEventListener('DOMContentLoaded', function() {
        console.log('Página de detalhes carregada para avaliação: ${avaliacao.titulo}');
    });
</script>
</body>
</html>