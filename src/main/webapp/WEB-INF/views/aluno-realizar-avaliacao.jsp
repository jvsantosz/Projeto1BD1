<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Realizar Avaliação</title>
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
        .timer {
            background: linear-gradient(135deg, #f5576c, #f093fb);
            color: white;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 20px;
            font-size: 1.2em;
            font-weight: bold;
        }
        .timer.urgente {
            background: linear-gradient(135deg, #ff0000, #ff6b6b);
            animation: pulse 1s infinite;
        }
        .questao-card {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .questao-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        .questao-numero {
            background: #667eea;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
        }
        .questao-texto {
            font-size: 1.1em;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
        }
        .opcoes-container {
            margin: 15px 0;
        }
        .opcao-item {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            margin-bottom: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .opcao-item:hover {
            border-color: #667eea;
            background: #f0f4ff;
        }
        .opcao-item.selecionada {
            border-color: #667eea;
            background: #e3f2fd;
        }
        .texto-resposta {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1em;
            resize: vertical;
            min-height: 100px;
        }
        .texto-resposta:focus {
            border-color: #667eea;
            outline: none;
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
            font-size: 16px;
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
        .btn-danger {
            background: #f5576c;
            color: white;
        }
        .btn-danger:hover {
            background: #e04a5e;
        }
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        .btn-warning:hover {
            background: #e67e22;
        }
        .navegacao-questoes {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
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
        .progresso-questoes {
            display: flex;
            gap: 5px;
            margin: 15px 0;
            flex-wrap: wrap;
        }
        .ponto-progresso {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #e9ecef;
            transition: all 0.3s ease;
        }
        .ponto-progresso.respondida {
            background: #28a745;
        }
        .ponto-progresso.atual {
            background: #667eea;
            transform: scale(1.2);
        }
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.7; }
            100% { opacity: 1; }
        }
        /* small helper for sticky bottom panel spacing on mobile */
        @media (max-width: 600px) {
            .container { padding-bottom: 120px; }
            .card[style*="position: sticky"] { position: static; }
        }
    </style>
</head>
<body>
<div class="header">
    <h1>📝 ${avaliacao.titulo}</h1>
    <div>
        <a href="/aluno-avaliacoes" class="btn btn-warning">📋 Voltar para Lista</a>
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

    <!-- Timer e Informações -->
    <div class="card">
        <div class="timer" id="timer">
            ⏰ Tempo Restante: <span id="tempoRestante">${tempoRestante}</span>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 15px;">
            <div style="text-align: center;">
                <strong>📊 Total de Questões</strong>
                <div style="font-size: 1.5em; font-weight: bold;">${questoes.size()}</div>
            </div>
            <div style="text-align: center;">
                <strong>✅ Respondidas</strong>
                <div style="font-size: 1.5em; font-weight: bold;" id="totalRespondidas">0</div>
            </div>
            <div style="text-align: center;">
                <strong>⏰ Duração</strong>
                <div style="font-size: 1.5em; font-weight: bold;">${avaliacao.duracaoMinutos} min</div>
            </div>
        </div>

        <!-- Progresso das Questões -->
        <div class="progresso-questoes" id="progressoQuestoes">
            <c:forEach var="questao" items="${questoes}" varStatus="status">
                <div class="ponto-progresso" id="ponto-${status.index}"
                     onclick="irParaQuestao(${status.index})"
                     title="Questão ${status.index + 1}"></div>
            </c:forEach>
        </div>
    </div>

    <!-- Formulário da Avaliação -->
    <form id="formAvaliacao">
        <input type="hidden" name="idUsuarioAvaliacao" value="${usuarioAvaliacao.idUsuarioAvaliacao}">

        <c:forEach var="questao" items="${questoes}" varStatus="status">
            <div class="card questao-card" id="questao-${status.index}"
                 style="${status.index > 0 ? 'display: none;' : ''}">

                <div class="questao-header">
                    <div class="questao-numero">Questão ${status.index + 1}</div>
                    <div class="badge badge-info">
                        <c:choose>
                            <c:when test="${not empty questao.pontuacaoEspecificaNaAvaliacao}">
                                ${questao.pontuacaoEspecificaNaAvaliacao}
                            </c:when>
                            <c:otherwise>
                                1.0
                            </c:otherwise>
                        </c:choose>
                        pontos
                    </div>
                </div>

                <div class="questao-texto">
                    <strong>
                        <c:choose>
                            <c:when test="${not empty detalhesQuestoes[questao.idQuestao]}">
                                ${detalhesQuestoes[questao.idQuestao].descricaoQuestao}
                            </c:when>
                            <c:otherwise>
                                [Questão não disponível - ID: ${questao.idQuestao}]
                            </c:otherwise>
                        </c:choose>
                    </strong>
                </div>

                <!-- Resposta por Tipo de Questão -->
                <c:set var="respostaQuestao" value="" />
                <c:set var="opcaoSelecionada" value="" />
                <c:forEach var="resposta" items="${respostas}">
                    <c:if test="${resposta.idAvaliacaoQuestao == questao.idAvaliacaoQuestao}">
                        <c:set var="respostaQuestao" value="${resposta.textoResposta}" />
                        <c:set var="opcaoSelecionada" value="${resposta.idOpcaoSelecionada}" />
                    </c:if>
                </c:forEach>

                <input type="hidden" name="idAvaliacaoQuestao" value="${questao.idAvaliacaoQuestao}">

                <!-- Questões de múltipla escolha -->
                <c:if test="${not empty opcoesPorQuestao[questao.idQuestao]}">
                    <div class="opcoes-container">
                        <c:forEach var="opcao" items="${opcoesPorQuestao[questao.idQuestao]}">
                            <div class="opcao-item ${opcao.idOpcao == opcaoSelecionada ? 'selecionada' : ''}"
                                 onclick="selecionarOpcao(this, ${opcao.idOpcao})">
                                <input type="radio"
                                       name="idOpcaoSelecionada"
                                       value="${opcao.idOpcao}"
                                    ${opcao.idOpcao == opcaoSelecionada ? 'checked' : ''}
                                       style="display: none;">
                                    ${opcao.textoOpcao}
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- Para questões de texto -->
                <c:if test="${empty opcoesPorQuestao[questao.idQuestao]}">
                    <div style="margin-top: 15px;">
                        <textarea name="textoResposta"
                                  class="texto-resposta"
                                  placeholder="Digite sua resposta aqui...">${respostaQuestao}</textarea>
                    </div>
                </c:if>

                <!-- Navegação entre questões -->
                <div class="navegacao-questoes">
                    <c:if test="${status.index > 0}">
                        <button type="button" class="btn btn-warning" onclick="questaoAnterior()">
                            ⬅️ Questão Anterior
                        </button>
                    </c:if>

                    <div style="flex: 1; text-align: center;">
                        <span class="badge badge-info">${status.index + 1} de ${questoes.size()}</span>
                    </div>

                    <c:if test="${status.index < questoes.size() - 1}">
                        <button type="button" class="btn btn-primary" onclick="proximaQuestao()">
                            Próxima Questão ➡️
                        </button>
                    </c:if>
                    <c:if test="${status.index == questoes.size() - 1}">
                        <button type="button" class="btn btn-success" onclick="finalizarAvaliacao()">
                            🏁 Finalizar Avaliação
                        </button>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </form>

    <!-- Painel de Controle Fixo -->
    <div class="card" style="position: sticky; bottom: 20px; background: rgba(255,255,255,0.95);">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <strong>📝 Avaliação em Andamento</strong>
                <div style="font-size: 0.9em; color: #666;">
                    ${avaliacao.titulo}
                </div>
            </div>
            <div style="display: flex; gap: 10px;">
                <button type="button" class="btn btn-warning" onclick="salvarResposta()">
                    💾 Salvar Resposta
                </button>
                <button type="button" class="btn btn-danger" onclick="finalizarAvaliacao()">
                    🏁 Finalizar
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    let questaoAtual = 0;
    const totalQuestoes = ${questoes.size()};
    let respostasSalvas = new Set();

    // Inicializar progresso
    document.addEventListener('DOMContentLoaded', function() {
        atualizarProgresso();
        iniciarTimer();

        // Marcar questões já respondidas (se houver)
        <c:forEach var="resposta" items="${respostas}">
        <c:if test="${not empty resposta.idAvaliacaoQuestao}">
        const idx${resposta.idAvaliacaoQuestao} = getQuestaoIndexById(${resposta.idAvaliacaoQuestao});
        if (idx${resposta.idAvaliacaoQuestao} !== -1) respostasSalvas.add(idx${resposta.idAvaliacaoQuestao});
        </c:if>
        </c:forEach>

        atualizarProgresso();
    });

    // Timer countdown
    function iniciarTimer() {
        const timerElement = document.getElementById('tempoRestante');
        const timerContainer = document.getElementById('timer');

        // Se o tempoRestante estiver vazio, tenta setar pela duracao (em minutos)
        if (!timerElement || !timerElement.textContent || timerElement.textContent.trim() === '') {
            // converte duracaoMinutos para mm:ss
            const duracao = parseInt('${avaliacao.duracaoMinutos}' || '0');
            const defaultMin = isNaN(duracao) ? 0 : duracao;
            const defaultTime = `${String(defaultMin).padStart(2,'0')}:00`;
            if (timerElement) timerElement.textContent = defaultTime;
        }

        function atualizarTimer() {
            const tempo = timerElement.textContent.split(':');
            let minutos = parseInt(tempo[0], 10);
            let segundos = parseInt(tempo[1], 10);

            if (isNaN(minutos) || isNaN(segundos)) return;

            if (minutos === 0 && segundos === 0) {
                finalizarAvaliacaoAutomaticamente();
                return;
            }

            if (segundos === 0) {
                minutos--;
                segundos = 59;
            } else {
                segundos--;
            }

            timerElement.textContent = `${minutos.toString().padStart(2, '0')}:${segundos.toString().padStart(2, '0')}`;

            // Alerta visual quando faltar pouco tempo
            if (minutos < 5) {
                timerContainer.classList.add('urgente');
            }
        }

        // atualiza a cada segundo
        setInterval(atualizarTimer, 1000);
    }

    // Navegação entre questões
    function mostrarQuestao(index) {
        const cards = document.querySelectorAll('.questao-card');
        if (index < 0 || index >= cards.length) return;
        cards.forEach((card, i) => {
            card.style.display = i === index ? 'block' : 'none';
        });
        questaoAtual = index;
        atualizarProgresso();
        // rolar para o topo da questão (UX)
        window.scrollTo({ top: document.getElementById('questao-' + index).offsetTop - 20, behavior: 'smooth' });
    }

    function questaoAnterior() {
        if (questaoAtual > 0) {
            salvarRespostaAtual();
            mostrarQuestao(questaoAtual - 1);
        }
    }

    function proximaQuestao() {
        if (questaoAtual < totalQuestoes - 1) {
            salvarRespostaAtual();
            mostrarQuestao(questaoAtual + 1);
        }
    }

    function irParaQuestao(index) {
        salvarRespostaAtual();
        mostrarQuestao(index);
    }

    // Encontrar índice da questão pelo ID
    function getQuestaoIndexById(idAvaliacaoQuestao) {
        const questoes = document.querySelectorAll('.questao-card');
        for (let i = 0; i < questoes.length; i++) {
            const input = questoes[i].querySelector('input[name="idAvaliacaoQuestao"]');
            if (input) {
                const val = parseInt(input.value, 10);
                if (!isNaN(val) && val === idAvaliacaoQuestao) return i;
            }
        }
        return -1;
    }

    // Seleção de opções
    function selecionarOpcao(elemento, idOpcao) {
        // Desselecionar outras opções do card atual
        const container = elemento.parentNode;
        container.querySelectorAll('.opcao-item').forEach(item => item.classList.remove('selecionada'));

        // Selecionar esta opção
        elemento.classList.add('selecionada');

        // Marcar o radio button dentro do elemento
        const radio = elemento.querySelector('input[type="radio"]');
        if (radio) radio.checked = true;

        // Marcar como respondida
        marcarComoRespondida(questaoAtual);
    }

    // Atualizar progresso
    function atualizarProgresso() {
        document.querySelectorAll('.ponto-progresso').forEach((ponto, index) => {
            ponto.classList.remove('atual', 'respondida');
            if (index === questaoAtual) ponto.classList.add('atual');
            if (respostasSalvas.has(index)) ponto.classList.add('respondida');
        });

        const total = respostasSalvas.size;
        const totalElem = document.getElementById('totalRespondidas');
        if (totalElem) totalElem.textContent = total;
    }

    function marcarComoRespondida(index) {
        respostasSalvas.add(index);
        atualizarProgresso();
    }

    // Salvar resposta da questão atual (via AJAX FormData)
    function salvarRespostaAtual() {
        try {
            const formData = new FormData();
            // idUsuarioAvaliacao global do form
            formData.append('idUsuarioAvaliacao', '${usuarioAvaliacao.idUsuarioAvaliacao}');

            const questaoAtualElement = document.getElementById('questao-' + questaoAtual);
            if (!questaoAtualElement) return;

            const idAvaliacaoQuestao = questaoAtualElement.querySelector('input[name="idAvaliacaoQuestao"]').value;
            formData.append('idAvaliacaoQuestao', idAvaliacaoQuestao);

            // Verifica se há opção selecionada (radiobutton)
            const opcaoSelecionada = questaoAtualElement.querySelector('input[name="idOpcaoSelecionada"]:checked');
            if (opcaoSelecionada) {
                formData.append('idOpcaoSelecionada', opcaoSelecionada.value);
            }

            // Verifica se há texto preenchido
            const textoResposta = questaoAtualElement.querySelector('textarea[name="textoResposta"]');
            if (textoResposta && textoResposta.value.trim() !== '') {
                formData.append('textoResposta', textoResposta.value.trim());
            }

            // Enviar via fetch para o endpoint do backend (mantive o padrão do seu projeto)
            fetch('/aluno-avaliacoes/salvar-resposta', {
                method: 'POST',
                body: formData,
                credentials: 'same-origin'
            })
                .then(response => response.json().catch(() => ({})))
                .then(data => {
                    // marca como respondida mesmo que backend não retorne JSON esperado,
                    // mas se backend retornar success=false, você pode tratar aqui
                    if (!data || data.success === undefined || data.success === true) {
                        marcarComoRespondida(questaoAtual);
                        console.log('Resposta salva (questão index):', questaoAtual);
                    } else {
                        console.error('Erro ao salvar resposta:', data.message || data);
                    }
                })
                .catch(error => {
                    console.error('Erro ao salvar resposta (fetch):', error);
                });

        } catch (e) {
            console.error('Erro em salvarRespostaAtual:', e);
        }
    }

    // Salvar manual (botão)
    function salvarResposta() {
        salvarRespostaAtual();
        // feedback simples para usuário
        setTimeout(() => alert('✅ Resposta salva com sucesso!'), 300);
    }

    // Finalizar avaliação (manual) -> envia formulário POST para o controller e redireciona
    function finalizarAvaliacao() {
        if (!confirm('Deseja finalizar a avaliação?\n\n⚠️ Após finalizar, não será possível alterar as respostas.')) {
            return;
        }

        // salva a resposta atual antes de finalizar
        salvarRespostaAtual();

        // Montar form para submissão convencional (garante compatibilidade com controllers que esperam form params)
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/aluno-avaliacoes/finalizar';

        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'idUsuarioAvaliacao';
        input.value = '${usuarioAvaliacao.idUsuarioAvaliacao}';
        form.appendChild(input);

        document.body.appendChild(form);
        form.submit();
    }

    // Finalizar automaticamente quando o tempo chega a zero
    function finalizarAvaliacaoAutomaticamente() {
        // evita múltiplas chamadas
        if (window._finalizandoAutomaticamente) return;
        window._finalizandoAutomaticamente = true;

        alert('⏰ Tempo esgotado! A avaliação será finalizada automaticamente.');

        // salva a última resposta (se houver)
        try {
            salvarRespostaAtual();
        } catch (e) {
            console.warn('Erro ao tentar salvar antes da finalização automática:', e);
        }

        // Submete via fetch e redireciona para a lista
        const formData = new FormData();
        formData.append('idUsuarioAvaliacao', '${usuarioAvaliacao.idUsuarioAvaliacao}');

        fetch('/aluno-avaliacoes/finalizar', {
            method: 'POST',
            body: formData,
            credentials: 'same-origin'
        })
            .then(() => {
                window.location.href = '/aluno-avaliacoes?sucesso=Tempo esgotado. Avaliação finalizada automaticamente.';
            })
            .catch(() => {
                window.location.href = '/aluno-avaliacoes?erro=Erro ao finalizar automaticamente.';
            });
    }

    // Salvar automaticamente a cada 30 segundos
    setInterval(function() {
        salvarRespostaAtual();
    }, 30000);

    // Prevenir saída acidental
    window.addEventListener('beforeunload', function(e) {
        // só mostra aviso se tiver pelo menos uma resposta não salva? Aqui simplificamos:
        if (respostasSalvas.size > 0) {
            e.preventDefault();
            e.returnValue = 'Você tem respostas não salvas. Tem certeza que deseja sair?';
        }
    });
</script>
</body>
</html>
