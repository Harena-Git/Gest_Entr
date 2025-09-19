<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Détail annonce</title>
</head>
<body>
    <h1>Détail de l'annonce</h1>
    <ul>
        <li>ID: ${annonce.id_annonce}</li>
        <li>Date annonce: ${annonce.date_annonce}</li>
        <li>Poste: ${annonce.poste.libelle}</li>
        <li>Département: ${annonce.poste.departement.departement}</li>
        <li>Responsabilité: ${annonce.responsabilite}</li>
        <li>Genre: ${annonce.profil.genre}</li>
        <li>Âge: ${annonce.profil.age}</li>
        <li>Année expérience: ${annonce.profil.annee_experience}</li>
        <li>Lieu: ${annonce.profil.lieu.lieu}</li>
        <li>Niveau diplôme: ${annonce.profil.diplome != null ? annonce.profil.diplome.niveau.libelle : ''}</li>
        <li>Date fin: ${annonce.date_fin}</li>
    </ul>
    <a href="/admin/annonces">Retour à la liste</a>
</body>
</html>
