<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.example.pjbd1.model.Usuario usuario = (com.example.pjbd1.model.Usuario) session.getAttribute("usuarioLogado");
    if (usuario == null) {
        response.sendRedirect("/?erro=Faça login primeiro");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Portal do Professor</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
        .user-info {
            text-align: right;
        }
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card h3 {
            color: #333;
            border-bottom: 2px solid #f5576c;
            padding-bottom: 10px;
            margin-top: 0;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        .stat-card {
            background: linear-gradient(135deg, #f093fb, #f5576c);
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
        .btn-success {
            background: #28a745;
            color: white;
        }
        .btn-success:hover {
            background: #218838;
        }
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        .btn-warning:hover {
            background: #e67e22;
        }
        .btn-danger {
            background: #f5576c;
            color: white;
        }
        .btn-danger:hover {
            background: #e04a5e;
        }
        .btn-info {
            background: #17a2b8;
            color: white;
        }
        .btn-info:hover {
            background: #138496;
        }
        .logout {
            color: #666;
            text-decoration: none;
            margin-left: 20px;
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
        .badge-primary { background: #d1ecf1; color: #0c5460; }
        .section-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
        }
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .action-card {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        .action-icon {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        .action-title {
            font-size: 1.2em;
            font-weight: 600;
            margin-bottom: 5px;
        }
        .action-desc {
            font-size: 0.9em;
            opacity: 0.9;
        }
        @media (max-width: 768px) {
            .section-grid {
                grid-template-columns: 1fr;
            }
            .quick-actions {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="header">
    <h1>👨‍🏫 Portal do Professor</h1>
    <div class="user-info">
        <strong>Bem-vindo, Prof. <%= usuario.getNome() %>!</strong>
        <a href="/logout" class="logout">🚪 Sair</a>
    </div>
</div>

<div class="container">
    <!-- Ações Rápidas -->
    <div class="card">
        <h3>🚀 Ações Rápidas</h3>
        <div class="quick-actions">
            <a href="/questoes" class="action-card">
                <div class="action-icon">❓</div>
                <div class="action-title">Gerenciar Questões</div>
                <div class="action-desc">Criar, editar e visualizar questões</div>
            </a>
            <a href="/avaliacoes" class="action-card">
                <div class="action-icon">📝</div>
                <div class="action-title">Gerenciar Avaliações</div>
                <div class="action-desc">Criar e gerenciar avaliações</div>
            </a>
            <a href="/professor/relatorios" class="action-card" style="background: linear-gradient(135deg, #28a745, #20c997);">
                <div class="action-icon">📊</div>
                <div class="action-title">Relatórios</div>
                <div class="action-desc">Estatísticas e análises detalhadas</div>
            </a>
            <a href="/avaliacoes/nova" class="action-card">
                <div class="action-icon">📋</div>
                <div class="action-title">Nova Avaliação</div>
                <div class="action-desc">Criar uma nova avaliação</div>
            </a>
        </div>
    </div>

    <!-- Estatísticas Gerais -->
    <div class="stats-grid">
        <div class="stat-card">
            <div>📚 Total de Avaliações</div>
            <div class="stat-number">${totalAvaliacoes != null ? totalAvaliacoes : '0'}</div>
            <small>Criadas no sistema</small>
        </div>
        <div class="stat-card">
            <div>❓ Total de Questões</div>
            <div class="stat-number">${totalQuestoes != null ? totalQuestoes : '0'}</div>
            <small>Disponíveis</small>
        </div>
        <div class="stat-card">
            <div>❌ Avaliações sem Questões</div>
            <div class="stat-number">${avaliacoesSemQuestoes != null ? avaliacoesSemQuestoes : '0'}</div>
            <small>Precisam de atenção</small>
        </div>
        <div class="stat-card">
            <div>📝 Questões Não Utilizadas</div>
            <div class="stat-number">${questoesNaoUtilizadas != null ? questoesNaoUtilizadas : '0'}</div>
            <small>Disponíveis para uso</small>
        </div>
    </div>

    <div class="section-grid">
        <!-- Módulo de Questões -->
        <div class="card">
            <h3>❓ Gestão de Questões</h3>

            <div style="display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap;">
                <a href="/questoes" class="btn btn-primary">📋 Ver Todas as Questões</a>
                <a href="/questoes/nova" class="btn btn-success">➕ Nova Questão</a>
                <a href="/professor/relatorios/questoes-sem-corretas" class="btn btn-danger">❌ Ver Problemas</a>
            </div>

            <h4>📊 Status das Questões</h4>
            <table class="table">
                <thead>
                <tr>
                    <th>Tipo</th>
                    <th>Quantidade</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>🔘 Múltipla Escolha</td>
                    <td><span class="badge badge-primary">${questoesMultiplaEscolha != null ? questoesMultiplaEscolha : '0'}</span></td>
                    <td><span class="badge badge-success">Ativas</span></td>
                </tr>
                <tr>
                    <td>📝 Texto Livre</td>
                    <td><span class="badge badge-primary">${questoesTexto != null ? questoesTexto : '0'}</span></td>
                    <td><span class="badge badge-success">Ativas</span></td>
                </tr>
                <tr>
                    <td>🔢 Numéricas</td>
                    <td><span class="badge badge-primary">${questoesNumerica != null ? questoesNumerica : '0'}</span></td>
                    <td><span class="badge badge-success">Ativas</span></td>
                </tr>
                </tbody>
            </table>

            <h4>⚠️ Questões que Precisam de Atenção</h4>
            <table class="table">
                <thead>
                <tr>
                    <th>Problema</th>
                    <th>Quantidade</th>
                    <th>Ação</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>Questões sem alternativas corretas</td>
                    <td><span class="badge badge-danger">${questoesSemCorretas != null ? questoesSemCorretas : '0'}</span></td>
                    <td><a href="/professor/relatorios/questoes-sem-corretas" class="btn btn-danger">Corrigir</a></td>
                </tr>
                <tr>
                    <td>Questões com múltiplas corretas</td>
                    <td><span class="badge badge-warning">${questoesMultiplasCorretas != null ? questoesMultiplasCorretas : '0'}</span></td>
                    <td><a href="/professor/relatorios/questoes-multiplas-corretas" class="btn btn-warning">Revisar</a></td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- Módulo de Avaliações -->
        <div class="card">
            <h3>📝 Gestão de Avaliações</h3>

            <div style="display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap;">
                <a href="/avaliacoes" class="btn btn-primary">📋 Ver Todas as Avaliações</a>
                <a href="/avaliacoes/nova" class="btn btn-success">➕ Nova Avaliação</a>
                <a href="/professor/relatorios" class="btn btn-info">📊 Ver Relatórios</a>
            </div>

            <h4>📈 Status das Avaliações</h4>
            <table class="table">
                <thead>
                <tr>
                    <th>Status</th>
                    <th>Quantidade</th>
                    <th>Ação</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>✅ Ativas</td>
                    <td><span class="badge badge-success">${avaliacoesAtivas != null ? avaliacoesAtivas : '0'}</span></td>
                    <td><a href="/avaliacoes" class="btn btn-primary">Ver</a></td>
                </tr>
                <tr>
                    <td>⏸️ Inativas</td>
                    <td><span class="badge badge-warning">${avaliacoesInativas != null ? avaliacoesInativas : '0'}</span></td>
                    <td><a href="/avaliacoes" class="btn btn-warning">Ativar</a></td>
                </tr>
                <tr>
                    <td>🏁 Concluídas</td>
                    <td><span class="badge badge-info">${avaliacoesConcluidas != null ? avaliacoesConcluidas : '0'}</span></td>
                    <td><a href="/professor/relatorios" class="btn btn-info">Resultados</a></td>
                </tr>
                </tbody>
            </table>

            <h4>🎯 Últimas Avaliações Criadas</h4>
            <table class="table">
                <thead>
                <tr>
                    <th>Avaliação</th>
                    <th>Status</th>
                    <th>Ações</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="avaliacao" items="${ultimasAvaliacoes}">
                    <tr>
                        <td>
                            <a href="/avaliacoes/${avaliacao.idAvaliacao}" style="text-decoration: none; color: #333;">
                                <strong>${avaliacao.titulo}</strong>
                            </a>
                            <c:if test="${not empty avaliacao.descricao}">
                                <br><small style="color: #666;">${avaliacao.descricao}</small>
                            </c:if>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${avaliacao.status == 'ATIVA'}">
                                    <span class="badge badge-success">✅ Ativa</span>
                                </c:when>
                                <c:when test="${avaliacao.status == 'INATIVA'}">
                                    <span class="badge badge-warning">⏸️ Inativa</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-info">${avaliacao.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="/professor/relatorios/estatisticas-avaliacao/${avaliacao.idAvaliacao}"
                               class="btn btn-info" style="padding: 5px 10px; font-size: 0.8em;">
                                📈
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Ações de Suporte -->
    <div class="card">
        <h3>🛠️ Suporte e Ajuda</h3>
        <div style="display: flex; gap: 15px; flex-wrap: wrap;">
            <a href="/questoes" class="btn btn-primary">❓ Central de Questões</a>
            <a href="/avaliacoes" class="btn btn-success">📝 Central de Avaliações</a>
            <a href="/professor/relatorios" class="btn btn-info">📊 Central de Relatórios</a>
            <a href="/menu-professor" class="btn btn-warning">🔄 Atualizar Dashboard</a>
        </div>
    </div>
</div>

<script>
    // Atualizar automaticamente a cada 30 segundos
    setTimeout(function() {
        window.location.reload();
    }, 30000);

    // Adicionar animações
    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.card');
        cards.forEach((card, index) => {
            card.style.animationDelay = (index * 0.1) + 's';
            card.style.animation = 'fadeInUp 0.5s ease-out';
        });
    });
</script>
</body>
</html>