<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head><title>Avaliações</title></head>
<body>
<h2>Lista de Avaliações</h2>

<table border="1">
    <tr><th>Título</th><th>Descrição</th><th>Ações</th></tr>
    <c:forEach var="a" items="${avaliacoes}">
        <tr>
            <td>${a.titulo}</td>
            <td>${a.descricao}</td>
            <td>
                <a href="/avaliacoes/deletar/${a.id}">Excluir</a>
            </td>
        </tr>
    </c:forEach>
</table>

<p><a href="/avaliacoes/novo">Nova Avaliação</a></p>
<p><a href="/">Voltar</a></p>
</body>
</html>