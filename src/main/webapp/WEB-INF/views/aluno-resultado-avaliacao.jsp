<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Resultado da Avaliação</title>
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
        .resumo-nota {
            text-align: center;
            padding: 30px;
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .nota-grande {
            font-size: 3em;
            font-weight: bold;
            margin: 10px 0;
        }
        .questao-item {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
        }
        .questao-correta {
            border-left: 5px solid #28a745;
        }
        .questao-incorreta {
            border-left: 5px solid #dc3545;
        }
        .resposta-aluno {
            background: #e7f3ff;
            padding: 10px;
            border-radius: 5px;
            margin: 5px 0;
        }
        .resposta-correta {
            background: #d4edda;
            padding: 10px;
            border-radius: 5px;
            margin: 5px 0;
        }
        .btn {
            padding: 12px 25px;
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
        .badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
        }
        .badge-success { background: #d4edda; color: #155724; }
        .badge-danger { background: #f8d7da; color: #721c24; }
        .badge-info { background: #d1ecf1; color: #0c5460; }
    </style>
</head>
<body>
<div class="header">
    <h1>📊 Resultado da Avaliação</h1>
    <div>
        <a href="/aluno-avaliacoes" class="btn btn-primary">📋 Voltar para Avaliações</a>
    </div>
</div>

<div class="container">
    <!-- DEBUG INFO -->
    <div class="card" style="background: #fff3cd; display: none;" id="debugInfo">
        <h4>🔧 Informações de Debug:</h4>
        <p>Total Questões: ${questoes.size()}</p>
        <p>Total Respostas: ${respostas.size()}</p>
        <p>DetalhesQuestoes: ${detalhesQuestoes.size()}</p>
        <p>OpcoesPorQuestao: ${opcoesPorQuestao.size()}</p>
    </div>

    <!-- Resumo da Nota -->
    <div class="card">
        <div class="resumo-nota">
            <h2>${avaliacao.titulo}</h2>
            <div class="nota-grande">
                <c:choose>
                    <c:when test="${not empty usuarioAvaliacao.notaTotalObtida}">
                        ${usuarioAvaliacao.notaTotalObtida}
                    </c:when>
                    <c:otherwise>
                        0.0
                    </c:otherwise>
                </c:choose>
            </div>
            <p>Nota Final</p>
            <small>
                Realizada em:
                <c:choose>
                    <c:when test="${not empty usuarioAvaliacao.dataFimReal}">
                        ${usuarioAvaliacao.dataFimReal}
                    </c:when>
                    <c:otherwise>
                        Data não disponível
                    </c:otherwise>
                </c:choose>
                <br>
                Status: ${usuarioAvaliacao.statusResposta}
            </small>
        </div>
    </div>

    <!-- Detalhes das Questões -->
    <div class="card">
        <h3>📝 Detalhamento por Questão</h3>

        <c:if test="${empty questoes}">
            <div style="text-align: center; padding: 40px; color: #666;">
                <p>Nenhuma questão encontrada para esta avaliação.</p>
            </div>
        </c:if>

        <c:forEach var="questao" items="${questoes}" varStatus="status">
            <c:set var="respostaAluno" value="${null}" />
            <c:forEach var="resposta" items="${respostas}">
                <c:if test="${resposta.idAvaliacaoQuestao == questao.idAvaliacaoQuestao}">
                    <c:set var="respostaAluno" value="${resposta}" />
                </c:if>
            </c:forEach>

            <div class="questao-item
                <c:choose>
                    <c:when test="${respostaAluno.notaObtida != null && questao.pontuacaoEspecificaNaAvaliacao != null && respostaAluno.notaObtida.compareTo(questao.pontuacaoEspecificaNaAvaliacao) == 0}">
                        questao-correta
                    </c:when>
                    <c:otherwise>
                        questao-incorreta
                    </c:otherwise>
                </c:choose>">

                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px;">
                    <h4>Questão ${status.index + 1}</h4>
                    <div class="badge
                        <c:choose>
                            <c:when test="${respostaAluno.notaObtida != null && questao.pontuacaoEspecificaNaAvaliacao != null && respostaAluno.notaObtida.compareTo(questao.pontuacaoEspecificaNaAvaliacao) == 0}">
                                badge-success
                            </c:when>
                            <c:otherwise>
                                badge-danger
                            </c:otherwise>
                        </c:choose>">
                        <c:choose>
                            <c:when test="${not empty respostaAluno.notaObtida}">
                                ${respostaAluno.notaObtida}
                            </c:when>
                            <c:otherwise>
                                0.0
                            </c:otherwise>
                        </c:choose>
                        /
                        <c:choose>
                            <c:when test="${not empty questao.pontuacaoEspecificaNaAvaliacao}">
                                ${questao.pontuacaoEspecificaNaAvaliacao}
                            </c:when>
                            <c:otherwise>
                                0.0
                            </c:otherwise>
                        </c:choose>
                        pts
                    </div>
                </div>

                <!-- Texto da Questão -->
                <div style="margin-bottom: 15px;">
                    <strong>
                        <!-- CORREÇÃO: Usar idQuestao como chave -->
                        <c:choose>
                            <c:when test="${not empty detalhesQuestoes[questao.idQuestao]}">
                                ${detalhesQuestoes[questao.idQuestao].descricaoQuestao}
                            </c:when>
                            <c:otherwise>
                                [Texto da questão não disponível - ID: ${questao.idQuestao}]
                            </c:otherwise>
                        </c:choose>
                    </strong>
                </div>

                <!-- Resposta do Aluno -->
                <div style="margin-bottom: 10px;">
                    <strong>Sua Resposta:</strong>
                    <div class="resposta-aluno">
                        <c:choose>
                            <c:when test="${not empty respostaAluno}">
                                <c:choose>
                                    <c:when test="${not empty respostaAluno.textoResposta}">
                                        ${respostaAluno.textoResposta}
                                    </c:when>
                                    <c:when test="${not empty respostaAluno.idOpcaoSelecionada}">
                                        <c:set var="opcaoSelecionada" value="${null}" />
                                        <!-- CORREÇÃO: Usar idQuestao como chave -->
                                        <c:if test="${not empty opcoesPorQuestao[questao.idQuestao]}">
                                            <c:forEach var="opcao" items="${opcoesPorQuestao[questao.idQuestao]}">
                                                <c:if test="${opcao.idOpcao == respostaAluno.idOpcaoSelecionada}">
                                                    <c:set var="opcaoSelecionada" value="${opcao.textoOpcao}" />
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                        <c:choose>
                                            <c:when test="${not empty opcaoSelecionada}">
                                                ${opcaoSelecionada}
                                            </c:when>
                                            <c:otherwise>
                                                Opção ${respostaAluno.idOpcaoSelecionada}
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <em style="color: #999;">Nenhuma resposta fornecida</em>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <em style="color: #999;">Nenhuma resposta encontrada</em>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Feedback -->
                <!-- CORREÇÃO: Usar idQuestao como chave -->
                <c:if test="${not empty detalhesQuestoes[questao.idQuestao]}">
                    <c:choose>
                        <c:when test="${respostaAluno.notaObtida != null && questao.pontuacaoEspecificaNaAvaliacao != null && respostaAluno.notaObtida.compareTo(questao.pontuacaoEspecificaNaAvaliacao) == 0}">
                            <c:if test="${not empty detalhesQuestoes[questao.idQuestao].feedbackCorreto}">
                                <div style="margin-top: 10px; padding: 10px; background: #d4edda; border-radius: 5px;">
                                    <strong>✅ Feedback:</strong> ${detalhesQuestoes[questao.idQuestao].feedbackCorreto}
                                </div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${not empty detalhesQuestoes[questao.idQuestao].feedbackIncorreto}">
                                <div style="margin-top: 10px; padding: 10px; background: #f8d7da; border-radius: 5px;">
                                    <strong>❌ Feedback:</strong> ${detalhesQuestoes[questao.idQuestao].feedbackIncorreto}
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </div>
        </c:forEach>
    </div>

    <!-- Ações -->
    <div class="card" style="text-align: center;">
        <a href="/aluno-avaliacoes" class="btn btn-primary">📋 Voltar para Avaliações</a>
        <a href="/menu-aluno" class="btn btn-primary">🎓 Voltar ao Menu</a>
    </div>
</div>

<script>
    // Mostrar debug info se houver parâmetro de debug
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('debug')) {
        document.getElementById('debugInfo').style.display = 'block';
    }
</script>
</body>
</html>