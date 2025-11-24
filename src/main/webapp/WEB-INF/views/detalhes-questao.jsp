<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Detalhes da Questão</title>
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
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.1);
        }
        .info-item {
            margin-bottom: 15px;
            padding: 10px;
            border-bottom: 1px solid #eee;
        }
        .info-label {
            font-weight: bold;
            color: #333;
            display: block;
            margin-bottom: 5px;
        }
        .info-value {
            color: #666;
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
        .badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
        }
        .badge-info { background: #d1ecf1; color: #0c5460; }
        .badge-warning { background: #fff3cd; color: #856404; }
        .badge-success { background: #d4edda; color: #155724; }
        .mensagem {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
            text-align: center;
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
    <h1>👀 Detalhes da Questão</h1>
</div>

<div class="container">
    <!-- Verificar se a questão existe -->
    <c:if test="${empty questao}">
        <div class="card">
            <div class="mensagem erro">
                <p>❌ Questão não encontrada ou não existe.</p>
                <a href="/questoes" class="btn btn-primary">Voltar para Lista</a>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty questao}">
        <!-- Informações Básicas -->
        <div class="card">
            <h3>📋 Informações da Questão</h3>

            <div class="info-item">
                <span class="info-label">ID:</span>
                <span class="info-value">${questao.idQuestao}</span>
            </div>

            <div class="info-item">
                <span class="info-label">Descrição:</span>
                <span class="info-value">${questao.descricaoQuestao}</span>
            </div>

            <div class="info-item">
                <span class="info-label">Tipo:</span>
                <span class="info-value">
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
                    </span>
            </div>

            <div class="info-item">
                <span class="info-label">Pontuação:</span>
                <span class="info-value">
                        <strong>${questao.valorPontuacao} pontos</strong>
                    </span>
            </div>

            <div class="info-item">
                <span class="info-label">Data de Criação:</span>
                <span class="info-value">${questao.dataCriacao}</span>
            </div>
        </div>

        <!-- Feedbacks -->
        <c:if test="${not empty questao.feedbackCorreto || not empty questao.feedbackIncorreto}">
            <div class="card">
                <h3>💬 Feedbacks</h3>

                <c:if test="${not empty questao.feedbackCorreto}">
                    <div class="info-item">
                        <span class="info-label" style="color: #28a745;">✅ Feedback Correto:</span>
                        <span class="info-value">${questao.feedbackCorreto}</span>
                    </div>
                </c:if>

                <c:if test="${not empty questao.feedbackIncorreto}">
                    <div class="info-item">
                        <span class="info-label" style="color: #dc3545;">❌ Feedback Incorreto:</span>
                        <span class="info-value">${questao.feedbackIncorreto}</span>
                    </div>
                </c:if>
            </div>
        </c:if>

        <!-- Ações -->
        <div class="card">
            <h3>⚡ Ações</h3>
            <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                <a href="/questoes/editar/${questao.idQuestao}" class="btn btn-warning">✏️ Editar Questão</a>
                <a href="/questoes" class="btn btn-primary">← Voltar para Lista</a>
                <a href="/avmarcos@gmail.comaliacoes/nova" class="btn btn-primary">📝 Usar em Avaliação</a>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>