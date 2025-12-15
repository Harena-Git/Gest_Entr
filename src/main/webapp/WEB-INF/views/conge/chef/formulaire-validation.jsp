<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Valider demande - Chef</title>
    <link rel="stylesheet" href="/css/style.css" />
</head>
<body>
<%-- <jsp:include page="/WEB-INF/views/menu_bar.jsp" /> --%>
<div class="container">
    <h2>Validation de la demande</h2>

    <c:if test="${not empty demande}">
        <p><strong>ID :</strong> ${demande.id_demande_conge}</p>
        <p><strong>Demandeur :</strong> ${demande.personnel.candidat.prenom} ${demande.personnel.candidat.nom}</p>
        <p><strong>Date début :</strong> <fmt:formatDate value="${demande.date_debut}" pattern="yyyy-MM-dd"/></p>
        <p><strong>Date fin :</strong> <fmt:formatDate value="${demande.date_fin}" pattern="yyyy-MM-dd"/></p>
        <p><strong>Nombre jours :</strong> ${demande.nombre_jours}</p>

        <form action="/chef/conge/approuver" method="post">
            <input type="hidden" name="idDemande" value="${demande.id_demande_conge}" />
            <input type="hidden" name="idChef" value="${chef.id_user}" />
            <div>
                <label for="commentaire">Commentaire (optionnel)</label>
                <textarea id="commentaire" name="commentaire"></textarea>
            </div>
            <div>
                <button type="submit">Approuver</button>
            </div>
        </form>

        <form action="/chef/conge/rejeter" method="post" style="margin-top:10px;">
            <input type="hidden" name="idDemande" value="${demande.id_demande_conge}" />
            <input type="hidden" name="idChef" value="${chef.id_user}" />
            <div>
                <label for="commentaireRejet">Motif du rejet</label>
                <textarea id="commentaireRejet" name="commentaire" required></textarea>
            </div>
            <div>
                <button type="submit">Rejeter</button>
            </div>
        </form>

    </c:if>

    <p><a href="javascript:history.back()">Retour</a></p>
</div>
</body>
</html>