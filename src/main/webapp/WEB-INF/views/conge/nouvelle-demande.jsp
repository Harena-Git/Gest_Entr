<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Nouvelle demande de congé</title>
    <link rel="stylesheet" href="/css/styles.css" />
</head>
<body>
<jsp:include page="/WEB-INF/views/menu_bar.jsp" />
<div class="container">
    <h2>Nouvelle demande de congé</h2>

    <c:if test="${not empty succes}">
        <div class="alert alert-success">${succes}</div>
    </c:if>
    <c:if test="${not empty erreur}">
        <div class="alert alert-danger">${erreur}</div>
    </c:if>

    <p>Solde restant : <strong>${soldeRestant}</strong> jours</p>

    <form action="/personnel/conge/creer" method="post">
        <input type="hidden" name="idPersonnel" value="${personnel.id_personnel}" />
        <div>
            <label for="dateDebut">Date début</label>
            <input type="date" id="dateDebut" name="dateDebut" required />
        </div>
        <div>
            <label for="dateFin">Date fin</label>
            <input type="date" id="dateFin" name="dateFin" required />
        </div>
        <div>
            <label for="motif">Motif</label>
            <input type="text" id="motif" name="motif" maxlength="255" />
        </div>
        <div>
            <button type="submit">Envoyer la demande</button>
            <a href="/">Annuler</a>
        </div>
    </form>
</div>
</body>
</html>