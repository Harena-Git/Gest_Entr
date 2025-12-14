<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Audit & Rapports" />
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="main-container">
    <!-- Statistiques d'audit -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">📅</div>
            <div class="stat-number">${statsAudit.validationsAujourdhui}</div>
            <div class="stat-label">Validations aujourd'hui</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">✅</div>
            <div class="stat-number">${statsAudit.tauxConcordance}%</div>
            <div class="stat-label">Taux concordance</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">⏱️</div>
            <div class="stat-number">${statsAudit.tempsMoyenValidation}</div>
            <div class="stat-label">Heures moy. traitement</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">👥</div>
            <div class="stat-number">${statsAudit.chefsActifs}</div>
            <div class="stat-label">Chefs actifs</div>
        </div>
    </div>
    
    <!-- Historique complet des validations -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">📋 Historique des validations</h2>
        </div>
        
        <!-- Tableau d'historique -->
        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Personnel</th>
                        <th>Type</th>
                        <th>Décision Chef</th>
                        <th>Décision RH</th>
                        <th>Validationné par</th>
                        <th>Statut</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="validation" items="${historiqueValidations}" varStatus="status">
                        <tr>
                            <td>
                                <%-- Afficher directement la date sans parser --%>
                                <c:if test="${not empty validation.dateValidation}">
                                    <c:set var="dateParts" value="${validation.dateValidation.toString().split('T')}" />
                                    <c:if test="${dateParts[0] != null}">
                                        <%-- Formater la date --%>
                                        <c:set var="dateStr" value="${dateParts[0]}" />
                                        <c:set var="year" value="${dateStr.substring(0, 4)}" />
                                        <c:set var="month" value="${dateStr.substring(5, 7)}" />
                                        <c:set var="day" value="${dateStr.substring(8, 10)}" />
                                        ${day}/${month}/${year}
                                    </c:if>
                                    <br>
                                    <small>
                                        <c:if test="${dateParts[1] != null}">
                                            <c:set var="timeStr" value="${dateParts[1]}" />
                                            <c:set var="hour" value="${timeStr.substring(0, 2)}" />
                                            <c:set var="minute" value="${timeStr.substring(3, 5)}" />
                                            ${hour}:${minute}
                                        </c:if>
                                    </small>
                                </c:if>
                            </td>
                            <td>
                                <strong>
                                    <c:choose>
                                        <c:when test="${validation.validationAbsChef.justificationAbsence != null}">
                                            ${validation.validationAbsChef.justificationAbsence.personnel.candidat.nom}
                                        </c:when>
                                        <c:when test="${validation.validationAbsChef.justificationRetard != null}">
                                            ${validation.validationAbsChef.justificationRetard.personnel.candidat.nom}
                                        </c:when>
                                        <c:otherwise>
                                            ${validation.validationAbsChef.presenceAbsence.personnel.candidat.nom}
                                        </c:otherwise>
                                    </c:choose>
                                </strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${validation.validationAbsChef.justificationAbsence != null}">
                                        <span class="status status-absent" style="font-size: 0.85em; padding: 4px 8px;">
                                            📄 Absence
                                        </span>
                                    </c:when>
                                    <c:when test="${validation.validationAbsChef.justificationRetard != null}">
                                        <span class="status status-pending" style="font-size: 0.85em; padding: 4px 8px;">
                                            ⏰ Retard
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status status-present" style="font-size: 0.85em; padding: 4px 8px;">
                                            📍 Présence
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="status ${validation.validationAbsChef.decisionValidation.libelle == 'accepté' ? 'status-present' : 'status-absent'}">
                                    ${validation.validationAbsChef.decisionValidation.libelle}
                                </span>
                            </td>
                            <td>
                                <span class="status ${validation.decisionValidation.libelle == 'accepté' ? 'status-present' : 'status-absent'}">
                                    ${validation.decisionValidation.libelle}
                                </span>
                            </td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <span style="width: 32px; height: 32px; background: #e9ecef; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.8em;">
                                        👤
                                    </span>
                                    <div>
                                        <div style="font-weight: 500;">${validation.user.nom}</div>
                                        <div style="font-size: 0.8em; color: #6c757d;">RH</div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${validation.validationAbsChef.decisionValidation.libelle == validation.decisionValidation.libelle}">
                                        <span class="status status-present" style="font-size: 0.85em; padding: 4px 8px;">
                                            ✅ Concordant
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status status-absent" style="font-size: 0.85em; padding: 4px 8px;">
                                            ⚠️ Contradiction
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty historiqueValidations}">
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 60px;">
                                <div style="font-size: 3em; margin-bottom: 20px; color: #6c757d;">📊</div>
                                <h3 style="color: #495057; margin-bottom: 15px;">Aucun historique de validation</h3>
                                <p style="color: #6c757d; max-width: 500px; margin: 0 auto;">
                                    L'historique des validations apparaîtra ici après les premières opérations.
                                </p>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Logs d'audit système -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">📝 Logs système récents</h2>
        </div>
        
        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Date/Heure</th>
                        <th>Action</th>
                        <th>Utilisateur</th>
                        <th>Table</th>
                        <th>Détails</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="log" items="${logsAudit}" varStatus="status">
                        <tr>
                            <td>
                                <%-- Afficher directement le timestamp sans parser --%>
                                <c:if test="${not empty log.timestamp}">
                                    <c:set var="timestampStr" value="${log.timestamp.toString()}" />
                                    <c:if test="${not empty timestampStr}">
                                        <c:set var="timestampParts" value="${timestampStr.split('T')}" />
                                        <c:if test="${timestampParts[0] != null && timestampParts[1] != null}">
                                            <%-- Formater la date --%>
                                            <c:set var="datePart" value="${timestampParts[0]}" />
                                            <c:set var="timePart" value="${timestampParts[1].substring(0, 8)}" />
                                            
                                            <c:set var="year" value="${datePart.substring(0, 4)}" />
                                            <c:set var="month" value="${datePart.substring(5, 7)}" />
                                            <c:set var="day" value="${datePart.substring(8, 10)}" />
                                            
                                            ${day}/${month}/${year} ${timePart}
                                        </c:if>
                                    </c:if>
                                </c:if>
                            </td>
                            <td>
                                <span class="status ${log.action.contains('CREATE') ? 'status-present' : log.action.contains('DELETE') ? 'status-absent' : 'status-pending'}">
                                    ${log.action}
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${log.userType == 'USER'}">
                                        User #${log.userId}
                                    </c:when>
                                    <c:when test="${log.userType == 'PERSONNEL'}">
                                        Personnel #${log.userId}
                                    </c:when>
                                    <c:otherwise>
                                        ${log.userType}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${log.tableName}</td>
                            <td style="max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                ${log.details}
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty logsAudit}">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 40px; color: #6c757d;">
                                📝 Aucun log système récent
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<style>
.status {
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 0.85em;
    font-weight: 500;
}

.status-present {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

.status-absent {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}

.status-pending {
    background-color: #fff3cd;
    color: #856404;
    border: 1px solid #ffeaa7;
}
</style>

<%@ include file="/WEB-INF/views/layout/footer.jsp" %>