<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Formulaire Annonce</title>
</head>
<body>
<h2>${annonce.id_annonce == null ? 'Ajouter' : 'Modifier'} une annonce</h2>
<form action="/admin/annonces" method="post">
    <input type="hidden" name="id_annonce" value="${annonce.id_annonce}" />
    <div>
        <label>Date annonce :</label>
        <input type="date" name="date_annonce" value="${annonce.date_annonce}" required />
    </div>
    <div>
        <label>Titre du poste :</label>
        <input type="text" name="libelle_poste" value="${annonce.poste != null ? annonce.poste.libelle : ''}" required />
    </div>
    <div>
        <label>Salaire :</label>
        <input type="number" name="salaire_poste" value="${annonce.poste != null ? annonce.poste.salaire : ''}" required />
    </div>
    <div>
        <label>Département :</label>
        <select name="id_departement" required>
            <c:forEach var="departement" items="${departements}">
                <option value="${departement.id_departement}" ${annonce.poste != null && annonce.poste.departement != null && annonce.poste.departement.id_departement == departement.id_departement ? 'selected' : ''}>
                    ${departement.departement}
                </option>
            </c:forEach>
        </select>
    </div>
    <div>
        <label>Responsabilité :</label>
        <input type="text" name="responsabilite" value="${annonce.responsabilite}" required />
    </div>
    <div>
        <label>Genre :</label>
        <select name="genre" required>
            <option value="Homme" ${annonce.profil != null && annonce.profil.genre == 'Homme' ? 'selected' : ''}>Homme</option>
            <option value="Femme" ${annonce.profil != null && annonce.profil.genre == 'Femme' ? 'selected' : ''}>Femme</option>
            <option value="Indifférent" ${annonce.profil != null && annonce.profil.genre == 'Indifférent' ? 'selected' : ''}>Indifférent</option>
        </select>
    </div>
    <div>
        <label>Âge :</label>
        <input type="number" name="age" value="${annonce.profil != null ? annonce.profil.age : ''}" required />
    </div>
    <div>
        <label>Nombre d'années d'expérience :</label>
        <input type="number" name="annee_experience" value="${annonce.profil != null ? annonce.profil.annee_experience : ''}" required />
    </div>
    <div>
        <label>Lieu du poste :</label>
        <select name="id_lieu" required>
            <c:forEach var="lieu" items="${lieux}">
                <option value="${lieu.id_lieu}" ${annonce.profil != null && annonce.profil.lieu != null && annonce.profil.lieu.id_lieu == lieu.id_lieu ? 'selected' : ''}>
                    ${lieu.lieu}
                </option>
            </c:forEach>
        </select>
    </div>
    <div>
        <label>Niveau du diplôme obtenu :</label>
        <select name="id_niveau" required>
            <c:forEach var="niveau" items="${niveaux}">
                <option value="${niveau.id_niveau}">${niveau.libelle}</option>
            </c:forEach>
        </select>
    </div>
    <div>
        <label>Date fin :</label>
        <input type="date" name="date_fin" value="${annonce.date_fin}" required />
    </div>
    <button type="submit">Enregistrer</button>
    <a href="/admin/annonces">Annuler</a>
</form>
</body>
</html>