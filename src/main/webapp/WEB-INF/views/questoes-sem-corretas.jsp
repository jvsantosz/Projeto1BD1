<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.pjbd1.model.Questao" %>
<%
    List<Questao> questoes = (List<Questao>) request.getAttribute("questoes");
    if (questoes == null) {
        questoes = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Questões sem Alternativas Corretas</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: #dc3545; color: white; padding: 10px; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        tr:hover { background: #f5f5f5; }
        .voltar {
            display: inline-block;
            padding: 8px 16px;
            background: #666;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .alert {
            background: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<a href="/professor/relatorios" class="voltar">← Voltar</a>
<h1>❌ Questões sem Alternativas Corretas</h1>

<% if (questoes.isEmpty()) { %>
<p style="color: #28a745;">✅ Todas as questões estão corretas!</p>
<% } else { %>
<div class="alert">
    <strong>Atenção:</strong> <%= questoes.size() %> questão(ões) sem alternativas corretas
</div>

<table>
    <tr>
        <th>ID</th>
        <th>Descrição</th>
        <th>Ação</th>
    </tr>
    <% for (Questao questao : questoes) { %>
    <tr>
        <td><%= questao.getIdQuestao() %></td>
        <td>
            <%= questao.getDescricaoQuestao() != null && questao.getDescricaoQuestao().length() > 100
                    ? questao.getDescricaoQuestao().substring(0, 100) + "..."
                    : questao.getDescricaoQuestao() %>
        </td>
        <td>
            <a href="/professor/questoes/editar/<%= questao.getIdQuestao() %>"
               style="color: #17a2b8; text-decoration: none;">
                ✏️ Editar
            </a>
        </td>
    </tr>
    <% } %>
</table>

<p style="margin-top: 20px; font-size: 0.9em; color: #666;">
    <strong>Nota:</strong> Estas questões não podem ser avaliadas automaticamente até que
    uma alternativa seja marcada como correta.
</p>
<% } %>
</body>
</html>