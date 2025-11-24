<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.example.pjbd1.model.Usuario usuario = (com.example.pjbd1.model.Usuario) session.getAttribute("usuarioLogado");
    if (usuario == null) {
        response.sendRedirect("/?erro=Faça login primeiro");
        return;
    }
%>
<html>
<head>
    <title>Portal do Aluno</title>
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
        .user-info {
            text-align: right;
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
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card h3 {
            color: #333;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
            margin-top: 0;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
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
        .avaliacoes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        .avaliacao-card {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            transition: all 0.3s ease;
        }
        .avaliacao-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .avaliacao-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        .avaliacao-title {
            font-size: 1.2em;
            font-weight: 600;
            color: #333;
            margin: 0;
        }
        .avaliacao-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin: 15px 0;
            font-size: 0.9em;
            color: #666;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>🎓 Portal do Aluno</h1>
    <div class="user-info">
        <strong>Bem-vindo, <%= usuario.getNome() %>!</strong>
        <a href="/logout" class="logout">🚪 Sair</a>
    </div>
</div>

<div class="container">
    <!-- Ações Rápidas -->
    <div class="card">
        <h3>🚀 Ações Rápidas</h3>
        <div class="quick-actions">
            <a href="/aluno-avaliacoes" class="action-card">
                <div class="action-icon">📝</div>
                <div class="action-title">Fazer Avaliações</div>
                <div class="action-desc">Realizar avaliações disponíveis</div>
            </a>
            <a href="/aluno-avaliacoes" class="action-card">
                <div class="action-icon">📊</div>
                <div class="action-title">Ver Resultados</div>
                <div class="action-desc">Consultar notas e desempenho</div>
            </a>
            <a href="/menu-aluno" class="action-card">
                <div class="action-icon">🔄</div>
                <div class="action-title">Atualizar</div>
                <div class="action-desc">Atualizar informações</div>
            </a>
        </div>
    </div>

    <!-- Estatísticas do Aluno -->
    <div class="stats-grid">
        <div class="stat-card">
            <div>📊 Média Geral</div>
            <div class="stat-number">${not empty mediaGeral ? mediaGeral : '0.0'}</div>
            <small>Baseado em todas as avaliações</small>
        </div>
        <div class="stat-card">
            <div>✅ Avaliações Realizadas</div>
            <div class="stat-number">${not empty totalAvaliacoes ? totalAvaliacoes : '0'}</div>
            <small>Total de provas feitas</small>
        </div>
        <div class="stat-card">
            <div>📝 Disponíveis</div>
            <div class="stat-number">${not empty avaliacoesDisponiveis ? avaliacoesDisponiveis : '0'}</div>
            <small>Avaliações para fazer</small>
        </div>
        <div class="stat-card">
            <div>🏆 Posição</div>
            <div class="stat-number">${not empty posicaoRanking ? posicaoRanking : 'N/A'}º</div>
            <small>No ranking geral</small>
        </div>
    </div>

    <!-- Avaliações Disponíveis -->
    <div class="card">
        <h3>📝 Avaliações Disponíveis para Realizar</h3>

        <c:if test="${empty avaliacoesRecentes}">
            <div style="text-align: center; padding: 40px; color: #666;">
                <p>🎉 Parabéns! Você já realizou todas as avaliações disponíveis.</p>
                <p>Novas avaliações serão disponibilizadas em breve.</p>
                <a href="/aluno-avaliacoes" class="btn btn-primary">Ver Todas as Avaliações</a>
            </div>
        </c:if>

        <c:if test="${not empty avaliacoesRecentes}">
            <div class="avaliacoes-grid">
                <c:forEach var="avaliacao" items="${avaliacoesRecentes}" varStatus="status">
                    <div class="avaliacao-card">
                        <div class="avaliacao-header">
                            <h4 class="avaliacao-title">${avaliacao.titulo}</h4>
                            <span class="badge badge-success">✅ Disponível</span>
                        </div>

                        <c:if test="${not empty avaliacao.descricao}">
                            <p style="color: #666; margin-bottom: 15px;">${avaliacao.descricao}</p>
                        </c:if>

                        <div class="avaliacao-info">
                            <div>
                                <strong>⏰ Duração:</strong><br>
                                    ${avaliacao.duracaoMinutos} minutos
                            </div>
                            <div>
                                <strong>📊 Status:</strong><br>
                                    ${avaliacao.status}
                            </div>
                        </div>

                        <div style="display: flex; gap: 10px; margin-top: 15px;">
                            <a href="/aluno-avaliacoes/iniciar/${avaliacao.idAvaliacao}"
                               class="btn btn-primary"
                               style="flex: 1; text-align: center;">
                                🚀 Iniciar
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div style="text-align: center; margin-top: 20px;">
                <a href="/aluno-avaliacoes" class="btn btn-success">
                    📋 Ver Todas as Avaliações Disponíveis
                </a>
            </div>
        </c:if>
    </div>

    <!-- Últimos Resultados - CORREÇÃO: REMOVER REFERÊNCIA A idUsuarioAvaliacao -->
    <div class="card">
        <h3>📊 Últimos Resultados</h3>
        <table class="table">
            <thead>
            <tr>
                <th>Avaliação</th>
                <th>Nota</th>
                <th>Status</th>
                <th>Data</th>
                <th>Ação</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="nota" items="${notasRecentes}">
                <tr>
                    <td>
                        <strong>${nota.tituloAvaliacao}</strong>
                    </td>
                    <td>
                        <strong>${nota.notaPercentual}%</strong>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${nota.notaPercentual >= 70}">
                                <span class="badge badge-success">Aprovado</span>
                            </c:when>
                            <c:when test="${nota.notaPercentual >= 50}">
                                <span class="badge badge-warning">Recuperação</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-danger">Reprovado</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty nota.dataRealizacao}">
                                ${nota.dataRealizacao}
                            </c:when>
                            <c:otherwise>
                                N/A
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <!-- CORREÇÃO: Remover link que depende de idUsuarioAvaliacao -->
                        <span class="btn btn-primary" style="padding: 5px 10px; background: #6c757d; border: none;"
                              title="Detalhes não disponíveis">
                            📈 Ver Detalhes
                        </span>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty notasRecentes}">
                <tr>
                    <td colspan="5" style="text-align: center; color: #666; padding: 20px;">
                        📝 Nenhuma avaliação realizada ainda.
                        <a href="/aluno-avaliacoes" style="margin-left: 10px;">Fazer primeira avaliação</a>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- Ranking Geral -->
    <div class="card">
        <h3>🏆 Ranking Geral - Top 5</h3>
        <table class="table">
            <thead>
            <tr>
                <th>Posição</th>
                <th>Aluno</th>
                <th>Média Geral</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="aluno" items="${rankingAlunos}" varStatus="status">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${status.index == 0}">🥇</c:when>
                            <c:when test="${status.index == 1}">🥈</c:when>
                            <c:when test="${status.index == 2}">🥉</c:when>
                            <c:otherwise>${status.index + 1}º</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:if test="${aluno.idUsuario == usuario.idUsuario}">
                            <strong>👉 ${aluno.nome} (Você)</strong>
                        </c:if>
                        <c:if test="${aluno.idUsuario != usuario.idUsuario}">
                            ${aluno.nome}
                        </c:if>
                    </td>
                    <td><strong>${aluno.mediaGeral}%</strong></td>
                    <td>
                        <c:if test="${aluno.idUsuario == usuario.idUsuario}">
                            <span class="badge badge-info">Sua posição</span>
                        </c:if>
                        <c:if test="${aluno.idUsuario != usuario.idUsuario}">
                            <span class="badge badge-success">Top ${status.index + 1}</span>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty rankingAlunos}">
                <tr>
                    <td colspan="4" style="text-align: center; color: #666; padding: 20px;">
                        📊 Nenhum dado de ranking disponível.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- Ações de Navegação -->
    <div class="card">
        <h3>🧭 Navegação</h3>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="/aluno-avaliacoes" class="btn btn-primary">📝 Central de Avaliações</a>
            <a href="/menu-aluno" class="btn btn-success">🔄 Atualizar Dashboard</a>
            <a href="/logout" class="btn btn-warning">🚪 Sair do Sistema</a>
        </div>
    </div>
</div>

<script>
    // Atualizar automaticamente a cada 60 segundos
    setTimeout(function() {
        window.location.reload();
    }, 60000);

    // Animações de entrada
    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.card');
        cards.forEach((card, index) => {
            card.style.animationDelay = (index * 0.1) + 's';
            card.style.animation = 'fadeInUp 0.5s ease-out';
        });
    });

    // Notificação de novas avaliações
    <c:if test="${not empty avaliacoesRecentes && avaliacoesRecentes.size() > 0}">
    if (Notification.permission === 'granted') {
        new Notification('📝 Novas Avaliações Disponíveis', {
            body: 'Você tem ${avaliacoesRecentes.size()} avaliação(ões) para realizar!',
            icon: '/favicon.ico'
        });
    } else if (Notification.permission !== 'denied') {
        Notification.requestPermission();
    }
    </c:if>
</script>
</body>
</html>