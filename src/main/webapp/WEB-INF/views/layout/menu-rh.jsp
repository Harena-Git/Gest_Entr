<%-- WEB-INF/views/layout/menu-rh.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<a href="${pageContext.request.contextPath}/rh/dashboard" class="nav-item ${pageContext.request.requestURI.contains('/rh/dashboard') ? 'active' : ''}">
    📊 Tableau de bord
</a>
<a href="${pageContext.request.contextPath}/rh/validations" class="nav-item ${pageContext.request.requestURI.contains('/rh/validations') ? 'active' : ''}">
    ✅ Validations
</a>
<a href="${pageContext.request.contextPath}/rh/audit" class="nav-item ${pageContext.request.requestURI.contains('/rh/audit') ? 'active' : ''}">
    🔍 Audit
</a>
<a href="${pageContext.request.contextPath}/rh/releves" class="nav-item ${pageContext.request.requestURI.contains('/rh/releves') ? 'active' : ''}">
    📊 Relevés
</a>
<a href="${pageContext.request.contextPath}/rh/paie" class="nav-item ${pageContext.request.requestURI.contains('/rh/paie') ? 'active' : ''}">
    💰 Paie
</a>