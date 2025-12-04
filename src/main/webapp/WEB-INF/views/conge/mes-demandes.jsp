<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Mes demandes de congé</title>
    <link rel="stylesheet" href="/css/styles.css" />
</head>
<body>
<jsp:include page="/WEB-INF/views/menu_bar.jsp" />
<div class="container">
    <h2>Mes demandes</h2>

    <c:if test="${not empty succes}">
        <div class="alert alert-success">${succes}</div>
    </c:if>
    <c:if test="${not empty erreur}">
        <div class="alert alert-danger">${erreur}</div>
    </c:if>

    <p>Solde restant : <strong>${soldeRestant}</strong> jours</p>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Date début</th>
                <th>Date fin</th>
                <th>Jours</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${demandes}" var="d">
                <tr>
                    <td>${d.id_demande_conge}</td>
                    <td><fmt:formatDate value="${d.date_debut}" pattern="yyyy-MM-dd"/></td>
                    <td><fmt:formatDate value="${d.date_fin}" pattern="yyyy-MM-dd"/></td>
                    <td>${d.nombre_jours}</td>
                    <td>${d.statutDemande.libelle}</td>
                    <td>
                        <a href="/personnel/conge/details/${d.id_demande_conge}">Voir</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty demandes}">
                <tr><td colspan="6">Aucune demande trouvée</td></tr>
            </c:if>
        </tbody>
    </table>

    <p><a href="/personnel/conge/nouvelle-demande?idPersonnel=${personnel.id_personnel}">Créer une nouvelle demande</a></p>
</div>
</body>
</html>