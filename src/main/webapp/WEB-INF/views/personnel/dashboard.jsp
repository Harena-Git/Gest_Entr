<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Tableau de bord Personnel" />
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="main-container">
    <c:if test="${not empty success}">
        <div class="alert alert-success">✅ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>
    
    <!-- Section Pointage -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">📍 Pointage du jour</h2>
            <div class="card-date">
                <fmt:formatDate value="${aujourdhui}" pattern="EEEE dd MMMM yyyy" />
            </div>
        </div>
        
        <div class="pointage-section">
            <c:choose>
                <c:when test="${presenceAujourdhui == null}">
                    <div class="pointage-info">
                        <p class="status-absent">❌ Non pointé aujourd'hui</p>
                        <form action="${pageContext.request.contextPath}/personnel/pointer-entree" method="post" style="margin-top: 20px;">
                            <button type="submit" class="btn btn-success" style="padding: 12px 24px; font-size: 16px; min-width: 180px;">
                                📍 Pointer mon entrée
                            </button>
                        </form>
                    </div>
                </c:when>
                <c:when test="${presenceAujourdhui.heureDepart == null}">
                    <div class="pointage-info">
                        <p style="font-size: 16px; margin-bottom: 15px;">✅ Entrée pointée à : 
                            <strong><fmt:formatDate value="${presenceAujourdhui.heureArrivee}" pattern="HH:mm" /></strong>
                        </p>
                        <form action="${pageContext.request.contextPath}/personnel/pointer-sortie" method="post">
                            <button type="submit" class="btn btn-primary" style="padding: 12px 24px; font-size: 16px; min-width: 180px;">
                                🏃 Pointer ma sortie
                            </button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="pointage-complete">
                        <p style="font-size: 16px; margin-bottom: 15px;">✅ Pointage complet pour aujourd'hui :</p>
                        <ul style="list-style: none; padding-left: 0;">
                            <li style="margin-bottom: 8px; font-size: 15px;">Entrée : 
                                <strong><fmt:formatDate value="${presenceAujourdhui.heureArrivee}" pattern="HH:mm" /></strong>
                            </li>
                            <li style="font-size: 15px;">Sortie : 
                                <strong><fmt:formatDate value="${presenceAujourdhui.heureDepart}" pattern="HH:mm" /></strong>
                            </li>
                        </ul>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <!-- Statistiques du mois -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon" style="font-size: 28px;">📅</div>
            <div class="stat-number">${stats.nombrePresences}</div>
            <div class="stat-label">Jours présents</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon" style="font-size: 28px;">⚠️</div>
            <div class="stat-number">${stats.nombreAbsences}</div>
            <div class="stat-label">Absences</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon" style="font-size: 28px;">⏰</div>
            <div class="stat-number">
                <c:if test="${stats.totalMinutesRetard != null && stats.totalMinutesRetard > 0}">
                    ${stats.totalMinutesRetard} min
                </c:if>
                <c:if test="${stats.totalMinutesRetard == null || stats.totalMinutesRetard == 0}">0 min</c:if>
            </div>
            <div class="stat-label">Retards total</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon" style="font-size: 28px;">💼</div>
            <div class="stat-number">
                <c:if test="${stats.nombreHeuresSup != null && stats.nombreHeuresSup > 0}">
                    ${stats.nombreHeuresSup}h
                </c:if>
                <c:if test="${stats.nombreHeuresSup == null || stats.nombreHeuresSup == 0}">0h</c:if>
            </div>
            <div class="stat-label">Heures supplémentaires</div>
        </div>
    </div>
    
    <%-- <!-- Actions rapides -->
    <div class="card">
        <h2 class="card-title">🚀 Actions rapides</h2>
        <div class="actions-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/personnel/justifications" class="btn btn-primary" style="padding: 14px 20px; font-size: 15px; text-align: center; min-height: 60px; display: flex; align-items: center; justify-content: center;">
                📄 Gérer mes justifications
            </a>
            <a href="${pageContext.request.contextPath}/personnel/historique" class="btn btn-primary" style="padding: 14px 20px; font-size: 15px; text-align: center; min-height: 60px; display: flex; align-items: center; justify-content: center;">
                📊 Voir mon historique
            </a>
            <a href="${pageContext.request.contextPath}/personnel/historique?dateDebut=<fmt:formatDate value='${aujourdhui}' pattern='yyyy-MM-dd' />&dateFin=<fmt:formatDate value='${aujourdhui}' pattern='yyyy-MM-dd' />" 
               class="btn btn-secondary" style="padding: 14px 20px; font-size: 15px; text-align: center; min-height: 60px; display: flex; align-items: center; justify-content: center;">
                📅 Aujourd'hui
            </a>
        </div>
    </div> --%>
</div>

<%@ include file="/WEB-INF/views/layout/footer.jsp" %>