<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.pjbd1.model.Usuario" %>
<%
    List<Usuario> alunos = (List<Usuario>) request.getAttribute("alunos");
    if (alunos == null) {
        alunos = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Alunos Nota Máxima</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: #4CAF50; color: white; padding: 10px; }
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
    </style>
</head>
<body>
<a href="/professor/relatorios" class="voltar">← Voltar</a>
<h1>🎯 Alunos com Nota Máxima</h1>

<% if (alunos.isEmpty()) { %>
<p>Nenhum aluno obteve nota máxima em todas as avaliações.</p>
<% } else { %>
<p>Total: <strong><%= alunos.size() %></strong> aluno(s)</p>
<table>
    <tr>
        <th>ID</th>
        <th>Nome</th>
    </tr>
    <% for (Usuario aluno : alunos) { %>
    <tr>
        <td><%= aluno.getIdUsuario() %></td>
        <td><strong><%= aluno.getNome() %></strong> 🏆</td>
    </tr>
    <% } %>
</table>
<% } %>
</body>
</html>