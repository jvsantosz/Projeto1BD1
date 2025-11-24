<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Avaliações Disponíveis</title>
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
        .avaliacao-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
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
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .avaliacao-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        .avaliacao-title {
            font-size: 1.3em;
            font-weight: 600;
            color: #333;
            margin: 0;
        }
        .avaliacao-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin: 15px 0;
        }
        .info-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9em;
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
            text-align: center;
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
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>📝 Avaliações Disponíveis</h1>
    <div>
        <a href="/menu-aluno" class="btn btn-warning">🎓 Voltar ao Menu</a>
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
        <h3>📋 Lista de Avaliações para Realizar</h3>

        <c:if test="${empty avaliacoes}">
            <div class="empty-state">
                <p>🎉 Parabéns! Você já realizou todas as avaliações disponíveis.</p>
                <p>Novas avaliações serão disponibilizadas em breve.</p>
                <a href="/menu-aluno" class="btn btn-primary">Voltar ao Menu</a>
            </div>
        </c:if>

        <c:if test="${not empty avaliacoes}">
            <div class="avaliacao-grid">
                <c:forEach var="avaliacao" items="${avaliacoes}">
                    <div class="avaliacao-card">
                        <div class="avaliacao-header">
                            <h3 class="avaliacao-title">${avaliacao.titulo}</h3>
                            <span class="badge badge-success">✅ Disponível</span>
                        </div>

                        <c:if test="${not empty avaliacao.descricao}">
                            <p style="color: #666; margin-bottom: 15px;">${avaliacao.descricao}</p>
                        </c:if>

                        <div class="avaliacao-info">
                            <div class="info-item">
                                <span>⏰</span>
                                <strong>${avaliacao.duracaoMinutos} minutos</strong>
                            </div>
                            <div class="info-item">
                                <span>📊</span>
                                <strong>${avaliacao.duracaoMinutos} min</strong>
                            </div>
                            <div class="info-item">
                                <span>📅</span>
                                <c:if test="${not empty avaliacao.dataInicio}">
                                    <small>Início: ${avaliacao.dataInicio}</small>
                                </c:if>
                                <c:if test="${empty avaliacao.dataInicio}">
                                    <small>Sem data limite</small>
                                </c:if>
                            </div>
                            <div class="info-item">
                                <span>⏱️</span>
                                <c:if test="${not empty avaliacao.dataFim}">
                                    <small>Fim: ${avaliacao.dataFim}</small>
                                </c:if>
                                <c:if test="${empty avaliacao.dataFim}">
                                    <small>Sem prazo final</small>
                                </c:if>
                            </div>
                        </div>

                        <div style="display: flex; gap: 10px; margin-top: 15px;">
                            <a href="/aluno-avaliacoes/iniciar/${avaliacao.idAvaliacao}"
                               class="btn btn-primary"
                               style="flex: 1; text-align: center;"
                               onclick="return confirmarInicio('${avaliacao.titulo}', ${avaliacao.duracaoMinutos})">
                                🚀 Iniciar Avaliação
                            </a>
                        </div>

                        <div style="margin-top: 10px; font-size: 0.8em; color: #666;">
                            <c:if test="${not empty avaliacao.dataInicio || not empty avaliacao.dataFim}">
                                <strong>📅 Período:</strong>
                                <c:if test="${not empty avaliacao.dataInicio}">
                                    ${avaliacao.dataInicio}
                                </c:if>
                                <c:if test="${not empty avaliacao.dataFim}">
                                    até ${avaliacao.dataFim}
                                </c:if>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div style="text-align: center; margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px;">
                <strong>📊 Resumo:</strong>
                    ${avaliacoes.size()} avaliação(ões) disponível(is) para realização
            </div>
        </c:if>
    </div>

    <!-- Informações Importantes -->
    <div class="card">
        <h3>ℹ️ Informações Importantes</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
            <div style="background: #e7f3ff; padding: 15px; border-radius: 8px;">
                <strong>⏰ Controle de Tempo</strong>
                <p style="margin: 5px 0 0 0; font-size: 0.9em;">
                    O tempo será contado a partir do momento que você iniciar a avaliação.
                </p>
            </div>
            <div style="background: #fff3cd; padding: 15px; border-radius: 8px;">
                <strong>💾 Salvamento Automático</strong>
                <p style="margin: 5px 0 0 0; font-size: 0.9em;">
                    Suas respostas são salvas automaticamente a cada alteração.
                </p>
            </div>
            <div style="background: #d4edda; padding: 15px; border-radius: 8px;">
                <strong>📝 Revisão Permitida</strong>
                <p style="margin: 5px 0 0 0; font-size: 0.9em;">
                    Você pode revisar e alterar respostas antes de finalizar.
                </p>
            </div>
        </div>
    </div>

    <!-- Ações Rápidas -->
    <div class="card">
        <h3>🚀 Ações Rápidas</h3>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="/menu-aluno" class="btn btn-warning">🎓 Voltar ao Menu</a>
            <a href="/aluno-avaliacoes" class="btn btn-primary">🔄 Atualizar Lista</a>
        </div>
    </div>
</div>

<script>
    // Confirmação para iniciar avaliação
    function confirmarInicio(titulo, duracao) {
        return confirm('Deseja iniciar a avaliação: \"' + titulo + '\"?\n\nDuração: ' + duracao + ' minutos\n\n⚠️ O tempo começará a contar imediatamente!');
    }
</script>
</body>
</html>