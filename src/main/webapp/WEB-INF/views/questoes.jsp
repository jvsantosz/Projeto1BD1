<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Gestão de Questões</title>
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
        .badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
        }
        .badge-success { background: #d4edda; color: #155724; }
        .badge-warning { background: #fff3cd; color: #856404; }
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
    </style>
</head>
<body>
<div class="header">
    <h1>❓ Gestão de Questões</h1>
    <div>
        <a href="/questoes/nova" class="btn btn-primary">➕ Nova Questão</a>
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

    <div class="card">
        <h3>📋 Lista de Questões</h3>

        <c:if test="${empty questoes}">
            <div style="text-align: center; padding: 40px; color: #666;">
                <p>📝 Nenhuma questão cadastrada ainda.</p>
                <a href="/questoes/nova" class="btn btn-primary">Criar Primeira Questão</a>
            </div>
        </c:if>

        <c:if test="${not empty questoes}">
            <table class="table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Descrição</th>
                    <th>Tipo</th>
                    <th>Pontuação</th>
                    <th>Data Criação</th>
                    <th>Status</th>
                    <th>Ações</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="questao" items="${questoes}">
                    <tr>
                        <td>${questao.idQuestao}</td>
                        <td>
                            <strong>${questao.descricaoQuestao}</strong>
                            <c:if test="${not empty questao.feedbackCorreto}">
                                <br><small>✅ ${questao.feedbackCorreto}</small>
                            </c:if>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${questao.tipoQuestao == 'MULTIPLA'}">
                                    <span class="badge badge-info">🔘 Múltipla Escolha</span>
                                </c:when>
                                <c:when test="${questao.tipoQuestao == 'TEXTO'}">
                                    <span class="badge badge-warning">📝 Texto Livre</span>
                                </c:when>
                                <c:when test="${questao.tipoQuestao == 'NUMERICA'}">
                                    <span class="badge badge-success">🔢 Numérica</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge">${questao.tipoQuestao}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <strong>${questao.valorPontuacao} pts</strong>
                        </td>
                        <td>
                            <small>${questao.dataCriacao}</small>
                        </td>
                        <td>
                            <span class="badge badge-success">✅ Ativa</span>
                        </td>
                        <td>
                            <a href="/questoes/${questao.idQuestao}" class="btn btn-primary" style="padding: 5px 10px;">👀 Ver</a>
                            <a href="/questoes/editar/${questao.idQuestao}" class="btn btn-warning" style="padding: 5px 10px;">✏️ Editar</a>
                            <a href="/questoes/deletar/${questao.idQuestao}"
                               class="btn btn-danger"
                               style="padding: 5px 10px;"
                               onclick="return confirm('Tem certeza que deseja excluir a questão: ${questao.descricaoQuestao}?')">
                                🗑️ Excluir
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <div class="card">
        <h3>📊 Ações Rápidas</h3>
        <a href="/questoes/estatisticas" class="btn btn-primary">📈 Ver Estatísticas</a>
        <a href="/questoes/nova" class="btn btn-primary">➕ Nova Questão</a>
        <a href="/avaliacoes" class="btn btn-warning">📝 Ir para Avaliações</a>
    </div>
</div>

<script>
    // Confirmação para exclusão
    function confirmarExclusao(descricao) {
        return confirm('Tem certeza que deseja excluir a questão: \"' + descricao + '\"?');
    }
</script>
</body>
</html>