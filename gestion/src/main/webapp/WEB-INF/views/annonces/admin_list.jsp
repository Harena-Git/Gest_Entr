<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Gestion des annonces (Admin)</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <h1>Liste des annonces</h1>
    <a href="/admin/annonces/choose-department">Ajouter une annonce</a>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Date annonce</th>
            <th>Poste</th>
            <th>Departement</th>
            <th>Responsabilite</th>
            <th>Genre</th>
            <th>Age</th>
            <th>Annee exp.</th>
            <th>Lieu</th>
            <th>Niveau diplome</th>
            <th>Date fin</th>
            <th>Actions</th>
        </tr>
        <c:forEach var="annonce" items="${annonces}">
            <tr>
                <td>${annonce.id_annonce}</td>
                <td>${annonce.date_annonce}</td>
                <td>${annonce.poste.libelle}</td>
                <td>${annonce.poste.departement.departement}</td>
                <td>${annonce.responsabilite}</td>
                <td>${annonce.profil.genre}</td>
                <td>${annonce.profil.age}</td>
                <td>${annonce.profil.annee_experience}</td>
                <td>${annonce.profil.lieu.lieu}</td>
                <td>${annonce.profil.diplome != null ? annonce.profil.diplome.niveau.libelle : ''}</td>
                <td>${annonce.date_fin}</td>
                <td>
                    <a href="/admin/annonces/${annonce.id_annonce}">Détail</a> |
                    <a href="/admin/annonces/edit/${annonce.id_annonce}">Modifier</a> |
                    <a href="/admin/annonces/delete/${annonce.id_annonce}" onclick="return confirm('Supprimer ?');">Supprimer</a>
                </td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
