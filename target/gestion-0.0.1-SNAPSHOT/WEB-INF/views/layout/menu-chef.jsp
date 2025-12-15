<%-- WEB-INF/views/layout/menu-chef.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<a href="${pageContext.request.contextPath}/chef/dashboard" class="nav-item ${pageContext.request.requestURI.contains('/chef/dashboard') ? 'active' : ''}">
    📊 Tableau de bord
</a>
<a href="${pageContext.request.contextPath}/chef/conge/en-attente" class="nav-item ${pageContext.request.requestURI.contains('/chef/conge') ? 'active' : ''}">
    📅 Valider congés
    <%-- Optionnel : Badge pour le nombre en attente --%>
    <c:if test="${sessionScope.congesEnAttenteCount != null && sessionScope.congesEnAttenteCount > 0}">
        <span class="badge bg-danger">${sessionScope.congesEnAttenteCount}</span>
    </c:if>
</a>
<a href="${pageContext.request.contextPath}/chef/validations" class="nav-item ${pageContext.request.requestURI.contains('/chef/validations') ? 'active' : ''}">
    ✅ Validations absences
</a>
<a href="${pageContext.request.contextPath}/chef/releves" class="nav-item ${pageContext.request.requestURI.contains('/chef/releves') ? 'active' : ''}">
    📄 Relevés
</a>
<a href="${pageContext.request.contextPath}/chef/equipe" class="nav-item ${pageContext.request.requestURI.contains('/chef/equipe') ? 'active' : ''}">
    👥 Mon équipe
</a>