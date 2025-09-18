<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profil</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<body>
    <h1>Détails du Profil</h1>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty profil}">
        <table class="table">
            <thead>
                <tr>
                    <th>Champ</th>
                    <th>Valeur</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>ID Profil</td>
                    <td>${profil.id_profil}</td>
                </tr>
                <tr>
                    <td>Genre</td>
                    <td>${profil.genre}</td>
                </tr>
                <tr>
                    <td>Âge</td>
                    <td>${profil.age}</td>
                </tr>
                <tr>
                    <td>Années d'expérience</td>
                    <td>${profil.annee_experience}</td>
                </tr>
                <tr>
                    <td>Lieu</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty profil.lieu}">
                                ${profil.lieu.id_lieu} - ${profil.lieu.lieu}
                            </c:when>
                            <c:otherwise>
                                Non spécifié
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td>Diplôme</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty profil.diplome}">
                                ${profil.diplome.id_diplome} - ${profil.diplome.niveau}
                            </c:when>
                            <c:otherwise>
                                Non spécifié
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </tbody>
        </table>
    </c:if>
    <a href="/acceuil" class="btn btn-secondary">Retour</a>
</body>
</html>