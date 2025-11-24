<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Configurar encoding
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");

    String erro = request.getParameter("erro");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Login | Sistema de Avaliações</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        #login-container {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .input-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 16px;
        }
        button {
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .links-uteis {
            text-align: center;
            margin-top: 20px;
        }
        .links-uteis a {
            color: #007bff;
            text-decoration: none;
        }
        .links-uteis a:hover {
            text-decoration: underline;
        }
        .erro {
            color: red;
            text-align: center;
            margin-top: 15px;
            padding: 10px;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
        }
    </style>
</head>
<body>

<div id="login-container">
    <h1>Entrar no Sistema</h1>

    <form action="/login" method="POST">
        <div class="input-group">
            <label for="usuario">Email:</label>
            <input type="text" id="usuario" name="usuario" required>
        </div>

        <div class="input-group">
            <label for="senha">Senha:</label>
            <input type="password" id="senha" name="senha" required>
        </div>

        <button type="submit">Entrar</button>

        <% if (erro != null) { %>
        <div class="erro"><%= erro %></div>
        <% } %>
    </form>

    <p class="links-uteis">
        <a href="/usuarios/novo">Cadastrar Usuario</a>
    </p>
</div>

</body>
</html>