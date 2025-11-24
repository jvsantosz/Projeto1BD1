<%@ page import="java.util.List" %>
<%@ page import="com.example.pjbd1.model.Usuario" %>
<%
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    String erro = request.getParameter("erro");
    String sucesso = request.getParameter("sucesso");
%>
<html>
<head>
    <title>Administração de Usuários</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        .mensagem {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .sucesso {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .erro {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .acoes a {
            display: inline-block;
            padding: 5px 10px;
            margin: 2px;
            text-decoration: none;
            border-radius: 3px;
            font-size: 14px;
        }
        .editar {
            background-color: #ffc107;
            color: #212529;
        }
        .excluir {
            background-color: #dc3545;
            color: white;
        }
        .voltar {
            display: inline-block;
            padding: 10px 15px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>🏢 Administração de Usuários</h1>

    <% if (sucesso != null) { %>
    <div class="mensagem sucesso">✅ <%= sucesso %></div>
    <% } %>

    <% if (erro != null) { %>
    <div class="mensagem erro">❌ <%= erro %></div>
    <% } %>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Email</th>
            <th>Tipo</th>
            <th>Data Cadastro</th>
            <th>Status</th>
            <th>Ações</th>
        </tr>
        </thead>
        <tbody>
        <% for (Usuario usuario : usuarios) { %>
        <tr>
            <td><%= usuario.getIdUsuario() %></td>
            <td><%= usuario.getNome() %></td>
            <td><%= usuario.getEmail() %></td>
            <td>
                <% if ("PROFESSOR".equals(usuario.getTipoUsuario())) { %>
                👨‍🏫 Professor
                <% } else if ("ALUNO".equals(usuario.getTipoUsuario())) { %>
                👨‍🎓 Aluno
                <% } else { %>
                <%= usuario.getTipoUsuario() %>
                <% } %>
            </td>
            <td><%= usuario.getDataCadastro() %></td>
            <td>
                <% if (usuario.getAtivo()) { %>
                <span style="color: green;">✅ Ativo</span>
                <% } else { %>
                <span style="color: red;">❌ Inativo</span>
                <% } %>
            </td>
            <td class="acoes">
                <a href="/admin/editar/<%= usuario.getIdUsuario() %>" class="editar">✏️ Editar</a>
                <a href="/admin/excluir/<%= usuario.getIdUsuario() %>"
                   class="excluir"
                   onclick="return confirm('Tem certeza que deseja excluir o usuário <%= usuario.getNome() %>?')">🗑️ Excluir</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <a href="/" class="voltar">← Voltar para Login</a>
</div>
</body>
</html>