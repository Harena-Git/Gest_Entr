<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Demandes en attente - Chef</title>
    <link rel="stylesheet" href="/css/styles.css" />
</head>
<body>
<%-- <jsp:include page="/WEB-INF/views/menu_bar.jsp" /> --%>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="container">
    <h2>Demandes en attente - Département du chef</h2>

    <c:if test="${not empty demandes}">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Demandeur</th>
                    <th>Date début</th>
                    <th>Date fin</th>
                    <th>Jours</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${demandes}" var="d">
                    <tr>
                        <td>${d.id_demande_conge}</td>
                        <td>${d.personnel.candidat.prenom} ${d.personnel.candidat.nom}</td>
                        <td><fmt:formatDate value="${d.date_debut}" pattern="yyyy-MM-dd"/></td>
                        <td><fmt:formatDate value="${d.date_fin}" pattern="yyyy-MM-dd"/></td>
                        <td>${d.nombre_jours}</td>
                        <td>
                            <a href="/chef/conge/valider/${d.id_demande_conge}?idChef=${chef.id_user}">Valider</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty demandes}">
        <p>Aucune demande en attente.</p>
    </c:if>
</div>
</body>
</html>