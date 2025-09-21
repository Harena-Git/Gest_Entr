<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des annonces</title>
</head>
<body>
    <h1>Liste des annonces</h1>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Titre</th>
            <th>Description</th>
            <!-- Ajoutez d'autres colonnes selon les champs de Annonce -->
        </tr>
        <c:forEach var="annonce" items="${annonces}">
            <tr>
                <td>${annonce.id}</td>
                <td>${annonce.titre}</td>
                <td>${annonce.description}</td>
                <!-- Ajoutez d'autres champs ici -->
            </tr>
        </c:forEach>
    </table>
</body>
</html>
