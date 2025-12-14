<%-- WEB-INF/views/layout/menu-chef.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<a href="${pageContext.request.contextPath}/chef/dashboard" class="nav-item ${pageContext.request.requestURI.contains('/chef/dashboard') ? 'active' : ''}">
    📊 Tableau de bord
</a>
<a href="${pageContext.request.contextPath}/chef/validations" class="nav-item ${pageContext.request.requestURI.contains('/chef/validations') ? 'active' : ''}">
    ✅ Validations
</a>
<a href="${pageContext.request.contextPath}/chef/releves" class="nav-item ${pageContext.request.requestURI.contains('/chef/releves') ? 'active' : ''}">
    📄 Relevés
</a>