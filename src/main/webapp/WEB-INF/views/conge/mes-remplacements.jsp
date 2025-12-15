<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Mes remplacements</title>
    <link rel="stylesheet" href="/css/styles.css" />
</head>
<body>
<%-- <jsp:include page="/WEB-INF/views/menu_bar.jsp" /> --%>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="container">
    <h2>Mes remplacements</h2>

    <c:if test="${not empty remplacements}">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Pour demande</th>
                    <th>Période</th>
                    <th>Accepté</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${remplacements}" var="r">
                    <tr>
                        <td>${r.id_remplacement}</td>
                        <td>${r.demandeConge.id_demande_conge}</td>
                        <td><fmt:formatDate value="${r.demandeConge.date_debut}" pattern="yyyy-MM-dd"/> - <fmt:formatDate value="${r.demandeConge.date_fin}" pattern="yyyy-MM-dd"/></td>
                        <td>${r.remplacant_accepte}</td>
                        <td>
                            <form action="/personnel/remplacement/accepter" method="post" style="display:inline;">
                                <input type="hidden" name="idRemplacement" value="${r.id_remplacement}" />
                                <input type="hidden" name="idPersonnel" value="${personnel.id_personnel}" />
                                <input type="text" name="commentaire" placeholder="Commentaire (optionnel)" />
                                <button type="submit">Accepter</button>
                            </form>
                            <form action="/personnel/remplacement/refuser" method="post" style="display:inline; margin-left:8px;">
                                <input type="hidden" name="idRemplacement" value="${r.id_remplacement}" />
                                <input type="hidden" name="idPersonnel" value="${personnel.id_personnel}" />
                                <input type="text" name="commentaire" placeholder="Motif (optionnel)" />
                                <button type="submit">Refuser</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty remplacements}">
        <p>Aucun remplacement assigné.</p>
    </c:if>
</div>
</body>
</html>