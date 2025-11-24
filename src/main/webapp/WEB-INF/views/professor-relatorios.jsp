<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Relatórios do Professor</title>
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
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            margin: 5px;
        }
        .btn-primary { background: #667eea; color: white; }
        .btn-warning { background: #f39c12; color: white; }
        .btn-info { background: #17a2b8; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,0,0,0.2); }
        .avaliacao-item {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .stat-card {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
        }
        .stat-number {
            font-size: 1.8em;
            font-weight: bold;
            margin: 5px 0;
        }
        .ranking-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        .ranking-table th, .ranking-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        .ranking-table th {
            background: #667eea;
            color: white;
        }
        .ranking-table tr:hover {
            background: #f8f9fa;
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

        /* Animações */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .fade-in {
            animation: fadeInUp 0.6s ease-out;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>📊 Relatórios do Professor</h1>
    <div>
        <a href="/menu-professor" class="btn btn-warning">🏠 Voltar ao Menu</a>
        <a href="/professor/avaliacoes" class="btn btn-primary">📝 Minhas Avaliações</a>
    </div>
</div>

<div class="container">
    <!-- Mensagens -->
    <c:if test="${not empty param.sucesso}">
        <div class="card fade-in" style="background: #d4edda; color: #155724; border-left: 4px solid #28a745;">
            <div style="display: flex; align-items: center;">
                <span style="font-size: 1.2em; margin-right: 10px;">✅</span>
                <strong>${param.sucesso}</strong>
            </div>
        </div>
    </c:if>
    <c:if test="${not empty param.erro}">
        <div class="card fade-in" style="background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545;">
            <div style="display: flex; align-items: center;">
                <span style="font-size: 1.2em; margin-right: 10px;">❌</span>
                <strong>${param.erro}</strong>
            </div>
        </div>
    </c:if>

    <!-- Informações do Professor -->
    <div class="card fade-in">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h2 style="margin: 0; color: #667eea;">👨‍🏫 Olá, ${professor.nome}!</h2>
                <p style="margin: 5px 0 0 0; color: #666;">Aqui estão todos os relatórios disponíveis para análise</p>
            </div>
            <div style="text-align: right;">
                <div class="stat-card" style="display: inline-block; margin: 0;">
                    <div class="stat-label">Avaliações</div>
                    <div class="stat-number">${not empty avaliacoes ? avaliacoes.size() : 0}</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Relatórios Gerais -->
    <div class="card fade-in">
        <h2>📈 Relatórios Gerais do Sistema</h2>
        <p style="color: #666; margin-bottom: 20px;">
            Análises completas de todo o sistema educacional
        </p>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 15px; margin: 20px 0;">
            <!-- Coluna 1 -->
            <div style="display: flex; flex-direction: column; gap: 10px;">
                <a href="/professor/relatorios/top5-geral" class="btn btn-success" style="text-align: left; justify-content: flex-start;">
                    🏆 Top 5 Alunos (Geral)
                </a>
                <a href="/professor/relatorios/questoes-sem-corretas" class="btn btn-warning" style="text-align: left; justify-content: flex-start;">
                    ❌ Questões sem Alternativas Corretas
                </a>
                <a href="/professor/relatorios/avaliacoes-sem-questoes" class="btn btn-danger" style="text-align: left; justify-content: flex-start;">
                    📝 Avaliações sem Questões
                </a>
                <a href="/professor/relatorios/alunos-nunca-fizeram" class="btn btn-info" style="text-align: left; justify-content: flex-start;">
                    📋 Alunos que Nunca Fizeram
                </a>
            </div>

            <!-- Coluna 2 -->
            <div style="display: flex; flex-direction: column; gap: 10px;">
                <a href="/professor/relatorios/questoes-nunca-utilizadas" class="btn btn-primary" style="text-align: left; justify-content: flex-start;">
                    📊 Questões Nunca Utilizadas
                </a>
                <a href="/professor/relatorios/alunos-nota-maxima" class="btn btn-success" style="text-align: left; justify-content: flex-start;">
                    ⭐ Alunos Nota Máxima
                </a>
                <a href="/professor/relatorios/alunos-acima-media" class="btn btn-info" style="text-align: left; justify-content: flex-start;">
                    📈 Alunos Acima da Média
                </a>
                <a href="/professor/relatorios/questoes-multiplas-corretas" class="btn btn-warning" style="text-align: left; justify-content: flex-start;">
                    ❓ Questões Múltiplas Corretas
                </a>
            </div>

            <!-- Coluna 3 -->
            <div style="display: flex; flex-direction: column; gap: 10px;">
                <a href="/professor/relatorios/questoes-nunca-respondidas" class="btn btn-primary" style="text-align: left; justify-content: flex-start;">
                    📝 Questões Nunca Respondidas
                </a>
                <a href="/professor/relatorios/avaliacoes-com-nota-zero" class="btn btn-danger" style="text-align: left; justify-content: flex-start;">
                    0️⃣ Avaliações com Nota Zero
                </a>
                <a href="/professor/relatorios/avaliacoes-duracao-acima-media" class="btn btn-info" style="text-align: left; justify-content: flex-start;">
                    ⏰ Avaliações Duração Acima Média
                </a>
                <a href="/professor/relatorios/alunos-completaram-todas" class="btn btn-success" style="text-align: left; justify-content: flex-start;">
                    ✅ Alunos Completaram Todas
                </a>
            </div>
        </div>
    </div>

    <!-- Relatórios por Avaliação -->
    <div class="card fade-in">
        <h2>🎯 Relatórios por Avaliação</h2>
        <p style="color: #666; margin-bottom: 20px;">
            Selecione uma avaliação para ver relatórios específicos
        </p>

        <!-- Avaliações do Professor -->
        <c:choose>
            <c:when test="${not empty avaliacoes}">
                <div style="display: grid; gap: 15px;">
                    <c:forEach items="${avaliacoes}" var="avaliacao" varStatus="status">
                        <div class="avaliacao-item fade-in" style="animation-delay: ${status.index * 0.1}s;">
                            <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                                <div style="flex: 1;">
                                    <h3 style="margin: 0 0 10px 0; color: #333;">
                                        📝 ${avaliacao.titulo}
                                    </h3>
                                    <c:if test="${not empty avaliacao.descricao}">
                                        <p style="margin: 0 0 10px 0; color: #666; font-size: 0.9em;">
                                                ${avaliacao.descricao}
                                        </p>
                                    </c:if>
                                    <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                                        <span class="badge badge-info">
                                            ID: ${avaliacao.idAvaliacao}
                                        </span>
                                        <c:if test="${not empty avaliacao.duracaoMinutos}">
                                            <span class="badge badge-warning">
                                                ⏱️ ${avaliacao.duracaoMinutos} min
                                            </span>
                                        </c:if>
                                        <!-- CORREÇÃO AQUI: usando status em vez de statusAvaliacao -->
                                        <c:if test="${not empty avaliacao.status}">
                                            <span class="badge
                                                <c:choose>
                                                    <c:when test="${avaliacao.status == 'ATIVA'}">badge-success</c:when>
                                                    <c:when test="${avaliacao.status == 'INATIVA'}">badge-danger</c:when>
                                                    <c:otherwise>badge-info</c:otherwise>
                                                </c:choose>">
                                                    ${avaliacao.status}
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                                <div style="display: flex; gap: 10px; flex-wrap: wrap; margin-left: 20px;">
                                    <a href="/professor/relatorios/top5-avaliacao/${avaliacao.idAvaliacao}"
                                       class="btn btn-primary"
                                       title="Ver os 5 melhores alunos">
                                        🏆 Top 5
                                    </a>
                                    <a href="/professor/relatorios/zeraram-avaliacao/${avaliacao.idAvaliacao}"
                                       class="btn btn-warning"
                                       title="Alunos que tiraram zero">
                                        0️⃣ Zeraram
                                    </a>
                                    <a href="/professor/relatorios/estatisticas-avaliacao/${avaliacao.idAvaliacao}"
                                       class="btn btn-info"
                                       title="Estatísticas completas">
                                        📈 Estatísticas
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 40px; color: #666;" class="fade-in">
                    <div style="font-size: 4em; margin-bottom: 20px;">📝</div>
                    <h3 style="margin: 0 0 15px 0;">Nenhuma Avaliação Encontrada</h3>
                    <p style="margin: 0 0 25px 0; max-width: 400px; margin-left: auto; margin-right: auto;">
                        Você ainda não criou nenhuma avaliação ou não há dados disponíveis no momento.
                    </p>
                    <a href="/professor/avaliacoes" class="btn btn-primary" style="font-size: 1.1em;">
                        📝 Criar Primeira Avaliação
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Informações Rápidas -->
    <div class="card fade-in">
        <h3>ℹ️ Como Usar os Relatórios</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
            <div style="background: #e7f3ff; padding: 15px; border-radius: 8px; border-left: 4px solid #17a2b8;">
                <strong>🏆 Top 5 Alunos</strong>
                <p style="margin: 5px 0 0 0; font-size: 0.9em;">
                    Veja os alunos com melhor desempenho em cada avaliação ou no geral
                </p>
            </div>
            <div style="background: #fff3cd; padding: 15px; border-radius: 8px; border-left: 4px solid #ffc107;">
                <strong>0️⃣ Alunos que Zeraram</strong>
                <p style="margin: 5px 0 0 0; font-size: 0.9em;">
                    Identifique alunos que precisam de atenção especial e apoio
                </p>
            </div>
            <div style="background: #d4edda; padding: 15px; border-radius: 8px; border-left: 4px solid #28a745;">
                <strong>📈 Estatísticas Gerais</strong>
                <p style="margin: 5px 0 0 0; font-size: 0.9em;">
                    Média da turma, maiores e menores notas, taxa de conclusão
                </p>
            </div>
            <div style="background: #f8d7da; padding: 15px; border-radius: 8px; border-left: 4px solid #dc3545;">
                <strong>❌ Questões Problemáticas</strong>
                <p style="margin: 5px 0 0 0; font-size: 0.9em;">
                    Identifique questões sem alternativas corretas ou com problemas
                </p>
            </div>
        </div>
    </div>
</div>

<script>
    // Efeitos visuais
    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.card');
        cards.forEach((card, index) => {
            card.style.animationDelay = (index * 0.1) + 's';
        });

        // Adicionar hover effects nas avaliações
        const avaliacaoItems = document.querySelectorAll('.avaliacao-item');
        avaliacaoItems.forEach(item => {
            item.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
                this.style.boxShadow = '0 8px 25px rgba(0,0,0,0.15)';
            });

            item.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
                this.style.boxShadow = '0 2px 10px rgba(0,0,0,0.1)';
            });
        });
    });
</script>
</body>
</html>