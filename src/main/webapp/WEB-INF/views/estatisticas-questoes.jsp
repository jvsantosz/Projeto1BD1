<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Estatísticas de Questões</title>
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
        }
        .container {
            max-width: 1000px;
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
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        .btn-warning:hover {
            background: #e67e22;
        }
        .progress-bar {
            background: #e9ecef;
            border-radius: 10px;
            height: 20px;
            margin: 10px 0;
            overflow: hidden;
        }
        .progress {
            background: #28a745;
            height: 100%;
            border-radius: 10px;
            transition: width 0.3s ease;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>📊 Estatísticas de Questões</h1>
</div>

<div class="container">
    <c:if test="${not empty estatisticas}">
        <!-- Cartões de Estatísticas -->
        <div class="stats-grid">
            <div class="stat-card">
                <div>📚 Total</div>
                <div class="stat-number">${estatisticas.totalQuestoes}</div>
                <small>Questões criadas</small>
            </div>

            <div class="stat-card">
                <div>🔘 Múltipla Escolha</div>
                <div class="stat-number">${estatisticas.questoesMultiplaEscolha}</div>
                <small>Questões</small>
            </div>

            <div class="stat-card">
                <div>📝 Texto Livre</div>
                <div class="stat-number">${estatisticas.questoesTexto}</div>
                <small>Questões</small>
            </div>

            <div class="stat-card">
                <div>🔢 Numéricas</div>
                <div class="stat-number">${estatisticas.questoesNumerica}</div>
                <small>Questões</small>
            </div>
        </div>

        <!-- Análise Detalhada -->
        <div class="card">
            <h3>📈 Análise Detalhada</h3>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <!-- Questões Não Utilizadas -->
                <div>
                    <h4>📦 Questões Não Utilizadas</h4>
                    <div class="progress-bar">
                        <div class="progress" style="width: ${(estatisticas.questoesNaoUtilizadas / estatisticas.totalQuestoes) * 100}%"></div>
                    </div>
                    <p><strong>${estatisticas.questoesNaoUtilizadas}</strong> de ${estatisticas.totalQuestoes} questões</p>
                </div>

                <!-- Questões com Problemas -->
                <div>
                    <h4>⚠️ Questões com Problemas</h4>
                    <div class="progress-bar">
                        <div class="progress" style="width: ${(estatisticas.questoesSemCorretas / estatisticas.totalQuestoes) * 100}%; background: #dc3545;"></div>
                    </div>
                    <p><strong>${estatisticas.questoesSemCorretas}</strong> sem opções corretas</p>
                    <p><strong>${estatisticas.questoesMultiplasCorretas}</strong> com múltiplas corretas</p>
                </div>
            </div>
        </div>

        <!-- Recomendações -->
        <div class="card">
            <h3>💡 Recomendações</h3>
            <c:choose>
                <c:when test="${estatisticas.questoesSemCorretas > 0}">
                    <p style="color: #dc3545;">❌ Existem <strong>${estatisticas.questoesSemCorretas}</strong> questões sem opções corretas. Revise-as.</p>
                </c:when>
                <c:otherwise>
                    <p style="color: #28a745;">✅ Todas as questões têm opções corretas definidas.</p>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${estatisticas.questoesNaoUtilizadas > 0}">
                    <p>📦 <strong>${estatisticas.questoesNaoUtilizadas}</strong> questões não foram usadas em avaliações.</p>
                </c:when>
                <c:otherwise>
                    <p style="color: #28a745;">✅ Todas as questões estão sendo utilizadas.</p>
                </c:otherwise>
            </c:choose>
        </div>

    </c:if>

    <c:if test="${empty estatisticas}">
        <div class="card">
            <div style="text-align: center; padding: 40px; color: #666;">
                <p>📊 Nenhuma estatística disponível.</p>
                <p>Crie algumas questões primeiro.</p>
            </div>
        </div>
    </c:if>

    <!-- Ações -->
    <div class="card">
        <h3>⚡ Ações</h3>
        <div style="display: flex; gap: 10px;">
            <a href="/questoes" class="btn btn-primary">📋 Ver Todas as Questões</a>
            <a href="/questoes/nova" class="btn btn-primary">➕ Nova Questão</a>
            <a href="/menu-professor" class="btn btn-warning">👨‍🏫 Voltar ao Menu</a>
        </div>
    </div>
</div>
</body>
</html>