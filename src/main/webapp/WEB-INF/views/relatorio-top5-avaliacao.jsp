<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Top 5 Alunos - Avaliação</title>
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
        .btn-primary { background: #667eea; color: white; }
        .btn-warning { background: #f39c12; color: white; }
        .ranking-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        .ranking-table th, .ranking-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        .ranking-table th {
            background: #667eea;
            color: white;
            font-weight: 600;
        }
        .ranking-table tr:hover {
            background: #f8f9fa;
        }
        .posicao {
            width: 60px;
            text-align: center;
            font-weight: bold;
            font-size: 1.2em;
        }
        .primeiro { color: #FFD700; } /* Ouro */
        .segundo { color: #C0C0C0; } /* Prata */
        .terceiro { color: #CD7F32; } /* Bronze */
        .percentual {
            font-weight: bold;
        }
        .excelente { color: #28a745; }
        .bom { color: #17a2b8; }
        .regular { color: #ffc107; }
    </style>
</head>
<body>
<div class="header">
    <h1>🏆 Top 5 Alunos</h1>
    <div>
        <a href="/professor/relatorios" class="btn btn-warning">📊 Voltar aos Relatórios</a>
        <a href="/professor/relatorios/estatisticas-avaliacao/${idAvaliacao}" class="btn btn-primary">📈 Ver Estatísticas</a>
    </div>
</div>

<div class="container">
    <div class="card">
        <h2>🎯 Melhores Desempenhos</h2>
        <p style="color: #666; margin-bottom: 20px;">
            Ranking dos 5 alunos com melhor desempenho nesta avaliação
        </p>

        <c:if test="${empty top5Alunos}">
            <div style="text-align: center; padding: 40px; color: #666;">
                <h3>📝 Nenhum aluno concluiu esta avaliação ainda</h3>
                <p>Aguarde até que os alunos finalizem a avaliação para ver o ranking.</p>
            </div>
        </c:if>

        <c:if test="${not empty top5Alunos}">
            <table class="ranking-table">
                <thead>
                <tr>
                    <th class="posicao">#</th>
                    <th>Aluno</th>
                    <th>Nota</th>
                    <th>Percentual</th>
                    <th>Desempenho</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="aluno" items="${top5Alunos}" varStatus="status">
                    <tr>
                        <td class="posicao
                                <c:if test="${status.index == 0}">primeiro</c:if>
                                <c:if test="${status.index == 1}">segundo</c:if>
                                <c:if test="${status.index == 2}">terceiro</c:if>">
                                ${status.index + 1}º
                        </td>
                        <td>
                            <strong>${aluno.nome}</strong>
                        </td>
                        <td>
                            <strong>${aluno.nota}</strong> pontos
                        </td>
                        <td>
                                <span class="percentual
                                    <c:choose>
                                        <c:when test="${aluno.percentual >= 90}">excelente</c:when>
                                        <c:when test="${aluno.percentual >= 70}">bom</c:when>
                                        <c:otherwise>regular</c:otherwise>
                                    </c:choose>">
                                    ${aluno.percentual}%
                                </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${aluno.percentual >= 90}">
                                    <span style="color: #28a745;">✅ Excelente</span>
                                </c:when>
                                <c:when test="${aluno.percentual >= 70}">
                                    <span style="color: #17a2b8;">👍 Bom</span>
                                </c:when>
                                <c:when test="${aluno.percentual >= 50}">
                                    <span style="color: #ffc107;">⚠️ Regular</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #dc3545;">❌ Precisa Melhorar</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <!-- Legenda -->
            <div style="background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 20px;">
                <h4>📊 Legenda de Desempenho:</h4>
                <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                    <div><span style="color: #28a745;">●</span> 90-100%: Excelente</div>
                    <div><span style="color: #17a2b8;">●</span> 70-89%: Bom</div>
                    <div><span style="color: #ffc107;">●</span> 50-69%: Regular</div>
                    <div><span style="color: #dc3545;">●</span> 0-49%: Precisa Melhorar</div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Ações Rápidas -->
    <div class="card">
        <h3>🚀 Ações Rápidas</h3>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="/professor/relatorios/zeraram-avaliacao/${idAvaliacao}" class="btn btn-warning">
                0️⃣ Ver Alunos que Zeraram
            </a>
            <button onclick="window.print()" class="btn btn-primary">
                🖨️ Imprimir Ranking
            </button>
            <a href="/professor/relatorios" class="btn btn-warning">
                📊 Todos os Relatórios
            </a>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Adiciona animação de entrada
        const rows = document.querySelectorAll('.ranking-table tbody tr');
        rows.forEach((row, index) => {
            row.style.animationDelay = (index * 0.1) + 's';
            row.style.animation = 'fadeInUp 0.5s ease-out';
        });
    });
</script>
</body>
</html>