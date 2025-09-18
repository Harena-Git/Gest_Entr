<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des annonces</title>
</head>
<body>
<h2>Liste des annonces</h2>
<a href="/admin/annonces/new">Ajouter une annonce</a>
<table border="1" cellpadding="8" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Date</th>
        <th>Responsabilité</th>
        <th>Profil</th>
        <th>Date fin</th>
        <th>Actions</th>
    </tr>
    <c:forEach var="annonce" items="${annonces}">
        <tr>
            <td>${annonce.id_annonce}</td>
            <td>${annonce.date_annonce}</td>
            <td>${annonce.responsabilite}</td>
            <td>
                ${annonce.profil != null ? annonce.profil.genre : ''}
                ${annonce.profil != null && annonce.profil.diplome != null ? ' - ' + annonce.profil.diplome.niveau : ''}
                ${annonce.profil != null && annonce.profil.diplome != null && annonce.profil.diplome.filiere != null ? ' - ' + annonce.profil.diplome.filiere.libelle : ''}
            </td>
            <td>${annonce.date_fin}</td>
            <td>
                <a href="/admin/annonces/edit/${annonce.id_annonce}">Modifier</a>
                <form action="/admin/annonces/delete/${annonce.id_annonce}" method="post" style="display:inline;">
                    <button type="submit" onclick="return confirm('Supprimer cette annonce ?');">Supprimer</button>
                </form>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>