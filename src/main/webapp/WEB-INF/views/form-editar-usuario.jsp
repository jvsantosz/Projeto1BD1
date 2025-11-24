<%@ page import="com.example.pjbd1.model.Usuario" %>
<%
    Usuario usuario = (Usuario) request.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("/admin?erro=Usuário não encontrado");
        return;
    }
%>
<html>
<head>
    <title>Editar Usuário</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .radio-group {
            display: flex;
            gap: 20px;
            margin-top: 5px;
        }
        .radio-group label {
            display: flex;
            align-items: center;
            font-weight: normal;
            cursor: pointer;
        }
        .radio-group input[type="radio"] {
            margin-right: 5px;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .checkbox-group input[type="checkbox"] {
            width: auto;
        }
        .botoes {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        button, .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }
        .btn-salvar {
            background-color: #28a745;
            color: white;
        }
        .btn-cancelar {
            background-color: #6c757d;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>✏️ Editar Usuário</h2>

    <form action="/admin/atualizar" method="post">
        <input type="hidden" name="idUsuario" value="<%= usuario.getIdUsuario() %>">

        <div class="form-group">
            <label for="nome">Nome:</label>
            <input type="text" id="nome" name="nome" value="<%= usuario.getNome() %>" required>
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<%= usuario.getEmail() %>" required>
        </div>

        <div class="form-group">
            <label for="senha">Senha (deixe em branco para manter a atual):</label>
            <input type="password" id="senha" name="senha" placeholder="Nova senha">
        </div>

        <div class="form-group">
            <label>Tipo de Usuário:</label>
            <div class="radio-group">
                <label>
                    <input type="radio" name="tipoUsuario" value="ALUNO"
                        <%= "ALUNO".equals(usuario.getTipoUsuario()) ? "checked" : "" %>> 👨‍🎓 Aluno
                </label>
                <label>
                    <input type="radio" name="tipoUsuario" value="PROFESSOR"
                        <%= "PROFESSOR".equals(usuario.getTipoUsuario()) ? "checked" : "" %>> 👨‍🏫 Professor
                </label>
            </div>
        </div>

        <div class="form-group">
            <div class="checkbox-group">
                <input type="checkbox" id="ativo" name="ativo"
                    <%= usuario.getAtivo() ? "checked" : "" %> value="true">
                <label for="ativo">Usuário Ativo</label>
            </div>
        </div>

        <div class="botoes">
            <button type="submit" class="btn-salvar">💾 Salvar Alterações</button>
            <a href="/admin" class="btn-cancelar">❌ Cancelar</a>
        </div>
    </form>
</div>
</body>
</html>