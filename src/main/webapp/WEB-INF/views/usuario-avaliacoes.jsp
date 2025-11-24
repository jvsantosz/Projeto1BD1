<%@ taglib uri="jakarta.tags.core" prefix="c" %>


<html>
<head><title>Atribuições de Avaliação</title></head>
<body>
<h2>Atribuições da Avaliação ${idAvaliacao}</h2>

<table border="1">
    <tr><th>Usuário</th><th>Status</th></tr>
    <c:forEach var="a" items="${atribuicoes}">
        <tr>
            <td>${a.idUsuario}</td>
            <td>${a.status}</td>
        </tr>
    </c:forEach>
</table>

<p><a href="/avaliacoes">Voltar</a></p>
</body>
</html>
