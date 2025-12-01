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
    <title>Alunos que Completaram Todas as Avaliações</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background: #f0f2f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 2px solid #28a745;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .voltar {
            display: inline-block;
            margin-bottom: 20px;
            padding: 8px 16px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .voltar:hover {
            background: #5a6268;
        }
        .contador {
            background: #28a745;
            color: white;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: bold;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th {
            background: #28a745;
            color: white;
            padding: 12px;
            text-align: left;
        }
        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .badge {
            background: #28a745;
            color: white;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        .sem-dados {
            text-align: center;
            padding: 40px;
            color: #666;
            border: 2px dashed #ddd;
            border-radius: 8px;
            margin: 20px 0;
        }
        .aluno-nome {
            font-weight: bold;
        }
        .aluno-id {
            font-size: 12px;
            color: #666;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="/professor/relatorios" class="voltar">← Voltar</a>
    <h1>✅ Alunos que Completaram Todas as Avaliações</h1>

    <% if (alunos.isEmpty()) { %>
    <div class="sem-dados">
        <h3>📋 Nenhum aluno completou todas as avaliações</h3>
        <p>Não há alunos que tenham concluído todas as avaliações atribuídas.</p>
    </div>
    <% } else { %>
    <div class="contador">
        Total de alunos: <%= alunos.size() %>
    </div>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Nome do Aluno</th>
            <th>Status</th>
        </tr>
        </thead>
        <tbody>
        <% for (Usuario aluno : alunos) { %>
        <tr>
            <td><%= aluno.getIdUsuario() %></td>
            <td>
                <div class="aluno-nome"><%= aluno.getNome() %></div>
            </td>
            <td>
                <span class="badge">✅ CONCLUÍDO</span>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</div>
</body>
</html>