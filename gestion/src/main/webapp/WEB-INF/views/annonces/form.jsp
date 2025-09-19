<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Formulaire annonce</title>
</head>
<body>
    <h1>${annonce.id_annonce == null ? 'Ajouter' : 'Modifier'} une annonce</h1>
    <form method="post" action="${annonce.id_annonce == null ? '/admin/annonces' : '/admin/annonces/update/' += annonce.id_annonce}">
        <!-- Poste (titre du poste) -->
        <label>Titre du poste :</label>
        <select name="posteId" required>
            <c:forEach var="poste" items="${postes}">
                <option value="${poste.id_poste}" ${annonce.poste != null && annonce.poste.id_poste == poste.id_poste ? 'selected' : ''}>${poste.libelle}</option>
            </c:forEach>
        </select><br/>

        <!-- Responsabilité -->
        <label>Responsabilite :</label>
        <textarea name="responsabilite" required>${annonce.responsabilite}</textarea><br/>

        <!-- Genre -->
        <label>Genre :</label>
        <select name="genre" required>
            <option value="Homme" ${annonce.profil != null && annonce.profil.genre == 'Homme' ? 'selected' : ''}>Homme</option>
            <option value="Femme" ${annonce.profil != null && annonce.profil.genre == 'Femme' ? 'selected' : ''}>Femme</option>
        </select><br/>

        <!-- Âge -->
        <label>Age :</label>
        <input type="number" name="age" value="${annonce.profil != null ? annonce.profil.age : ''}" required/><br/>

        <!-- Année d'expérience -->
        <label>Annee d'experience :</label>
        <input type="text" name="annee_experience" value="${annonce.profil != null ? annonce.profil.annee_experience : ''}" required/><br/>

        <!-- Lieu -->
        <label>Lieu :</label>
        <select name="lieuId" required>
            <c:forEach var="lieu" items="${lieux}">
                <option value="${lieu.id_lieu}" ${annonce.profil != null && annonce.profil.lieu != null && annonce.profil.lieu.id_lieu == lieu.id_lieu ? 'selected' : ''}>${lieu.lieu}</option>
            </c:forEach>
        </select><br/>


        <!-- Diplôme -->
        <label>Diplôme :</label>
        <select name="diplomeId" required>
            <c:forEach var="diplome" items="${diplomes}">
                <option value="${diplome.id_diplome}">
                    <c:if test="${not empty diplome.niveau}">${diplome.niveau.libelle}</c:if>
                    <c:if test="${not empty diplome.filiere}"> - ${diplome.filiere.libelle}</c:if>
                </option>
            </c:forEach>
        </select><br/>

        <!-- Date fin -->
        <label>Date fin :</label>
        <input type="date" name="date_fin" value="${annonce.date_fin}" required/><br/>

        <button type="submit">Enregistrer</button>
    </form>
    <a href="/admin/annonces">Retour à la liste</a>
</body>
</html>
