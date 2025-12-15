<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Détails demande de congé</title>
    <link rel="stylesheet" href="/css/styles.css" />
</head>
<body>
<%-- <jsp:include page="/WEB-INF/views/menu_bar.jsp" /> --%>
<div class="container">
    <h2>Détails de la demande</h2>

    <c:if test="${not empty demande}">
        <div>
            <p><strong>ID :</strong> ${demande.id_demande_conge}</p>
            <p><strong>Demandeur :</strong> ${demande.personnel.candidat.prenom} ${demande.personnel.candidat.nom}</p>
            <p><strong>Date demande :</strong> <fmt:formatDate value="${demande.date_demande}" pattern="yyyy-MM-dd"/></p>
            <p><strong>Date début :</strong> <fmt:formatDate value="${demande.date_debut}" pattern="yyyy-MM-dd"/></p>
            <p><strong>Date fin :</strong> <fmt:formatDate value="${demande.date_fin}" pattern="yyyy-MM-dd"/></p>
            <p><strong>Nombre jours :</strong> ${demande.nombre_jours}</p>
            <p><strong>Motif :</strong> ${demande.motif}</p>
            <p><strong>Statut :</strong> ${demande.statutDemande.libelle}</p>
        </div>
    </c:if>

    <p><a href="javascript:history.back()">Retour</a></p>
</div>
</body>
</html>