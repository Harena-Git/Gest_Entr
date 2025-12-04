<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Détails remplacement</title>
    <link rel="stylesheet" href="/css/styles.css" />
</head>
<body>
<jsp:include page="/WEB-INF/views/menu_bar.jsp" />
<div class="container">
    <h2>Détails du remplacement</h2>

    <c:if test="${not empty remplacement}">
        <p><strong>ID :</strong> ${remplacement.id_remplacement}</p>
        <p><strong>Remplaçant :</strong> ${remplacement.personnel.candidat.prenom} ${remplacement.personnel.candidat.nom}</p>
        <p><strong>Pour la demande :</strong> ${remplacement.demandeConge.id_demande_conge}</p>
        <p><strong>Période :</strong> <fmt:formatDate value="${remplacement.demandeConge.date_debut}" pattern="yyyy-MM-dd"/> - <fmt:formatDate value="${remplacement.demandeConge.date_fin}" pattern="yyyy-MM-dd"/></p>
        <p><strong>Accepté :</strong> ${remplacement.remplacant_accepte}</p>
        <p><strong>Notifié :</strong> ${remplacement.notifiee}</p>
        <p><strong>Commentaire remplaçant :</strong> ${remplacement.commentaire_remplacant}</p>
    </c:if>

    <p><a href="javascript:history.back()">Retour</a></p>
</div>
</body>
</html>