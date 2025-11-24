<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Alunos que Zeraram - Avaliação</title>
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
        .btn-danger { background: #dc3545; color: white; }
        .alunos-list {
            display: grid;
            gap: 10px;
            margin: 20px 0;
        }
        .aluno-item {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
        }
        .aluno-item:hover {
            background: #fff3cd;
            border-color: #ffc107;
        }
        .aluno-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .aluno-nome {
            font-weight: 600;
            font-size: 1.1em;
        }
        .status-zero {
            background: #dc3545;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
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
    <h1>0️⃣ Alunos que Zeraram</h1>
    <div>
        <a href="/professor/relatorios" class="btn btn-warning">📊 Voltar aos Relatórios</a>
        <a href="/professor/relatorios/top5-avaliacao/${idAvaliacao}" class="btn btn-primary">🏆 Ver Top 5</a>
    </div>
</div>

<div class="container">
    <div class="card">
        <h2>🎯 Alunos com Dificuldades</h2>
        <p style="color: #666; margin-bottom: 20px;">
            Lista de alunos que obtiveram nota zero nesta avaliação e podem precisar de atenção especial
        </p>

        <c:if test="${empty alunosZero}">
            <div class="empty-state">
                <h3>🎉 Excelente notícia!</h3>
                <p>Nenhum aluno zerou esta avaliação.</p>
                <p>Todos os alunos que concluíram obtiveram pelo menos alguns pontos.</p>
            </div>
        </c:if>

        <c:if test="${not empty alunosZero}">
            <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                <strong>⚠️ Atenção Professor:</strong>
                    ${alunosZero.size()} aluno(s) zerou/zeraram esta avaliação e pode(m) precisar de apoio adicional.
            </div>

            <div class="alunos-list">
                <c:forEach var="aluno" items="${alunosZero}" varStatus="status">
                    <div class="aluno-item">
                        <div class="aluno-info">
                            <div class="aluno-nome">${aluno.nome}</div>
                            <span class="status-zero">NOTA ZERO</span>
                        </div>
                        <div>
                            <small style="color: #666;">ID: ${aluno.idUsuario}</small>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Recomendações -->
            <div style="background: #fff3cd; padding: 20px; border-radius: 8px; margin-top: 20px;">
                <h4>💡 Recomendações Pedagógicas:</h4>
                <ul style="margin: 10px 0 0 20px;">
                    <li>Entre em contato individual com estes alunos</li>
                    <li>Ofereça revisão dos conceitos principais</li>
                    <li>Considere aplicar uma avaliação de recuperação</li>
                    <li>Verifique se houve problemas técnicos durante a prova</li>
                </ul>
            </div>
        </c:if>
    </div>

    <!-- Ações Rápidas -->
    <div class="card">
        <h3>🚀 Ações Rápidas</h3>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="/professor/relatorios/top5-avaliacao/${idAvaliacao}" class="btn btn-primary">
                🏆 Ver Melhores Alunos
            </a>
            <a href="/professor/relatorios/estatisticas-avaliacao/${idAvaliacao}" class="btn btn-warning">
                📈 Ver Estatísticas Completas
            </a>
            <button onclick="window.print()" class="btn btn-primary">
                🖨️ Imprimir Relatório
            </button>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const alunos = document.querySelectorAll('.aluno-item');
        alunos.forEach((aluno, index) => {
            aluno.style.animationDelay = (index * 0.1) + 's';
            aluno.style.animation = 'fadeInUp 0.5s ease-out';
        });
    });
</script>
</body>
</html>