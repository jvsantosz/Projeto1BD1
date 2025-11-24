<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head><title>Usuários</title></head>
<body>
<h2>Usuários Cadastrados</h2>

<table border="1">
    <tr><th>Nome</th><th>Email</th><th>Ações</th></tr>
    <c:forEach var="u" items="${usuarios}">
        <tr>
            <td>${u.nomeCompleto}</td>
            <td>${u.email}</td>
            <td><a href="/usuarios/deletar/${u.idUsuario}">Excluir</a></td>
        </tr>
    </c:forEach>
</table>

<p><a href="/usuarios/novo">Novo Usuário</a></p>
<p><a href="/">Voltar</a></p>
</body>
</html>
