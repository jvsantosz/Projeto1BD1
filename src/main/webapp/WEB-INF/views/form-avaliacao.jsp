<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Nova Avaliação</title>
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
            max-width: 800px;
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
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }
        .form-control:focus {
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
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        .btn-warning:hover {
            background: #e67e22;
        }
        .questao-item {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }
        .questao-item:hover {
            background: #e9ecef;
        }
        .questao-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 10px;
        }
        .checkbox-group {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            flex: 1;
        }
        .questao-texto {
            flex: 1;
        }
        .pontuacao-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .pontuacao-input {
            width: 80px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-align: center;
        }
        .questao-detalhes {
            font-size: 0.9em;
            color: #666;
            margin-top: 5px;
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
    </style>
</head>
<body>
<div class="header">
    <h1>📝 ${avaliacao.idAvaliacao != null ? 'Editar' : 'Nova'} Avaliação</h1>
    <div>
        <a href="/avaliacoes" class="btn btn-warning">📋 Voltar</a>
    </div>
</div>

<div class="container">
    <!-- Mensagens -->
    <c:if test="${param.erro != null}">
        <div class="mensagem erro">❌ ${param.erro}</div>
    </c:if>

    <div class="card">
        <form action="/avaliacoes/salvar" method="post" id="formAvaliacao">

            <div class="form-group">
                <label for="titulo">📌 Título da Avaliação *</label>
                <input type="text" id="titulo" name="titulo" class="form-control"
                       value="${avaliacao.titulo}" required placeholder="Ex: Prova de Matemática - 1º Bimestre">
            </div>

            <div class="form-group">
                <label for="descricao">📝 Descrição</label>
                <textarea id="descricao" name="descricao" class="form-control" rows="3"
                          placeholder="Descreva o objetivo desta avaliação...">${avaliacao.descricao}</textarea>
            </div>

            <div class="form-group">
                <label for="duracaoMinutos">⏰ Duração (minutos) *</label>
                <input type="number" id="duracaoMinutos" name="duracaoMinutos" class="form-control"
                       value="${avaliacao.duracaoMinutos != null ? avaliacao.duracaoMinutos : 60}"
                       min="1" max="480" required>
            </div>

            <div class="form-group">
                <label>❓ Questões da Avaliação</label>
                <small style="display: block; color: #666; margin-bottom: 10px;">
                    Selecione as questões que farão parte desta avaliação:
                </small>

                <c:if test="${empty questoes}">
                    <div style="text-align: center; padding: 20px; color: #666; background: #f8f9fa; border-radius: 8px;">
                        <p>📝 Nenhuma questão disponível.</p>
                        <a href="/questoes/nova" class="btn btn-primary">Criar Primeira Questão</a>
                    </div>
                </c:if>

                <c:if test="${not empty questoes}">
                    <div style="max-height: 400px; overflow-y: auto; border: 1px solid #e9ecef; border-radius: 8px; padding: 15px;">
                        <c:forEach var="questao" items="${questoes}" varStatus="status">
                            <div class="questao-item">
                                <div class="questao-header">
                                    <div class="checkbox-group">
                                        <input type="checkbox"
                                               id="questao_${questao.idQuestao}"
                                               name="questoesSelecionadas"
                                               value="${questao.idQuestao}"
                                               class="questao-checkbox">
                                        <div class="questao-texto">
                                            <label for="questao_${questao.idQuestao}" style="margin: 0; font-weight: 600; cursor: pointer;">
                                                    ${questao.descricaoQuestao}
                                            </label>
                                            <div class="questao-detalhes">
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
                                                <span style="margin-left: 10px;">Pontuação padrão: ${questao.valorPontuacao} pts</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="pontuacao-group">
                                        <label for="pontuacao_${questao.idQuestao}" style="font-size: 0.9em; color: #666;">Pontos:</label>
                                        <input type="number"
                                               id="pontuacao_${questao.idQuestao}"
                                               name="pontuacoes"
                                               class="pontuacao-input"
                                               placeholder="pts"
                                               step="0.5"
                                               min="0.5"
                                               max="10"
                                               value="1.0">
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div style="margin-top: 10px; font-size: 0.9em; color: #666;">
                        <strong>📊 Total selecionado:</strong>
                        <span id="totalSelecionadas">0</span> questões |
                        <span id="totalPontos">0</span> pontos
                    </div>
                </c:if>
            </div>

            <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 25px;">
                <a href="/avaliacoes" class="btn btn-warning">❌ Cancelar</a>
                <button type="submit" class="btn btn-primary">💾 Salvar Avaliação</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const checkboxes = document.querySelectorAll('.questao-checkbox');
        const pontuacaoInputs = document.querySelectorAll('input[name="pontuacoes"]');

        // Atualizar totais
        function atualizarTotais() {
            const checkboxesSelecionados = document.querySelectorAll('.questao-checkbox:checked');
            let totalPontos = 0;

            pontuacaoInputs.forEach((input, index) => {
                if (checkboxes[index].checked) {
                    totalPontos += parseFloat(input.value) || 0;
                }
            });

            document.getElementById('totalSelecionadas').textContent = checkboxesSelecionados.length;
            document.getElementById('totalPontos').textContent = totalPontos.toFixed(1);
        }

        // Atualizar quando checkboxes ou inputs mudam
        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', atualizarTotais);
        });

        pontuacaoInputs.forEach(input => {
            input.addEventListener('input', atualizarTotais);
        });

        // Validação do formulário
        document.getElementById('formAvaliacao').addEventListener('submit', function(e) {
            const titulo = document.getElementById('titulo').value.trim();
            const duracao = document.getElementById('duracaoMinutos').value;
            const questaoSelecionadas = document.querySelectorAll('.questao-checkbox:checked');

            if (!titulo) {
                alert('Por favor, preencha o título da avaliação.');
                e.preventDefault();
                return;
            }

            if (!duracao || duracao < 1) {
                alert('A duração deve ser de pelo menos 1 minuto.');
                e.preventDefault();
                return;
            }

            // Verificar pontuações das questões selecionadas
            let todasPontuacoesValidas = true;
            const questaoIdsSelecionadas = [];
            const pontuacoesSelecionadas = [];

            checkboxes.forEach((checkbox, index) => {
                if (checkbox.checked) {
                    const pontuacaoInput = pontuacaoInputs[index];
                    const valor = parseFloat(pontuacaoInput.value);

                    questaoIdsSelecionadas.push(checkbox.value);
                    pontuacoesSelecionadas.push(valor);

                    if (!valor || valor < 0.5 || valor > 10) {
                        todasPontuacoesValidas = false;
                        pontuacaoInput.style.borderColor = 'red';
                    } else {
                        pontuacaoInput.style.borderColor = '';
                    }
                }
            });

            if (!todasPontuacoesValidas) {
                alert('Por favor, verifique as pontuações. Todas devem estar entre 0.5 e 10 pontos.');
                e.preventDefault();
                return;
            }

            if (questaoSelecionadas.length === 0) {
                if (!confirm('Nenhuma questão foi selecionada. Deseja criar a avaliação sem questões?')) {
                    e.preventDefault();
                    return;
                }
            }

            // DEBUG: Mostrar no console o que será enviado
            console.log('📝 Questões selecionadas:', questaoIdsSelecionadas);
            console.log('📊 Pontuações:', pontuacoesSelecionadas);
            console.log('🔢 Total de questões:', questaoIdsSelecionadas.length);
            console.log('🔢 Total de pontuações:', pontuacoesSelecionadas.length);
        });

        // Inicializar totais
        atualizarTotais();
    });
</script>
</body>
</html>