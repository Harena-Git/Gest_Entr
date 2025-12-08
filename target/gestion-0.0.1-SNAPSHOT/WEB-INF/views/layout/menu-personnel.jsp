<%-- WEB-INF/views/layout/menu-personnel.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<a href="${pageContext.request.contextPath}/personnel/dashboard" class="nav-item ${pageContext.request.requestURI.endsWith('dashboard') ? 'active' : ''}">
    📊 Tableau de bord
</a>
<a href="${pageContext.request.contextPath}/personnel/justifications" class="nav-item ${pageContext.request.requestURI.endsWith('justifications') ? 'active' : ''}">
    📄 Mes justifications
</a>
<a href="${pageContext.request.contextPath}/personnel/historique" class="nav-item ${pageContext.request.requestURI.endsWith('historique') ? 'active' : ''}">
    📅 Mon historique
</a>