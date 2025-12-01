<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Personnels</title>
</head>
<body>
    <h2>Liste des Personnels</h2>
    <div></div>
        <table border="1">
            <thead>
                <tr>
                    <th>Matricule</th>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Poste</th>
                    <th>Adresse</th>
                    <th>Date de naissance</th>
                    <th>Email</th>
                    <th>Genre</th>
                    <th>Telephone</th>
                    <th>Date d'embauche</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="personnel" items="${personnels}">
                    <tr>
                        <td>${personnel.matricule}</td>
                        <td>${personnel.candidat.nom}</td>
                        <td>${personnel.candidat.prenom}</td>
                        <td>${personnel.poste.libelle}</td>
                        <td>${personnel.candidat.adresse}</td>
                        <td>${personnel.candidat.date_naissance}</td>
                        <td>${personnel.candidat.email}</td>
                        <td>${personnel.candidat.genre}</td>
                        <td>${personnel.candidat.telephone}</td>
                        <td>${personnel.date_embauche}</td>
                        <td>
                            <a href="personnels/${personnel.id_personnel}/fichePaie">Voir Fiche de Paie</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>