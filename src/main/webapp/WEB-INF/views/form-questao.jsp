<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Nova Questão</title>
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
            box-shadow: 0 5px 25px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 16px;
            font-family: 'Segoe UI', Arial, sans-serif;
        }
        textarea {
            min-height: 100px;
            resize: vertical;
        }
        .btn {
            padding: 12px 30px;
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
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        .btn-warning:hover {
            background: #e67e22;
        }
        .btn-danger {
            background: #e74c3c;
            color: white;
            padding: 5px 10px;
            font-size: 14px;
        }
        .btn-danger:hover {
            background: #c0392b;
        }
        .opcoes-container {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin: 15px 0;
            background: #f8f9fa;
        }
        .opcao-item {
            padding: 10px;
            border-bottom: 1px solid #eee;
        }
        .opcao-item:last-child {
            border-bottom: none;
        }
        .mensagem {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .erro {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .opcao-header {
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>📝 Nova Questão</h1>
</div>

<div class="container">
    <div class="card">
        <!-- Mensagem de Erro -->
        <c:if test="${param.erro != null}">
            <div class="mensagem erro">❌ ${param.erro}</div>
        </c:if>

        <form action="/questoes/salvar" method="post" id="formQuestao">
            <!-- Descrição da Questão -->
            <div class="form-group">
                <label for="descricaoQuestao">📋 Descrição da Questão:</label>
                <textarea id="descricaoQuestao" name="descricaoQuestao"
                          placeholder="Digite o enunciado da questão..." required></textarea>
            </div>

            <!-- Tipo da Questão -->
            <div class="form-group">
                <label for="tipoQuestao">🎯 Tipo da Questão:</label>
                <select id="tipoQuestao" name="tipoQuestao" required onchange="toggleOpcoes()">
                    <option value="">Selecione o tipo...</option>
                    <option value="MULTIPLA">🔘 Múltipla Escolha</option>
                    <option value="TEXTO">📝 Texto Livre</option>
                    <option value="NUMERICA">🔢 Numérica</option>
                </select>
            </div>

            <!-- Pontuação -->
            <div class="form-group">
                <label for="valorPontuacao">⭐ Valor da Pontuação:</label>
                <input type="number" id="valorPontuacao" name="valorPontuacao"
                       step="0.5" min="0.5" max="100" value="10" required>
            </div>

            <!-- Feedbacks (Opcionais) -->
            <div class="form-group">
                <label for="feedbackCorreto">✅ Feedback para Resposta Correta (Opcional):</label>
                <textarea id="feedbackCorreto" name="feedbackCorreto"
                          placeholder="Mensagem que o aluno verá ao acertar..."></textarea>
            </div>

            <div class="form-group">
                <label for="feedbackIncorreto">❌ Feedback para Resposta Incorreta (Opcional):</label>
                <textarea id="feedbackIncorreto" name="feedbackIncorreto"
                          placeholder="Mensagem que o aluno verá ao errar..."></textarea>
            </div>

            <!-- Container para Opções (Aparece apenas para Múltipla Escolha) -->
            <div id="opcoesContainer" class="opcoes-container" style="display: none;">
                <h4>🔘 Opções de Resposta (Múltipla Escolha)</h4>
                <div id="opcoesList">
                    <!-- Opções serão adicionadas dinamicamente -->
                </div>
                <button type="button" class="btn btn-primary" onclick="adicionarOpcao()">➕ Adicionar Opção</button>
            </div>

            <!-- Botões -->
            <div style="display: flex; gap: 15px; margin-top: 30px;">
                <button type="submit" class="btn btn-primary">💾 Salvar Questão</button>
                <a href="/questoes" class="btn btn-warning">← Voltar para Lista</a>
            </div>
        </form>
    </div>
</div>

<script>
    // Contador de opções
    let contadorOpcoes = 0;

    // Mostrar/ocultar opções baseado no tipo
    function toggleOpcoes() {
        const tipo = document.getElementById('tipoQuestao').value;
        const container = document.getElementById('opcoesContainer');
        console.log('Tipo selecionado:', tipo);

        if (tipo === 'MULTIPLA') {
            container.style.display = 'block';
            const opcoesExistentes = document.querySelectorAll('#opcoesList .opcao-item');
            console.log('Opções existentes:', opcoesExistentes.length);
            if (opcoesExistentes.length === 0) {
                adicionarOpcao();
                adicionarOpcao();
            }
        } else {
            container.style.display = 'none';
        }
    }

    // Adicionar nova opção - CORRIGIDO
    function adicionarOpcao() {
        contadorOpcoes++;
        const opcoesList = document.getElementById('opcoesList');

        const opcaoDiv = document.createElement('div');
        opcaoDiv.className = 'opcao-item';

        // ✅ CORRIGIDO: Use concatenação em vez de template literal
        opcaoDiv.innerHTML =
            '<div class="opcao-header">' +
            '<input type="text" name="opcoesTexto" placeholder="Texto da opção..." required style="flex: 1;">' +
            '<label style="display: flex; align-items: center; gap: 5px; white-space: nowrap;">' +
            '<input type="checkbox" name="opcoesCorretas" value="' + contadorOpcoes + '">' +
            'Correta' +
            '</label>' +
            '<button type="button" class="btn btn-danger" onclick="removerOpcao(this)">🗑️</button>' +
            '</div>';

        opcoesList.appendChild(opcaoDiv);
        console.log('✅ Opção adicionada, valor do checkbox:', contadorOpcoes);
    }

    // Remover opção
    function removerOpcao(botao) {
        const opcaoItem = botao.closest('.opcao-item');
        const opcoesList = document.getElementById('opcoesList');
        const opcoesExistentes = opcoesList.querySelectorAll('.opcao-item');

        if (opcoesExistentes.length <= 1) {
            alert('A questão deve ter pelo menos uma opção!');
            return;
        }

        opcaoItem.remove();
    }

    // Validação do formulário
    document.getElementById('formQuestao').addEventListener('submit', function(e) {
        const tipo = document.getElementById('tipoQuestao').value;
        const pontuacao = document.getElementById('valorPontuacao').value;

        if (!tipo) {
            alert('Selecione o tipo da questão!');
            e.preventDefault();
            return;
        }

        if (pontuacao <= 0) {
            alert('A pontuação deve ser maior que zero!');
            e.preventDefault();
            return;
        }

        if (tipo === 'MULTIPLA') {
            const opcoes = document.querySelectorAll('input[name="opcoesTexto"]');
            if (opcoes.length < 2) {
                alert('Questões de múltipla escolha precisam de pelo menos 2 opções!');
                e.preventDefault();
                return;
            }

            const temCorreta = document.querySelector('input[name="opcoesCorretas"]:checked');
            if (!temCorreta) {
                alert('Selecione pelo menos uma opção como correta!');
                e.preventDefault();
                return;
            }
        }
    });

    console.log('Script de nova questão carregado!');
</script>
</body>
</html>