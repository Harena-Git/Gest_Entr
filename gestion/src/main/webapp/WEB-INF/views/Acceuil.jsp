<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Acceuil</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
    <h1>Les offres d'emploie</h1>
    <ul>
        <c:forEach var="annonce" items="${annonces}">
            <li>
                ID : ${annonce.id_annonce}, Date : ${annonce.date_annonce}
                Responsable : ${annonce.responsabilite} ${annonce.date_fin}
                Poste : ${annonce.poste}, ID_Profil: ${annonce.profil.id_profil}
                <form action="profil" method="get" style="display:inline;">
                    <input type="hidden" name="idProfil" value="${annonce.profil.id_profil}">
                    <button type="submit" class="btn btn-primary btn-sm">Choisir</button>
                </form>
            </li>
        </c:forEach>
    </ul>
</body>
</html>