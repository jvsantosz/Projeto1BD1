

<html>
<head><title>Opções de Questão</title></head>
<body>
<h2>Opções da Questão ${idQuestao}</h2>

<table border="1">
    <tr><th>Letra</th><th>Texto</th><th>Correta?</th><th>Ações</th></tr>
    <c:forEach var="o" items="${opcoes}">
        <tr>
            <td>${o.letra}</td>
            <td>${o.texto}</td>
            <td>${o.correta}</td>
            <td><a href="/opcoes/deletar/${o.id}">Excluir</a></td>
        </tr>
    </c:forEach>
</table>

<p><a href="/questoes">Voltar</a></p>
</body>
</html>
