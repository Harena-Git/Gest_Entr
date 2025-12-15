<%-- WEB-INF/views/layout/menu-personnel.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<a href="${pageContext.request.contextPath}/personnel/dashboard" class="nav-item ${pageContext.request.requestURI.endsWith('dashboard') ? 'active' : ''}">
    📊 Tableau de bord
</a>
<a href="${pageContext.request.contextPath}/personnel/conge/mes-demandes" class="nav-item ${pageContext.request.requestURI.contains('/conge/') ? 'active' : ''}">
    🏖️ Mes congés
    <%-- Optionnel : Badge pour le nombre de demandes en attente --%>
    <c:if test="${sessionScope.mesCongesEnAttente != null && sessionScope.mesCongesEnAttente > 0}">
        <span class="badge bg-info">${sessionScope.mesCongesEnAttente}</span>
    </c:if>
</a>
<a href="${pageContext.request.contextPath}/personnel/justifications" class="nav-item ${pageContext.request.requestURI.endsWith('justifications') ? 'active' : ''}">
    📄 Mes justifications
</a>
<a href="${pageContext.request.contextPath}/personnel/historique" class="nav-item ${pageContext.request.requestURI.endsWith('historique') ? 'active' : ''}">
    📅 Mon historique
</a>