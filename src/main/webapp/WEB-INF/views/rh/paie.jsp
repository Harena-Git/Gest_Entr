<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>
<h2>Documentation de l'API Simple Paie</h2>
<div style="border: 1px solid #ddd; padding: 15px; margin: 10px 0;">
    <h4>🔗 API Simple Paie</h4>
    
    <div style="margin-bottom: 10px;">
        <strong>Pour tous :</strong><br>
        <code>GET ${pageContext.request.contextPath}/api/paie?mois=${moisPaie}&annee=${anneePaie}</code>
    </div>
    
    <div style="margin-bottom: 10px;">
        <strong>Pour un département :</strong><br>
        <code>GET ${pageContext.request.contextPath}/api/paie?departement=1&mois=${moisPaie}&annee=${anneePaie}</code>
    </div>
    
    <div style="margin-bottom: 10px;">
        <strong>Pour un personnel :</strong><br>
        <code>GET ${pageContext.request.contextPath}/api/paie?personnel=49&mois=${moisPaie}&annee=${anneePaie}</code>
    </div>
    
    <div>
        <a href="${pageContext.request.contextPath}/api/paie?mois=${moisPaie}&annee=${anneePaie}" 
           target="_blank" class="btn btn-sm btn-primary">
           🔗 Tester l'API
        </a>
    </div>
</div>