<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestão de Avaliações</title>
    <style>
        /* Mantenha todo o seu CSS igual */
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
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            margin: 10px 0;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>📝 Gestão de Avaliações</h1>
    <div>
        <a href="/avaliacoes/nova" class="btn btn-primary">➕ Nova Avaliação</a>
        <a href="/menu-professor" class="btn btn-warning">👨‍🏫 Voltar</a>
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

    <!-- Estatísticas Rápidas -->
    <div class="stats-grid">
        <div class="stat-card">
            <div>📚 Total</div>
            <div class="stat-number">${avaliacoes.size()}</div>
            <small>Avaliações criadas</small>
        </div>
        <div class="stat-card">
            <div>✅ Ativas</div>
            <div class="stat-number">
                <c:set var="avaliacoesAtivas" value="0" />
                <c:forEach var="av" items="${avaliacoes}">
                    <c:if test="${av.status == 'ATIVA'}">
                        <c:set var="avaliacoesAtivas" value="${avaliacoesAtivas + 1}" />
                    </c:if>
                </c:forEach>
                ${avaliacoesAtivas}
            </div>
            <small>Avaliações ativas</small>
        </div>
        <div class="stat-card">
            <div>📋 Com Questões</div>
            <div class="stat-number">
                <!-- Será preenchido via JavaScript ou backend -->
                ${avaliacoes.size()}
            </div>
            <small>Com questões</small>
        </div>
    </div>

    <div class="card">
        <h3>📋 Lista de Avaliações</h3>

        <c:if test="${empty avaliacoes}">
            <div style="text-align: center; padding: 40px; color: #666;">
                <p>📝 Nenhuma avaliação criada ainda.</p>
                <a href="/avaliacoes/nova" class="btn btn-primary">Criar Primeira Avaliação</a>
            </div>
        </c:if>

        <c:if test="${not empty avaliacoes}">
            <table class="table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Título</th>
                    <th>Descrição</th>
                    <th>Duração</th>
                    <th>Status</th>
                    <th>Datas</th>
                    <th>Ações</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="avaliacao" items="${avaliacoes}">
                    <tr>
                        <td>${avaliacao.idAvaliacao}</td>
                        <td>
                            <strong>${avaliacao.titulo}</strong>
                        </td>
                        <td>
                            <c:if test="${not empty avaliacao.descricao}">
                                ${avaliacao.descricao}
                            </c:if>
                            <c:if test="${empty avaliacao.descricao}">
                                <em style="color: #999;">Sem descrição</em>
                            </c:if>
                        </td>
                        <td>
                            <strong>${avaliacao.duracaoMinutos} min</strong>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${avaliacao.status == 'ATIVA'}">
                                    <span class="badge badge-success">✅ Ativa</span>
                                </c:when>
                                <c:when test="${avaliacao.status == 'INATIVA'}">
                                    <span class="badge badge-danger">❌ Inativa</span>
                                </c:when>
                                <c:when test="${avaliacao.status == 'CONCLUIDA'}">
                                    <span class="badge badge-info">🏁 Concluída</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-warning">${avaliacao.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${not empty avaliacao.dataInicio}">
                                <small>Início: ${avaliacao.dataInicio}</small><br>
                            </c:if>
                            <c:if test="${not empty avaliacao.dataFim}">
                                <small>Fim: ${avaliacao.dataFim}</small>
                            </c:if>
                            <c:if test="${empty avaliacao.dataInicio && empty avaliacao.dataFim}">
                                <small style="color: #999;">Sem datas definidas</small>
                            </c:if>
                        </td>
                        <td>
                            <div style="display: flex; gap: 5px; flex-wrap: wrap;">
                                <a href="/avaliacoes/${avaliacao.idAvaliacao}" class="btn btn-primary" style="padding: 5px 10px;">👀 Ver</a>
                                <!-- REMOVIDO: Botão Editar -->
                                <a href="/avaliacoes/excluir/${avaliacao.idAvaliacao}"
                                   class="btn btn-danger"
                                   style="padding: 5px 10px;"
                                   onclick="return confirm('Tem certeza que deseja excluir a avaliação: ${avaliacao.titulo}?')">
                                    🗑️ Excluir
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <div class="card">
        <h3>📊 Ações Rápidas</h3>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="/avaliacoes/nova" class="btn btn-primary">➕ Nova Avaliação</a>
            <a href="/questoes" class="btn btn-success">❓ Gerenciar Questões</a>
            <a href="/menu-professor" class="btn btn-warning">👨‍🏫 Voltar ao Menu</a>
        </div>
    </div>
</div>

<script>
    // Confirmação para exclusão
    function confirmarExclusao(titulo) {
        return confirm('Tem certeza que deseja excluir a avaliação: \"' + titulo + '\"?');
    }

    // Atualizar estatísticas em tempo real
    document.addEventListener('DOMContentLoaded', function() {
        const avaliacoesComQuestoes = document.querySelectorAll('table tbody tr').length;
        const statQuestoes = document.querySelector('.stats-grid .stat-card:nth-child(3) .stat-number');
        if (statQuestoes) {
            statQuestoes.textContent = avaliacoesComQuestoes;
        }
    });
</script>
</body>
</html>