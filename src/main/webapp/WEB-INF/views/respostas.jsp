<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
<head><title>Respostas</title></head>
<body>
<h2>Respostas do Usuário/Avaliação ${idAvaliacaoUsuario}</h2>

<table border="1">
    <tr><th>Questão</th><th>Resposta</th></tr>
    <c:forEach var="r" items="${respostas}">
        <tr>
            <td>${r.idQuestao}</td>
            <td>${r.respostaTexto}</td>
        </tr>
    </c:forEach>
</table>

<p><a href="/avaliacoes">Voltar</a></p>
</body>
</html>
