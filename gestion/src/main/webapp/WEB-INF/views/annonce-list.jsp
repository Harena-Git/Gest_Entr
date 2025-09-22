<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>Liste des annonces</h2>

<table border="1">
    <tr>
        <th>Poste</th>
        <th>Profil</th>
        <th>domaine</th>
        <th>annee_experience</th>
        <th>Responsabilité</th>
        <th>Date fin</th>
        <th>Action</th>
    </tr>
    <c:forEach var="annonce" items="${annonces}">
        <tr>
            <td>${annonce.poste.libelle}</td>
            <td>${annonce.profil.genre}</td>
            <td>${annonce.profil.diplome.filiere.libelle}</td>
            <td>${annonce.profil.annee_experience}</td>
            <td>${annonce.responsabilite}</td>
            <td>${annonce.date_fin}</td>
            <td>
                <form action="${pageContext.request.contextPath}/candidat/form" method="get">
                    <input type="hidden" name="idAnnonce" value="${annonce.id_annonce}" />
                    <button type="submit">Postulez</button>
                </form>
            </td>
        </tr>
    </c:forEach>
</table>
